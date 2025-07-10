import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/app_runtime_context.dart';

class SpeechToTextTestPage extends StatefulWidget {
  const SpeechToTextTestPage({super.key});

  @override
  State<SpeechToTextTestPage> createState() => _SpeechToTextTestPageState();
}

// 操作结果封装类
class OperationResult {
  final bool success;
  final String message;
  final int successCount;
  final int totalCount;
  final List<String> details;
  final List<String> errors;

  OperationResult({
    required this.success,
    required this.message,
    this.successCount = 0,
    this.totalCount = 0,
    this.details = const [],
    this.errors = const [],
  });
}

// S3路径辅助类
class S3PathHelper {
  // 生成音频文件路径: private/{userId}/tasks/{taskId}/audio/{filename}
  static String getAudioPath(String userId, String taskId, String filename) {
    return 'private/$userId/tasks/$taskId/audio/$filename';
  }

  // 生成转录结果路径: private/{userId}/tasks/{taskId}/transcripts/{filename}
  static String getTranscriptPath(
    String userId,
    String taskId,
    String filename,
  ) {
    return 'private/$userId/tasks/$taskId/transcripts/$filename';
  }
}

// 错误提示常量
class ErrorMessages {
  static const Map<String, Map<String, String>> messages = {
    'apiGateway': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. Cognito Identity Pool 不允许未认证访问\n'
          '2. 需要用户登录后才能调用 API\n'
          '3. Identity Pool 权限配置问题\n'
          '4. API Gateway 权限配置问题',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 在 AWS Console 中启用 Identity Pool 的未认证访问\n'
          '2. 或者实现用户登录功能\n'
          '3. 检查 IAM 角色权限',
    },
    'fileUpload': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. S3 存储桶权限问题\n'
          '2. Cognito Identity Pool 权限不足\n'
          '3. 网络连接问题\n'
          '4. 文件格式或大小限制\n'
          '5. 临时文件创建失败',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶策略\n'
          '2. 确认 Identity Pool 角色权限\n'
          '3. 检查网络连接\n'
          '4. 确认设备存储空间充足',
    },
    'transcriptionNotFound': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 转录任务尚未完成\n'
          '2. 转录任务失败\n'
          '3. 文件路径不正确',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 等待几分钟后重试（转录需要时间）\n'
          '2. 检查 AWS CloudWatch 日志确认 Lambda 执行状态\n'
          '3. 确认 S3 中是否存在转录结果文件',
    },
    'accessDenied': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. S3 存储桶权限问题\n'
          '2. Cognito Identity Pool 权限不足',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶策略\n'
          '2. 确认 Identity Pool 角色权限',
    },
    'general': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 网络连接问题\n'
          '2. 转录结果文件格式异常\n'
          '3. JSON 解析失败',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查网络连接\n'
          '2. 重新上传音频文件\n'
          '3. 检查转录结果文件格式',
    },
    'deletion': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 文件已被手动删除\n'
          '2. S3 存储桶权限问题\n'
          '3. Cognito Identity Pool 权限不足\n'
          '4. 网络连接问题',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶中文件是否存在\n'
          '2. 确认删除权限配置\n'
          '3. 检查网络连接',
    },
  };
}

class _SpeechToTextTestPageState extends State<SpeechToTextTestPage> {
  String _apiResult = '点击测试按钮开始语音转文字测试...';
  bool _isLoading = false;
  List<String> _uploadedFileNames = []; // 保存所有上传的文件名（不含扩展名）
  String _currentTaskId = ''; // 当前任务ID

  //支持多个音频文件测试。
  //record_test_audio，录制的音频，拿手机录制B站的声音，然后再用ffmpeg做数据处理，策略见日志13。
  //poem_audio，mac say 命令生成的音频。
  final List<String> _fileNames = [
    'record_test_audio.mp3',
    'record_test_audio.mp3',
  ];
  // static const String _uuid =
  //     "1eaade33-f351-461a-8f73-59a11cba04f9"; // 模拟用户UUID

  @override
  void initState() {
    super.initState();
    _currentTaskId = 'task_${DateTime.now().millisecondsSinceEpoch}'; // 初始化任务ID
  }

  // 公共方法：更新加载状态和结果
  void _updateState({required bool isLoading, required String result}) {
    setState(() {
      _isLoading = isLoading;
      _apiResult = result;
    });
  }

  // 公共方法：构建进度信息
  String _buildProgressMessage({
    required String operation,
    required int current,
    required int total,
    String? currentItem,
    String? additionalInfo,
  }) {
    final buffer = StringBuffer();
    buffer.write('正在$operation...\n\n');
    buffer.write('📊 $operation统计:\n');
    buffer.write('• 总文件数: $total\n');
    buffer.write('• 进度: $current/$total\n');

    if (currentItem != null) {
      buffer.write('• 当前文件: $currentItem\n');
    }

    if (additionalInfo != null) {
      buffer.write('$additionalInfo\n');
    }

    buffer.write('\n⏳ 处理中...');
    return buffer.toString();
  }

