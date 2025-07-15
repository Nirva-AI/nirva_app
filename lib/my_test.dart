import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_service.dart';
import 'dart:math';
import 'package:nirva_app/utils.dart';
import 'dart:convert';
import 'package:nirva_app/hive_helper.dart';

// 填充测试数据的类。
class MyTest {
  static final random = Random();
  //
  static Future<void> setupTestData() async {
    // 设置用户信息
    AppService().setUser(
      User(
        id: "1eaade33-f351-461a-8f73-59a11cba04f9", // 这个ID是测试用的，必须和服务器对上。
        username: 'weilyupku@gmail.com',
        password: 'secret',
        displayName: 'wei',
      ),
    );

    //这里读取日记。
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-04-19-00.txt.json',
      DateTime(2025, 4, 19),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-05-09-00.txt.json',
      DateTime(2025, 5, 9),
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

      await HiveHelper.createJournalFile(
        fileName: JournalFile.dateTimeToKey(dateTime),
        content: jsonEncode(jsonData),
      );

      final journalFileStorage = HiveHelper.getJournalFile(
        JournalFile.dateTimeToKey(dateTime),
      );
      if (journalFileStorage != null) {
        // 直接测试一次！
        final jsonDecode =
            json.decode(journalFileStorage.content) as Map<String, dynamic>;

        final journalFile = JournalFile.fromJson(jsonDecode);
        Logger().d(
          'loadTestJournalFile Journal file loaded: ${jsonEncode(journalFile.toJson())}',
        );
      }
    } catch (error) {
      debugPrint('加载日记文件时出错: $error');
    }
  }

  // 添加日记的笔记数据
  static void initializeTestMyNotes(JournalFile journalFile) {
    // 设置测试数据
    List<EventAnalysis> events = journalFile.events;

    //
    if (events.isNotEmpty) {
      EventAnalysis randomEvent = events[random.nextInt(events.length)];
      debugPrint('随机选中的日记: ${randomEvent.event_title}');
      AppService().notesProvider.setupNotes([
        Note(
          id: randomEvent.event_id,
          content:
              'This is a test note for diary entry ${randomEvent.event_id}.',
        ),
      ]);
      debugPrint('已添加到笔记: ${randomEvent.event_id}');
    } else {
      debugPrint('diaryEntries 列表为空');
    }
  }
}
