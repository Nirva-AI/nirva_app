import Flutter

/// Enhanced BLE Audio Plugin with background processing support
@available(iOS 13.0, *)
class BleAudioPluginV2: NSObject, FlutterPlugin {
    
    // MARK: - Properties
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var streamingEventChannel: FlutterEventChannel?
    private var segmentEventChannel: FlutterEventChannel?
    
    internal var connectionEventSink: FlutterEventSink?
    internal var streamingEventSink: FlutterEventSink?
    internal var segmentEventSink: FlutterEventSink?
    
    private lazy var bleService: BleAudioServiceV2 = {
        print("BleAudioPluginV2: Accessing BleAudioServiceV2.shared for the first time")
        let service = BleAudioServiceV2.shared
        print("BleAudioPluginV2: BleAudioServiceV2.shared accessed successfully")
        return service
    }()
    
    // MARK: - FlutterPlugin Implementation
    static func register(with registrar: FlutterPluginRegistrar) {
        print("========================================")
        print("BleAudioPluginV2: register() called")
        print("BleAudioPluginV2: Creating plugin instance...")
        print("========================================")
        
        // Method channel for control commands
        let methodChannel = FlutterMethodChannel(
            name: "com.nirva.ble_audio_v2",
            binaryMessenger: registrar.messenger()
        )
        
        // Event channels for different event streams
        let connectionEventChannel = FlutterEventChannel(
            name: "com.nirva.ble_audio_v2/connection_events",
            binaryMessenger: registrar.messenger()
        )
        
        let streamingEventChannel = FlutterEventChannel(
            name: "com.nirva.ble_audio_v2/streaming_events",
            binaryMessenger: registrar.messenger()
        )
        
        let segmentEventChannel = FlutterEventChannel(
            name: "com.nirva.ble_audio_v2/segment_events",
            binaryMessenger: registrar.messenger()
        )
        
        let instance = BleAudioPluginV2()
        print("BleAudioPluginV2: Plugin instance created")
        
        instance.methodChannel = methodChannel
        instance.eventChannel = connectionEventChannel
        instance.streamingEventChannel = streamingEventChannel
        instance.segmentEventChannel = segmentEventChannel
        
        print("BleAudioPluginV2: Registering method call delegate...")
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        
        print("BleAudioPluginV2: Setting up event stream handlers...")
        connectionEventChannel.setStreamHandler(instance)
        streamingEventChannel.setStreamHandler(StreamHandler(type: .streaming, plugin: instance))
        segmentEventChannel.setStreamHandler(StreamHandler(type: .segment, plugin: instance))
        
        print("BleAudioPluginV2: Setting up service callbacks...")
        // Setup service callbacks
        instance.setupServiceCallbacks()
        
        print("BleAudioPluginV2: Registration complete!")
    }
    
