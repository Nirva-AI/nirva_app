import 'dart:convert';
import 'package:flutter/services.dart';

class Utils {
  // 静态方法：加载 JSON 文件并解析为 Map
  static Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    // 加载 JSON 文件内容
    final String jsonString = await rootBundle.loadString(path);
    // 将 JSON 字符串解析为 Map
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
