import Foundation
import Accelerate

/// Voice Activity Detector for audio segmentation
/// Uses energy-based detection with adaptive thresholding
@available(iOS 13.0, *)
class VoiceActivityDetector {
    
    // MARK: - Configuration
    struct Configuration {
        let sampleRate: Int = 16000
        let frameSize: Int = 320            // 20ms at 16kHz
        let energyThreshold: Float = 0.001  // Lower initial energy threshold for real audio
        let silenceDuration: TimeInterval = 2.0  // 2 seconds of silence to trigger segment
        let minSpeechDuration: TimeInterval = 0.5 // Minimum speech duration to be valid
        let adaptationRate: Float = 0.95    // Moderate adaptation rate
        let hangoverFrames: Int = 10        // Moderate hangover for stability
        let noiseMultiplier: Float = 3.0    // Speech must be 3x louder than noise
        let zcrThresholdLow: Float = 0.1    // Low ZCR threshold for speech
        let zcrThresholdHigh: Float = 0.4   // High ZCR threshold for noise/clicks
    }
    
    // MARK: - Properties
    private let config = Configuration()
    private let vadQueue = DispatchQueue(label: "com.nirva.vad", qos: .userInitiated)
    
    // VAD state
    private var energyThreshold: Float
    private var noiseFloor: Float = 0.0
    private var isSpeechActive = false
    private var silenceStartTime: Date?
    private var speechStartTime: Date?
    private var hangoverCounter = 0
    
    // Energy calculation
    private var energyHistory: [Float] = []
    private let historySize = 50
    
    // Statistics
    private var totalFrames = 0
    private var speechFrames = 0
    private var silenceFrames = 0
    private var segmentsTriggerred = 0
    
    // Callbacks
    var onSpeechStart: (() -> Void)?
    var onSpeechEnd: ((TimeInterval) -> Void)?  // Duration of speech
    var onSilenceDetected: ((TimeInterval) -> Void)?  // Duration of silence
    
    // MARK: - Initialization
    init() {
        energyThreshold = config.energyThreshold
        print("VoiceActivityDetector: Initialized")
        print("  Sample Rate: \(config.sampleRate) Hz")
        print("  Frame Size: \(config.frameSize) samples")
        print("  Silence Duration: \(config.silenceDuration)s")
    }
    
    // MARK: - Public Methods
    
    /// Process PCM audio data for voice activity
    /// - Parameter pcmData: PCM audio data (16-bit signed integers)
    /// - Returns: true if speech is detected, false for silence
    func processPCM(_ pcmData: Data) -> Bool {
        return vadQueue.sync {
            // Convert Data to Int16 array
            let samples = pcmData.withUnsafeBytes { buffer in
                Array(buffer.bindMemory(to: Int16.self))
            }
            
            // Process in frames
            var frameResults: [Bool] = []
            for i in stride(from: 0, to: samples.count, by: config.frameSize) {
                let frameEnd = min(i + config.frameSize, samples.count)
                let frame = Array(samples[i..<frameEnd])
                
                if frame.count == config.frameSize {
                    let isSpeech = processFrame(frame)
                    frameResults.append(isSpeech)
                }
            }
            
            // Return overall result (any frame with speech)
            return frameResults.contains(true)
        }
    }
    
