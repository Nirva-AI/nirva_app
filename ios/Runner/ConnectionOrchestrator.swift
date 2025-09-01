import Foundation
import CoreBluetooth

/// Connection orchestrator that manages BLE connection state machine with auto-reconnect
@available(iOS 13.0, *)
class ConnectionOrchestrator: NSObject {
    
    // MARK: - Connection States
    enum ConnectionState: String {
        case idle = "idle"
        case discovering = "discovering"
        case connecting = "connecting"
        case subscribed = "subscribed"
        case backoff = "backoff"
    }
    
    // MARK: - Properties
    private var centralManager: CBCentralManager?
    private let bleQueue = DispatchQueue(label: "com.nirva.ble.orchestrator", qos: .userInitiated)
    private var isBluetoothInitialized = false
    
    // State management
    private var currentState: ConnectionState = .idle {
        didSet {
            if oldValue != currentState {
                print("ConnectionOrchestrator: State transition \(oldValue) -> \(currentState)")
                onStateChanged?(currentState.rawValue)
            }
        }
    }
    
    // Connection intent
    private var connectIntent: Bool = false
    
    // Device management
    private var rememberedDeviceUUID: UUID?
    private var rememberedServiceUUIDs: [CBUUID] = []
    private var targetPeripheral: CBPeripheral?
    private var audioCharacteristic: CBCharacteristic?
    private var lastKnownBatteryLevel: Int?
    
    // Service and characteristic UUIDs for OMI/hardware device
    private let audioServiceUUID = CBUUID(string: "19B10000-E8F2-537E-4F6C-D104768A1214")
    private let audioCharacteristicUUID = CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214")
    private let buttonServiceUUID = CBUUID(string: "23BA7924-0000-1000-7450-346EAC492E92") // Used for scanning
    
    // Service UUIDs for background scanning - iOS will wake app for these
    private var scanServiceUUIDs: [CBUUID] {
        return [audioServiceUUID, buttonServiceUUID]
    }
    
    // Backoff configuration
    private var backoffTimer: Timer?
    private var backoffAttempt = 0
    private let backoffSteps = [2.0, 5.0, 10.0, 20.0, 30.0, 60.0] // seconds
    private let backoffJitterRange = 0.2 // ±20% jitter
    
    // Watchdog configuration
    private var streamWatchdogTimer: Timer?
    private var lastPacketTimestamp: Date?
    private let watchdogTimeout: TimeInterval = 2.0 // 2 seconds for always-on audio
    
    // Statistics
    private var connectionAttempts = 0
    private var successfulConnections = 0
    private var lastStableConnectionTime: Date?
    private let stabilityWindow: TimeInterval = 60.0 // 60 seconds for backoff reset
    
    // Callbacks
    var onStateChanged: ((String) -> Void)?
    var onDeviceDiscovered: (([String: Any]) -> Void)?  // For discovery events
    var onDeviceConnected: ((String) -> Void)?
    var onDeviceDisconnected: ((String?, String?) -> Void)? // deviceId, error
    var onPacketReceived: ((Data) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initialization
    override init() {
        super.init()
        print("ConnectionOrchestrator: init() called")
        DebugLogger.shared.log("ConnectionOrchestrator: init() called")
        // Delay CBCentralManager initialization until actually needed
        loadRememberedDevice()
    }
    
    private func setupCentralManager() {
        guard centralManager == nil else {
            print("ConnectionOrchestrator: CBCentralManager already initialized")
            return
        }
        
        print("ConnectionOrchestrator: setupCentralManager() called - initializing CBCentralManager")
        DebugLogger.shared.log("ConnectionOrchestrator: setupCentralManager() called - initializing CBCentralManager")
        let options: [String: Any] = [
            CBCentralManagerOptionShowPowerAlertKey: true,
            CBCentralManagerOptionRestoreIdentifierKey: "com.nirva.ble.orchestrator.restoration"
        ]
        
        // CRITICAL: Use nil for queue to use main queue for delegate callbacks
        // This is required for background BLE to work properly on iOS
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        isBluetoothInitialized = true
        print("ConnectionOrchestrator: CBCentralManager created with main queue for background support")
        DebugLogger.shared.log("ConnectionOrchestrator: CBCentralManager created with main queue for background support")
    }
    
    /// Ensure CBCentralManager is initialized when needed
    private func ensureCentralManagerInitialized() {
        if centralManager == nil {
            setupCentralManager()
        }
    }
    
    private func loadRememberedDevice() {
        // Load remembered device from UserDefaults
        if let uuidString = UserDefaults.standard.string(forKey: "com.nirva.ble.rememberedDevice"),
           let uuid = UUID(uuidString: uuidString) {
            rememberedDeviceUUID = uuid
            print("ConnectionOrchestrator: Loaded remembered device UUID on init: \(uuid)")
            DebugLogger.shared.log("ConnectionOrchestrator: Loaded remembered device UUID on init: \(uuid)")
            
            if let serviceStrings = UserDefaults.standard.array(forKey: "com.nirva.ble.rememberedServices") as? [String] {
                rememberedServiceUUIDs = serviceStrings.compactMap { CBUUID(string: $0) }
                print("ConnectionOrchestrator: Loaded remembered service UUIDs: \(rememberedServiceUUIDs)")
            }
        } else {
            print("ConnectionOrchestrator: No remembered device found on init")
            DebugLogger.shared.log("ConnectionOrchestrator: No remembered device found on init")
        }
    }
    
    // MARK: - Public API
    
    /// Check if CBCentralManager has been initialized (permission has been requested)
    func isBluetoothPermissionRequested() -> Bool {
        return isBluetoothInitialized
    }
    
    /// Set the connection intent (true to connect, false to disconnect)
    func setConnectIntent(_ intent: Bool) {
        bleQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("ConnectionOrchestrator: Setting connect intent to \(intent)")
            DebugLogger.shared.log("ConnectionOrchestrator: Setting connect intent to \(intent)")
            self.connectIntent = intent
            
            if intent {
                // Initialize CBCentralManager when actually needed
                self.ensureCentralManagerInitialized()
                print("ConnectionOrchestrator: Current state = \(self.currentState), BT state = \(self.centralManager?.state.rawValue ?? -1)")
                self.startConnectionFlow()
            } else {
                self.stopConnectionFlow()
            }
        }
    }
    
