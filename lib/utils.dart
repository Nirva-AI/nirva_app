import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class Utils {
  // 静态方法：加载 JSON 文件并解析为 Map
  static Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    // 加载 JSON 文件内容
    final String jsonString = await rootBundle.loadString(path);
    // 将 JSON 字符串解析为 Map
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  // 将 JSON 数据写入文件的方法
  static Future<void> writeJsonToFile(
    String fileName,
    Map<String, dynamic> jsonData,
  ) async {
    try {
      // 获取应用程序的文档目录
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // 将 JSON 数据写入文件
      final file = File(filePath);
      await file.writeAsString(jsonData.toString());

      debugPrint('JSON 数据已写入文件: $filePath');
    } catch (e) {
      debugPrint('写入 JSON 文件时出错: $e');
    }
  }

  static String fullFormatEventDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(dateTime);
  }

  static Tuple2<DateTime, DateTime> extractEventTimeRange(
    DateTime referenceDateTime,
    String timeRange,
  ) {
    final times = timeRange.split('-');
    if (times.length != 2) {
      throw FormatException('Invalid time range format: $timeRange');
    }

    final startTimeParts = times[0].trim().split(':');
    final endTimeParts = times[1].trim().split(':');

    if (startTimeParts.length != 2 || endTimeParts.length != 2) {
      throw FormatException('Invalid time format in range: $timeRange');
    }

    final startDateTime = DateTime(
      referenceDateTime.year,
      referenceDateTime.month,
      referenceDateTime.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );

    final endDateTime = DateTime(
      referenceDateTime.year,
      referenceDateTime.month,
      referenceDateTime.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );

    return Tuple2(startDateTime, endDateTime);
  }
}
