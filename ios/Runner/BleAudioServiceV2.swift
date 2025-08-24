import Foundation
import CoreBluetooth

/// Enhanced BLE Audio Service with background processing support
/// This service coordinates between ConnectionOrchestrator and the audio processing pipeline
@available(iOS 13.0, *)
class BleAudioServiceV2: NSObject {
    
    // MARK: - Singleton
    static let shared = BleAudioServiceV2()
    
    // MARK: - Properties
    private var connectionOrchestrator: ConnectionOrchestrator!
    private var packetReassembler: PacketReassembler?
    private var audioProcessor: AudioProcessor?
    
    // Service configuration
    private var isInitialized = false
    private var isStreaming = false
    
    // Statistics
    private var totalPacketsReceived = 0
    private var totalBytesReceived = 0
    private var sessionStartTime: Date?
    private var backgroundPacketsReceived = 0
    private var lastBackgroundPacketTime: Date?
    private var totalSegments = 0  // Track number of segments for metadata
    
    // Callbacks for Flutter communication
    var onStateChanged: ((String) -> Void)?
    var onDeviceDiscovered: (([String: Any]) -> Void)?
    var onStreamingStatusChanged: (([String: Any]) -> Void)?
    var onSegmentEvent: (([String: Any]) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        print("BleAudioServiceV2: init() called")
        DebugLogger.shared.log("BleAudioServiceV2: init() called")
        
        // Create ConnectionOrchestrator instance
        print("BleAudioServiceV2: Creating ConnectionOrchestrator...")
        DebugLogger.shared.log("BleAudioServiceV2: Creating ConnectionOrchestrator...")
        connectionOrchestrator = ConnectionOrchestrator()
        print("BleAudioServiceV2: ConnectionOrchestrator created")
        DebugLogger.shared.log("BleAudioServiceV2: ConnectionOrchestrator created")
        
        setupOrchestrator()
    }
    
    private func setupOrchestrator() {
        print("BleAudioServiceV2: Setting up orchestrator callbacks...")
        
        // Set up connection orchestrator callbacks
        connectionOrchestrator.onStateChanged = { [weak self] state in
            print("BleAudioServiceV2: State changed callback - \(state)")
            self?.handleConnectionStateChange(state)
        }
        
        connectionOrchestrator.onDeviceDiscovered = { [weak self] deviceInfo in
            print("BleAudioServiceV2: Device discovered callback")
            self?.onDeviceDiscovered?(deviceInfo)
        }
        
        connectionOrchestrator.onDeviceConnected = { [weak self] deviceId in
            print("BleAudioServiceV2: Device connected callback - \(deviceId)")
            self?.handleDeviceConnected(deviceId)
        }
        
        connectionOrchestrator.onDeviceDisconnected = { [weak self] deviceId, error in
            print("BleAudioServiceV2: Device disconnected callback")
            self?.handleDeviceDisconnected(deviceId: deviceId, error: error)
        }
        
        connectionOrchestrator.onPacketReceived = { [weak self] data in
            self?.handleIncomingPacket(data)
        }
        
        connectionOrchestrator.onError = { [weak self] error in
            print("BleAudioServiceV2: Error callback - \(error)")
            self?.onError?(error)
        }
        
        print("BleAudioServiceV2: Orchestrator callbacks setup complete")
    }
    
    // MARK: - Public API
    
