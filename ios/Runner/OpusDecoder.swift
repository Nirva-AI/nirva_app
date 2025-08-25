import Foundation
import AVFoundation

/// Native Opus decoder implementation using libopus via Objective-C wrapper
/// Matches the Flutter implementation parameters exactly
@available(iOS 13.0, *)
class OpusDecoder {
    
    // MARK: - Configuration (matches Flutter OpusDecoderService)
    struct Configuration {
        let sampleRate: Int32 = 16000   // 16 kHz (OMI device configuration)
        let channels: Int32 = 1          // Mono
        let frameSize: Int = 160         // 10ms at 16kHz
        let maxFrameSize: Int = 5760    // Maximum Opus frame size
    }
    
    // MARK: - Properties
    private let config = Configuration()
    private var decoder: OpaquePointer?
    private let decoderQueue = DispatchQueue(label: "com.nirva.opus.decoder", qos: .userInitiated)
    
    // Statistics
    private var totalFramesDecoded = 0
    private var totalBytesDecoded = 0
    private var failedDecodes = 0
    private var plcFrames = 0
    
    // Decoder state
    private var isInitialized = false
    
    // MARK: - Initialization
    init?() {
        // Create Opus decoder using the wrapper
        var error: Int32 = 0
        let decoderPtr = OpusWrapper.createDecoder(
            withSampleRate: config.sampleRate,
            channels: config.channels,
            error: &error
        )
        
        if error != 0 || decoderPtr == nil {
            print("OpusDecoder: Failed to create decoder - error: \(error)")
            // Keep critical error logging
            DebugLogger.shared.log("OpusDecoder: Failed to create decoder - error: \(error)")
            return nil
        }
        
        decoder = OpaquePointer(decoderPtr)
        
        print("OpusDecoder: Native decoder initialized successfully")
        print("  Sample Rate: \(config.sampleRate) Hz")
        print("  Channels: \(config.channels)")
        print("  Frame Size: \(config.frameSize) samples")
        // DebugLogger.shared.log("OpusDecoder: Native libopus decoder initialized")
        isInitialized = true
    }
    
    deinit {
        if let decoder = decoder {
            OpusWrapper.destroyDecoder(UnsafeMutableRawPointer(decoder))
        }
    }
    
    // MARK: - Public Methods
    
    /// Decode Opus audio data to PCM
    /// Uses native libopus to decode real Opus packets from the OMI device
    func decode(_ opusData: Data) -> Data? {
        return decoderQueue.sync {
            guard isInitialized, let decoder = decoder else {
                print("OpusDecoder: Decoder not initialized")
                return nil
            }
            
            // Update statistics
            totalFramesDecoded += 1
            totalBytesDecoded += opusData.count
            
            // Prepare output buffer for PCM data
            // Maximum output size: max_frame_size * channels * sizeof(int16)
            let maxOutputSamples = config.maxFrameSize
            var pcmBuffer = [Int16](repeating: 0, count: maxOutputSamples)
            
            // Decode Opus packet using the wrapper
            let decodedSamples = opusData.withUnsafeBytes { opusBytes in
                OpusWrapper.decode(
                    UnsafeMutableRawPointer(decoder),
                    input: opusBytes.bindMemory(to: UInt8.self).baseAddress,
                    inputLength: Int32(opusData.count),
                    output: &pcmBuffer,
                    outputLength: Int32(maxOutputSamples),
                    decodeFec: 0  // No FEC
                )
            }
            
            if decodedSamples < 0 {
                // Decoding error
                failedDecodes += 1
                let errorCode = decodedSamples
                print("OpusDecoder: Decode error: \(getOpusErrorString(errorCode))")
                // DebugLogger.shared.log("OpusDecoder: Decode error: \(getOpusErrorString(errorCode))")
                
                // Generate PLC frame for packet loss
                return decodePLC()
            }
            
            // Convert decoded samples to Data
            let actualSamples = Int(decodedSamples)
            var pcmData = Data(capacity: actualSamples * 2)  // 2 bytes per Int16 sample
            
            for i in 0..<actualSamples {
                let sample = pcmBuffer[i]
                withUnsafeBytes(of: sample.littleEndian) { bytes in
                    pcmData.append(contentsOf: bytes)
                }
            }
            
            // Log only periodically to avoid spam
            if totalFramesDecoded % 100 == 1 {
                print("OpusDecoder: Decoded \(opusData.count) bytes → \(pcmData.count) bytes PCM (\(actualSamples) samples)")
                // DebugLogger.shared.log("OpusDecoder: Decoded frame #\(totalFramesDecoded) - \(opusData.count) bytes → \(actualSamples) samples")
            }
            
            return pcmData
        }
    }
    
