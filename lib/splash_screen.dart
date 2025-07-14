import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/my_test.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/apis.dart'; // 确保导入了 API 类

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final int minDuration = 400; // 最小等待时间
    final Stopwatch stopwatch = Stopwatch()..start();

    //检查网络状态，临时先这么写。
    await checkNetworkStatus();

    try {
      final urlConfig = await APIs.getUrlConfig();
      if (urlConfig == null) {
        Logger().e('获取 URL 配置失败');
        return;
      }

      Logger().i('API 初始化成功');

      final token = await APIs.login();
      if (token == null) {
        Logger().e('登录失败，未获取到 token');
        return;
      }
    } catch (e) {
      Logger().e('登录流程出现错误: $e');
    }

    // 清空AppRuntimeContext（在设置Provider之前）
    AppRuntimeContext.clear();

    // 初始化JournalFilesProvider - 添加mounted检查以避免跨async间隙使用BuildContext
    if (mounted) {
      final journalFilesProvider = Provider.of<JournalFilesProvider>(
        context,
        listen: false,
      );
      AppRuntimeContext().setJournalFilesProvider(journalFilesProvider);
    }

    // 执行数据初始化（从main.dart移动过来）
    await _setupHiveStorage();

    // 设置初始选中日期（从TestData移动过来，确保在journalFiles加载后执行）
    AppRuntimeContext().selectDateTime(DateTime.now());

    // 计算剩余时间
    final int elapsed = stopwatch.elapsedMilliseconds;
    final int remainingTime = minDuration - elapsed;

    if (remainingTime > 0) {
      // 如果等待时间不足 400ms，继续等待
      await Future.delayed(Duration(milliseconds: remainingTime));
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
        color: Colors.white, // 背景颜色const Color.fromARGB(255, 234, 196, 103)
        child: Center(
          child: Text(
            'NIRVA',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // 数据初始化方法（从main.dart移动过来）
  Future<void> _setupHiveStorage() async {
    // 在开始数据初始化之前清空上下文，但要在Provider设置之后
    // 注意：不能在这里调用AppRuntimeContext.clear()，因为会清空已设置的Provider

    // 填充测试数据。
    await MyTest.initializeTestData();

    // 喜爱的日记数据
    AppRuntimeContext().runtimeData.favorites.value =
        AppRuntimeContext().hiveManager.getFavoritesIds();

    // 对话列表
    final storageChatHistory = AppRuntimeContext().hiveManager.getChatHistory();
    AppRuntimeContext().runtimeData.chatHistory.value =
        storageChatHistory; // 清空之前的聊天记录

    // 任务列表
    final retrievedTasks = AppRuntimeContext().hiveManager.getAllTasks();
    AppRuntimeContext().runtimeData.tasks.value = retrievedTasks;

    //notes
    final retrievedNotes = AppRuntimeContext().hiveManager.getAllNotes();
    AppRuntimeContext().runtimeData.notes.value = retrievedNotes;

    //journal files
    AppRuntimeContext().initializeJournalFiles(
      AppRuntimeContext().hiveManager.retrieveJournalFiles(),
    );
  }

  // 网络状态检查失败后的处理: 如果用户没有网络连接，是否需要阻止后续逻辑执行？目前代码中即使没有网络连接，仍会继续执行后续的 API 配置和登录逻辑。
  // 用户体验优化: 在网络状态检查失败时，可以提供更多选项（如重试按钮）而不是仅仅显示一个确认对话框。
  Future<void> checkNetworkStatus() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none)) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("No Network Connection"),
              content: const Text(
                "Please check your network connection and try again.",
              ),
              actions: [
                TextButton(
                  onPressed:
                      () => {
                        debugPrint("No Network Connection"),
                        Navigator.pop(context),
                      },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }
}