    /// Force end of speech segment (e.g., when connection lost)
    func forceEndSegment() {
        vadQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.isSpeechActive {
                self.endSpeech()
            }
        }
    }
    
    /// Get VAD statistics
    func getStatistics() -> [String: Any] {
        return vadQueue.sync {
            [
                "totalFrames": totalFrames,
                "speechFrames": speechFrames,
                "silenceFrames": silenceFrames,
                "segmentsTriggerred": segmentsTriggerred,
                "currentThreshold": energyThreshold,
                "noiseFloor": noiseFloor,
                "isSpeechActive": isSpeechActive,
                "speechRatio": totalFrames > 0 ? Float(speechFrames) / Float(totalFrames) : 0
            ]
        }
    }
    
    /// Reset VAD state
    func reset() {
        vadQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.energyThreshold = self.config.energyThreshold
            self.noiseFloor = 0.0
            self.isSpeechActive = false
            self.silenceStartTime = nil
            self.speechStartTime = nil
            self.hangoverCounter = 0
            self.energyHistory.removeAll()
            self.totalFrames = 0
            self.speechFrames = 0
            self.silenceFrames = 0
            self.segmentsTriggerred = 0
            
            print("VoiceActivityDetector: Reset complete")
        }
    }
    
    // MARK: - Private Methods
    
    private func processFrame(_ samples: [Int16]) -> Bool {
        totalFrames += 1
        
        // Calculate frame energy
        let energy = calculateEnergy(samples)
        
        // Calculate zero-crossing rate for click/noise detection
        let zcr = calculateZeroCrossingRate(samples)
        
        // Update energy history
        energyHistory.append(energy)
        if energyHistory.count > historySize {
            energyHistory.removeFirst()
        }
        
        // Adaptive threshold update
        updateThreshold(energy: energy)
        
        // Determine if speech is present (with ZCR filtering)
        let isSpeech = detectSpeech(energy: energy, zcr: zcr)
        
        // Update state machine
        updateStateMachine(isSpeech: isSpeech)
        
        return isSpeech
    }
    
    private func calculateEnergy(_ samples: [Int16]) -> Float {
        // Convert to float and normalize
        var floatSamples = samples.map { Float($0) / 32768.0 }
        
        // Calculate RMS energy
        var energy: Float = 0
        vDSP_measqv(&floatSamples, 1, &energy, vDSP_Length(floatSamples.count))
        
        return sqrt(energy / Float(floatSamples.count))
    }
    
    private func calculateZeroCrossingRate(_ samples: [Int16]) -> Float {
        // Calculate zero-crossing rate (normalized by frame size)
        // Speech typically has moderate ZCR, while clicks/pongs have very high ZCR
        var crossings = 0
        for i in 1..<samples.count {
            if (samples[i] >= 0 && samples[i-1] < 0) || (samples[i] < 0 && samples[i-1] >= 0) {
                crossings += 1
            }
        }
        return Float(crossings) / Float(samples.count)
    }
    
    private func detectSpeech(energy: Float, zcr: Float) -> Bool {
        // Speech detection with energy AND zero-crossing rate filtering
        let prevSpeechState = isSpeechActive
        var result = false
        
        // Filter out clicks/pongs with very high ZCR (typical of impulsive sounds)
        let isLikelyNoise = zcr > config.zcrThresholdHigh
        
        // Use energy thresholds only if ZCR suggests it's not a click/pong
        if !isLikelyNoise && energy > energyThreshold * 1.5 {
            // Clear speech detected - requires 1.5x threshold
            hangoverCounter = config.hangoverFrames
            result = true
        } else if !isLikelyNoise && energy > energyThreshold && hangoverCounter > 0 {
            // Possible speech with hangover
            result = true
        } else if hangoverCounter > 0 {
            // Hangover period
            hangoverCounter -= 1
            result = true
        } else {
            // Silence or noise
            result = false
        }
        
        // Log state transitions and when filtering out noise
        if (result != prevSpeechState) || (isLikelyNoise && energy > energyThreshold) {
            if isLikelyNoise && energy > energyThreshold {
                print("VAD: Filtered noise/click - Energy=\(String(format: "%.6f", energy)), ZCR=\(String(format: "%.3f", zcr)) (too high)")
                DebugLogger.shared.log("VAD: Filtered noise - ZCR=\(String(format: "%.3f", zcr))")
            } else if (result != prevSpeechState) {
                print("VAD: Energy=\(String(format: "%.6f", energy)), ZCR=\(String(format: "%.3f", zcr)), Threshold=\(String(format: "%.6f", energyThreshold)), Speech=\(result)")
                DebugLogger.shared.log("VAD: E=\(String(format: "%.6f", energy)), ZCR=\(String(format: "%.3f", zcr)), Speech=\(result)")
            }
        }
        
        return result
    }
    
    private func updateThreshold(energy: Float) {
        // Adaptive threshold based on noise floor
        if !isSpeechActive {
            // Update noise floor during silence
            if noiseFloor == 0 {
                noiseFloor = energy
            } else {
                noiseFloor = noiseFloor * config.adaptationRate + energy * (1 - config.adaptationRate)
            }
            
            // Set threshold above noise floor with higher multiplier
            energyThreshold = max(noiseFloor * config.noiseMultiplier, config.energyThreshold)
        }
    }
    
    private func updateStateMachine(isSpeech: Bool) {
        let now = Date()
        
        if isSpeech {
            speechFrames += 1
            
            if !isSpeechActive {
                // Transition from silence to speech
                startSpeech()
            }
            
            // Reset silence timer
            silenceStartTime = nil
            
        } else {
            silenceFrames += 1
            
            if isSpeechActive {
                // Start tracking silence duration
                if silenceStartTime == nil {
                    silenceStartTime = now
                } else {
                    // Check if silence duration exceeds threshold
                    let silenceDuration = now.timeIntervalSince(silenceStartTime!)
                    
                    if silenceDuration >= config.silenceDuration {
                        // End speech segment
                        endSpeech()
                        
                        // Notify about silence
                        onSilenceDetected?(silenceDuration)
                    }
                }
            }
        }
    }
    
    private func startSpeech() {
        isSpeechActive = true
        speechStartTime = Date()
        silenceStartTime = nil
        
        print("VoiceActivityDetector: Speech started")
        onSpeechStart?()
    }
    
    private func endSpeech() {
        guard let startTime = speechStartTime else { return }
        
        let duration = Date().timeIntervalSince(startTime)
        
        // Only trigger segment if speech was long enough
        if duration >= config.minSpeechDuration {
            segmentsTriggerred += 1
            print("VoiceActivityDetector: Speech ended - Duration: \(String(format: "%.1f", duration))s")
            onSpeechEnd?(duration)
        } else {
            print("VoiceActivityDetector: Short speech ignored - Duration: \(String(format: "%.1f", duration))s")
        }
        
        isSpeechActive = false
        speechStartTime = nil
        silenceStartTime = nil
        hangoverCounter = 0
    }
}