    /// Initialize the service and prepare for streaming
    func initialize() -> Bool {
        DebugLogger.shared.log("BleAudioServiceV2: initialize() called")
        
        guard !isInitialized else {
            print("BleAudioServiceV2: Already initialized")
            DebugLogger.shared.log("BleAudioServiceV2: Already initialized")
            
            // Attempt auto-connect if already initialized
            attemptAutoConnect()
            return true
        }
        
        print("BleAudioServiceV2: Initializing...")
        DebugLogger.shared.log("BleAudioServiceV2: Initializing...")
        DebugLogger.shared.log("BleAudioServiceV2: Log file path: \(DebugLogger.shared.getLogPath())")
        
        // Initialize packet reassembler
        packetReassembler = PacketReassembler()
        packetReassembler?.onCompletePacket = { [weak self] opusData in
            self?.handleCompleteOpusPacket(opusData)
        }
        
        // Initialize audio processor with Opus decoder
        print("BleAudioServiceV2: Creating AudioProcessor...")
        DebugLogger.shared.log("BleAudioServiceV2: Creating AudioProcessor...")
        audioProcessor = AudioProcessor()
        
        if audioProcessor != nil {
            print("BleAudioServiceV2: AudioProcessor created successfully")
            DebugLogger.shared.log("BleAudioServiceV2: AudioProcessor created successfully")
            
            audioProcessor?.onSegmentReady = { [weak self] wavData, duration, filePath in
                self?.handleAudioSegment(wavData, duration: duration, filePath: filePath)
            }
            audioProcessor?.onError = { error in
                print("BleAudioServiceV2: AudioProcessor error: \(error)")
            }
        } else {
            print("BleAudioServiceV2: ERROR - Failed to create AudioProcessor!")
            DebugLogger.shared.log("BleAudioServiceV2: ERROR - Failed to create AudioProcessor!")
        }
        
        isInitialized = true
        print("BleAudioServiceV2: Initialization complete")
        DebugLogger.shared.log("BleAudioServiceV2: Initialization complete")
        
        // Attempt auto-connect to remembered device
        attemptAutoConnect()
        
        return true
    }
    
    /// Attempt to auto-connect to remembered device
    func attemptAutoConnect() {
        print("BleAudioServiceV2: Attempting auto-connect to remembered device")
        DebugLogger.shared.log("BleAudioServiceV2: Attempting auto-connect to remembered device")
        connectionOrchestrator.attemptAutoConnect()
    }
    
    /// Start scanning for BLE devices
    func startScanning() -> Bool {
        guard isInitialized else {
            print("BleAudioServiceV2: Not initialized")
            return false
        }
        
        print("BleAudioServiceV2: Starting scan...")
        print("BleAudioServiceV2: ConnectionOrchestrator instance: \(connectionOrchestrator)")
        
        // For now, just set connect intent to start discovery
        // In production, this would be triggered by user action
        print("BleAudioServiceV2: About to call setConnectIntent(true)")
        connectionOrchestrator.setConnectIntent(true)
        print("BleAudioServiceV2: Called setConnectIntent(true)")
        return true
    }
    
    /// Stop scanning
    func stopScanning() {
        print("BleAudioServiceV2: Stopping scan...")
        connectionOrchestrator.setConnectIntent(false)
    }
    
    /// Connect to a specific device
    func connectToDevice(deviceId: String) -> Bool {
        guard let uuid = UUID(uuidString: deviceId) else {
            print("BleAudioServiceV2: Invalid device ID")
            return false
        }
        
        print("BleAudioServiceV2: Connecting to device \(deviceId)")
        
        // Use the new connectToDevice method for user-initiated connection
        connectionOrchestrator.connectToDevice(uuid: uuid)
        
        return true
    }
    
    /// Disconnect from current device
    func disconnect() {
        print("BleAudioServiceV2: Disconnecting...")
        connectionOrchestrator.setConnectIntent(false)
        stopStreaming()
    }
    
    /// Forget a paired device
    func forgetDevice() {
        print("BleAudioServiceV2: Forgetting device...")
        connectionOrchestrator.forgetDevice()
        stopStreaming()
    }
    
    /// Start audio streaming
    func startStreaming() -> Bool {
        guard isInitialized else {
            print("BleAudioServiceV2: Not initialized")
            return false
        }
        
        guard !isStreaming else {
            print("BleAudioServiceV2: Already streaming")
            return true
        }
        
        print("BleAudioServiceV2: Starting audio stream...")
        
        isStreaming = true
        sessionStartTime = Date()
        totalPacketsReceived = 0
        totalBytesReceived = 0
        
        // Notify Flutter
        notifyStreamingStatus()
        
        return true
    }
    
    /// Stop audio streaming
    func stopStreaming() {
        guard isStreaming else { return }
        
        print("BleAudioServiceV2: Stopping audio stream...")
        
        isStreaming = false
        sessionStartTime = nil
        
        // Notify Flutter
        notifyStreamingStatus()
    }
    
