import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';

class JournalFilesProvider extends ChangeNotifier {
  List<JournalFile> _journalFiles = [];
  final List<Dashboard> _dashboards = [];

  // 从AppService迁移过来的状态
  DateTime _selectedDateTime = DateTime.now();
  JournalFile? _currentJournalFile;

  List<JournalFile> get journalFiles => List.unmodifiable(_journalFiles);
  List<Dashboard> get dashboards => List.unmodifiable(_dashboards);

  // 从AppService迁移过来的getter
  DateTime get selectedDateTime => _selectedDateTime;
  JournalFile get currentJournalFile =>
      _currentJournalFile ?? JournalFile.createEmpty();

  void setupJournalFiles(List<JournalFile> files) {
    _journalFiles = files;
    _sortJournalFilesByDate();
    _refreshDashboardData();
    _onActiveJournalFile(); // 添加这个调用以更新当前日记文件
    notifyListeners();
  }

  // 从AppService迁移过来的方法
  void selectDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    _onActiveJournalFile();
    notifyListeners();
  }

  void addJournalFile(JournalFile journalFile) {
    setupJournalFiles(_journalFiles + [journalFile]);
  }

  void initializeJournalFiles(List<JournalFile> files) {
    setupJournalFiles(files);
  }

  // 从AppService迁移过来的私有方法
  void _onActiveJournalFile() {
    _currentJournalFile = null;
    for (var journalFile in _journalFiles) {
      if (journalFile.time_stamp ==
          JournalFile.dateTimeToKey(_selectedDateTime)) {
        _currentJournalFile = journalFile;
        break;
      }
    }
  }

  // 从AppService迁移过来的社交地图相关方法
  Map<String, SocialEntity> buildSocialMap() {
    final Map<String, SocialEntity> map = {};
    for (var journalFile in _journalFiles) {
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

  double getTotalSocialHours() {
    double totalHours = 0;
    final global = buildSocialMap();
    for (var entity in global.values) {
      totalHours += entity.hours;
    }
    return totalHours;
  }

  JournalFile? getJournalFileByDate(DateTime date) {
    final dateString = JournalFile.dateTimeToKey(date);
    for (var file in _journalFiles) {
      if (file.time_stamp.startsWith(dateString)) {
        return file;
      }
    }
    return null;
  }

  void _sortJournalFilesByDate() {
    _journalFiles =
        _journalFiles.where((file) => file.time_stamp.isNotEmpty).toList()
          ..sort(
            (a, b) => DateTime.parse(
              a.time_stamp,
            ).compareTo(DateTime.parse(b.time_stamp)),
          );
  }

  void _refreshDashboardData() {
    _dashboards.clear();
    if (_journalFiles.isEmpty) {
      return;
    }

    final firstDayTimeStamp = _journalFiles.first.time_stamp;
    final currentDay = DateTime.now();

    var firstDay = DateTime.parse(firstDayTimeStamp);
    var daysBetween = currentDay.difference(firstDay).inDays;
    if (daysBetween < 14) {
      firstDay = currentDay.subtract(Duration(days: 14));
      daysBetween = 14;
      debugPrint(
        'Rebuilding Dashboard2 with first day: $firstDay, days between: $daysBetween',
      );
    }

    for (int i = 0; i <= daysBetween; i++) {
      final date = firstDay.add(Duration(days: i));
      _dashboards.add(Dashboard(dateTime: date));
      _dashboards.last.testShuffle();
    }

    for (var dashboard in _dashboards) {
      final journalFile = getJournalFileByDate(dashboard.dateTime);
      if (journalFile != null) {
        dashboard.journalFile = journalFile;
        dashboard.syncDataWithJournalFile();
      }
    }
  }

  /// Clear all journal files data (used on logout)
  void clearData() {
    _journalFiles = [];
    _dashboards.clear();
    _currentJournalFile = null;
    _selectedDateTime = DateTime.now();
    notifyListeners();
  }
}