    /// Connect to a specific device (user-initiated pairing)
    func connectToDevice(uuid: UUID) {
        bleQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("ConnectionOrchestrator: User-initiated connection to device \(uuid)")
            DebugLogger.shared.log("ConnectionOrchestrator: User-initiated connection to device \(uuid)")
            
            // Remember this device for future auto-reconnect
            self.rememberDevice(uuid: uuid, serviceUUIDs: [self.audioServiceUUID])
            
            // Initialize CBCentralManager when connecting to device
            self.ensureCentralManagerInitialized()
            
            // Try to retrieve the peripheral
            let peripherals = self.centralManager?.retrievePeripherals(withIdentifiers: [uuid]) ?? []
            if let peripheral = peripherals.first {
                print("ConnectionOrchestrator: Found peripheral to connect: \(peripheral.name ?? "unknown")")
                self.targetPeripheral = peripheral
                self.transitionToConnecting()
            } else {
                // If we can't retrieve it, we need to scan for it
                print("ConnectionOrchestrator: Peripheral not in cache, will scan for it")
                self.setConnectIntent(true)
            }
        }
    }
    
    /// Remember a device for auto-reconnect
    func rememberDevice(uuid: UUID, serviceUUIDs: [CBUUID]) {
        bleQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("ConnectionOrchestrator: Remembering device \(uuid)")
            self.rememberedDeviceUUID = uuid
            self.rememberedServiceUUIDs = serviceUUIDs
            
            // Save to UserDefaults for persistence
            UserDefaults.standard.set(uuid.uuidString, forKey: "com.nirva.ble.rememberedDevice")
            UserDefaults.standard.set(serviceUUIDs.map { $0.uuidString }, forKey: "com.nirva.ble.rememberedServices")
        }
    }
    
    /// Forget the remembered device
    func forgetDevice() {
        bleQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("ConnectionOrchestrator: Forgetting device")
            DebugLogger.shared.log("ConnectionOrchestrator: Forgetting device")
            self.rememberedDeviceUUID = nil
            self.rememberedServiceUUIDs = []
            self.targetPeripheral = nil
            
            // Clear from UserDefaults
            UserDefaults.standard.removeObject(forKey: "com.nirva.ble.rememberedDevice")
            UserDefaults.standard.removeObject(forKey: "com.nirva.ble.rememberedServices")
            UserDefaults.standard.synchronize()  // Force save
            
            // Disconnect if connected
            if let peripheral = self.targetPeripheral {
                self.centralManager?.cancelPeripheralConnection(peripheral)
            }
            
            self.setConnectIntent(false)
        }
    }
    
    /// Attempt to auto-connect to remembered device
    func attemptAutoConnect() {
        bleQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let deviceUUID = self.rememberedDeviceUUID else {
                print("ConnectionOrchestrator: No remembered device to auto-connect")
                DebugLogger.shared.log("ConnectionOrchestrator: No remembered device to auto-connect")
                return
            }
            
            // Initialize CBCentralManager for auto-connect
            self.ensureCentralManagerInitialized()
            
            guard self.centralManager?.state == .poweredOn else {
                print("ConnectionOrchestrator: Bluetooth not ready for auto-connect")
                DebugLogger.shared.log("ConnectionOrchestrator: Bluetooth not ready for auto-connect")
                return
            }
            
            // Reset state if stuck in connecting without a peripheral
            if self.currentState == .connecting && self.targetPeripheral == nil {
                print("ConnectionOrchestrator: Stuck in connecting state without peripheral, resetting to idle")
                DebugLogger.shared.log("ConnectionOrchestrator: Stuck in connecting state without peripheral, resetting to idle")
                self.currentState = .idle
            }
            
            guard self.currentState == .idle else {
                print("ConnectionOrchestrator: Already in connection flow (state: \(self.currentState)), skipping auto-connect")
                DebugLogger.shared.log("ConnectionOrchestrator: Already in connection flow (state: \(self.currentState)), skipping auto-connect")
                return
            }
            
            print("ConnectionOrchestrator: Attempting auto-connect to remembered device: \(deviceUUID)")
            DebugLogger.shared.log("ConnectionOrchestrator: Attempting auto-connect to remembered device: \(deviceUUID)")
            
            // Set connect intent to trigger connection flow
            self.connectIntent = true
            self.startConnectionFlow()
        }
    }
    
    /// Get current connection info
    func getConnectionInfo() -> [String: Any] {
        var info: [String: Any] = [
            "state": currentState.rawValue,
            "deviceId": rememberedDeviceUUID?.uuidString ?? "",
            "isConnected": currentState == .subscribed,
            "connectionAttempts": connectionAttempts,
            "successfulConnections": successfulConnections
        ]
        
        // Add device name if available
        if let deviceName = targetPeripheral?.name {
            info["deviceName"] = deviceName
            info["name"] = deviceName  // Also add as "name" for compatibility
        }
        
        // Add battery level if available
        if let batteryLevel = getBatteryLevel() {
            info["batteryLevel"] = batteryLevel
            info["battery"] = batteryLevel  // Also add as "battery" for compatibility
        }
        
        print("ConnectionOrchestrator: getConnectionInfo - currentState: \(currentState.rawValue), isConnected: \(currentState == .subscribed)")
        DebugLogger.shared.log("ConnectionOrchestrator: getConnectionInfo - currentState: \(currentState.rawValue), isConnected: \(currentState == .subscribed)")
        return info
    }
    
    // MARK: - Private Methods - Connection Flow
    
    private func startConnectionFlow() {
        guard connectIntent else { 
            print("ConnectionOrchestrator: No connect intent, aborting flow")
            DebugLogger.shared.log("ConnectionOrchestrator: No connect intent, aborting flow")
            return 
        }
        guard let manager = centralManager, manager.state == .poweredOn else {
            print("ConnectionOrchestrator: Bluetooth not powered on or not initialized")
            DebugLogger.shared.log("ConnectionOrchestrator: Bluetooth not powered on or not initialized")
            return
        }
        
        print("ConnectionOrchestrator: Starting connection flow")
        DebugLogger.shared.log("ConnectionOrchestrator: Starting connection flow")
        transitionToDiscovering()
    }
    
    private func stopConnectionFlow() {
        print("ConnectionOrchestrator: Stopping connection flow")
        
        // Cancel any pending operations
        cancelBackoffTimer()
        cancelStreamWatchdog()
        
        // Disconnect if connected
        if let peripheral = targetPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
        
        currentState = .idle
    }
    
    // MARK: - State Transitions
    
    private func transitionToDiscovering() {
        guard let manager = centralManager else {
            print("ConnectionOrchestrator: CBCentralManager not initialized")
            return
        }
        
        print("ConnectionOrchestrator: Transitioning to discovering")
        print("ConnectionOrchestrator: Central manager state: \(manager.state.rawValue)")
        DebugLogger.shared.log("ConnectionOrchestrator: Transitioning to discovering")
        DebugLogger.shared.log("ConnectionOrchestrator: Central manager state: \(manager.state.rawValue)")
        currentState = .discovering
        connectionAttempts += 1
        
        // Notify state change
        onStateChanged?("discovering")
        
        // Load remembered device if available
        if rememberedDeviceUUID == nil {
            if let uuidString = UserDefaults.standard.string(forKey: "com.nirva.ble.rememberedDevice"),
               let uuid = UUID(uuidString: uuidString) {
                rememberedDeviceUUID = uuid
                print("ConnectionOrchestrator: Loaded remembered device UUID: \(uuid)")
                
                if let serviceStrings = UserDefaults.standard.array(forKey: "com.nirva.ble.rememberedServices") as? [String] {
                    rememberedServiceUUIDs = serviceStrings.compactMap { CBUUID(string: $0) }
                    print("ConnectionOrchestrator: Loaded remembered service UUIDs: \(rememberedServiceUUIDs)")
                }
            }
        }
        
        // Try to retrieve known peripheral
        if let deviceUUID = rememberedDeviceUUID {
            let peripherals = manager.retrievePeripherals(withIdentifiers: [deviceUUID])
            if let peripheral = peripherals.first {
                print("ConnectionOrchestrator: Found remembered peripheral: \(peripheral.name ?? "unknown")")
                targetPeripheral = peripheral
                transitionToConnecting()
                return
            } else {
                print("ConnectionOrchestrator: Could not retrieve remembered peripheral")
            }
        }
        
        // Try to find connected peripherals with our service
        // Check both audio and button services
        let serviceUUIDs = [audioServiceUUID, buttonServiceUUID]
        let connectedPeripherals = manager.retrieveConnectedPeripherals(withServices: serviceUUIDs)
        if let peripheral = connectedPeripherals.first {
            print("ConnectionOrchestrator: Found already connected peripheral: \(peripheral.name ?? "unknown")")
            targetPeripheral = peripheral
            transitionToConnecting()
            return
        } else {
            print("ConnectionOrchestrator: No connected peripherals with our services found")
        }
        
        // Start scanning as last resort
        // Scan for button service which is advertised by the device
        print("ConnectionOrchestrator: Starting scan for peripherals")
        print("ConnectionOrchestrator: Button service UUID: \(buttonServiceUUID)")
        print("ConnectionOrchestrator: Audio service UUID: \(audioServiceUUID)")
        
        // Stop any existing scan first
        manager.stopScan()
        
        // CRITICAL: Must scan with specific service UUIDs for iOS background wake
        // iOS will NOT wake the app in background if scanning with nil services
        print("ConnectionOrchestrator: Starting scan with service UUIDs for background wake: \(scanServiceUUIDs)")
        DebugLogger.shared.log("ConnectionOrchestrator: Scanning with services: \(scanServiceUUIDs)")
        
        manager.scanForPeripherals(withServices: scanServiceUUIDs, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false  // Don't need duplicates
        ])
        print("ConnectionOrchestrator: Scan started with background-compatible service filtering")
        
        // Add a timer to check scan status
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            if self.currentState == .discovering {
                print("ConnectionOrchestrator: Still scanning after 3 seconds, connection attempts: \(self.connectionAttempts)")
            }
        }
    }
    
    private func transitionToConnecting() {
        guard let peripheral = targetPeripheral else {
            print("ConnectionOrchestrator: No target peripheral to connect")
            transitionToBackoff(error: "No peripheral available")
            return
        }
        
        print("ConnectionOrchestrator: Connecting to \(peripheral.identifier)")
        DebugLogger.shared.log("ConnectionOrchestrator: Connecting to \(peripheral.identifier)")
        currentState = .connecting
        connectionAttempts += 1
        
        // Notify state change
        onStateChanged?("connecting")
        
        // Stop scanning if active
        centralManager?.stopScan()
        
        // Connect with background options - CRITICAL for wake events
        let options: [String: Any] = [
            CBConnectPeripheralOptionNotifyOnConnectionKey: true,
            CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
            CBConnectPeripheralOptionNotifyOnNotificationKey: true,
            // This is CRITICAL - tells iOS to preserve this connection for background
            CBConnectPeripheralOptionStartDelayKey: 0
        ]
        centralManager?.connect(peripheral, options: options)
        
        print("ConnectionOrchestrator: Connecting with background wake options")
        DebugLogger.shared.log("ConnectionOrchestrator: Connecting with background wake options")
    }
    
    private func transitionToSubscribed() {
        print("ConnectionOrchestrator: Transitioning to subscribed")
        DebugLogger.shared.log("ConnectionOrchestrator: Transitioning to subscribed")
        currentState = .subscribed
        successfulConnections += 1
        lastStableConnectionTime = Date()
        
        // Reset backoff on successful connection
        backoffAttempt = 0
        
        // Start stream watchdog
        startStreamWatchdog()
        
        // Notify state change
        onStateChanged?("subscribed")
        
        // Notify connection success
        if let deviceId = targetPeripheral?.identifier.uuidString {
            onDeviceConnected?(deviceId)
        }
    }
    
    private func transitionToBackoff(error: String?) {
        print("ConnectionOrchestrator: Transitioning to backoff - \(error ?? "unknown error")")
        currentState = .backoff
        
        // Cancel any pending operations
        cancelStreamWatchdog()
        
        // Notify disconnection
        if let deviceId = targetPeripheral?.identifier.uuidString {
            onDeviceDisconnected?(deviceId, error)
        }
        
        // Schedule backoff retry
        scheduleBackoffRetry()
    }
    
    // MARK: - Backoff Logic
    
    private func scheduleBackoffRetry() {
        guard connectIntent else { return }
        
        // Calculate backoff delay with jitter
        let baseDelay = backoffSteps[min(backoffAttempt, backoffSteps.count - 1)]
        let jitter = baseDelay * backoffJitterRange * (Double.random(in: -1...1))
        let delay = baseDelay + jitter
        
        print("ConnectionOrchestrator: Scheduling retry in \(delay) seconds (attempt \(backoffAttempt + 1))")
        
        backoffTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.bleQueue.async {
                self?.handleBackoffRetry()
            }
        }
        
        backoffAttempt += 1
    }
    
    private func handleBackoffRetry() {
        print("ConnectionOrchestrator: Backoff retry triggered")
        
        guard connectIntent else { return }
        guard centralManager?.state == .poweredOn else { return }
        
        transitionToDiscovering()
    }
    
    private func cancelBackoffTimer() {
        backoffTimer?.invalidate()
        backoffTimer = nil
    }
    
    // MARK: - Stream Watchdog
    
    private func startStreamWatchdog() {
        print("ConnectionOrchestrator: Starting stream watchdog")
        lastPacketTimestamp = Date()
        
        streamWatchdogTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.bleQueue.async {
                self?.checkStreamWatchdog()
            }
        }
    }
    
    private func checkStreamWatchdog() {
        guard let lastPacket = lastPacketTimestamp else { return }
        
        let timeSinceLastPacket = Date().timeIntervalSince(lastPacket)
        if timeSinceLastPacket > watchdogTimeout {
            print("ConnectionOrchestrator: Stream watchdog triggered - no packets for \(timeSinceLastPacket)s")
            
            // Force disconnect and retry
            if let peripheral = targetPeripheral {
                centralManager?.cancelPeripheralConnection(peripheral)
            }
            transitionToBackoff(error: "Stream timeout")
        }
    }
    
    private func refreshStreamWatchdog() {
        lastPacketTimestamp = Date()
    }
    
    private func cancelStreamWatchdog() {
        streamWatchdogTimer?.invalidate()
        streamWatchdogTimer = nil
        lastPacketTimestamp = nil
    }
    
    // MARK: - Stability Check
    
    private func checkStabilityForBackoffReset() {
        guard let stableTime = lastStableConnectionTime else { return }
        
        if Date().timeIntervalSince(stableTime) >= stabilityWindow {
            print("ConnectionOrchestrator: Stable connection achieved, resetting backoff")
            backoffAttempt = 0
        }
    }
}

