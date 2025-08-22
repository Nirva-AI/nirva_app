import Flutter

@available(iOS 13.0, *)
class BleAudioPlugin: NSObject, FlutterPlugin {
    
    // MARK: - Properties
    private static var sharedBleService: BleAudioService?
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    private var bleService: BleAudioService {
        if BleAudioPlugin.sharedBleService == nil {
            BleAudioPlugin.sharedBleService = BleAudioService()
        }
        return BleAudioPlugin.sharedBleService!
    }
    
    // MARK: - FlutterPlugin Implementation
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.nirva.ble_audio", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "com.nirva.ble_audio/events", binaryMessenger: registrar.messenger())
        let instance = BleAudioPlugin()
        instance.methodChannel = channel
        instance.eventChannel = eventChannel
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(instance)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Use the shared BLE service instance
        let bleService = self.bleService
        
        // Handle method calls
        switch call.method {
        case "startScanning":
            handleStartScanning(bleService: bleService, result: result)
            
        case "stopScanning":
            handleStopScanning(bleService: bleService, result: result)
            
        case "disconnect":
            handleDisconnect(bleService: bleService, result: result)
            
        case "getConnectionState":
            handleGetConnectionState(bleService: bleService, result: result)
            
        case "isScanning":
            handleIsScanning(bleService: bleService, result: result)
            
        case "connectToDevice":
            handleConnectToDevice(call: call, bleService: bleService, result: result)
            
        case "getBluetoothState":
            handleGetBluetoothState(bleService: bleService, result: result)
            
        case "getDiscoveredDevicesCount":
            handleGetDiscoveredDevicesCount(bleService: bleService, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Method Handlers
    private func handleStartScanning(bleService: BleAudioService, result: @escaping FlutterResult) {
        let success = bleService.startScanning()
        result(success)
    }
    
    private func handleStopScanning(bleService: BleAudioService, result: @escaping FlutterResult) {
        bleService.stopScanning()
        result(true)
    }
    
    private func handleDisconnect(bleService: BleAudioService, result: @escaping FlutterResult) {
        bleService.disconnect()
        result(true)
    }
    
    private func handleGetConnectionState(bleService: BleAudioService, result: @escaping FlutterResult) {
        let state = bleService.getConnectionState()
        result(state)
    }
    
    private func handleIsScanning(bleService: BleAudioService, result: @escaping FlutterResult) {
        let scanning = bleService.isCurrentlyScanning()
        result(scanning)
    }
    
    private func handleConnectToDevice(call: FlutterMethodCall, bleService: BleAudioService, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let deviceId = args["deviceId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing deviceId parameter", details: nil))
            return
        }
        
        let success = bleService.connectToDevice(deviceId: deviceId)
        result(success)
    }
    
    private func handleGetBluetoothState(bleService: BleAudioService, result: @escaping FlutterResult) {
        let state = bleService.getBluetoothState()
        result(state)
    }
    
    private func handleGetDiscoveredDevicesCount(bleService: BleAudioService, result: @escaping FlutterResult) {
        let count = bleService.getDiscoveredDevicesCount()
        result(count)
    }
}

// MARK: - FlutterStreamHandler
@available(iOS 13.0, *)
extension BleAudioPlugin: FlutterStreamHandler {
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        
        // Use the shared BLE service instance
        let bleService = self.bleService
        
        bleService.onDeviceDiscovered = { [weak self] deviceInfo in
            self?.eventSink?(["event": "deviceDiscovered", "device": deviceInfo])
        }
        
        bleService.onConnectionStateChanged = { [weak self] state in
            self?.eventSink?(["event": "connectionStateChanged", "state": state])
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        
        // Clear BLE service callbacks
        let bleService = self.bleService
        bleService.onDeviceDiscovered = nil
        bleService.onConnectionStateChanged = nil
        
        return nil
    }
}
