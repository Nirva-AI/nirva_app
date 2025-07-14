import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';

class JournalFilesProvider extends ChangeNotifier {
  List<JournalFile> _journalFiles = [];
  final List<Dashboard> _dashboards = [];

  List<JournalFile> get journalFiles => List.unmodifiable(_journalFiles);
  List<Dashboard> get dashboards => List.unmodifiable(_dashboards);

  void setupJournalFiles(List<JournalFile> files) {
    _journalFiles = files;
    _sortJournalFilesByDate();
    _refreshDashboardData();
    notifyListeners();
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
}
