import Foundation
import CoreBluetooth

@available(iOS 13.0, *)
class BleAudioService: NSObject {
    
    // MARK: - Properties
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var discoveredPeripherals: [String: CBPeripheral] = [:]
    
    // MARK: - BLE Configuration
    // These will be configured when we implement the actual audio streaming
    // For now, we're just doing device discovery and connection
    
    // MARK: - State
    private var isScanning = false
    private var connectionState: ConnectionState = .idle
    private var _pendingScanRequest = false
    
    // MARK: - Callbacks
    var onDeviceDiscovered: (([String: Any]) -> Void)?
    var onConnectionStateChanged: ((String) -> Void)?
    
    // MARK: - Enums
    enum ConnectionState: String, CaseIterable {
        case idle = "idle"
        case scanning = "scanning"
        case connecting = "connecting"
        case connected = "connected"
        case error = "error"
    }
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupCentralManager()
    }
    
    private func setupCentralManager() {
        let options: [String: Any] = [
            CBCentralManagerOptionShowPowerAlertKey: true,
            CBCentralManagerOptionRestoreIdentifierKey: "com.nirva.ble_audio_restore"
        ]
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
    // MARK: - Public Methods
    func startScanning() -> Bool {
        guard !isScanning else {
            return false
        }
        
        // Check Bluetooth state and handle different cases
        switch centralManager.state {
        case .poweredOn:
            _startScanningInternal()
            return true
            
        case .poweredOff, .unauthorized, .unsupported:
            return false
            
        case .unknown, .resetting:
            // Store the intent to scan and start when Bluetooth becomes ready
            _pendingScanRequest = true
            return true
            
        @unknown default:
            return false
        }
    }
    
    private func _startScanningInternal() {
        isScanning = true
        connectionState = .scanning
        _pendingScanRequest = false
        
        // Start scanning for ANY BLE devices (no service filter for now)
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false
        ])
        
        // Auto-stop scanning after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            self?.stopScanning()
        }
    }
    
    func stopScanning() {
        guard isScanning else { return }
        
        centralManager.stopScan()
        isScanning = false
        
        if connectionState == .scanning {
            connectionState = .error
        }
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        connectedPeripheral = nil
        connectionState = .idle
    }
    
    func getConnectionState() -> String {
        return connectionState.rawValue
    }
    
    func isCurrentlyScanning() -> Bool {
        return isScanning
    }
    
    func getBluetoothState() -> String {
        return String(describing: centralManager.state)
    }
    
    func getDiscoveredDevicesCount() -> Int {
        return discoveredPeripherals.count
    }
    

    
    func connectToDevice(deviceId: String) -> Bool {
        guard let peripheral = discoveredPeripherals[deviceId] else {
            return false
        }
        
        guard centralManager.state == .poweredOn else {
            return false
        }
        
        connectionState = .connecting
        onConnectionStateChanged?(connectionState.rawValue)
        
        // Store the peripheral we're trying to connect to
        connectedPeripheral = peripheral
        
        // Connect with options
        centralManager.connect(peripheral, options: [
            CBConnectPeripheralOptionNotifyOnConnectionKey: true,
            CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
            CBConnectPeripheralOptionNotifyOnNotificationKey: true
        ])
        
        return true
    }
}

// MARK: - CBCentralManagerDelegate
@available(iOS 13.0, *)
extension BleAudioService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            connectionState = .idle
            
            // If there was a pending scan request, start scanning now
            if _pendingScanRequest {
                DispatchQueue.main.async { [weak self] in
                    self?._startScanningInternal()
                }
            }
            
        case .poweredOff, .unauthorized, .unsupported, .unknown, .resetting:
            connectionState = .error
            _pendingScanRequest = false
            
        @unknown default:
            _pendingScanRequest = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceId = peripheral.identifier.uuidString
        let deviceName = peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "Unknown Device"
        
        // Store the discovered peripheral
        discoveredPeripherals[deviceId] = peripheral
        
        // Create device info dictionary for Flutter
        let deviceInfo: [String: Any] = [
            "id": deviceId,
            "name": deviceName,
            "rssi": RSSI.intValue
        ]
        
        // Notify Flutter about the discovered device
        onDeviceDiscovered?(deviceInfo)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectionState = .connected
        onConnectionStateChanged?(connectionState.rawValue)
        
        // Set up peripheral delegate and discover services
        peripheral.delegate = self
        
        // Discover ALL services for now (we'll filter later)
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionState = .error
        onConnectionStateChanged?(connectionState.rawValue)
        connectedPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        connectionState = .idle
        onConnectionStateChanged?(connectionState.rawValue)
    }
    
    // MARK: - State Restoration (Basic implementation for now)
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        // Extract restored peripherals
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                if peripheral.state == .connected {
                    connectedPeripheral = peripheral
                    peripheral.delegate = self
                    connectionState = .connected
                    
                    // Re-discover services for the restored peripheral
                    // We'll implement proper service discovery in the next phase
                    peripheral.discoverServices(nil)
                }
            }
        }
    }
}

// MARK: - CBPeripheralDelegate
@available(iOS 13.0, *)
extension BleAudioService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // TODO: Implement service discovery in the next phase
        // This will handle the actual audio service and characteristics
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // TODO: Implement characteristic discovery in the next phase
        // This will set up audio data notifications
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // TODO: Process audio data (packet reassembly, Opus decode, VAD, etc.)
        // This will be implemented in the next phase
    }
}
