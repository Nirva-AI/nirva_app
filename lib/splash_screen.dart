import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/my_test.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:nirva_app/services/native_s3_bridge.dart';

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
      // Check if first launch by seeing if user token exists
      final isFirstLaunch = HiveHelper.getUserToken().access_token.isEmpty;
      
      if (isFirstLaunch) {
        // TEMPORARY FIX: Wait longer for iOS network to be ready on first launch
        Logger().i('First launch detected - waiting for iOS network initialization...');
        await Future.delayed(const Duration(seconds: 5));
      }
      
      // 检查网络状态 - 无网络时阻止启动
      final hasNetwork = await _checkNetworkStatus();
      if (!hasNetwork) {
        return; // 阻止后续执行
      }

      // 初始化JournalFilesProvider
      if (!mounted) return;
      final journalFilesProvider = Provider.of<JournalFilesProvider>(
        context,
        listen: false,
      );

      // 获取其他Providers用于数据初始化
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);

      // 获取其他Providers用于数据初始化
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final chatHistoryProvider = Provider.of<ChatHistoryProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // 填充测试数据。
      await MyTest.setupTestData(notesProvider, userProvider);

      // 执行数据初始化
      await _setupHiveStorage(
        tasksProvider,
        favoritesProvider,
        notesProvider,
        chatHistoryProvider,
        userProvider,
      );

      // 设置初始选中日期 - 使用有测试数据的日期
      journalFilesProvider.selectDateTime(DateTime(2025, 7, 28));

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
      // 在异步操作前获取 UserProvider，避免跨异步使用 context
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      // Retry logic for first network call
      URLConfigurationResponse? urlConfig;
      int retryCount = 0;
      const maxRetries = 3;
      
      while (retryCount < maxRetries) {
        try {
          urlConfig = await NirvaAPI.getUrlConfig();
          break; // Success, exit loop
        } catch (e) {
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(const Duration(seconds: 2));
          } else {
            rethrow; // All retries failed
          }
        }
      }
      
      if (urlConfig == null) {
        throw Exception('获取 URL 配置失败');
      }

      Logger().i('API 配置获取成功');

      final token = await NirvaAPI.login(user);
      if (token == null) {
        throw Exception('登录失败，未获取到 token');
      }

      Logger().i('用户登录成功');
      
      // Fetch S3 credentials after successful login
      try {
        Logger().i('Fetching S3 upload credentials...');
        await NativeS3Bridge.instance.refreshCredentialsIfNeeded();
        Logger().i('S3 credentials fetch initiated');
      } catch (e) {
        Logger().w('Failed to fetch S3 credentials on login: $e');
        // Don't fail the login process if S3 credentials fail
      }
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

  Future<void> _setupHiveStorage(
    TasksProvider tasksProvider,
    FavoritesProvider favoritesProvider,
    NotesProvider notesProvider,
    ChatHistoryProvider chatHistoryProvider,
    UserProvider userProvider,
  ) async {
    // 喜爱的日记数据
    final retrievedFavorites = HiveHelper.getFavoritesIds();
    favoritesProvider.setupFavorites(retrievedFavorites);

    // 对话列表
    final storageChatHistory = HiveHelper.getChatHistory();
    chatHistoryProvider.setupChatHistory(storageChatHistory);

    // 任务列表
    final retrievedTasks = HiveHelper.getAllTasks();
    tasksProvider.setupTasks(retrievedTasks);

    // 笔记列表
    final retrievedNotes = HiveHelper.getAllNotes();
    notesProvider.setupNotes(retrievedNotes);

    //journal files
    final journalFilesProvider = Provider.of<JournalFilesProvider>(
      context,
      listen: false,
    );
    final retrievedJournalFiles = HiveHelper.retrieveJournalFiles();
    journalFilesProvider.initializeJournalFiles(retrievedJournalFiles);
  }
}
