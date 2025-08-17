import 'package:flutter/material.dart';
import 'package:nirva_app/splash_screen.dart';
import 'package:provider/provider.dart';
import 'services/ios_background_audio_manager.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  IosBackgroundAudioManager? _iosBackgroundAudioManager;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the iOS background audio manager from provider
    _iosBackgroundAudioManager = context.read<IosBackgroundAudioManager>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // App resumed from background
      debugPrint('App resumed from background');
      _handleAppResumed();
    } else if (state == AppLifecycleState.paused) {
      // App going to background
      debugPrint('App going to background');
      _handleAppPaused();
    } else if (state == AppLifecycleState.inactive) {
      // App inactive (task switching or lock screen)
      debugPrint('App inactive');
      _handleAppInactive();
    } else if (state == AppLifecycleState.detached) {
      // App completely exited or detached
      debugPrint('App detached');
      _handleAppDetached();
    }
  }
  
  /// Handle app resumed from background
  void _handleAppResumed() {
    debugPrint('App resumed - checking iOS background audio status');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // If background audio was interrupted, try to restore it
      if (_iosBackgroundAudioManager!.isBackgroundAudioEnabled && 
          !_iosBackgroundAudioManager!.isBackgroundTaskActive) {
        debugPrint('App resumed - restoring background audio processing');
        _iosBackgroundAudioManager!.startBackgroundAudio();
      }
    }
  }
  
  /// Handle app going to background
  void _handleAppPaused() {
    debugPrint('App paused - ensuring iOS background audio continues');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // Ensure background audio is active before going to background
      if (_iosBackgroundAudioManager!.isAudioSessionActive && 
          !_iosBackgroundAudioManager!.isBackgroundAudioEnabled) {
        debugPrint('App paused - starting background audio processing');
        _iosBackgroundAudioManager!.startBackgroundAudio();
      }
    }
  }
  
  /// Handle app becoming inactive
  void _handleAppInactive() {
    debugPrint('App inactive - maintaining audio session');
    
    if (_iosBackgroundAudioManager?.isIos == true) {
      // Ensure audio session stays active during task switching
      if (_iosBackgroundAudioManager!.isAudioSessionActive) {
        debugPrint('App inactive - audio session maintained');
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
