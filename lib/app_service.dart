// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/data.dart';

class AppService {
  // 可重置的单例模式
  static AppService? _instance;
  static AppService get instance {
    _instance ??= AppService._internal();
    return _instance!;
  }

  factory AppService() => instance;
  AppService._internal();

  // 清空数据
  static void clear() {
    _instance = AppService._internal();
  }

  // 当前选中的日期时间
  DateTime _selectedDateTime = DateTime.now();

  // 当前的日记文件
  JournalFile? _currentJournalFile;

  // JournalFiles Provider 引用
  JournalFilesProvider? _journalFilesProvider;

  // 设置JournalFilesProvider
  void setJournalFilesProvider(JournalFilesProvider provider) {
    _journalFilesProvider = provider;
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
    return _currentJournalFile ?? JournalFile.createEmpty();
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


/*

*/