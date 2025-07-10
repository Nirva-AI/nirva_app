import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

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

  //支持多个音频文件测试。
  //record_test_audio，录制的音频，拿手机录制B站的声音，然后再用ffmpeg做数据处理，策略见日志13。
  //poem_audio，mac say 命令生成的音频。
  final List<String> _fileNames = [
    'record_test_audio.mp3',
    'record_test_audio.mp3',
  ];
  static const String _uuid =
      "1eaade33-f351-461a-8f73-59a11cba04f9"; // 生成一个唯一的UUID

  @override
  void initState() {
    super.initState();
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

  // 公共方法：处理文件操作的通用逻辑
  Future<OperationResult> _processFiles<T>({
    required List<String> items,
    required String operation,
    required Future<T> Function(String item, int index) processor,
    required String Function(T result, String item) resultExtractor,
  }) async {
    final details = <String>[];
    final errors = <String>[];
    int successCount = 0;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      try {
        _updateState(
          isLoading: true,
          result: _buildProgressMessage(
            operation: operation,
            current: i + 1,
            total: items.length,
            currentItem: item,
          ),
        );

        final result = await processor(item, i);
        final detail = resultExtractor(result, item);
        details.add(detail);
        successCount++;
      } catch (e) {
        safePrint('$operation失败: $item - $e');
        errors.add('$item: ${e.toString()}');
      }
    }

    return OperationResult(
      success: successCount > 0,
      message: '',
      successCount: successCount,
      totalCount: items.length,
      details: details,
      errors: errors,
    );
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

    List<File> tempFiles = [];
    List<String> uploadedFileNames = [];
    const int maxMbSize = 50;
    const int maxFileSize = maxMbSize * 1024 * 1024;

    try {
      safePrint('开始批量上传音频文件到 S3...');

      final result = await _processFiles<String>(
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

          // 更新进度显示
          _updateState(
            isLoading: true,
            result: _buildProgressMessage(
              operation: '批量上传音频文件',
              current: index + 1,
              total: _fileNames.length,
              currentItem: currentFileName,
              additionalInfo:
                  '• 目标文件名: $fileName\n• 文件大小: ${(audioBytes.length / 1024).toStringAsFixed(2)} KB\n\n⏳ 上传中...',
            ),
          );

          // 上传文件到 S3
          final uploadOperation = Amplify.Storage.uploadFile(
            localFile: AWSFile.fromPath(tempFile.path),
            path: StoragePath.fromString(fileName),
            options: StorageUploadFileOptions(
              metadata: {
                'fileType': 'audio',
                'originalName': currentFileName,
                'uploadTime': 'auto-generated',
                'uploadMethod': 'uploadFile',
                'batchIndex': index.toString(),
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
          uploadedFileNames.add(uploadedFileName);

          return uploadedFileName;
        },
        resultExtractor:
            (uploadedFileName, currentFileName) => uploadedFileName,
      );

      // 更新上传记录
      _uploadedFileNames = uploadedFileNames;

      final additionalInfo =
          '🎯 上传详情:\n'
          '• 目标桶: nirvaappaudiostorage0e8a7-dev\n'
          '• 上传方式: uploadFile (支持大文件)\n\n'
          '📋 下一步:\n'
          '• S3 事件应该已经触发 Lambda 函数\n'
          '• 检查 AWS CloudWatch 日志查看 Lambda 执行情况\n'
          '• Lambda 函数名: S3Trigger0f8e56ad-dev\n\n'
          '💡 优势:\n'
          '• 支持批量上传多个文件\n'
          '• 使用 uploadFile 支持大文件流式上传\n'
          '• 自动处理多部分上传 (>100MB)\n'
          '• 实时进度监控';

      _updateState(
        isLoading: false,
        result: _buildSuccessMessage(
          operation: '批量音频文件上传',
          result: result,
          additionalInfo: additionalInfo,
        ),
      );
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

    _updateState(isLoading: true, result: '正在批量获取转录结果...');

    try {
      safePrint('开始批量获取转录结果...');
      List<Map<String, dynamic>> allResults = [];

      final result = await _processFiles<Map<String, dynamic>>(
        items: _uploadedFileNames,
        operation: '批量获取转录结果',
        processor: (uploadedFileName, index) async {
          // 根据上传的文件名构造转录结果文件路径
          final transcriptFileName = '$uploadedFileName.json';
          final transcriptPath = 'transcripts/$transcriptFileName';

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
        resultExtractor: (resultData, uploadedFileName) {
          allResults.add(resultData);
          return '${resultData['fileName']}: ${resultData['transcriptText']}';
        },
      );

      // 合并所有转录文本并写入文件
      String mergedTranscriptText = '';
      String savedFilePath = '';

      if (result.successCount > 0) {
        // 提取并合并所有成功的转录文本
        List<String> transcriptTexts = [];
        for (var resultData in allResults) {
          if (resultData['fullData'] != null) {
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

        // 将合并的文本写入临时目录
        try {
          final tempDir = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final file = File(
            '${tempDir.path}/merged_transcripts_$timestamp.txt',
          );
          await file.writeAsString(mergedTranscriptText, encoding: utf8);
          savedFilePath = file.path;
          safePrint('合并转录文本已保存到: $savedFilePath');
        } catch (e) {
          safePrint('保存合并转录文本失败: $e');
        }
      }

      // 构建详细结果显示
      final buffer = StringBuffer();
      buffer.write(_buildSuccessMessage(operation: '批量转录结果获取', result: result));

      buffer.write('🎯 转录结果汇总:\n');
      for (int i = 0; i < allResults.length; i++) {
        final resultData = allResults[i];
        buffer.write('\n--- 文件 ${i + 1}: ${resultData['fileName']} ---\n');
        buffer.write('📄 文件大小: ${resultData['fileSize']} KB\n');
        buffer.write('📝 转录文本: 「${resultData['transcriptText']}」\n');
      }

      if (result.successCount > 0) {
        buffer.write('\n📝 合并转录文本:\n');
        buffer.write('「$mergedTranscriptText」\n\n');

        if (savedFilePath.isNotEmpty) {
          buffer.write('💾 文本文件已保存:\n');
          buffer.write('• 路径: $savedFilePath\n');
          buffer.write('• 文件大小: ${mergedTranscriptText.length} 字符\n\n');
        }

        buffer.write('💡 详细信息:\n');
        buffer.write('• 可在开发者日志中查看完整 JSON 结果\n');
        buffer.write('• S3 路径格式: transcripts/[文件名].json\n');
        buffer.write('• 合并文本已保存到设备临时目录\n');
      }

      _updateState(isLoading: false, result: buffer.toString());
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

    _updateState(isLoading: true, result: '正在批量删除文件...');

    try {
      safePrint('开始批量删除上传的文件...');
      List<String> deletedFiles = [];
      List<String> errors = [];

      final result = await _processFiles<int>(
        items: _uploadedFileNames,
        operation: '批量删除文件',
        processor: (uploadedFileName, index) async {
          int deletedCount = 0;

          // 构造文件路径
          final audioFileName = '$uploadedFileName.mp3';
          final transcriptFileName = '$uploadedFileName.json';
          final transcriptPath = 'transcripts/$transcriptFileName';

          safePrint('准备删除音频文件: $audioFileName');
          safePrint('准备删除转录结果文件: $transcriptPath');

          // 更新进度显示
          _updateState(
            isLoading: true,
            result: _buildProgressMessage(
              operation: '批量删除文件',
              current: (index * 2) + 1,
              total: _uploadedFileNames.length * 2,
              currentItem: '$uploadedFileName (音频文件)',
            ),
          );

          // 删除音频文件
          try {
            await Amplify.Storage.remove(
              path: StoragePath.fromString(audioFileName),
            ).result;
            deletedCount++;
            deletedFiles.add('音频文件: $audioFileName');
            safePrint('音频文件删除成功: $audioFileName');
          } catch (e) {
            safePrint('删除音频文件失败: $e');
            if (e.toString().contains('NoSuchKey') ||
                e.toString().contains('not found')) {
              errors.add('音频文件不存在: $audioFileName');
            } else {
              errors.add('删除音频文件失败: $audioFileName - ${e.toString()}');
            }
          }

          // 更新进度显示
          _updateState(
            isLoading: true,
            result: _buildProgressMessage(
              operation: '批量删除文件',
              current: (index * 2) + 2,
              total: _uploadedFileNames.length * 2,
              currentItem: '$uploadedFileName (转录结果)',
            ),
          );

          // 删除转录结果文件
          try {
            await Amplify.Storage.remove(
              path: StoragePath.fromString(transcriptPath),
            ).result;
            deletedCount++;
            deletedFiles.add('转录结果: $transcriptPath');
            safePrint('转录结果文件删除成功: $transcriptPath');
          } catch (e) {
            safePrint('删除转录结果文件失败: $e');
            if (e.toString().contains('NoSuchKey') ||
                e.toString().contains('not found')) {
              errors.add('转录结果文件不存在: $transcriptPath');
            } else {
              errors.add('删除转录结果文件失败: $transcriptPath - ${e.toString()}');
            }
          }

          return deletedCount;
        },
        resultExtractor:
            (deletedCount, uploadedFileName) =>
                '$uploadedFileName: $deletedCount 个文件',
      );

      // 构建结果信息
      String resultMessage;
      final totalDeleted = result.details
          .map((detail) => int.parse(detail.split(': ')[1].split(' ')[0]))
          .reduce((a, b) => a + b);

      if (totalDeleted > 0) {
        final additionalInfo =
            deletedFiles.isNotEmpty
                ? '🗑️ 已删除文件:\n${deletedFiles.map((file) => '• $file').join('\n')}\n\n'
                : '';

        final errorInfo =
            errors.isNotEmpty
                ? '⚠️ 错误信息:\n${errors.map((error) => '• $error').join('\n')}\n\n'
                : '';

        resultMessage = _buildSuccessMessage(
          operation: '批量文件删除',
          result: OperationResult(
            success: true,
            message: '',
            successCount: totalDeleted,
            totalCount: _uploadedFileNames.length * 2,
            details: result.details,
            errors: errors,
          ),
          additionalInfo: '$additionalInfo $errorInfo',
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
            '错误': '${errors.length} 个',
          },
        );

        if (errors.isNotEmpty) {
          resultMessage +=
              '\n\n❌ 错误列表:\n${errors.map((error) => '• $error').join('\n')}';
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
                      _uuid,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
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
                      label: '批量上传音频到S3 (uploadFile支持大文件)',
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
                      label: '批量删除上传的文件',
                      loadingLabel: '批量删除中...',
                      icon: Icons.delete,
                      backgroundColor: Colors.red.shade600,
                      onPressed: _deleteUploadedFiles,
                      loadingKeyword: '删除',
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
                              style: TextStyle(
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
