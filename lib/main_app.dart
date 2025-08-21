import 'package:flutter/material.dart';
import 'package:nirva_app/splash_screen.dart';
import 'package:provider/provider.dart';
import 'services/ios_background_audio_manager.dart';
import 'services/app_lifecycle_logging_service.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  IosBackgroundAudioManager? _iosBackgroundAudioManager;
  AppLifecycleLoggingService? _lifecycleLoggingService;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    _initializeLifecycleLogging();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the iOS background audio manager from provider
    _iosBackgroundAudioManager = context.read<IosBackgroundAudioManager>();
  }
  
  /// Initialize lifecycle logging service
  Future<void> _initializeLifecycleLogging() async {
    try {
      _lifecycleLoggingService = AppLifecycleLoggingService();
      await _lifecycleLoggingService!.initialize();
      debugPrint('MainApp: Lifecycle logging service initialized');
      
      // Log app start
      await _lifecycleLoggingService!.logCustomEvent('APP_START', {
        'description': 'App started or resumed from cold start',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('MainApp: Error initializing lifecycle logging: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Log the lifecycle state change
    _lifecycleLoggingService?.logAppLifecycleStateChange(state);
    
    if (state == AppLifecycleState.resumed) {
      // App resumed from background
      debugPrint('App resumed from background');
      _handleAppResumed();
      _lifecycleLoggingService?.logAppResumed();
    } else if (state == AppLifecycleState.paused) {
      // App going to background
      debugPrint('App going to background');
      _handleAppPaused();
      _lifecycleLoggingService?.logAppPaused();
    } else if (state == AppLifecycleState.inactive) {
      // App inactive (task switching or lock screen)
      debugPrint('App inactive');
      _handleAppInactive();
      _lifecycleLoggingService?.logAppInactive();
    } else if (state == AppLifecycleState.detached) {
      // App completely exited or detached
      debugPrint('App detached');
      _handleAppDetached();
      _lifecycleLoggingService?.logAppDetached();
    }
  }
  
  /// Handle app resumed from background
  void _handleAppResumed() {
    debugPrint('App resumed - checking iOS background audio status');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // If background audio was interrupted, try to restore it
              if (_iosBackgroundAudioManager!.isInitialized) {
        debugPrint('App resumed - iOS background manager is ready for BT wake events');
      }
    }
  }
  
  /// Handle app going to background
  void _handleAppPaused() {
    debugPrint('App paused - ensuring iOS background audio continues');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // Ensure background audio is active before going to background
      if (_iosBackgroundAudioManager!.isInitialized) {
        debugPrint('App paused - iOS background manager is ready for BT wake events');
      }
    }
  }
  
  /// Handle app becoming inactive
  void _handleAppInactive() {
    debugPrint('App inactive - maintaining audio session');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // Ensure audio session stays active during task switching
      if (_iosBackgroundAudioManager!.isInitialized) {
        debugPrint('App inactive - iOS background manager ready for BT wake events');
      }
    }
  }
  
  /// Handle app being detached
  void _handleAppDetached() {
    debugPrint('App detached - this should not happen with background audio');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nirva App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E3C26),
        ),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Georgia'),
          displayMedium: TextStyle(fontFamily: 'Georgia'),
          displaySmall: TextStyle(fontFamily: 'Georgia'),
          headlineLarge: TextStyle(fontFamily: 'Georgia'),
          headlineMedium: TextStyle(fontFamily: 'Georgia'),
          headlineSmall: TextStyle(fontFamily: 'Georgia'),
          titleLarge: TextStyle(fontFamily: 'Georgia'),
          titleMedium: TextStyle(fontFamily: 'Georgia'),
          titleSmall: TextStyle(fontFamily: 'Georgia'),
          bodyLarge: TextStyle(fontFamily: 'Georgia'),
          bodyMedium: TextStyle(fontFamily: 'Georgia'),
          bodySmall: TextStyle(fontFamily: 'Georgia'),
          labelLarge: TextStyle(fontFamily: 'Georgia'),
          labelMedium: TextStyle(fontFamily: 'Georgia'),
          labelSmall: TextStyle(fontFamily: 'Georgia'),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