  // 公共方法：构建错误消息
  String _buildErrorMessage({
    required String operation,
    required String error,
    String? errorType,
    Map<String, dynamic>? statistics,
  }) {
    final buffer = StringBuffer();
    buffer.write('❌ $operation失败!\n\n');
    buffer.write('错误信息: $error\n\n');

    if (statistics != null) {
      buffer.write('📊 统计信息:\n');
      statistics.forEach((key, value) {
        buffer.write('• $key: $value\n');
      });
      buffer.write('\n');
    }

    // 根据错误类型添加相应的提示
    String messageKey = 'general';
    if (errorType != null) {
      if (error.contains('NoSuchKey') || error.contains('not found')) {
        messageKey = 'transcriptionNotFound';
      } else if (error.contains('AccessDenied')) {
        messageKey = 'accessDenied';
      } else if (errorType == 'upload') {
        messageKey = 'fileUpload';
      } else if (errorType == 'api') {
        messageKey = 'apiGateway';
      } else if (errorType == 'deletion') {
        messageKey = 'deletion';
      }
    }

    final messages = ErrorMessages.messages[messageKey]!;
    buffer.write('${messages['reasons']}\n\n');
    buffer.write(messages['solutions']);

    return buffer.toString();
  }

  // 公共方法：构建成功消息
  String _buildSuccessMessage({
    required String operation,
    required OperationResult result,
    String? additionalInfo,
  }) {
    final buffer = StringBuffer();
    buffer.write('✅ $operation完成!\n\n');
    buffer.write('📊 统计信息:\n');
    buffer.write('• 总文件数: ${result.totalCount}\n');
    buffer.write('• 成功处理: ${result.successCount}\n');
    buffer.write('• 失败文件: ${result.totalCount - result.successCount}\n\n');

    if (result.details.isNotEmpty) {
      buffer.write('📁 处理详情:\n');
      for (String detail in result.details) {
        buffer.write('• $detail\n');
      }
      buffer.write('\n');
    }

    if (result.errors.isNotEmpty) {
      buffer.write('⚠️ 错误信息:\n');
      for (String error in result.errors) {
        buffer.write('• $error\n');
      }
      buffer.write('\n');
    }

    if (additionalInfo != null) {
      buffer.write('$additionalInfo\n');
    }

    return buffer.toString();
  }

