import Flutter
import UIKit
import BackgroundTasks
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  // Background task identifier
  private let backgroundTaskIdentifier = "com.nirva.backgroundAudioProcessing"
  
  // Method channel for Flutter communication
  private var methodChannel: FlutterMethodChannel?
  
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
    
    // Register background tasks for iOS 13+
    if #available(iOS 13.0, *) {
      BGTaskScheduler.shared.register(
        forTaskWithIdentifier: backgroundTaskIdentifier,
        using: nil
      ) { task in
        self.handleBackgroundTask(task)
      }
    }
    
    // Register for app lifecycle notifications
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleApplicationWillResignActive),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleApplicationDidEnterBackground),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleApplicationWillEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
      
    case "scheduleBackgroundTask":
      if #available(iOS 13.0, *) {
        let success = scheduleNextBackgroundTask()
        result(success)
      } else {
        result(false)
      }
      
    case "cancelAllBackgroundTasks":
      if #available(iOS 13.0, *) {
        let success = cancelAllBackgroundTasks()
        result(success)
      } else {
        result(false)
      }
      
    case "sendKeepAliveSignal":
      sendKeepAliveSignal()
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
  
  // MARK: - Background Task Handling
  
  @available(iOS 13.0, *)
  private func handleBackgroundTask(_ task: BGTask) {
    print("AppDelegate: Background task started: \(task.identifier)")
    
    // Set expiration handler
    task.expirationHandler = {
      print("AppDelegate: Background task expiring, cleaning up...")
      self.cleanupBackgroundTask()
    }
    
    // Schedule next background task
    _ = self.scheduleNextBackgroundTask()
    
    // Simulate some work to keep the task alive
    DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
      print("AppDelegate: Background task completing successfully")
      task.setTaskCompleted(success: true)
    }
  }
  
  @available(iOS 13.0, *)
  private func scheduleNextBackgroundTask() -> Bool {
    let request = BGProcessingTaskRequest(identifier: backgroundTaskIdentifier)
    request.requiresNetworkConnectivity = false
    request.requiresExternalPower = false
    request.earliestBeginDate = Date(timeIntervalSinceNow: 30) // Schedule for 30 seconds later
    
    do {
      try BGTaskScheduler.shared.submit(request)
      print("AppDelegate: Next background task scheduled successfully")
      return true
    } catch {
      print("AppDelegate: Failed to schedule background task: \(error)")
      return false
    }
  }
  
  @available(iOS 13.0, *)
  private func cancelAllBackgroundTasks() -> Bool {
    do {
      BGTaskScheduler.shared.cancelAllTaskRequests()
      print("AppDelegate: All background tasks cancelled successfully")
      return true
    } catch {
      print("AppDelegate: Failed to cancel background tasks: \(error)")
      return false
    }
  }
  
  private func sendKeepAliveSignal() {
    print("AppDelegate: Keep-alive signal sent")
    // This is a lightweight operation to keep the background task alive
    // The actual work is done by the background task scheduler
  }
  
  // MARK: - App Lifecycle Handling
  
  @objc private func handleApplicationWillResignActive() {
    print("AppDelegate: Application will resign active")
    
    // Start background task to keep app alive
    if #available(iOS 13.0, *) {
      _ = scheduleNextBackgroundTask()
    }
  }
  
  @objc private func handleApplicationDidEnterBackground() {
    print("AppDelegate: Application did enter background")
    
    // Ensure audio session stays active
    _ = activateAudioSession()
    
    // Schedule immediate background task
    if #available(iOS 13.0, *) {
      _ = scheduleNextBackgroundTask()
    }
  }
  
  @objc private func handleApplicationWillEnterForeground() {
    print("AppDelegate: Application will enter foreground")
    
    // Cancel any pending background tasks
    if #available(iOS 13.0, *) {
      _ = cancelAllBackgroundTasks()
    }
  }
  
  // MARK: - Background Task Cleanup
  
  private func cleanupBackgroundTask() {
    print("AppDelegate: Cleaning up background task")
    
    // Notify Flutter about background task expiration
    methodChannel?.invokeMethod("onBackgroundTaskExpiring", arguments: nil)
  }
  
  // MARK: - Memory Warning Handling
  
  override func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    super.applicationDidReceiveMemoryWarning(application)
    print("AppDelegate: Memory warning received")
    
    // Try to keep critical audio processing alive
    // The audio session should prevent the app from being terminated
  }
  
  // MARK: - Deallocation
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
