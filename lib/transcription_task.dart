import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// S3路径辅助类
/// 用于生成标准的S3存储路径
class S3PathHelper {
  /// 生成音频文件路径: private/{userId}/tasks/{taskId}/audio/{filename}
  static String getAudioPath(String userId, String taskId, String filename) {
    return 'private/$userId/tasks/$taskId/audio/$filename';
  }

  /// 生成转录结果路径: private/{userId}/tasks/{taskId}/transcripts/{filename}
  static String getTranscriptPath(
    String userId,
    String taskId,
    String filename,
  ) {
    return 'private/$userId/tasks/$taskId/transcripts/$filename';
  }
}

/// 上传和转录任务管理类
///
/// 这个类封装了完整的音频文件上传和转录的业务流程：
/// 1. 上传音频文件到S3
/// 2. 获取转录结果
/// 3. 清理任务文件
class UploadAndTranscribeTask {
  // 核心属性
  final String taskId;
  final String userId;
  final List<String> sourceFileNames;

  // 内部状态
  List<String> _uploadedFileNames = [];
  final List<File> _tempFiles = [];
  bool _isUploaded = false;
  bool _isTranscribed = false;

  /// 构造函数
  ///
  /// [userId] 用户ID
  /// [sourceFileNames] 源文件名列表
  UploadAndTranscribeTask({required this.userId, required this.sourceFileNames})
    : taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';