    // MARK: - Service Setup
    private func setupServiceCallbacks() {
        // Connection state changes
        bleService.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.connectionEventSink?([
                    "event": "connectionStateChanged",
                    "state": state,
                    "timestamp": Date().timeIntervalSince1970
                ])
            }
        }
        
        // Device discovery/connection events
        bleService.onDeviceDiscovered = { [weak self] deviceInfo in
            DispatchQueue.main.async {
                self?.connectionEventSink?(deviceInfo)
            }
        }
        
        // Streaming status updates
        bleService.onStreamingStatusChanged = { [weak self] status in
            DispatchQueue.main.async {
                self?.streamingEventSink?(status)
            }
        }
        
        // Segment events (audio processing milestones)
        bleService.onSegmentEvent = { [weak self] event in
            DispatchQueue.main.async {
                self?.segmentEventSink?(event)
            }
        }
        
        // Error events
        bleService.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.connectionEventSink?([
                    "event": "error",
                    "error": error,
                    "timestamp": Date().timeIntervalSince1970
                ])
            }
        }
    }
    
    // MARK: - Method Call Handler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("BleAudioPluginV2: Received method call: \(call.method)")
        
        switch call.method {
        // Initialization
        case "initialize":
            print("BleAudioPluginV2: Calling bleService.initialize()")
            let success = bleService.initialize()
            print("BleAudioPluginV2: Initialize returned: \(success)")
            result(success)
            
        // Scanning
        case "startScanning":
            print("BleAudioPluginV2: Calling bleService.startScanning()")
            let success = bleService.startScanning()
            print("BleAudioPluginV2: StartScanning returned: \(success)")
            result(success)
            
        case "stopScanning":
            bleService.stopScanning()
            result(true)
            
        // Connection management
        case "connectToDevice":
            guard let args = call.arguments as? [String: Any],
                  let deviceId = args["deviceId"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing deviceId", details: nil))
                return
            }
            let success = bleService.connectToDevice(deviceId: deviceId)
            result(success)
            
        case "disconnect":
            bleService.disconnect()
            result(true)
            
        case "forgetDevice":
            bleService.forgetDevice()
            result(true)
            
        // Streaming control
        case "startStreaming":
            let success = bleService.startStreaming()
            result(success)
            
        case "stopStreaming":
            bleService.stopStreaming()
            result(true)
            
        // Information queries
        case "getConnectionInfo":
            var info = bleService.getConnectionInfo()
            // Add battery level to connection info
            if let batteryLevel = bleService.getBatteryLevel() {
                info["batteryLevel"] = batteryLevel
            }
            print("BleAudioPluginV2: Connection info: \(info)")
            result(info)
            
        case "getBatteryLevel":
            let batteryLevel = bleService.getBatteryLevel()
            print("BleAudioPluginV2: Battery level: \(batteryLevel ?? -1)")
            result(batteryLevel)
            
        case "getStreamingStats":
            let stats = bleService.getStreamingStats()
            result(stats)
            
        case "getDebugLog":
            // Get recent log contents (last 500KB for more history)
            let logContents = DebugLogger.shared.getRecentLogContents(maxBytes: 512000)
            
            // Get connection info for summary
            let connInfo = BleAudioServiceV2.shared.getConnectionInfo()
            let bgPackets = connInfo["backgroundPacketsReceived"] as? Int ?? 0
            let totalPackets = connInfo["totalPacketsReceived"] as? Int ?? 0
            let bgPercentage = totalPackets > 0 ? (Double(bgPackets) / Double(totalPackets) * 100) : 0
            
            // Add detailed state info at the top
            let stateInfo = """
            === CURRENT STATE ===
            App State: \(UIApplication.shared.applicationState.rawValue) (0=Active, 1=Inactive, 2=Background)
            Date: \(Date())
            
            === BACKGROUND BLE SUMMARY ===
            ✅ Background Packets Received: \(bgPackets)
            📊 Total Packets Received: \(totalPackets)
            📈 Background Percentage: \(String(format: "%.1f", bgPercentage))%
            🔌 Connection State: \(connInfo["state"] ?? "unknown")
            ⏰ Last BG Packet: \(connInfo["timeSinceLastBgPacket"] != nil ? "\(String(format: "%.1f", connInfo["timeSinceLastBgPacket"] as? Double ?? 0))s ago" : "never")
            
            === FULL CONNECTION INFO ===
            \(connInfo)
            
            === LOG START (Last 100KB) ===
            
            """
            
            result(stateInfo + logContents)
            
        // Settings
        case "setConnectIntent":
            guard let args = call.arguments as? [String: Any],
                  let intent = args["intent"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing intent", details: nil))
                return
            }
            // This would be implemented to control auto-reconnect behavior
            result(true)
            
        case "setBatchSize":
            guard let args = call.arguments as? [String: Any],
                  let size = args["size"] as? Int else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing size", details: nil))
                return
            }
            // This would configure VAD batch size (Phase 2)
            result(true)
            
        case "setS3Credentials":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing credentials", details: nil))
                return
            }
            
            // Pass credentials to S3BackgroundUploader
            S3BackgroundUploader.shared.setCredentials(args)
            
            // Also store userId in UserDefaults for native access
            if let userId = args["userId"] as? String {
                UserDefaults.standard.set(userId, forKey: "userId")
            }
            
            result(true)
            
        case "getUploadQueueStatus":
            let stats = S3BackgroundUploader.shared.getStatistics()
            result(stats)
            
        case "processQueuedUploads":
            S3BackgroundUploader.shared.processQueuedUploads()
            result(true)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - FlutterStreamHandler for Connection Events
@available(iOS 13.0, *)
extension BleAudioPluginV2: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        connectionEventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        connectionEventSink = nil
        return nil
    }
}

// MARK: - Additional Stream Handlers
@available(iOS 13.0, *)
class StreamHandler: NSObject, FlutterStreamHandler {
    enum StreamType {
        case streaming
        case segment
    }
    
    let type: StreamType
    weak var plugin: BleAudioPluginV2?
    
    init(type: StreamType, plugin: BleAudioPluginV2) {
        self.type = type
        self.plugin = plugin
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        switch type {
        case .streaming:
            plugin?.streamingEventSink = events
        case .segment:
            plugin?.segmentEventSink = events
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        switch type {
        case .streaming:
            plugin?.streamingEventSink = nil
        case .segment:
            plugin?.segmentEventSink = nil
        }
        return nil
    }
}