    /// Get current connection info
    func getConnectionInfo() -> [String: Any] {
        var info = connectionOrchestrator.getConnectionInfo()
        info["isInitialized"] = isInitialized
        info["isStreaming"] = isStreaming
        info["totalPacketsReceived"] = totalPacketsReceived
        info["totalBytesReceived"] = totalBytesReceived
        info["backgroundPacketsReceived"] = Int(backgroundPacketsReceived)  // Convert to Int for JSON
        
        if let startTime = sessionStartTime {
            info["sessionDuration"] = Date().timeIntervalSince(startTime)
        }
        
        if let lastBgTime = lastBackgroundPacketTime {
            info["lastBackgroundPacket"] = lastBgTime.timeIntervalSince1970
            info["timeSinceLastBgPacket"] = Date().timeIntervalSince(lastBgTime)
        }
        
        // Add saved audio files info
        let audioFiles = getSavedAudioFiles()
        info["savedAudioFiles"] = audioFiles.count
        info["audioFilesList"] = audioFiles
        
        // Add audio processor stats
        if let audioStats = audioProcessor?.getStatistics() {
            info["audioProcessor"] = audioStats
        }
        
        return info
    }
    
    /// Get saved audio files
    func getSavedAudioFiles() -> [String] {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let audioDir = (documentsPath as NSString).appendingPathComponent("ble_audio_segments")
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: audioDir)
            let wavFiles = files.filter { $0.hasSuffix(".wav") }
            print("BleAudioServiceV2: Found \(wavFiles.count) WAV files in \(audioDir)")
            for file in wavFiles {
                let filePath = (audioDir as NSString).appendingPathComponent(file)
                if let attributes = try? FileManager.default.attributesOfItem(atPath: filePath),
                   let fileSize = attributes[.size] as? Int {
                    print("  - \(file): \(fileSize) bytes")
                }
            }
            return wavFiles
        } catch {
            print("BleAudioServiceV2: Error reading audio directory: \(error)")
            print("  Directory path: \(audioDir)")
            return []
        }
    }
    
    /// Get streaming statistics
    func getStreamingStats() -> [String: Any] {
        return [
            "isStreaming": isStreaming,
            "packetsReceived": totalPacketsReceived,
            "bytesReceived": totalBytesReceived,
            "sessionDuration": sessionStartTime != nil ? Date().timeIntervalSince(sessionStartTime!) : 0,
            "packetsPerSecond": calculatePacketsPerSecond()
        ]
    }
    
    // MARK: - Private Methods
    
    private func handleConnectionStateChange(_ state: String) {
        print("BleAudioServiceV2: Connection state changed to \(state)")
        
        onStateChanged?(state)
        
        // Auto-start streaming when subscribed
        if state == "subscribed" && !isStreaming {
            startStreaming()
        } else if state != "subscribed" && isStreaming {
            stopStreaming()
        }
    }
    
    private func handleDeviceConnected(_ deviceId: String) {
        print("BleAudioServiceV2: Device connected: \(deviceId)")
        
        // Notify Flutter
        onDeviceDiscovered?([
            "event": "deviceConnected",
            "deviceId": deviceId,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    private func handleDeviceDisconnected(deviceId: String?, error: String?) {
        print("BleAudioServiceV2: Device disconnected: \(deviceId ?? "unknown") - \(error ?? "no error")")
        
        // Stop streaming if active
        if isStreaming {
            stopStreaming()
        }
        
        // Notify Flutter
        onDeviceDiscovered?([
            "event": "deviceDisconnected",
            "deviceId": deviceId ?? "",
            "error": error ?? "",
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    private func handleIncomingPacket(_ data: Data) {
        // Check app state for background logging
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "[BACKGROUND]" : appState == .inactive ? "[INACTIVE]" : "[FOREGROUND]"
        
        // Track background packets
        if appState == .background || appState == .inactive {
            backgroundPacketsReceived += 1
            lastBackgroundPacketTime = Date()
            
            // ALWAYS log background packets - this is critical!
            print("BleAudioServiceV2: \(stateString) BACKGROUND PACKET #\(totalPacketsReceived + 1) (BG#\(backgroundPacketsReceived)), size: \(data.count) bytes")
            DebugLogger.shared.log("BleAudioServiceV2: \(stateString) BACKGROUND PACKET #\(totalPacketsReceived + 1) (BG#\(backgroundPacketsReceived)), size: \(data.count) bytes")
            
            // Mark background wake event
            if backgroundPacketsReceived == 1 {
                DebugLogger.shared.markBackgroundWake()
            }
        } else if totalPacketsReceived % 10 == 0 || totalPacketsReceived < 5 {
            // Log foreground packets periodically
            print("BleAudioServiceV2: \(stateString) Received packet #\(totalPacketsReceived + 1), size: \(data.count) bytes")
            DebugLogger.shared.log("BleAudioServiceV2: \(stateString) Received packet #\(totalPacketsReceived + 1), size: \(data.count) bytes")
        }
        
        // Update statistics
        totalPacketsReceived += 1
        totalBytesReceived += data.count
        
        // Auto-start streaming when we receive data
        if !isStreaming && totalPacketsReceived > 0 {
            print("BleAudioServiceV2: Auto-starting streaming due to incoming data")
            DebugLogger.shared.log("BleAudioServiceV2: Auto-starting streaming due to incoming data")
            startStreaming()
        }
        
        guard isStreaming else { return }
        
        // Process packet through reassembler
        packetReassembler?.processPacket(data)
        
        // Periodically notify streaming status
        if totalPacketsReceived % 100 == 0 {
            notifyStreamingStatus()
        }
    }
    
    private func handleCompleteOpusPacket(_ opusData: Data) {
        print("BleAudioServiceV2: Complete Opus packet received (\(opusData.count) bytes)")
        DebugLogger.shared.log("BleAudioServiceV2: Complete Opus packet received (\(opusData.count) bytes)")
        
        // Forward to audio processor for decoding and buffering
        if let processor = audioProcessor {
            print("BleAudioServiceV2: Forwarding to AudioProcessor")
            processor.processOpusPacket(opusData)
        } else {
            print("BleAudioServiceV2: WARNING - AudioProcessor is nil!")
        }
        
        // Notify Flutter about the packet
        onSegmentEvent?([
            "event": "opusPacketComplete",
            "size": opusData.count,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    private func handleAudioSegment(_ wavData: Data, duration: TimeInterval, filePath: String) {
        print("BleAudioServiceV2: Audio segment ready - Duration: \(duration)s, Size: \(wavData.count) bytes")
        print("BleAudioServiceV2: Segment file path: \(filePath)")
        DebugLogger.shared.log("BleAudioServiceV2: Audio segment ready at: \(filePath)")
        
        // Phase 5: Queue for S3 upload via background URLSession
        // The AudioProcessor already saved the WAV file, we just need to queue it
        
        // Check if file exists (it should have been saved by AudioProcessor)
        if FileManager.default.fileExists(atPath: filePath) {
            print("BleAudioServiceV2: Queueing segment for S3 upload: \(filePath)")
            let fileName = URL(fileURLWithPath: filePath).lastPathComponent
            DebugLogger.shared.log("BleAudioServiceV2: Queueing segment for S3 upload: \(fileName)")
            
            // Get user ID from UserDefaults (set by Flutter)
            let userId = UserDefaults.standard.string(forKey: "userId") ?? "default_user"
            
            // Queue for S3 upload with metadata
            S3BackgroundUploader.shared.queueUpload(
                localPath: filePath,
                userId: userId,
                metadata: [
                    "duration": String(duration),
                    "segmentNumber": String(totalSegments),
                    "deviceId": connectionOrchestrator.getConnectionInfo()["deviceId"] as? String ?? "unknown"
                ]
            )
            
            totalSegments += 1
        } else {
            print("BleAudioServiceV2: ERROR - WAV file not found at: \(filePath)")
            DebugLogger.shared.log("BleAudioServiceV2: ERROR - WAV file not found at: \(filePath)")
        }
        
        // TODO: Phase 6 - Send to Deepgram for transcription
        
        // Notify Flutter about the segment
        onSegmentEvent?([
            "event": "audioSegmentReady",
            "duration": duration,
            "size": wavData.count,
            "timestamp": Date().timeIntervalSince1970,
            "filePath": filePath
        ])
    }
    
    private func notifyStreamingStatus() {
        onStreamingStatusChanged?(getStreamingStats())
    }
    
    private func calculatePacketsPerSecond() -> Double {
        guard let startTime = sessionStartTime else { return 0 }
        
        let duration = Date().timeIntervalSince(startTime)
        guard duration > 0 else { return 0 }
        
        return Double(totalPacketsReceived) / duration
    }
    
    // MARK: - Battery Level
    
    /// Get battery level from connected device
    func getBatteryLevel() -> Int? {
        return connectionOrchestrator.getBatteryLevel()
    }
}

// PacketReassembler is now implemented in PacketReassembler.swift
// AudioProcessor is now implemented in AudioProcessor.swift