    /// Generate PLC (Packet Loss Concealment) frame
    func decodePLC() -> Data? {
        guard isInitialized, let decoder = decoder else {
            return nil
        }
        
        plcFrames += 1
        
        // Prepare output buffer
        let outputSamples = config.frameSize
        var pcmBuffer = [Int16](repeating: 0, count: outputSamples)
        
        // Generate PLC frame using the wrapper
        let decodedSamples = OpusWrapper.decode(
            UnsafeMutableRawPointer(decoder),
            input: nil,  // NULL input for PLC
            inputLength: 0,  // Zero length for PLC
            output: &pcmBuffer,
            outputLength: Int32(outputSamples),
            decodeFec: 0  // No FEC
        )
        
        if decodedSamples < 0 {
            print("OpusDecoder: PLC generation failed: \(getOpusErrorString(decodedSamples))")
            return nil
        }
        
        // Convert to Data
        let actualSamples = Int(decodedSamples)
        var pcmData = Data(capacity: actualSamples * 2)
        
        for i in 0..<actualSamples {
            let sample = pcmBuffer[i]
            withUnsafeBytes(of: sample.littleEndian) { bytes in
                pcmData.append(contentsOf: bytes)
            }
        }
        
        return pcmData
    }
    
    /// Get decoder statistics
    func getStatistics() -> [String: Any] {
        return decoderQueue.sync {
            [
                "totalFramesDecoded": totalFramesDecoded,
                "totalBytesDecoded": totalBytesDecoded,
                "failedDecodes": failedDecodes,
                "plcFrames": plcFrames,
                "successRate": totalFramesDecoded > 0 
                    ? Double(totalFramesDecoded - failedDecodes) / Double(totalFramesDecoded) 
                    : 0.0
            ]
        }
    }
    
    /// Reset decoder state
    func reset() {
        decoderQueue.async { [weak self] in
            guard let self = self, let decoder = self.decoder else { return }
            
            // Reset Opus decoder state using the wrapper
            let error = OpusWrapper.decoderCtl(UnsafeMutableRawPointer(decoder), request: 4028)  // OPUS_RESET_STATE = 4028
            if error != 0 {
                print("OpusDecoder: Failed to reset decoder: \(self.getOpusErrorString(error))")
            }
            
            // Reset statistics
            self.totalFramesDecoded = 0
            self.totalBytesDecoded = 0
            self.failedDecodes = 0
            self.plcFrames = 0
            
            print("OpusDecoder: Decoder reset")
            // DebugLogger.shared.log("OpusDecoder: Decoder reset")
        }
    }
    
    // MARK: - Private Methods
    
    /// Convert Opus error code to string
    private func getOpusErrorString(_ errorCode: Int32) -> String {
        switch errorCode {
        case 0: // OPUS_OK
            return "OK"
        case -1: // OPUS_BAD_ARG
            return "Bad argument"
        case -2: // OPUS_BUFFER_TOO_SMALL
            return "Buffer too small"
        case -3: // OPUS_INTERNAL_ERROR
            return "Internal error"
        case -4: // OPUS_INVALID_PACKET
            return "Invalid packet"
        case -5: // OPUS_UNIMPLEMENTED
            return "Unimplemented"
        case -6: // OPUS_INVALID_STATE
            return "Invalid state"
        case -7: // OPUS_ALLOC_FAIL
            return "Allocation failed"
        default:
            return "Unknown error (\(errorCode))"
        }
    }
}

// Helper extension for clamping
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}