import Foundation
import AVFoundation

/// Audio processor that handles PCM buffering, VAD, and segmentation
@available(iOS 13.0, *)
class AudioProcessor {
    
    // MARK: - Configuration
    struct Configuration {
        let sampleRate: Int = 16000
        let channels: Int = 1
        let bufferDuration: TimeInterval = 0.5  // 500ms buffer
        let maxSegmentDuration: TimeInterval = 30.0 // Maximum 30 second segments (failsafe)
        let silenceThreshold: TimeInterval = 2.0 // 2 seconds of silence triggers segment close
        let minSegmentDuration: TimeInterval = 1.0 // Minimum 1 second for valid segment
    }
    
    // MARK: - Properties
    private let config = Configuration()
    private let processingQueue = DispatchQueue(label: "com.nirva.audio.processor", qos: .userInitiated)
    
    // Audio buffers
    private var pcmBuffer = Data()
    private var currentSegment = Data()
    private var segmentStartTime: Date?
    
    // Opus decoder
    private var opusDecoder: OpusDecoder?
    
    // VAD for intelligent segmentation
    private var vad: VoiceActivityDetector?
    private var lastSpeechTime: Date?
    private var isSpeechActive = false
    
    // Callbacks
    var onSegmentReady: ((Data, TimeInterval, String) -> Void)?  // Added filePath parameter
    var onError: ((Error) -> Void)?
    
    // Statistics
    private var totalPCMBytes = 0
    private var totalDuration: TimeInterval = 0
    
    // MARK: - Initialization
    init() {
        print("AudioProcessor: init() called")
        // DebugLogger.shared.log("AudioProcessor: init() called")
        
        opusDecoder = OpusDecoder()
        if opusDecoder == nil {
            print("AudioProcessor: Failed to initialize Opus decoder")
            DebugLogger.shared.log("AudioProcessor: Failed to initialize Opus decoder")
        } else {
            print("AudioProcessor: Initialized with Opus decoder")
            // DebugLogger.shared.log("AudioProcessor: Initialized with Opus decoder")
        }
        
        // Initialize VAD
        print("AudioProcessor: Creating VoiceActivityDetector...")
        vad = VoiceActivityDetector()
        setupVAD()
        
        print("AudioProcessor: Configuration:")
        print("  Sample Rate: \(config.sampleRate) Hz")
        print("  Max Segment Duration: \(config.maxSegmentDuration)s")
        print("  Silence Threshold: \(config.silenceThreshold)s")
        print("  Min Segment Duration: \(config.minSegmentDuration)s")
        print("  VAD: Enabled")
        print("  File naming: Using timestamp-based unique names")
        // DebugLogger.shared.log("AudioProcessor: Fully initialized with VAD")
    }
    
    private func setupVAD() {
        vad?.onSpeechStart = { [weak self] in
            self?.handleSpeechStart()
        }
        
        vad?.onSpeechEnd = { [weak self] duration in
            self?.handleSpeechEnd(duration: duration)
        }
        
        vad?.onSilenceDetected = { [weak self] duration in
            self?.handleSilenceDetected(duration: duration)
        }
    }
    
    // MARK: - Public Methods
    
