import 'package:flutter/material.dart';
import 'package:nirva_app/home_page.dart';
import 'package:nirva_app/service_manager.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/chat_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ServiceManager _serviceManager = ServiceManager();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final int minDuration = 400; // 最小等待时间
    final Stopwatch stopwatch = Stopwatch()..start();

    // 调用 configureApiEndpoint 并等待返回
    final bool success = await _serviceManager.configureApiEndpoint();

    // 计算剩余时间
    final int elapsed = stopwatch.elapsedMilliseconds;
    final int remainingTime = minDuration - elapsed;

    if (remainingTime > 0) {
      // 如果等待时间不足 400ms，继续等待
      await Future.delayed(Duration(milliseconds: remainingTime));
    }

    // 打印日志，方便调试
    debugPrint('API Endpoint Configuration Success: $success');

    if (!success) {
      DataManager().fillTestData();
      ChatManager().fillTestData();
    }

    // 跳转到下一个场景
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const HomePage(title: 'Nirva App Home Page'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // 无动画过渡
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple, // 背景颜色
        child: Center(
          child: Text(
            'NIRVA',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