// MARK: - CBCentralManagerDelegate
@available(iOS 13.0, *)
extension ConnectionOrchestrator: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateString: String
        switch central.state {
        case .unknown: stateString = "unknown"
        case .resetting: stateString = "resetting"
        case .unsupported: stateString = "unsupported"
        case .unauthorized: stateString = "unauthorized"
        case .poweredOff: stateString = "poweredOff"
        case .poweredOn: stateString = "poweredOn"
        @unknown default: stateString = "unknown"
        }
        
        print("ConnectionOrchestrator: Bluetooth state updated to \(stateString) (\(central.state.rawValue))")
        DebugLogger.shared.log("ConnectionOrchestrator: Bluetooth state updated to \(stateString)")
        DebugLogger.shared.log("ConnectionOrchestrator: connectIntent=\(connectIntent), currentState=\(currentState)")
        
        switch central.state {
        case .poweredOn:
            print("ConnectionOrchestrator: Bluetooth powered on, connectIntent=\(connectIntent), currentState=\(currentState)")
            DebugLogger.shared.log("ConnectionOrchestrator: Bluetooth powered on, will check if should start flow")
            
            // Auto-connect to remembered device if we have one and not already connecting
            if rememberedDeviceUUID != nil && currentState == .idle && !connectIntent {
                print("ConnectionOrchestrator: Have remembered device, attempting auto-connect")
                DebugLogger.shared.log("ConnectionOrchestrator: Have remembered device, attempting auto-connect")
                attemptAutoConnect()
            } else if connectIntent && currentState == .idle {
                DebugLogger.shared.log("ConnectionOrchestrator: Starting connection flow from BT state update")
                startConnectionFlow()
            } else {
                DebugLogger.shared.log("ConnectionOrchestrator: Not starting flow - connectIntent=\(connectIntent), currentState=\(currentState)")
            }
            
        case .poweredOff, .unauthorized, .unsupported:
            currentState = .idle
            onError?("Bluetooth unavailable: \(stateString)")
            
        case .resetting, .unknown:
            // Wait for state to stabilize
            print("ConnectionOrchestrator: Waiting for Bluetooth state to stabilize")
            break
            
        @unknown default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("ConnectionOrchestrator: ============ BACKGROUND RESTORATION ============")
        DebugLogger.shared.log("ConnectionOrchestrator: ============ BACKGROUND RESTORATION ============")
        DebugLogger.shared.markBackgroundWake() // Mark this critical event
        
        // Log all restoration keys for debugging
        for (key, value) in dict {
            print("ConnectionOrchestrator: Restoration key: \(key)")
            DebugLogger.shared.log("ConnectionOrchestrator: Restoration key: \(key)")
        }
        
        // Restore peripherals
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                print("ConnectionOrchestrator: Restored peripheral \(peripheral.identifier) - state: \(peripheral.state.rawValue)")
                DebugLogger.shared.log("ConnectionOrchestrator: Restored peripheral \(peripheral.identifier) - state: \(peripheral.state.rawValue)")
                
                // Always set ourselves as delegate
                peripheral.delegate = self
                
                if peripheral.state == .connected {
                    targetPeripheral = peripheral
                    
                    // CRITICAL: Re-discover services and re-subscribe to characteristics
                    // iOS doesn't automatically restore characteristic subscriptions
                    print("ConnectionOrchestrator: Re-discovering services for background wake")
                    DebugLogger.shared.log("ConnectionOrchestrator: Re-discovering services for background wake")
                    peripheral.discoverServices([audioServiceUUID])
                    
                    // Check if we already have services discovered
                    if let services = peripheral.services {
                        print("ConnectionOrchestrator: Peripheral has \(services.count) services already discovered")
                        DebugLogger.shared.log("ConnectionOrchestrator: Peripheral has \(services.count) services already discovered")
                        
                        // Check for audio service
                        for service in services {
                            if service.uuid == audioServiceUUID {
                                print("ConnectionOrchestrator: Audio service already discovered, checking characteristics")
                                DebugLogger.shared.log("ConnectionOrchestrator: Audio service already discovered, checking characteristics")
                                
                                // Check if characteristics are already discovered
                                if let characteristics = service.characteristics {
                                    for characteristic in characteristics {
                                        if characteristic.uuid == audioCharacteristicUUID {
                                            print("ConnectionOrchestrator: Audio characteristic found, re-enabling notifications")
                                            DebugLogger.shared.log("ConnectionOrchestrator: Audio characteristic found, re-enabling notifications")
                                            audioCharacteristic = characteristic
                                            
                                            // Re-enable notifications (critical for background)
                                            peripheral.setNotifyValue(true, for: characteristic)
                                            
                                            // Update state
                                            currentState = .subscribed
                                        }
                                    }
                                } else {
                                    // Discover characteristics
                                    peripheral.discoverCharacteristics([audioCharacteristicUUID], for: service)
                                }
                            }
                        }
                    } else {
                        // Re-discover services
                        print("ConnectionOrchestrator: No services cached, re-discovering")
                        DebugLogger.shared.log("ConnectionOrchestrator: No services cached, re-discovering")
                        peripheral.discoverServices([audioServiceUUID])
                    }
                    
                    // Remember this device
                    rememberDevice(uuid: peripheral.identifier, serviceUUIDs: [audioServiceUUID])
                }
            }
        }
        
        // Restore scan options if we were scanning
        if let scanServices = dict[CBCentralManagerRestoredStateScanServicesKey] as? [CBUUID] {
            print("ConnectionOrchestrator: Had active scan for services: \(scanServices)")
            DebugLogger.shared.log("ConnectionOrchestrator: Had active scan for services: \(scanServices)")
            
            // Resume scanning with the same services
            print("ConnectionOrchestrator: Resuming scan after restoration")
            DebugLogger.shared.log("ConnectionOrchestrator: Resuming scan after restoration")
            centralManager?.scanForPeripherals(withServices: scanServices, options: nil)
        }
        if let _ = dict[CBCentralManagerRestoredStateScanOptionsKey] {
            print("ConnectionOrchestrator: Was scanning before restoration")
            DebugLogger.shared.log("ConnectionOrchestrator: Was scanning before restoration")
            // Resume scanning if needed
            if connectIntent && currentState != .subscribed {
                transitionToDiscovering()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "Unknown"
        print("ConnectionOrchestrator: Discovered peripheral: \(name) (\(peripheral.identifier)) RSSI: \(RSSI)")
        print("ConnectionOrchestrator: Advertisement data: \(advertisementData)")
        DebugLogger.shared.log("ConnectionOrchestrator: Discovered peripheral: \(name) (\(peripheral.identifier)) RSSI: \(RSSI)")
        
        // Log to Flutter event channel too for visibility
        self.onDeviceDiscovered?([
            "event": "deviceDiscovered",
            "deviceId": peripheral.identifier.uuidString,
            "name": name,
            "rssi": RSSI.intValue,
            "timestamp": Date().timeIntervalSince1970
        ])
        
        // For testing, let's see all devices but only connect to ones with our service
        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            print("ConnectionOrchestrator: Advertised services: \(serviceUUIDs)")
            DebugLogger.shared.log("ConnectionOrchestrator: Advertised services: \(serviceUUIDs)")
            
            // Only auto-connect if this is our remembered device
            if let rememberedUUID = rememberedDeviceUUID,
               peripheral.identifier == rememberedUUID {
                print("ConnectionOrchestrator: Found our remembered device! Auto-connecting...")
                print("ConnectionOrchestrator: Remembered UUID: \(rememberedUUID)")
                print("ConnectionOrchestrator: Found device UUID: \(peripheral.identifier)")
                print("ConnectionOrchestrator: Device name: \(peripheral.name ?? "Unknown")")
                DebugLogger.shared.log("ConnectionOrchestrator: Found our remembered device! Auto-connecting...")
                DebugLogger.shared.log("ConnectionOrchestrator: Remembered UUID: \(rememberedUUID)")
                DebugLogger.shared.log("ConnectionOrchestrator: Found device UUID: \(peripheral.identifier)")
                targetPeripheral = peripheral
                transitionToConnecting()
                return  // Stop scanning once we found our device
            } else if serviceUUIDs.contains(audioServiceUUID) {
                // Just notify that we found a compatible device, but don't auto-connect
                print("ConnectionOrchestrator: Found device with audio service: \(peripheral.name ?? "Unknown") (\(peripheral.identifier))")
                DebugLogger.shared.log("ConnectionOrchestrator: Found device with audio service but not auto-connecting (not remembered)")
                
                // Notify Flutter about discovered device
                onDeviceDiscovered?([
                    "event": "deviceDiscovered",
                    "deviceId": peripheral.identifier.uuidString,
                    "name": peripheral.name ?? "Unknown Device",
                    "rssi": RSSI.intValue,
                    "timestamp": Date().timeIntervalSince1970
                ])
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("ConnectionOrchestrator: Connected to peripheral \(peripheral.identifier)")
        
        peripheral.delegate = self
        // Discover both audio and battery services
        let batteryServiceUUID = CBUUID(string: "180F")
        peripheral.discoverServices([audioServiceUUID, batteryServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("ConnectionOrchestrator: Failed to connect: \(error?.localizedDescription ?? "unknown")")
        transitionToBackoff(error: error?.localizedDescription)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("ConnectionOrchestrator: Disconnected: \(error?.localizedDescription ?? "clean disconnect")")
        
        if connectIntent {
            // Auto-reconnect if we still want to be connected
            transitionToBackoff(error: error?.localizedDescription)
        } else {
            currentState = .idle
        }
    }
}

// MARK: - CBPeripheralDelegate
@available(iOS 13.0, *)
extension ConnectionOrchestrator: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("ConnectionOrchestrator: Service discovery error: \(error!)")
            transitionToBackoff(error: "Service discovery failed")
            return
        }
        
        guard let services = peripheral.services else {
            print("ConnectionOrchestrator: No services found")
            transitionToBackoff(error: "No services")
            return
        }
        
        var foundAudioService = false
        for service in services {
            if service.uuid == audioServiceUUID {
                print("ConnectionOrchestrator: Found audio service")
                peripheral.discoverCharacteristics([audioCharacteristicUUID], for: service)
                foundAudioService = true
            } else if service.uuid == CBUUID(string: "180F") {
                print("ConnectionOrchestrator: Found battery service")
                peripheral.discoverCharacteristics([CBUUID(string: "2A19")], for: service)
            }
        }
        
        if !foundAudioService {
            print("ConnectionOrchestrator: Audio service not found")
            transitionToBackoff(error: "Audio service not found")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("ConnectionOrchestrator: Characteristic discovery error: \(error!)")
            transitionToBackoff(error: "Characteristic discovery failed")
            return
        }
        
        guard let characteristics = service.characteristics else {
            print("ConnectionOrchestrator: No characteristics found")
            transitionToBackoff(error: "No characteristics")
            return
        }
        
        for characteristic in characteristics {
            if characteristic.uuid == audioCharacteristicUUID {
                print("ConnectionOrchestrator: Found audio characteristic")
                print("ConnectionOrchestrator: Characteristic properties: \(characteristic.properties.rawValue)")
                DebugLogger.shared.log("ConnectionOrchestrator: Characteristic properties: \(characteristic.properties.rawValue)")
                
                // Check if characteristic supports notifications
                if characteristic.properties.contains(.notify) {
                    print("ConnectionOrchestrator: Characteristic supports notifications")
                    DebugLogger.shared.log("ConnectionOrchestrator: Characteristic supports notifications")
                }
                if characteristic.properties.contains(.indicate) {
                    print("ConnectionOrchestrator: Characteristic supports indications")
                    DebugLogger.shared.log("ConnectionOrchestrator: Characteristic supports indications")
                }
                
                audioCharacteristic = characteristic
                
                // Enable notifications (critical for background)
                // IMPORTANT: This MUST succeed while app is in foreground for background to work
                peripheral.setNotifyValue(true, for: characteristic)
                print("ConnectionOrchestrator: Called setNotifyValue(true) for audio characteristic")
                DebugLogger.shared.log("ConnectionOrchestrator: Called setNotifyValue(true) for audio characteristic")
                
                // Log the exact state for debugging
                print("ConnectionOrchestrator: Peripheral state: \(peripheral.state.rawValue)")
                print("ConnectionOrchestrator: Characteristic notifying: \(characteristic.isNotifying)")
                DebugLogger.shared.log("ConnectionOrchestrator: Characteristic notifying: \(characteristic.isNotifying)")
                return
            } else if characteristic.uuid == CBUUID(string: "2A19") {
                print("ConnectionOrchestrator: Found battery characteristic")
                // Read battery level immediately
                peripheral.readValue(for: characteristic)
                // Also enable notifications for battery updates if supported
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
        
        // Only fail if we're looking for audio characteristic in audio service
        if service.uuid == audioServiceUUID {
            print("ConnectionOrchestrator: Audio characteristic not found")
            transitionToBackoff(error: "Audio characteristic not found")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("ConnectionOrchestrator: Failed to enable notifications: \(error!)")
            transitionToBackoff(error: "Notification setup failed")
            return
        }
        
        if characteristic.isNotifying {
            print("ConnectionOrchestrator: Notifications enabled for audio characteristic")
            transitionToSubscribed()
        } else {
            print("ConnectionOrchestrator: Notifications disabled")
            transitionToBackoff(error: "Notifications disabled")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // THIS METHOD SHOULD BE CALLED EVEN IN BACKGROUND IF BLE WAKE IS WORKING
        let appState = UIApplication.shared.applicationState
        let stateString = appState == .background ? "[BACKGROUND-WAKE]" : appState == .inactive ? "[INACTIVE]" : "[FOREGROUND]"
        
        guard error == nil else {
            print("ConnectionOrchestrator: \(stateString) Error receiving data: \(error!)")
            // Keep critical error logging
            DebugLogger.shared.log("ConnectionOrchestrator: \(stateString) Error receiving data: \(error!)")
            return
        }
        
        guard let data = characteristic.value else {
            print("ConnectionOrchestrator: \(stateString) Received empty data")
            // DebugLogger.shared.log("ConnectionOrchestrator: \(stateString) Received empty data")
            return
        }
        
        // Check if this is battery level characteristic
        if characteristic.uuid == CBUUID(string: "2A19") {
            if !data.isEmpty {
                let batteryLevel = Int(data[0])
                lastKnownBatteryLevel = batteryLevel
                print("ConnectionOrchestrator: Battery level updated: \(batteryLevel)%")
                DebugLogger.shared.log("Battery level: \(batteryLevel)%")
            }
            return
        }
        
        // Log ALL packets in background - this is our wake event!
        // if appState == .background || appState == .inactive {
            // print("ConnectionOrchestrator: \(stateString) BLE WAKE EVENT! Packet size: \(data.count) bytes")
            // Keep critical background wake event
            // DebugLogger.shared.log("ConnectionOrchestrator: \(stateString) BLE WAKE EVENT!")
            
            // We have ~10 seconds to process after wake
            // print("ConnectionOrchestrator: Processing in BLE wake window...")
            // DebugLogger.shared.log("ConnectionOrchestrator: Processing in BLE wake window...")
        // }
        
        // Refresh watchdog on packet received
        refreshStreamWatchdog()
        
        // Forward packet to processing pipeline
        onPacketReceived?(data)
    }
    
    // MARK: - Battery Level
    
    func getBatteryLevel() -> Int? {
        guard let peripheral = targetPeripheral,
              peripheral.state == .connected else {
            print("ConnectionOrchestrator: No connected device for battery query")
            return nil
        }
        
        // Find battery service (standard UUID: 0x180F)
        guard let batteryService = peripheral.services?.first(where: { 
            $0.uuid == CBUUID(string: "180F") 
        }) else {
            print("ConnectionOrchestrator: Battery service not found")
            return lastKnownBatteryLevel  // Return cached value if available
        }
        
        // Find battery level characteristic (standard UUID: 0x2A19)
        guard let batteryChar = batteryService.characteristics?.first(where: {
            $0.uuid == CBUUID(string: "2A19")
        }) else {
            print("ConnectionOrchestrator: Battery characteristic not found")
            return lastKnownBatteryLevel
        }
        
        // Check if we have a cached value
        if let value = batteryChar.value, !value.isEmpty {
            let batteryLevel = Int(value[0])
            lastKnownBatteryLevel = batteryLevel
            print("ConnectionOrchestrator: Battery level: \(batteryLevel)%")
            return batteryLevel
        }
        
        // Request a read if no cached value
        peripheral.readValue(for: batteryChar)
        print("ConnectionOrchestrator: Requested battery read, returning cached: \(lastKnownBatteryLevel ?? -1)")
        return lastKnownBatteryLevel
    }
}