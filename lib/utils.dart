import 'dart:convert';
import 'dart:io'; // 用于文件操作
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

  /// 从特定格式的文件名中提取日期时间、文件编号和后缀
  /// 文件名格式为"nirva-YYYY-MM-DD-NN.txt"
  /// 返回一个包含日期时间对象、文件编号和后缀的元组
  /// 如果文件名格式不正确或解析失败，返回null
  static Tuple3<DateTime, int, String>? parseDataFromSpecialUploadFilename(
    String filename,
  ) {
    // 用"-"分割文件名
    final parts = filename.split("-");

    // 检查分割后的数组长度是否至少为5
    if (parts.length < 5) {
      debugPrint("文件名格式不正确: $filename");
      return null;
    }

    // 检查第一部分是否为"nirva"
    if (parts[0] != "nirva") {
      debugPrint("文件名不符合预期格式: $filename");
      return null;
    }

    try {
      // 解析年、月、日
      final year = int.parse(parts[1]);
      final month = int.parse(parts[2]);
      final day = int.parse(parts[3]);

      // 解析文件编号和后缀
      final fileNumAndSuffix = parts[4].split(".");
      if (fileNumAndSuffix.length < 2) {
        debugPrint("文件名后缀格式不正确: $filename");
        return null;
      }

      final fileNumber = int.parse(fileNumAndSuffix[0]);
      final fileSuffix = fileNumAndSuffix.last; // 使用last获取最后一个元素，处理多个点的情况

      // 创建日期时间对象
      final dateTime = DateTime(year, month, day);

      // 返回元组
      return Tuple3(dateTime, fileNumber, fileSuffix);
    } catch (e) {
      debugPrint("解析文件名时出错: $e, 文件名: $filename");
      debugPrint("无法从文件名 $filename 中解析出日期时间、文件编号或后缀。");
      return null;
    }
  }
}