    /// Process incoming Opus packet
    func processOpusPacket(_ opusData: Data) {
        print("AudioProcessor: processOpusPacket called with \(opusData.count) bytes")
        // DebugLogger.shared.log("AudioProcessor: processOpusPacket called with \(opusData.count) bytes")
        
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Decode Opus to PCM
            guard let pcmData = self.opusDecoder?.decode(opusData) else {
                print("AudioProcessor: Failed to decode Opus packet")
                // Keep critical error
                DebugLogger.shared.log("AudioProcessor: Failed to decode Opus packet")
                return
            }
            
            // Check if we have non-silent audio
            let hasAudio = pcmData.contains { $0 != 0 }
            if hasAudio {
                print("AudioProcessor: Decoded to \(pcmData.count) bytes of PCM (contains audio!)")
                // DebugLogger.shared.log("AudioProcessor: Decoded PCM contains audio data!")
            }
            
            // Add to buffer
            self.pcmBuffer.append(pcmData)
            self.totalPCMBytes += pcmData.count
            
            // Process buffer if it's large enough
            if self.shouldProcessBuffer() {
                self.processBuffer()
            }
        }
    }
    
    /// Force close current segment (e.g., when connection lost)
    func forceCloseSegment() {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            if !self.currentSegment.isEmpty {
                self.finalizeSegment(forced: true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func shouldProcessBuffer() -> Bool {
        // Process when buffer has at least 500ms of audio
        let samplesInBuffer = pcmBuffer.count / 2 // 16-bit samples
        let bufferDuration = Double(samplesInBuffer) / Double(config.sampleRate)
        return bufferDuration >= config.bufferDuration
    }
    
    private func processBuffer() {
        // Run VAD on the buffer first
        let hasSpeech = vad?.processPCM(pcmBuffer) ?? false
        
        // Update speech state
        if hasSpeech {
            // Start new segment if we don't have one and speech is detected
            if segmentStartTime == nil {
                startNewSegment()
            }
            lastSpeechTime = Date()
            isSpeechActive = true
            
            // Add buffer to current segment when speech is active
            currentSegment.append(pcmBuffer)
        } else if isSpeechActive && segmentStartTime != nil {
            // Still add buffer during speech segments even if this buffer is quiet
            currentSegment.append(pcmBuffer)
            
            // Check for silence duration
            if let lastSpeech = lastSpeechTime {
                let silenceDuration = Date().timeIntervalSince(lastSpeech)
                if silenceDuration >= config.silenceThreshold {
                    print("AudioProcessor: \(String(format: "%.1f", silenceDuration))s of silence detected, closing segment")
                    // DebugLogger.shared.log("AudioProcessor: Closing segment after \(silenceDuration)s silence")
                    finalizeSegment(forced: false)
                    segmentStartTime = nil
                    isSpeechActive = false
                }
            }
        }
        
        pcmBuffer.removeAll()
        
        // Failsafe: Close segment if it's too long (but this should rarely happen with proper VAD)
        if let startTime = segmentStartTime {
            let segmentDuration = Date().timeIntervalSince(startTime)
            if segmentDuration >= config.maxSegmentDuration {
                print("AudioProcessor: Maximum segment duration reached (\(config.maxSegmentDuration)s), forcing close")
                finalizeSegment(forced: true)
                segmentStartTime = nil
                isSpeechActive = false
            }
        }
    }
    
    private func startNewSegment() {
        segmentStartTime = Date()
        currentSegment.removeAll()
        print("AudioProcessor: Started new segment")
    }
    
    private func finalizeSegment(forced: Bool) {
        guard !currentSegment.isEmpty else { return }
        
        let duration = Date().timeIntervalSince(segmentStartTime ?? Date())
        
        // Skip segments that are too short (likely noise)
        if duration < config.minSegmentDuration && !forced {
            print("AudioProcessor: Skipping short segment (\(String(format: "%.1f", duration))s < \(config.minSegmentDuration)s)")
            currentSegment.removeAll()
            return
        }
        
        totalDuration += duration
        
        print("AudioProcessor: Finalizing segment")
        print("  Duration: \(String(format: "%.1f", duration))s")
        print("  Size: \(currentSegment.count) bytes")
        print("  Forced: \(forced)")
        
        // Create WAV file from PCM data
        if let wavData = createWAVFile(from: currentSegment) {
            // Save WAV file to disk  
            // Use timestamp with milliseconds for guaranteed uniqueness
            let timestamp = Int(Date().timeIntervalSince1970 * 1000)
            let fileName = "segment_\(timestamp).wav"
            if let filePath = saveWAVFile(wavData, fileName: fileName) {
                print("AudioProcessor: Segment saved to: \(filePath)")
                // Keep segment creation logging for tracking
                DebugLogger.shared.log("AudioProcessor: Segment saved: \(fileName)")
                
                // Notify that segment is ready with the actual file path
                onSegmentReady?(wavData, duration, filePath)
            }
        }
        
        // Clear segment
        currentSegment.removeAll()
        segmentStartTime = nil
    }
    
    /// Save WAV file to documents directory
    private func saveWAVFile(_ wavData: Data, fileName: String) -> String? {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let audioDir = (documentsPath as NSString).appendingPathComponent("ble_audio_segments")
            
            // Create directory if it doesn't exist
            try FileManager.default.createDirectory(atPath: audioDir, withIntermediateDirectories: true, attributes: nil)
            
            let filePath = (audioDir as NSString).appendingPathComponent(fileName)
            try wavData.write(to: URL(fileURLWithPath: filePath))
            
            return filePath
        } catch {
            print("AudioProcessor: Failed to save WAV file: \(error)")
            return nil
        }
    }
    
    /// Convert PCM data to WAV format
    private func createWAVFile(from pcmData: Data) -> Data? {
        var wavData = Data()
        
        // WAV header
        let sampleRate = UInt32(config.sampleRate)
        let channels = UInt16(config.channels)
        let bitsPerSample: UInt16 = 16
        let byteRate = sampleRate * UInt32(channels) * UInt32(bitsPerSample) / 8
        let blockAlign = channels * bitsPerSample / 8
        let dataSize = UInt32(pcmData.count)
        let chunkSize = 36 + dataSize
        
        // RIFF header
        wavData.append("RIFF".data(using: .ascii)!)
        wavData.append(withUnsafeBytes(of: chunkSize.littleEndian) { Data($0) })
        wavData.append("WAVE".data(using: .ascii)!)
        
        // fmt subchunk
        wavData.append("fmt ".data(using: .ascii)!)
        wavData.append(withUnsafeBytes(of: UInt32(16).littleEndian) { Data($0) }) // Subchunk1Size
        wavData.append(withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) })  // AudioFormat (PCM)
        wavData.append(withUnsafeBytes(of: channels.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: sampleRate.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: byteRate.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: blockAlign.littleEndian) { Data($0) })
        wavData.append(withUnsafeBytes(of: bitsPerSample.littleEndian) { Data($0) })
        
        // data subchunk
        wavData.append("data".data(using: .ascii)!)
        wavData.append(withUnsafeBytes(of: dataSize.littleEndian) { Data($0) })
        wavData.append(pcmData)
        
        return wavData
    }
    
    // MARK: - Statistics
    
    func getStatistics() -> [String: Any] {
        return processingQueue.sync {
            var stats: [String: Any] = [
                "totalPCMBytes": totalPCMBytes,
                "totalDuration": totalDuration,
                "currentSegmentSize": currentSegment.count,
                "bufferSize": pcmBuffer.count,
                "isProcessing": segmentStartTime != nil,
                "isSpeechActive": isSpeechActive
            ]
            
            // Add VAD statistics
            if let vadStats = vad?.getStatistics() {
                stats["vad"] = vadStats
            }
            
            return stats
        }
    }
    
    /// Reset the processor
    func reset() {
        processingQueue.async { [weak self] in
            self?.pcmBuffer.removeAll()
            self?.currentSegment.removeAll()
            self?.segmentStartTime = nil
            self?.totalPCMBytes = 0
            self?.totalDuration = 0
            self?.vad?.reset()
            print("AudioProcessor: Reset complete")
        }
    }
    
    // MARK: - VAD Callbacks
    
    private func handleSpeechStart() {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("AudioProcessor: Speech started")
            self.isSpeechActive = true
            self.lastSpeechTime = Date()
            
            // Start new segment if not already started
            if self.segmentStartTime == nil {
                self.startNewSegment()
            }
        }
    }
    
    private func handleSpeechEnd(duration: TimeInterval) {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("AudioProcessor: Speech ended - Duration: \(String(format: "%.1f", duration))s")
            self.isSpeechActive = false
        }
    }
    
    private func handleSilenceDetected(duration: TimeInterval) {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("AudioProcessor: Silence detected - Duration: \(String(format: "%.1f", duration))s")
            // DebugLogger.shared.log("AudioProcessor: VAD silence callback - duration: \(duration)s")
            
            // Check if we should close the segment due to silence
            if duration >= self.config.silenceThreshold && !self.currentSegment.isEmpty {
                let segmentSize = self.currentSegment.count
                let segmentDuration = Date().timeIntervalSince(self.segmentStartTime ?? Date())
                print("AudioProcessor: Closing segment due to \(duration)s silence")
                print("  Segment duration: \(String(format: "%.1f", segmentDuration))s")
                print("  Segment size: \(segmentSize) bytes")
                // DebugLogger.shared.log("AudioProcessor: Closing segment - duration: \(segmentDuration)s, size: \(segmentSize)")
                
                self.finalizeSegment(forced: false)
                // Don't immediately start a new segment - wait for speech
                self.segmentStartTime = nil
                self.isSpeechActive = false
            }
        }
    }
}