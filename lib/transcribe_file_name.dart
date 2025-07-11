import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

/// 转录文件名处理类
/// 支持从特定格式的文件名中解析日期时间、文件编号和后缀
/// 也支持从这些组件生成标准格式的文件名
/// 文件名格式：nirva-YYYY-MM-DD-NN.suffix
/// transcribe_file_name.dart
class TranscribeFileName {
  final DateTime dateTime;
  final int fileNumber;
  final String fileSuffix;

  /// 构造函数
  TranscribeFileName({
    required this.dateTime,
    required this.fileNumber,
    required this.fileSuffix,
  });

  /// 从文件名解析创建实例的命名构造函数
  TranscribeFileName.fromFilename(String filename)
    : this._fromParsedData(_parseFilename(filename));

  /// 私有构造函数，用于从解析的数据创建实例
  TranscribeFileName._fromParsedData(Tuple3<DateTime, int, String>? parsedData)
    : dateTime = parsedData?.item1 ?? DateTime.now(),
      fileNumber = parsedData?.item2 ?? 0,
      fileSuffix = parsedData?.item3 ?? 'txt' {
    if (parsedData == null) {
      throw ArgumentError('无法解析文件名格式');
    }
  }

  /// 生成标准格式的文件名
  /// 格式：nirva-YYYY-MM-DD-NN.suffix
  String generateFilename() {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final number = fileNumber.toString().padLeft(2, '0');

    return 'nirva-$year-$month-$day-$number.$fileSuffix';
  }

  /// 静态方法：从文件名解析数据（保持向后兼容）
  static Tuple3<DateTime, int, String>? parse(String filename) {
    return _parseFilename(filename);
  }

  /// 静态方法：尝试从文件名创建实例，失败时返回null
  static TranscribeFileName? tryFromFilename(String filename) {
    try {
      return TranscribeFileName.fromFilename(filename);
    } catch (e) {
      debugPrint('创建TranscribeFileName实例失败: $e');
      return null;
    }
  }

  /// 验证当前实例的数据是否有效
  bool isValid() {
    return fileNumber >= 0 &&
        fileSuffix.isNotEmpty &&
        dateTime.year >= 1900 &&
        dateTime.year <= 9999;
  }

  /// 私有静态方法：解析文件名的核心逻辑
  static Tuple3<DateTime, int, String>? _parseFilename(String filename) {
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

  /// 创建当前实例的副本，可选择性地修改某些属性
  TranscribeFileName copyWith({
    DateTime? dateTime,
    int? fileNumber,
    String? fileSuffix,
  }) {
    return TranscribeFileName(
      dateTime: dateTime ?? this.dateTime,
      fileNumber: fileNumber ?? this.fileNumber,
      fileSuffix: fileSuffix ?? this.fileSuffix,
    );
  }

  @override
  String toString() {
    return 'TranscribeFileName{dateTime: $dateTime, fileNumber: $fileNumber, fileSuffix: $fileSuffix, filename: ${generateFilename()}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TranscribeFileName &&
        other.dateTime == dateTime &&
        other.fileNumber == fileNumber &&
        other.fileSuffix == fileSuffix;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^ fileNumber.hashCode ^ fileSuffix.hashCode;
  }
}
