// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/runtime_data.dart';
import 'package:nirva_app/my_hive_manager.dart';
import 'package:nirva_app/url_configuration.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/data.dart';

const String serverAddress = '192.168.192.122';
const int basePort = 8001;
const String devHttpUrl = 'http://$serverAddress:$basePort';

// 管理全局数据的类
class AppRuntimeContext {
  // 可重置的单例模式
  static AppRuntimeContext? _instance;
  static AppRuntimeContext get instance {
    _instance ??= AppRuntimeContext._internal();
    return _instance!;
  }

  factory AppRuntimeContext() => instance;
  AppRuntimeContext._internal();

  // 清空数据
  static void clear() {
    _instance = AppRuntimeContext._internal();
  }

  // 用户信息
  User _user = User(id: "", username: "", password: "", displayName: "");

  // 当前选中的日期时间
  DateTime _selectedDateTime = DateTime.now();

  // 当前的日记文件
  JournalFile? _currentJournalFile;

  // 空的日记文件实例
  final emptyJournalFile = JournalFile.createEmpty();

  // 数据管理器实例
  final RuntimeData _runtimeData = RuntimeData();

  // Hive 存储实例
  final MyHiveManager _hiveManager = MyHiveManager();

  // URL 配置实例
  final URLConfiguration _urlConfig = URLConfiguration();

  // JournalFiles Provider 引用
  JournalFilesProvider? _journalFilesProvider;

  // Tasks Provider 引用
  TasksProvider? _tasksProvider;

  // Favorites Provider 引用
  FavoritesProvider? _favoritesProvider;

  // Notes Provider 引用
  NotesProvider? _notesProvider;

  // 获取用户
  User get user {
    return _user;
  }

  // 用于基础app服务的 Dio 实例
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: devHttpUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )
    ..interceptors.addAll([
      LogInterceptor(request: true, requestHeader: true, responseHeader: true),
      InterceptorsWrapper(
        onError: (error, handler) {
          Logger().e('Dio Error: ${error.message}');
          return handler.next(error);
        },
      ),
    ]);

  RuntimeData get runtimeData {
    return _runtimeData;
  }

  MyHiveManager get hiveManager {
    return _hiveManager;
  }

  URLConfiguration get urlConfig {
    return _urlConfig;
  }

  Dio get dio {
    return _dio;
  }

  TasksProvider get tasksProvider {
    return _tasksProvider!;
  }

  FavoritesProvider get favoritesProvider {
    return _favoritesProvider!;
  }

  NotesProvider get notesProvider {
    return _notesProvider!;
  }

  void setUser(User user) {
    _user = user;
  }

  // 设置JournalFilesProvider
  void setJournalFilesProvider(JournalFilesProvider provider) {
    _journalFilesProvider = provider;
  }

  // 设置TasksProvider
  void setTasksProvider(TasksProvider provider) {
    _tasksProvider = provider;
  }

  // 设置FavoritesProvider
  void setFavoritesProvider(FavoritesProvider provider) {
    _favoritesProvider = provider;
  }

  // 设置NotesProvider
  void setNotesProvider(NotesProvider provider) {
    _notesProvider = provider;
  }

  // 根据日期获取日记文件
  JournalFile? getJournalFileByDate(DateTime date) {
    return _journalFilesProvider?.getJournalFileByDate(date);
  }

  //
  DateTime get selectedDateTime {
    return _selectedDateTime;
  }

  // 获取当前的日记文件。
  JournalFile get currentJournalFile {
    return _currentJournalFile ?? emptyJournalFile;
  }

  // 清除对话历史!
  Future<void> clearChatHistory() async {
    // 运行时数据清除
    runtimeData.chatHistory.value = [];

    // Hive 存储清除
    await AppRuntimeContext().hiveManager.clearChatHistory();
  }

  //
  void selectDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    _onActiveJournalFile();
  }

  //
  void addJournalFile(JournalFile journalFile) {
    if (_journalFilesProvider != null) {
      _journalFilesProvider!.setupJournalFiles(journalFiles + [journalFile]);
    }
    _onActiveJournalFile();
  }

  //
  void initializeJournalFiles(List<JournalFile> files) {
    if (_journalFilesProvider != null) {
      _journalFilesProvider!.setupJournalFiles(files);
    }
    _onActiveJournalFile();
  }

  //
  void _onActiveJournalFile() {
    _currentJournalFile = null;
    for (var journalFile in journalFiles) {
      if (journalFile.time_stamp ==
          JournalFile.dateTimeToKey(_selectedDateTime)) {
        _currentJournalFile = journalFile;
      }
    }
  }

  //
  List<JournalFile> get journalFiles {
    // 获取所有的日记文件
    return _journalFilesProvider?.journalFiles ?? [];
  }

  //
  List<Dashboard> get dashboards {
    // 获取所有的仪表板
    return _journalFilesProvider?.dashboards ?? [];
  }

  //
  // 获取当前的社交地图
  Map<String, SocialEntity> buildSocialMap() {
    // 获取全局社交实体的映射
    final Map<String, SocialEntity> map = {};
    for (var journalFile in journalFiles) {
      Map<String, SocialEntity> subMap = journalFile.socialEntities;
      for (var key in subMap.keys) {
        if (!map.containsKey(key)) {
          map[key] = subMap[key]!;
        } else {
          // 如果已经存在，则合并
          map[key]!.merge(subMap[key]!);
        }
      }
    }
    return map;
  }

  // 获取全局社交地图
  double getTotalSocialHours() {
    // 计算全局社交时间
    double totalHours = 0;
    final global = buildSocialMap();
    for (var entity in global.values) {
      totalHours += entity.hours;
    }
    return totalHours;
  }
}
