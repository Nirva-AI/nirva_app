import 'dart:convert';
import 'dart:io'; // 用于文件操作
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class Logger {
  static void d(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG');
    }
  }
}

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
}