  // 公共方法：清理临时文件
  Future<void> _cleanupTempFiles(List<File> tempFiles) async {
    for (File tempFile in tempFiles) {
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
          safePrint('临时文件已清理: ${tempFile.path}');
        } catch (e) {
          safePrint('清理临时文件失败: $e');
        }
      }
    }
  }

  // 并行处理方法：控制并发数量的并行执行
  Future<List<dynamic>> _processInParallel({
    required List<String> items,
    required Future<dynamic> Function(String item, int index) processor,
    int maxConcurrency = 8,
    required String operation,
  }) async {
    final results = <dynamic>[];
    int completed = 0;

    // 分批处理，每批最多 maxConcurrency 个
    for (int i = 0; i < items.length; i += maxConcurrency) {
      final batch = items.skip(i).take(maxConcurrency).toList();
      final batchIndices = List.generate(batch.length, (index) => i + index);

      // 创建当前批次的 Future 列表，包装错误处理
      final batchFutures =
          batch.asMap().entries.map((entry) async {
            final item = entry.value;
            final index = batchIndices[entry.key];

            try {
              return await processor(item, index);
            } catch (error) {
              safePrint('$operation失败: $item - $error');
              return {'error': error.toString(), 'item': item};
            }
          }).toList();

      // 等待当前批次完成
      final batchResults = await Future.wait(batchFutures);
      results.addAll(batchResults);

      completed += batch.length;

      // 更新进度
      _updateState(
        isLoading: true,
        result: _buildProgressMessage(
          operation: operation,
          current: completed,
          total: items.length,
          additionalInfo:
              '• 并行处理中 (最大并发: $maxConcurrency)\n• 当前批次: ${batch.length} 个文件',
        ),
      );
    }

    return results;
  }

  // 功能1：API Gateway测试
  Future<void> _testAPIGateway() async {
    _updateState(isLoading: true, result: '正在调用 API Gateway...');

    try {
      safePrint('开始调用 Amplify API...');

      // 检查认证状态
      try {
        final session = await Amplify.Auth.fetchAuthSession();
        safePrint('Auth session: ${session.isSignedIn}');

        if (!session.isSignedIn) {
          safePrint('用户未登录，将使用未认证凭证调用API...');
        } else {
          safePrint('用户已登录，将使用认证凭证调用API...');
        }
      } catch (e) {
        safePrint('获取认证状态失败: $e');
      }

      // 使用 Amplify API 调用 REST 端点
      final restOperation = Amplify.API.get(
        '/echo',
        apiName: 'echoapi',
        queryParameters: {'message': 'Hello'},
      );

      final response = await restOperation.response;
      safePrint('API 调用成功，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = response.decodeBody();
        safePrint('响应内容: $responseBody');

        final Map<String, dynamic> jsonData = jsonDecode(responseBody);
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(jsonData);

        _updateState(
          isLoading: false,
          result:
              '✅ API 调用成功!\n\n📡 请求信息:\n'
              '• API: echoapi\n'
              '• 路径: /echo\n'
              '• 参数: message=Hello\n'
              '• 状态码: ${response.statusCode}\n\n'
              '📄 响应内容:\n$prettyJson',
        );
      } else {
        _updateState(
          isLoading: false,
          result:
              '❌ API 调用失败!\n\n'
              '状态码: ${response.statusCode}\n'
              '响应: ${response.decodeBody()}',
        );
      }
    } catch (e) {
      safePrint('API 调用出错: $e');
      _updateState(
        isLoading: false,
        result: _buildErrorMessage(
          operation: 'API 调用',
          error: e.toString(),
          errorType: 'api',
        ),
      );
      Logger().e('API 调用失败: $e');
    }
  }

  // 功能3：批量上传音频到S3->事件触发Lambda->启动Transcribe任务->输出的转录结果JSON再次存入S3
  Future<void> _testFileUploadAndTranscribe() async {
    _updateState(isLoading: true, result: '正在准备批量上传音频文件...');

    // 生成新的任务ID
    final String userId = AppRuntimeContext().data.user.id;
    _currentTaskId = 'task_${DateTime.now().millisecondsSinceEpoch}';

    List<File> tempFiles = [];
    List<String> uploadedFileNames = [];
    const int maxMbSize = 50;
    const int maxFileSize = maxMbSize * 1024 * 1024;

    try {
      safePrint('开始并行批量上传音频文件到 S3...');
      safePrint('当前用户ID: $userId');
      safePrint('当前任务ID: $_currentTaskId');

      // 并行处理上传
      final results = await _processInParallel(
        items: _fileNames,
        operation: '批量上传音频文件',
        processor: (currentFileName, index) async {
          // 从 assets 加载音频文件
          final ByteData audioData = await rootBundle.load(
            'assets/$currentFileName',
          );
          final Uint8List audioBytes = audioData.buffer.asUint8List();
          safePrint('音频文件大小: ${audioBytes.length} bytes');

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
          tempFiles.add(tempFile);

          // 生成唯一的文件名
          final fileName = 'test_audio_${timestamp}_$index.mp3';

          // 使用新的S3路径结构: private/{userId}/tasks/{taskId}/audio/{filename}
          final s3Path = S3PathHelper.getAudioPath(
            userId,
            _currentTaskId,
            fileName,
          );
          safePrint('上传路径: $s3Path');

          // 上传文件到 S3
          final uploadOperation = Amplify.Storage.uploadFile(
            localFile: AWSFile.fromPath(tempFile.path),
            path: StoragePath.fromString(s3Path),
            options: StorageUploadFileOptions(
              metadata: {
                'fileType': 'audio',
                'originalName': currentFileName,
                'uploadTime': 'auto-generated',
                'uploadMethod': 'uploadFile',
                'batchIndex': index.toString(),
                'userId': userId,
                'taskId': _currentTaskId,
              },
            ),
          );

          final uploadResult = await uploadOperation.result;
          safePrint('文件上传成功: ${uploadResult.uploadedItem.path}');

          // 保存上传的文件名（不含扩展名）
          final uploadedFileName = fileName.substring(
            0,
            fileName.lastIndexOf('.'),
          );
          return uploadedFileName;
        },
      );

      // 处理结果
      int successCount = 0;
      List<String> errors = [];

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        if (result is Map && result.containsKey('error')) {
          errors.add('${result['item']}: ${result['error']}');
        } else if (result is String) {
          uploadedFileNames.add(result);
          successCount++;
        }
      }

      // 严格成功判断：只有所有文件都上传成功才算成功
      bool isCompleteSuccess = successCount == _fileNames.length;

      // 更新上传记录（只有完全成功时才更新）
      if (isCompleteSuccess) {
        _uploadedFileNames = uploadedFileNames;
      }

      final additionalInfo =
          '🎯 上传详情:\n'
          '• 目标桶: nirvaappaudiostorage0e8a7-dev\n'
          '• 上传方式: uploadFile (支持大文件)\n'
          '• 并行处理: 最大并发 8 个文件\n'
          '• 用户ID: $userId\n'
          '• 任务ID: $_currentTaskId\n'
          '• S3路径格式: private/{userId}/tasks/{taskId}/audio/{filename}\n\n'
          '📋 下一步:\n'
          '• S3 事件应该已经触发 Lambda 函数\n'
          '• 检查 AWS CloudWatch 日志查看 Lambda 执行情况\n'
          '• Lambda 函数名: S3Trigger0f8e56ad-dev\n'
          '• Lambda 需要解析新的路径结构\n\n'
          '💡 优势:\n'
          '• 支持批量并行上传多个文件\n'
          '• 使用 uploadFile 支持大文件流式上传\n'
          '• 自动处理多部分上传 (>100MB)\n'
          '• 实时进度监控\n'
          '• 并行处理大幅提升速度\n'
          '• 用户隔离的路径结构\n'
          '• 任务级别的文件组织';

      final operationResult = OperationResult(
        success: isCompleteSuccess, // 严格成功判断：必须所有文件都成功
        message: '',
        successCount: successCount,
        totalCount: _fileNames.length,
        details: uploadedFileNames,
        errors: errors,
      );

      if (isCompleteSuccess) {
        // 完全成功：显示成功消息
        _updateState(
          isLoading: false,
          result: _buildSuccessMessage(
            operation: '批量音频文件上传',
            result: operationResult,
            additionalInfo: additionalInfo,
          ),
        );
      } else {
        // 有任何失败：显示失败消息
        _updateState(
          isLoading: false,
          result: _buildErrorMessage(
            operation: '批量音频文件上传',
            error: '批量上传未完全成功，存在失败文件',
            errorType: 'upload',
            statistics: {
              '总文件数': _fileNames.length,
              '成功上传': successCount,
              '失败文件': _fileNames.length - successCount,
              '成功率':
                  '${(successCount / _fileNames.length * 100).toStringAsFixed(1)}%',
            },
          ),
        );
      }
    } catch (e) {
      safePrint('批量文件上传失败: $e');
      _updateState(
        isLoading: false,
        result: _buildErrorMessage(
          operation: '批量音频文件上传',
          error: e.toString(),
          errorType: 'upload',
          statistics: {
            '总文件数': _fileNames.length,
            '成功上传': uploadedFileNames.length,
            '失败文件': _fileNames.length - uploadedFileNames.length,
          },
        ),
      );
      Logger().e('批量文件上传失败: $e');
    } finally {
      await _cleanupTempFiles(tempFiles);
    }
  }

  // 功能4：批量获取转录结果
  Future<void> _getTranscriptionResult() async {
    if (_uploadedFileNames.isEmpty) {
      _updateState(
        isLoading: false,
        result:
            '❌ 获取转录结果失败!\n\n'
            '错误信息: 没有找到上传的音频文件记录\n\n'
            '💡 解决方案:\n'
            '请先上传音频文件，然后再获取转录结果',
      );
      return;
    }

    _updateState(isLoading: true, result: '正在并行批量获取转录结果...');
    final String userId = AppRuntimeContext().data.user.id;

    try {
      safePrint('开始并行批量获取转录结果...');

      // 并行获取所有转录结果
      final results = await _processInParallel(
        items: _uploadedFileNames,
        operation: '批量获取转录结果',
        processor: (uploadedFileName, index) async {
          // 根据上传的文件名构造转录结果文件路径
          final transcriptFileName = '$uploadedFileName.json';
          final transcriptPath = S3PathHelper.getTranscriptPath(
            userId,
            _currentTaskId,
            transcriptFileName,
          );

          safePrint('查找转录结果文件: $transcriptPath');

          // 从 S3 下载转录结果文件
          final downloadResult =
              await Amplify.Storage.downloadData(
                path: StoragePath.fromString(transcriptPath),
              ).result;

          safePrint('转录结果下载成功，文件大小: ${downloadResult.bytes.length} bytes');

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

          return {
            'fileName': uploadedFileName,
            'transcriptText': transcriptText,
            'fileSize': (downloadResult.bytes.length / 1024).toStringAsFixed(2),
            'fullData': transcriptionData,
          };
        },
      );

      // 处理所有结果
      List<Map<String, dynamic>> allResults = [];
      List<String> errors = [];
      int successCount = 0;

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        if (result is Map && result.containsKey('error')) {
          errors.add('${result['item']}: ${result['error']}');
          allResults.add({
            'fileName': result['item'],
            'transcriptText': '获取失败: ${result['error']}',
            'fileSize': 'N/A',
            'error': true,
          });
        } else if (result is Map<String, dynamic>) {
          allResults.add(result);
          successCount++;
        }
      }

      // 严格成功判断：只有所有转录结果都获取成功才算成功
      bool isCompleteSuccess = successCount == _uploadedFileNames.length;

      // 在所有文件获取完成后，统一进行文本合并（只有完全成功时才合并）
      String mergedTranscriptText = '';
      String savedFilePath = '';

      if (isCompleteSuccess) {
        // 提取并合并所有成功的转录文本
        List<String> transcriptTexts = [];
        for (var resultData in allResults) {
          if (resultData['error'] != true && resultData['fullData'] != null) {
            final fullData = resultData['fullData'] as Map<String, dynamic>;
            if (fullData.containsKey('results') &&
                fullData['results'] != null &&
                fullData['results']['transcripts'] != null) {
              final transcripts = fullData['results']['transcripts'] as List;
              for (var transcript in transcripts) {
                if (transcript['transcript'] != null) {
                  transcriptTexts.add(transcript['transcript'].toString());
                }
              }
            }
          }
        }

        mergedTranscriptText = transcriptTexts.join('\n\n');

        // 将合并的文本写入Documents目录（iOS Files App可见）
        try {
          // 使用Documents目录而不是临时目录，使文件在iOS Files App中可见
          final appDocDir = await getApplicationDocumentsDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final file = File(
            '${appDocDir.path}/merged_transcripts_$timestamp.txt',
          );
          await file.writeAsString(mergedTranscriptText, encoding: utf8);
          savedFilePath = file.path;
          safePrint('合并转录文本已保存到Documents目录: $savedFilePath');
          safePrint('提示: 在iOS中，此文件可通过Files App访问（如果已启用文件共享）');
        } catch (e) {
          safePrint('保存合并转录文本失败: $e');
        }
      }

      // 构建详细结果显示
      final operationResult = OperationResult(
        success: isCompleteSuccess, // 严格成功判断：必须所有文件都成功
        message: '',
        successCount: successCount,
        totalCount: _uploadedFileNames.length,
        details:
            allResults
                .where((r) => r['error'] != true)
                .map((r) => '${r['fileName']}: ${r['transcriptText']}')
                .toList(),
        errors: errors,
      );

      if (isCompleteSuccess) {
        // 完全成功：显示成功消息和完整结果
        final buffer = StringBuffer();
        buffer.write(
          _buildSuccessMessage(
            operation: '批量转录结果获取',
            result: operationResult,
            additionalInfo:
                '🚀 并行处理优势:\n• 同时获取多个文件，大幅提升速度\n• 最大并发: 8 个文件\n• 所有文件获取完成后统一合并文本\n• 使用新的路径结构: private/{userId}/tasks/{taskId}/transcripts/\n\n',
          ),
        );

        buffer.write('🎯 转录结果汇总:\n');
        for (int i = 0; i < allResults.length; i++) {
          final resultData = allResults[i];
          buffer.write('\n--- 文件 ${i + 1}: ${resultData['fileName']} ---\n');
          buffer.write('📄 文件大小: ${resultData['fileSize']} KB\n');
          buffer.write('📝 转录文本: 「${resultData['transcriptText']}」\n');
        }

        buffer.write('\n📝 合并转录文本:\n');
        buffer.write('「$mergedTranscriptText」\n\n');

        if (savedFilePath.isNotEmpty) {
          buffer.write('💾 文本文件已保存:\n');
          buffer.write('• 路径: $savedFilePath\n');
          buffer.write('• 文件大小: ${mergedTranscriptText.length} 字符\n\n');
        }

        buffer.write('💡 详细信息:\n');
        buffer.write('• 可在开发者日志中查看完整 JSON 结果\n');
        buffer.write(
          '• S3 路径格式: private/{userId}/tasks/{taskId}/transcripts/[文件名].json\n',
        );
        buffer.write('• 合并文本已保存到设备临时目录\n');
        buffer.write('• 并行处理显著提升获取速度\n');

        _updateState(isLoading: false, result: buffer.toString());
      } else {
        // 有任何失败：显示失败消息和部分结果
        final buffer = StringBuffer();
        buffer.write(
          _buildErrorMessage(
            operation: '批量转录结果获取',
            error: '转录结果获取未完全成功，存在失败文件',
            statistics: {
              '总文件数': _uploadedFileNames.length,
              '成功获取': successCount,
              '失败文件': _uploadedFileNames.length - successCount,
              '成功率':
                  '${(successCount / _uploadedFileNames.length * 100).toStringAsFixed(1)}%',
            },
          ),
        );

        // 即使失败也显示部分结果供参考
        if (successCount > 0) {
          buffer.write('\n📋 部分成功的转录结果 (仅供参考):\n');
          for (int i = 0; i < allResults.length; i++) {
            final resultData = allResults[i];
            buffer.write('\n--- 文件 ${i + 1}: ${resultData['fileName']} ---\n');

            if (resultData['error'] == true) {
              buffer.write('❌ ${resultData['transcriptText']}\n');
            } else {
              buffer.write('✅ 文件大小: ${resultData['fileSize']} KB\n');
              buffer.write('📝 转录文本: 「${resultData['transcriptText']}」\n');
            }
          }

          buffer.write('\n⚠️ 注意: 由于存在失败文件，未生成合并文本文件\n');
          buffer.write('💡 建议: 请重新上传音频文件或等待转录任务完成后重试\n');
        }

        _updateState(isLoading: false, result: buffer.toString());
      }
    } catch (e) {
      safePrint('批量获取转录结果失败: $e');
      _updateState(
        isLoading: false,
        result: _buildErrorMessage(
          operation: '批量获取转录结果',
          error: e.toString(),
          statistics: {'总文件数': _uploadedFileNames.length},
        ),
      );
      Logger().e('批量获取转录结果失败: $e');
    }
  }

  // 功能5：批量删除上传的音频文件和转录结果
  // ignore: unused_element
  Future<void> _deleteUploadedFiles() async {
    if (_uploadedFileNames.isEmpty) {
      _updateState(
        isLoading: false,
        result:
            '❌ 删除文件失败!\n\n'
            '错误信息: 没有找到上传的音频文件记录\n\n'
            '💡 解决方案:\n'
            '请先上传音频文件后再尝试删除',
      );
      return;
    }

    _updateState(isLoading: true, result: '正在并行批量删除文件...');

    final String userId = AppRuntimeContext().data.user.id;

    try {
      safePrint('开始并行批量删除上传的文件...');

      // 并行删除所有文件组（每个文件组包含音频文件和转录结果）
      final results = await _processInParallel(
        items: _uploadedFileNames,
        operation: '批量删除文件',
        processor: (uploadedFileName, index) async {
          // 构造文件路径
          final audioFileName = '$uploadedFileName.mp3';
          final transcriptFileName = '$uploadedFileName.json';
          final audioPath = S3PathHelper.getAudioPath(
            userId,
            _currentTaskId,
            audioFileName,
          );
          final transcriptPath = S3PathHelper.getTranscriptPath(
            userId,
            _currentTaskId,
            transcriptFileName,
          );

          safePrint('准备删除音频文件: $audioPath');
          safePrint('准备删除转录结果文件: $transcriptPath');

          List<String> deletedFiles = [];
          List<String> deleteErrors = [];

          // 同时删除音频文件和转录结果文件
          final deleteFutures = [
            // 删除音频文件
            Amplify.Storage.remove(path: StoragePath.fromString(audioPath))
                .result
                .then((_) {
                  deletedFiles.add('音频文件: $audioPath');
                  safePrint('音频文件删除成功: $audioPath');
                })
                .catchError((e) {
                  safePrint('删除音频文件失败: $e');
                  if (e.toString().contains('NoSuchKey') ||
                      e.toString().contains('not found')) {
                    deleteErrors.add('音频文件不存在: $audioPath');
                  } else {
                    deleteErrors.add('删除音频文件失败: $audioPath - ${e.toString()}');
                  }
                }),

            // 删除转录结果文件
            Amplify.Storage.remove(path: StoragePath.fromString(transcriptPath))
                .result
                .then((_) {
                  deletedFiles.add('转录结果: $transcriptPath');
                  safePrint('转录结果文件删除成功: $transcriptPath');
                })
                .catchError((e) {
                  safePrint('删除转录结果文件失败: $e');
                  if (e.toString().contains('NoSuchKey') ||
                      e.toString().contains('not found')) {
                    deleteErrors.add('转录结果文件不存在: $transcriptPath');
                  } else {
                    deleteErrors.add(
                      '删除转录结果文件失败: $transcriptPath - ${e.toString()}',
                    );
                  }
                }),
          ];

          // 等待两个删除操作完成
          await Future.wait(deleteFutures);

          return {
            'fileName': uploadedFileName,
            'deletedCount': deletedFiles.length,
            'deletedFiles': deletedFiles,
            'errors': deleteErrors,
          };
        },
      );

      // 处理所有结果
      List<String> allDeletedFiles = [];
      List<String> allErrors = [];
      int totalDeleted = 0;

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        if (result is Map && result.containsKey('error')) {
          allErrors.add('处理文件失败: ${result['item']} - ${result['error']}');
        } else if (result is Map<String, dynamic>) {
          final deletedFiles = result['deletedFiles'] as List<String>;
          final errors = result['errors'] as List<String>;
          final deletedCount = result['deletedCount'] as int;

          allDeletedFiles.addAll(deletedFiles);
          allErrors.addAll(errors);
          totalDeleted += deletedCount;
        }
      }

      // 构建结果信息
      String resultMessage;

      if (totalDeleted > 0) {
        final additionalInfo =
            allDeletedFiles.isNotEmpty
                ? '🗑️ 已删除文件:\n${allDeletedFiles.map((file) => '• $file').join('\n')}\n\n'
                : '';

        final errorInfo =
            allErrors.isNotEmpty
                ? '⚠️ 错误信息:\n${allErrors.map((error) => '• $error').join('\n')}\n\n'
                : '';

        final parallelInfo =
            '🚀 并行处理优势:\n'
            '• 同时删除多个文件组，大幅提升速度\n'
            '• 最大并发: 8 个文件组\n'
            '• 每个文件组的音频和转录文件同时删除\n'
            '• 使用新的路径结构进行精确删除\n\n';

        resultMessage = _buildSuccessMessage(
          operation: '批量文件删除',
          result: OperationResult(
            success: true,
            message: '',
            successCount: totalDeleted,
            totalCount: _uploadedFileNames.length * 2,
            details:
                results
                    .where((r) => r is Map && r['deletedCount'] > 0)
                    .map((r) => '${r['fileName']}: ${r['deletedCount']} 个文件')
                    .toList(),
            errors: allErrors,
          ),
          additionalInfo: '$parallelInfo$additionalInfo$errorInfo',
        );

        // 清空当前会话记录
        _uploadedFileNames.clear();
      } else {
        resultMessage = _buildErrorMessage(
          operation: '批量删除文件',
          error: '所有文件删除都失败了',
          errorType: 'deletion',
          statistics: {
            '预期删除': '${_uploadedFileNames.length * 2} 个文件',
            '成功删除': '0 个文件',
            '错误': '${allErrors.length} 个',
          },
        );

        if (allErrors.isNotEmpty) {
          resultMessage +=
              '\n\n❌ 错误列表:\n${allErrors.map((error) => '• $error').join('\n')}';
        }
      }

      _updateState(isLoading: false, result: resultMessage);
    } catch (e) {
      safePrint('批量删除文件操作失败: $e');
      _updateState(
        isLoading: false,
        result: _buildErrorMessage(
          operation: '批量删除文件操作',
          error: e.toString(),
          errorType: 'deletion',
          statistics: {'AWS 服务': '可能异常'},
        ),
      );
      Logger().e('批量删除文件失败: $e');
    }
  }

  // 功能6：删除整个任务文件夹（包含所有音频和转录文件）
  Future<void> _deleteTaskFolder() async {
    if (_currentTaskId.isEmpty) {
      _updateState(
        isLoading: false,
        result:
            '❌ 删除任务文件夹失败!\n\n'
            '错误信息: 没有找到当前任务ID\n\n'
            '💡 解决方案:\n'
            '请先上传音频文件生成任务后再尝试删除',
      );
      return;
    }

    _updateState(isLoading: true, result: '正在删除整个任务文件夹...');
    final String userId = AppRuntimeContext().data.user.id;

    try {
      safePrint('开始删除整个任务文件夹...');
      safePrint('当前用户ID: $userId');
      safePrint('当前任务ID: $_currentTaskId');

      // 构造任务文件夹的路径前缀
      // 删除 private/{userId}/tasks/{taskId}/ 下的所有内容
      final taskFolderPrefix = 'private/$userId/tasks/$_currentTaskId/';
      safePrint('任务文件夹前缀: $taskFolderPrefix');

      // 首先列出所有匹配前缀的文件
      final listResult =
          await Amplify.Storage.list(
            path: StoragePath.fromString(taskFolderPrefix),
            options: StorageListOptions(
              pageSize: 1000, // 一次最多获取1000个文件
              pluginOptions: S3ListPluginOptions(
                excludeSubPaths: false, // 包含子路径中的文件
              ),
            ),
          ).result;

      final itemsToDelete = listResult.items;
      safePrint('找到 ${itemsToDelete.length} 个文件需要删除');

      if (itemsToDelete.isEmpty) {
        _updateState(
          isLoading: false,
          result:
              '⚠️ 任务文件夹为空或不存在!\n\n'
              '📂 任务文件夹路径: $taskFolderPrefix\n\n'
              '💡 可能原因:\n'
              '• 任务文件夹已被删除\n'
              '• 还没有上传过文件\n'
              '• 转录任务尚未生成结果文件',
        );
        return;
      }

      // 并行删除所有文件
      List<String> deletedFiles = [];
      List<String> deleteErrors = [];
      int successCount = 0;

      // 分批并行删除文件
      final maxConcurrency = 10; // 删除操作可以设置更高的并发数
      for (int i = 0; i < itemsToDelete.length; i += maxConcurrency) {
        final batch = itemsToDelete.skip(i).take(maxConcurrency).toList();

        // 更新进度
        _updateState(
          isLoading: true,
          result: _buildProgressMessage(
            operation: '删除任务文件夹',
            current: i + 1,
            total: itemsToDelete.length,
            additionalInfo:
                '• 任务文件夹: $taskFolderPrefix\n'
                '• 并行删除中 (最大并发: $maxConcurrency)\n'
                '• 当前批次: ${batch.length} 个文件',
          ),
        );

        // 创建删除任务
        final deleteFutures =
            batch.map((item) async {
              final filePath = item.path;
              try {
                await Amplify.Storage.remove(
                  path: StoragePath.fromString(filePath),
                ).result;

                deletedFiles.add(filePath);
                safePrint('文件删除成功: $filePath');
                return {'success': true, 'path': filePath};
              } catch (e) {
                final errorMsg = '删除失败: $filePath - ${e.toString()}';
                deleteErrors.add(errorMsg);
                safePrint('文件删除失败: $errorMsg');
                return {
                  'success': false,
                  'path': filePath,
                  'error': e.toString(),
                };
              }
            }).toList();

        // 等待当前批次完成
        final batchResults = await Future.wait(deleteFutures);
        successCount += batchResults.where((r) => r['success'] == true).length;
      }

      // 构建结果信息
      final operationResult = OperationResult(
        success: successCount > 0,
        message: '',
        successCount: successCount,
        totalCount: itemsToDelete.length,
        details: deletedFiles.take(10).toList(), // 只显示前10个删除的文件
        errors: deleteErrors.take(10).toList(), // 只显示前10个错误
      );

      final additionalInfo =
          '🗂️ 任务文件夹删除详情:\n'
          '• 任务文件夹: $taskFolderPrefix\n'
          '• 用户ID: $userId\n'
          '• 任务ID: $_currentTaskId\n'
          '• 并行处理: 最大并发 $maxConcurrency 个文件\n\n'
          '🚀 优势:\n'
          '• 一次性删除整个任务的所有相关文件\n'
          '• 包括音频文件和转录结果\n'
          '• 高效的批量并行删除\n'
          '• 自动清理任务文件夹结构\n\n'
          '📋 注意事项:\n'
          '• 此操作会删除任务下的所有文件\n'
          '• 包括 audio/ 和 transcripts/ 目录下的所有内容\n'
          '• 删除后无法恢复，请谨慎操作\n\n';

      if (successCount == itemsToDelete.length) {
        // 全部删除成功，清空当前会话记录
        _uploadedFileNames.clear();

        _updateState(
          isLoading: false,
          result: _buildSuccessMessage(
            operation: '任务文件夹删除',
            result: operationResult,
            additionalInfo:
                '$additionalInfo✅ 所有文件删除成功！\n• 任务文件夹已完全清空\n• 会话记录已重置\n',
          ),
        );
      } else if (successCount > 0) {
        _updateState(
          isLoading: false,
          result: _buildSuccessMessage(
            operation: '任务文件夹删除',
            result: operationResult,
            additionalInfo:
                '$additionalInfo⚠️ 部分文件删除失败！\n• 请检查失败的文件是否仍然存在\n• 可以重试删除操作\n${deleteErrors.length > 10 ? "• 更多错误信息请查看日志\n" : ""}${deletedFiles.length > 10 ? "• 更多删除详情请查看日志\n" : ""}',
          ),
        );
      } else {
        _updateState(
          isLoading: false,
          result: _buildErrorMessage(
            operation: '任务文件夹删除',
            error: '所有文件删除都失败了',
            errorType: 'deletion',
            statistics: {
              '总文件数': itemsToDelete.length,
              '成功删除': 0,
              '失败文件': itemsToDelete.length,
            },
          ),
        );
      }
    } catch (e) {
      safePrint('删除任务文件夹操作失败: $e');
      _updateState(
        isLoading: false,
        result: _buildErrorMessage(
          operation: '删除任务文件夹操作',
          error: e.toString(),
          errorType: 'deletion',
          statistics: {'任务ID': _currentTaskId, '用户ID': userId},
        ),
      );
      Logger().e('删除任务文件夹失败: $e');
    }
  }

  // UI辅助方法：创建测试按钮
  Widget _buildTestButton({
    required String label,
    required String loadingLabel,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback? onPressed,
    String? loadingKeyword,
  }) {
    final isCurrentlyLoading =
        _isLoading &&
        (loadingKeyword == null || _apiResult.contains(loadingKeyword));

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon:
          isCurrentlyLoading
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : Icon(icon),
      label: Text(isCurrentlyLoading ? loadingLabel : label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语音转文字测试'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 测试按钮区域
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "用户ID: 1eaade33-f351-461a-8f73-59a11cba04f9",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "任务ID: $_currentTaskId",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    _buildTestButton(
                      label: 'API Gateway测试',
                      loadingLabel: '测试中...',
                      icon: Icons.health_and_safety,
                      backgroundColor: Colors.green.shade600,
                      onPressed: _testAPIGateway,
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      label: '批量上传音频到S3 (用户隔离路径)',
                      loadingLabel: '批量上传中...',
                      icon: Icons.upload_file,
                      backgroundColor: Colors.orange.shade600,
                      onPressed: _testFileUploadAndTranscribe,
                      loadingKeyword: '上传',
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      label: '批量获取转录结果',
                      loadingLabel: '批量获取中...',
                      icon: Icons.download,
                      backgroundColor: Colors.purple.shade600,
                      onPressed: _getTranscriptionResult,
                      loadingKeyword: '获取转录结果',
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      label: '删除整个任务文件夹',
                      loadingLabel: '删除中...',
                      icon: Icons.folder_off,
                      backgroundColor: Colors.redAccent.shade700,
                      onPressed: _deleteTaskFolder,
                      loadingKeyword: '删除任务文件夹',
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 结果显示区域
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '结果:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _apiResult,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

*/