  /// 步骤1：上传文件到S3
  ///
  /// 并行上传所有音频文件，支持最大50MB文件大小限制
  /// 返回 [UploadResult] 包含上传结果详情
  Future<UploadResult> uploadFiles() async {
    final startTime = DateTime.now();
    final List<String> uploadedFileNames = [];
    final List<String> errors = [];
    _tempFiles.clear();

    const int maxMbSize = 50;
    const int maxFileSize = maxMbSize * 1024 * 1024;

    try {
      safePrint('UploadAndTranscribeTask: 开始上传文件...');
      safePrint('用户ID: $userId, 任务ID: $taskId');

      // 并行上传所有文件
      final results = await _processFilesInParallel(
        items: sourceFileNames,
        processor: (fileName, index) async {
          // 从 assets 加载音频文件
          final ByteData audioData = await rootBundle.load('assets/$fileName');
          final Uint8List audioBytes = audioData.buffer.asUint8List();

          // 检查文件大小限制
          if (audioBytes.length > maxFileSize) {
            final fileSizeMB = (audioBytes.length / (1024 * 1024))
                .toStringAsFixed(2);
            throw Exception('文件大小超过限制: $fileSizeMB MB');
          }

          // 创建临时文件
          final tempDir = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final tempFile = File(
            '${tempDir.path}/test_audio_${timestamp}_$index.mp3',
          );
          await tempFile.writeAsBytes(audioBytes);
          _tempFiles.add(tempFile);

          // 生成唯一的文件名
          final uniqueFileName = 'test_audio_${timestamp}_$index.mp3';

          // 构建S3路径
          final s3Path = S3PathHelper.getAudioPath(
            userId,
            taskId,
            uniqueFileName,
          );

          // 上传文件到 S3
          final uploadOperation = Amplify.Storage.uploadFile(
            localFile: AWSFile.fromPath(tempFile.path),
            path: StoragePath.fromString(s3Path),
            options: StorageUploadFileOptions(
              metadata: {
                'fileType': 'audio',
                'originalName': fileName,
                'uploadTime': DateTime.now().toIso8601String(),
                'uploadMethod': 'uploadFile',
                'batchIndex': index.toString(),
                'userId': userId,
                'taskId': taskId,
              },
            ),
          );

          await uploadOperation.result;

          // 返回上传的文件名（不含扩展名）
          return uniqueFileName.substring(0, uniqueFileName.lastIndexOf('.'));
        },
      );

      // 处理结果
      int successCount = 0;
      for (final result in results) {
        if (result is Map && result.containsKey('error')) {
          errors.add('${result['item']}: ${result['error']}');
        } else if (result is String) {
          uploadedFileNames.add(result);
          successCount++;
        }
      }

      // 严格成功判断：所有文件都必须上传成功
      final isSuccess = successCount == sourceFileNames.length;

      if (isSuccess) {
        _uploadedFileNames = uploadedFileNames;
        _isUploaded = true;
        safePrint('UploadAndTranscribeTask: 所有文件上传成功');
      } else {
        await _cleanupTempFiles();
        safePrint('UploadAndTranscribeTask: 上传失败，已清理临时文件');
      }

      return UploadResult(
        success: isSuccess,
        taskId: taskId,
        uploadedFileNames: uploadedFileNames,
        errors: errors,
        duration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      await _cleanupTempFiles();
      safePrint('UploadAndTranscribeTask: 上传异常: $e');
      return UploadResult(
        success: false,
        taskId: taskId,
        uploadedFileNames: [],
        errors: [e.toString()],
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// 步骤2：获取转录结果
  ///
  /// 从S3下载并解析转录结果文件，合并所有转录文本
  /// 返回 [TranscriptionResult] 包含转录结果详情
  Future<TranscriptionResult> getTranscriptionResults() async {
    final startTime = DateTime.now();

    // 检查前置条件
    if (!_isUploaded || _uploadedFileNames.isEmpty) {
      return TranscriptionResult(
        success: false,
        taskId: taskId,
        transcripts: [],
        mergedText: '',
        savedFilePath: '',
        errors: ['任务未完成上传或上传文件记录为空'],
        duration: DateTime.now().difference(startTime),
      );
    }

    try {
      safePrint('UploadAndTranscribeTask: 开始获取转录结果...');

      // 并行获取所有转录结果
      final results = await _processFilesInParallel(
        items: _uploadedFileNames,
        processor: (uploadedFileName, index) async {
          final transcriptFileName = '$uploadedFileName.json';
          final transcriptPath = S3PathHelper.getTranscriptPath(
            userId,
            taskId,
            transcriptFileName,
          );

          // 从 S3 下载转录结果文件
          final downloadResult =
              await Amplify.Storage.downloadData(
                path: StoragePath.fromString(transcriptPath),
              ).result;

          // 解析 JSON 内容
          final jsonString = String.fromCharCodes(downloadResult.bytes);
          final Map<String, dynamic> transcriptionData = jsonDecode(jsonString);

          // 提取转录文本
          String transcriptText = '';
          if (transcriptionData.containsKey('results') &&
              transcriptionData['results'] != null &&
              transcriptionData['results']['transcripts'] != null &&
              transcriptionData['results']['transcripts'].isNotEmpty) {
            transcriptText =
                transcriptionData['results']['transcripts'][0]['transcript'] ??
                '无转录文本';
          } else {
            transcriptText = '无法解析转录文本';
          }

          return TranscriptData(
            fileName: uploadedFileName,
            transcriptText: transcriptText,
            fileSizeKB: (downloadResult.bytes.length / 1024).round(),
          );
        },
      );

      // 处理结果
      final List<TranscriptData> transcripts = [];
      final List<String> errors = [];

      for (final result in results) {
        if (result is Map && result.containsKey('error')) {
          errors.add('${result['item']}: ${result['error']}');
        } else if (result is TranscriptData) {
          transcripts.add(result);
        }
      }

      // 严格成功判断：所有转录结果都必须获取成功
      final isSuccess = transcripts.length == _uploadedFileNames.length;

      String mergedText = '';
      String savedFilePath = '';

      if (isSuccess) {
        // 合并所有转录文本
        mergedText = transcripts.map((t) => t.transcriptText).join('\n\n');

        // 保存合并文本到文件
        try {
          final appDocDir = await getApplicationDocumentsDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final file = File(
            '${appDocDir.path}/merged_transcripts_$timestamp.txt',
          );
          await file.writeAsString(mergedText, encoding: utf8);
          savedFilePath = file.path;
          safePrint('UploadAndTranscribeTask: 合并文本已保存: $savedFilePath');
        } catch (e) {
          safePrint('UploadAndTranscribeTask: 保存合并文本失败: $e');
        }

        _isTranscribed = true;
        safePrint('UploadAndTranscribeTask: 所有转录结果获取成功');
      }

      return TranscriptionResult(
        success: isSuccess,
        taskId: taskId,
        transcripts: transcripts,
        mergedText: mergedText,
        savedFilePath: savedFilePath,
        errors: errors,
        duration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      safePrint('UploadAndTranscribeTask: 获取转录结果异常: $e');
      return TranscriptionResult(
        success: false,
        taskId: taskId,
        transcripts: [],
        mergedText: '',
        savedFilePath: '',
        errors: [e.toString()],
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// 步骤3：删除任务文件
  ///
  /// 删除S3中的所有任务相关文件和本地临时文件
  /// 返回是否成功删除文件
  Future<bool> deleteTaskFiles() async {
    try {
      safePrint('UploadAndTranscribeTask: 开始删除任务文件...');

      // 构造任务文件夹路径前缀
      final taskFolderPrefix = 'private/$userId/tasks/$taskId/';

      // 列出所有匹配前缀的文件
      final listResult =
          await Amplify.Storage.list(
            path: StoragePath.fromString(taskFolderPrefix),
            options: StorageListOptions(
              pageSize: 1000,
              pluginOptions: S3ListPluginOptions(excludeSubPaths: false),
            ),
          ).result;

      if (listResult.items.isEmpty) {
        safePrint('UploadAndTranscribeTask: 没有文件需要删除');
        await _cleanupTempFiles();
        return true;
      }

      // 并行删除所有文件
      int successCount = 0;
      final deleteFutures = listResult.items.map((item) async {
        try {
          await Amplify.Storage.remove(
            path: StoragePath.fromString(item.path),
          ).result;
          successCount++;
          return true;
        } catch (e) {
          safePrint('UploadAndTranscribeTask: 删除文件失败: ${item.path} - $e');
          return false;
        }
      });

      await Future.wait(deleteFutures);
      await _cleanupTempFiles();

      safePrint(
        'UploadAndTranscribeTask: 删除完成，成功删除 $successCount/${listResult.items.length} 个文件',
      );
      return successCount > 0;
    } catch (e) {
      safePrint('UploadAndTranscribeTask: 删除任务文件异常: $e');
      await _cleanupTempFiles();
      return false;
    }
  }

  /// 内部辅助方法：并行处理文件
  ///
  /// 支持批量并发处理，默认最大并发数为8
  Future<List<dynamic>> _processFilesInParallel({
    required List<String> items,
    required Future<dynamic> Function(String item, int index) processor,
    int maxConcurrency = 8,
  }) async {
    final results = <dynamic>[];

    for (int i = 0; i < items.length; i += maxConcurrency) {
      final batch = items.skip(i).take(maxConcurrency).toList();
      final batchIndices = List.generate(batch.length, (index) => i + index);

      final batchFutures =
          batch.asMap().entries.map((entry) async {
            final item = entry.value;
            final index = batchIndices[entry.key];

            try {
              return await processor(item, index);
            } catch (error) {
              safePrint('UploadAndTranscribeTask: 处理失败: $item - $error');
              return {'error': error.toString(), 'item': item};
            }
          }).toList();

      final batchResults = await Future.wait(batchFutures);
      results.addAll(batchResults);
    }

    return results;
  }

  /// 内部辅助方法：清理临时文件
  Future<void> _cleanupTempFiles() async {
    for (final tempFile in _tempFiles) {
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
          safePrint('UploadAndTranscribeTask: 临时文件已清理: ${tempFile.path}');
        } catch (e) {
          safePrint('UploadAndTranscribeTask: 清理临时文件失败: $e');
        }
      }
    }
    _tempFiles.clear();
  }

  // 状态查询方法
  bool get isUploaded => _isUploaded;
  bool get isTranscribed => _isTranscribed;
  List<String> get uploadedFileNames => List.unmodifiable(_uploadedFileNames);
}

/// 上传结果数据结构
///
/// 包含上传操作的完整结果信息
class UploadResult {
  final bool success;
  final String taskId;
  final List<String> uploadedFileNames;
  final List<String> errors;
  final Duration duration;

  const UploadResult({
    required this.success,
    required this.taskId,
    required this.uploadedFileNames,
    required this.errors,
    required this.duration,
  });
}

/// 转录结果数据结构
///
/// 包含转录操作的完整结果信息
class TranscriptionResult {
  final bool success;
  final String taskId;
  final List<TranscriptData> transcripts;
  final String mergedText;
  final String savedFilePath;
  final List<String> errors;
  final Duration duration;

  const TranscriptionResult({
    required this.success,
    required this.taskId,
    required this.transcripts,
    required this.mergedText,
    required this.savedFilePath,
    required this.errors,
    required this.duration,
  });
}

/// 转录数据结构
///
/// 包含单个文件的转录信息
class TranscriptData {
  final String fileName;
  final String transcriptText;
  final int fileSizeKB;

  const TranscriptData({
    required this.fileName,
    required this.transcriptText,
    required this.fileSizeKB,
  });
}
