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
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup method channel after Flutter engine is ready
    DispatchQueue.main.async {
      self.setupMethodChannel()
    }
    
    // Configure audio session for background processing
    configureAudioSession()
    
    // Initialize Bluetooth manager for wake events
    initializeBluetoothManager()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - App Lifecycle Handling
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    print("AppDelegate: App will enter foreground")
    
    // Check if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: App was woken from background - notifying Flutter")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
      wasWokenFromBackground = false
    }
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    print("AppDelegate: App became active")
    
    // Check if app was woken from background
    if wasWokenFromBackground {
      print("AppDelegate: App was woken from background - notifying Flutter")
      methodChannel?.invokeMethod("onBtWakeEvent", arguments: nil)
      wasWokenFromBackground = false
    }
  }
  
  // MARK: - Bluetooth Manager Setup
  
  private func initializeBluetoothManager() {
    centralManager = CBCentralManager(delegate: self, queue: nil)
    print("AppDelegate: Bluetooth manager initialized")
  }
  
  // MARK: - Method Channel Setup
  
  private func setupMethodChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("AppDelegate: FlutterViewController not available yet")
      return
    }
    
    methodChannel = FlutterMethodChannel(
      name: "com.nirva/backgroundTask",
      binaryMessenger: controller.binaryMessenger
    )
    
    methodChannel?.setMethodCallHandler { [weak self] call, result in
      self?.handleMethodCall(call, result: result)
    }
    
    print("AppDelegate: Method channel setup completed")
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
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("AppDelegate: Bluetooth central manager state updated: \(central.state.rawValue)")
    
    switch central.state {
    case .poweredOn:
      print("AppDelegate: Bluetooth is powered on")
      // Start scanning for peripherals to enable background wake events
      centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
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
