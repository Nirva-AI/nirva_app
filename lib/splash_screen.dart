import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nirva_app/app_service.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
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
    final int minDuration = 600; // 最小等待时间，确保有足够时间完成初始化
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      // 检查网络状态 - 无网络时阻止启动
      final hasNetwork = await _checkNetworkStatus();
      if (!hasNetwork) {
        return; // 阻止后续执行
      }

      // 清空AppRuntimeContext（在设置Provider之前）
      AppService.clear();

      // 初始化JournalFilesProvider
      if (!mounted) return;
      final journalFilesProvider = Provider.of<JournalFilesProvider>(
        context,
        listen: false,
      );
      AppService().setJournalFilesProvider(journalFilesProvider);

      // 初始化TasksProvider
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
      AppService().setTasksProvider(tasksProvider);

      // 初始化FavoritesProvider
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      AppService().setFavoritesProvider(favoritesProvider);

      // 初始化NotesProvider
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      AppService().setNotesProvider(notesProvider);

      // 初始化ChatHistoryProvider
      final chatHistoryProvider = Provider.of<ChatHistoryProvider>(
        context,
        listen: false,
      );
      AppService().setChatHistoryProvider(chatHistoryProvider);

      // 执行数据初始化
      await _setupHiveStorage();

      // 设置初始选中日期
      AppService().selectDateTime(DateTime.now());

      // API初始化和登录
      await _initializeAPIs();

      // 确保最小显示时间
      final int elapsed = stopwatch.elapsedMilliseconds;
      final int remainingTime = minDuration - elapsed;
      if (remainingTime > 0) {
        await Future.delayed(Duration(milliseconds: remainingTime));
      }

      // 跳转到主页面
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const HomePage(title: 'Nirva App Home Page'),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return child; // 无动画过渡
            },
          ),
        );
      }
    } catch (e) {
      Logger().e('应用初始化失败: $e');
      if (mounted) {
        _showFatalError('应用初始化失败', '请重启应用重试\n错误信息: $e');
      }
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

  // API初始化方法
  Future<void> _initializeAPIs() async {
    try {
      final urlConfig = await APIs.getUrlConfig();
      if (urlConfig == null) {
        throw Exception('获取 URL 配置失败');
      }

      Logger().i('API 配置获取成功');

      final token = await APIs.login();
      if (token == null) {
        throw Exception('登录失败，未获取到 token');
      }

      Logger().i('用户登录成功');
    } catch (e) {
      Logger().e('API初始化或登录失败: $e');
      rethrow; // 重新抛出异常，让上层处理
    }
  }

  // 网络状态检查方法 - 返回是否有网络连接
  Future<bool> _checkNetworkStatus() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none)) {
      if (!mounted) return false;

      await _showFatalError("无网络连接", "请检查网络连接后重启应用");
      return false;
    }
    return true;
  }

  // 显示致命错误对话框
  Future<void> _showFatalError(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // 不允许点击外部关闭
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  // 关闭对话框但不继续执行
                  Navigator.pop(context);
                },
                child: const Text("确定"),
              ),
            ],
          ),
    );
  }

  Future<void> _setupHiveStorage() async {
    // 填充测试数据。
    await MyTest.setupTestData();

    // 喜爱的日记数据
    final retrievedFavorites = AppService().hiveManager.getFavoritesIds();
    AppService().favoritesProvider.setupFavorites(retrievedFavorites);

    // 对话列表
    final storageChatHistory = AppService().hiveManager.getChatHistory();
    AppService().chatHistoryProvider.setupChatHistory(storageChatHistory);

    // 任务列表
    final retrievedTasks = AppService().hiveManager.getAllTasks();
    AppService().tasksProvider.setupTasks(retrievedTasks);

    // 笔记列表
    final retrievedNotes = AppService().hiveManager.getAllNotes();
    AppService().notesProvider.setupNotes(retrievedNotes);

    //journal files
    AppService().initializeJournalFiles(
      AppService().hiveManager.retrieveJournalFiles(),
    );
  }
}
