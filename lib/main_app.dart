import 'package:flutter/material.dart';
import 'package:nirva_app/splash_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 添加生命周期观察者
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 移除观察者
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
    } else if (state == AppLifecycleState.detached) {
      // App completely exited or detached
      debugPrint('App detached');
    }
  }
  
  /// Handle app resumed from background
  void _handleAppResumed() {
    // iOS background audio should continue working
    // No special action needed for iOS background audio
    debugPrint('App resumed - iOS background audio should continue');
  }
  
  /// Handle app going to background
  void _handleAppPaused() {
    // iOS background audio should continue working
    // The IosBackgroundAudioManager handles keeping the app alive
    debugPrint('App paused - iOS background audio should continue');
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
      home: const SplashScreen(), // 设置 SplashScreen 为初始页面
    );
  }
}
