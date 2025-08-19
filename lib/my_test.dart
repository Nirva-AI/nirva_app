import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/utils.dart';
import 'dart:convert';
import 'package:nirva_app/hive_helper.dart';

// 填充测试数据的类。
class MyTest {
  //
  static Future<void> setupTestData([
    NotesProvider? notesProvider,
    UserProvider? userProvider,
  ]) async {
    //这里读取日记。
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-04-19-00.txt.json',
      DateTime(2025, 4, 19),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-05-09-00.txt.json',
      DateTime(2025, 5, 9),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-07-28-00.txt.json',
      DateTime(2025, 7, 28),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-07-29-00.txt.json',
      DateTime(2025, 7, 29),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-07-30-00.txt.json',
      DateTime(2025, 7, 30),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-08-15-00.txt.json',
      DateTime(2025, 8, 15),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-08-16-00.txt.json',
      DateTime(2025, 8, 16),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-08-17-00.txt.json',
      DateTime(2025, 8, 17),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-08-18-00.txt.json',
      DateTime(2025, 8, 18),
    );
  }

  // 加载测试日记文件
  static Future<void> loadTestJournalFile(
    String path,
    DateTime dateTime,
  ) async {
    try {
      final jsonData = await Utils.loadJsonAsset(path);
      final loadJournalFile = JournalFile.fromJson(jsonData);
      debugPrint('事件数量: ${loadJournalFile.events.length}');

      // 故意存储一个测试的数据。
      await HiveHelper.createJournalFile(
        fileName: JournalFile.dateTimeToKey(dateTime),
        content: jsonEncode(jsonData),
      );

      final journalFileStorage = HiveHelper.getJournalFile(
        JournalFile.dateTimeToKey(dateTime),
      );
      assert(
        journalFileStorage != null,
        'Journal file storage should not be null',
      );
    } catch (error) {
      debugPrint('加载日记文件时出错: $error');
    }
  }
}
