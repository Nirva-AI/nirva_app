import Flutter
import UIKit
import BackgroundTasks
import AVFoundation
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate {
  
  // Background task identifier
  private let backgroundTaskIdentifier = "com.nirva.backgroundAudioProcessing"
  
  // Method channel for Flutter communication
  private var methodChannel: FlutterMethodChannel?
  
  // Bluetooth wake event handling
  private var centralManager: CBCentralManager?
  
  // Track if app was woken from background
  private var wasWokenFromBackground = false
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("========================================")
    print("AppDelegate: application didFinishLaunchingWithOptions")
    print("AppDelegate: Launch options: \(String(describing: launchOptions))")
    print("AppDelegate: About to register plugins")
    print("========================================")
    
    // Check if app was launched due to BLE events
    if let centralManagerIdentifiers = launchOptions?[UIApplication.LaunchOptionsKey.bluetoothCentrals] as? [String] {
      print("AppDelegate: ✅ App launched for BLE restoration with identifiers: \(centralManagerIdentifiers)")
      DebugLogger.shared.log("AppDelegate: ✅ App launched for BLE restoration with identifiers: \(centralManagerIdentifiers)")
      DebugLogger.shared.markBackgroundWake() // Mark BLE wake launch
      wasWokenFromBackground = true
    } else {
      print("AppDelegate: ❌ Normal launch, not BLE wake")
      DebugLogger.shared.log("AppDelegate: ❌ Normal launch, not BLE wake")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    print("AppDelegate: GeneratedPluginRegistrant.register completed")
    
    // Register our custom BLE Audio Plugin V2
    if #available(iOS 13.0, *) {
      print("AppDelegate: About to register BleAudioPluginV2")
      if let registrar = self.registrar(forPlugin: "BleAudioPluginV2") {
        BleAudioPluginV2.register(with: registrar)
        print("AppDelegate: BleAudioPluginV2 registered successfully")
      } else {
        print("AppDelegate: Failed to get registrar for BleAudioPluginV2")
      }
    }
    
    print("AppDelegate: All plugins registered")
    
    // Setup method channel after Flutter engine is ready
    DispatchQueue.main.async {
      self.setupMethodChannel()
    }
    
    // Configure audio session for background processing
    configureAudioSession()
    
    // Initialize Bluetooth manager for wake events
    initializeBluetoothManager()
    
    // Force initialize BleAudioServiceV2 and start auto-connect
    if #available(iOS 13.0, *) {
      print("AppDelegate: Initializing BleAudioServiceV2")
      let bleService = BleAudioServiceV2.shared
      let initialized = bleService.initialize()
      print("AppDelegate: BleAudioServiceV2 initialized: \(initialized)")
    }
    
    print("AppDelegate: All initialization completed")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - App Lifecycle Handling
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    print("AppDelegate: ============ APP ENTERING BACKGROUND ============")
    DebugLogger.shared.log("AppDelegate: ============ APP ENTERING BACKGROUND ============")
    
    // Log critical info for debugging
    if #available(iOS 13.0, *) {
      let connectionInfo = BleAudioServiceV2.shared.getConnectionInfo()
      print("AppDelegate: BLE Connection state when backgrounding: \(connectionInfo)")
      DebugLogger.shared.log("AppDelegate: BLE Connection state when backgrounding: \(connectionInfo)")
    }
    
    // Request background time to ensure BLE operations complete
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    backgroundTask = application.beginBackgroundTask {
      print("AppDelegate: Background task expired")
      DebugLogger.shared.log("AppDelegate: Background task expired")
      application.endBackgroundTask(backgroundTask)
    }
    
    // The app should rely on BLE wake events, not background tasks
    // iOS will wake us when BLE packets arrive
    print("AppDelegate: Waiting for BLE wake events...")
    DebugLogger.shared.log("AppDelegate: Waiting for BLE wake events...")
    
    // NOTE: If no wake events occur, the BLE device may need firmware changes:
    // 1. Add "indicate" property to the characteristic (not just "notify")
    // 2. Or use longer connection intervals (>1 second) for background
    print("AppDelegate: NOTE - Characteristic must support 'indicate' for reliable wake")
    DebugLogger.shared.log("AppDelegate: NOTE - Characteristic must support 'indicate' for reliable wake")
  }
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    print("AppDelegate: ============ APP ENTERING FOREGROUND ============")
    DebugLogger.shared.log("AppDelegate: ============ APP ENTERING FOREGROUND ============")
    
    // Check if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: App was woken from background - notifying Flutter")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
      wasWokenFromBackground = false
    }
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    print("AppDelegate: ============ APP BECAME ACTIVE ============")
    DebugLogger.shared.log("AppDelegate: ============ APP BECAME ACTIVE ============")
    
    // Check if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: App was woken from background - notifying Flutter")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
      wasWokenFromBackground = false
    }
  }
  
  override func applicationWillResignActive(_ application: UIApplication) {
    print("AppDelegate: ============ APP WILL RESIGN ACTIVE ============")
    DebugLogger.shared.log("AppDelegate: ============ APP WILL RESIGN ACTIVE ============")
  }
  
  // MARK: - Bluetooth Manager Setup
  
  private func initializeBluetoothManager() {
    let options: [String: Any] = [
      CBCentralManagerOptionShowPowerAlertKey: true,
      CBCentralManagerOptionRestoreIdentifierKey: "com.nirva.appdelegate.ble.restoration"
    ]
    centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    print("AppDelegate: Bluetooth manager initialized with state restoration")
  }
  
  // MARK: - Method Channel Setup
  
  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("AppDelegate: FlutterViewController not available yet")
      return
    }
    
    // Background task method channel
    methodChannel = FlutterMethodChannel(
      name: "com.nirva/backgroundTask",
      binaryMessenger: controller.binaryMessenger
    )
    
    methodChannel?.setMethodCallHandler { [weak self] call, result in
      self?.handleMethodCall(call, result: result)
    }
    

    
    print("AppDelegate: Method channels setup completed")
  }
  
  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "configureAudioSession":
      let success = configureAudioSession()
      result(success)
      
    case "activateAudioSession":
      let success = activateAudioSession()
      result(success)
      
    case "deactivateAudioSession":
      let success = deactivateAudioSession()
      result(success)
      
    case "onBtWakeEvent":
      // Handle BT wake event from Flutter side
      print("AppDelegate: BT wake event received from Flutter")
      result(true)
      
    default:
      print("AppDelegate: Unknown method call: \(call.method)")
      result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - Audio Session Configuration
  
  private func configureAudioSession() -> Bool {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      
      // Set audio session category for background processing
      try audioSession.setCategory(
        .playAndRecord,
        mode: .voiceChat,
        options: [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker]
      )
      
      // Set audio session active
      try audioSession.setActive(true)
      
      print("AppDelegate: Audio session configured successfully for background processing")
      return true
    } catch {
      print("AppDelegate: Failed to configure audio session: \(error)")
      return false
    }
  }
  
  private func activateAudioSession() -> Bool {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setActive(true)
      print("AppDelegate: Audio session activated successfully")
      return true
    } catch {
      print("AppDelegate: Failed to activate audio session: \(error)")
      return false
    }
  }
  
  private func deactivateAudioSession() -> Bool {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setActive(false)
      print("AppDelegate: Audio session deactivated successfully")
      return true
    } catch {
      print("AppDelegate: Failed to deactivate audio session: \(error)")
      return false
    }
  }
  
  // MARK: - CBCentralManagerDelegate
  
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    print("AppDelegate: ============ BLE BACKGROUND RESTORATION ============")
    DebugLogger.shared.log("AppDelegate: ============ BLE BACKGROUND RESTORATION ============")
    DebugLogger.shared.markBackgroundWake() // Mark this critical event
    
    // Mark that app was woken from background
    wasWokenFromBackground = true
    
    // Log restoration state for debugging
    for (key, value) in dict {
      print("AppDelegate: Restoration key: \(key)")
      DebugLogger.shared.log("AppDelegate: Restoration key: \(key)")
    }
    
    // Notify Flutter about wake event
    methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("AppDelegate: Bluetooth central manager state updated: \(central.state.rawValue)")
    
    switch central.state {
    case .poweredOn:
      print("AppDelegate: Bluetooth is powered on")
      // CRITICAL: Must scan with specific service UUIDs for background wake
      // Using the same UUIDs as ConnectionOrchestrator for consistency
      let audioServiceUUID = CBUUID(string: "19B10000-E8F2-537E-4F6C-D104768A1214")
      let buttonServiceUUID = CBUUID(string: "23BA7924-0000-1000-7450-346EAC492E92")
      centralManager?.scanForPeripherals(withServices: [audioServiceUUID, buttonServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    case .poweredOff:
      print("AppDelegate: Bluetooth is powered off")
      centralManager?.stopScan()
    case .resetting:
      print("AppDelegate: Bluetooth is resetting")
    case .unauthorized:
      print("AppDelegate: Bluetooth is unauthorized")
    case .unknown:
      print("AppDelegate: Bluetooth state is unknown")
    case .unsupported:
      print("AppDelegate: Bluetooth is unsupported")
    @unknown default:
      print("AppDelegate: Bluetooth state is unknown default")
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print("AppDelegate: Discovered peripheral: \(peripheral.name ?? "Unknown")")
    
    // Only notify if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: BT peripheral discovered while app was woken from background")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("AppDelegate: Connected to peripheral: \(peripheral.name ?? "Unknown")")
    
    // Only notify if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: BT peripheral connected while app was woken from background")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
    }
  }
  
  // MARK: - Deallocation
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
