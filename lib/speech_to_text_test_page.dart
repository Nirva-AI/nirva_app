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

  // 功能1：API Gateway测试
  Future<void> _testAPIGateway() async {
    setState(() {
      _isLoading = true;
      _apiResult = '正在调用 API Gateway...';
    });

    try {
      safePrint('开始调用 Amplify API...');

      // 检查认证状态
      try {
        final session = await Amplify.Auth.fetchAuthSession();
        safePrint('Auth session: ${session.isSignedIn}');

        if (!session.isSignedIn) {
          safePrint('用户未登录，将使用未认证凭证调用API...');
          // 对于未认证用户，Amplify 会自动尝试获取临时凭证
        } else {
          safePrint('用户已登录，将使用认证凭证调用API...');
        }
      } catch (e) {
        safePrint('获取认证状态失败: $e');
        // 即使获取认证状态失败，也继续尝试调用API
      }

      // 使用 Amplify API 调用 REST 端点
      final restOperation = Amplify.API.get(
        '/echo',
        apiName: 'echoapi', // 这是在 amplifyconfiguration.dart 中定义的 API 名称
        queryParameters: {'message': 'Hello'},
      );

      final response = await restOperation.response;

      safePrint('API 调用成功，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        // 解析响应体
        final responseBody = response.decodeBody();
        safePrint('响应内容: $responseBody');

        // 美化 JSON 显示
        final Map<String, dynamic> jsonData = jsonDecode(responseBody);
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(jsonData);

        setState(() {
          _apiResult =
              '✅ API 调用成功!\n\n📡 请求信息:\n'
              '• API: echoapi\n'
              '• 路径: /echo\n'
              '• 参数: message=Hello\n'
              '• 状态码: ${response.statusCode}\n\n'
              '📄 响应内容:\n$prettyJson';
        });
      } else {
        setState(() {
          _apiResult =
              '❌ API 调用失败!\n\n'
              '状态码: ${response.statusCode}\n'
              '响应: ${response.decodeBody()}';
        });
      }
    } catch (e) {
      safePrint('API 调用出错: $e');
      setState(() {
        _apiResult =
            '❌ API 调用出错!\n\n'
            '错误信息: ${e.toString()}\n\n'
            '🔍 可能的原因:\n'
            '1. Cognito Identity Pool 不允许未认证访问\n'
            '2. 需要用户登录后才能调用 API\n'
            '3. Identity Pool 权限配置问题\n'
            '4. API Gateway 权限配置问题\n\n'
            '💡 建议解决方案:\n'
            '1. 在 AWS Console 中启用 Identity Pool 的未认证访问\n'
            '2. 或者实现用户登录功能\n'
            '3. 检查 IAM 角色权限';
        Logger().e('API 调用失败: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 功能3：批量上传音频到S3->事件触发Lambda->启动Transcribe任务->输出的转录结果JSON再次存入S3
  Future<void> _testFileUploadAndTranscribe() async {
    setState(() {
      _isLoading = true;
      _apiResult = '正在准备批量上传音频文件...';
    });

    List<File> tempFiles = [];
    List<String> uploadedFileNames = [];
    int successCount = 0;
    int totalFiles = _fileNames.length;

    try {
      safePrint('开始批量上传音频文件到 S3...');

      setState(() {
        _apiResult =
            '正在批量上传音频文件...\n\n'
            '📊 上传统计:\n'
            '• 总文件数: $totalFiles\n'
            '• 进度: 0/$totalFiles\n\n'
            '⏳ 准备中...';
      });

      // 遍历所有文件名进行上传
      for (int i = 0; i < _fileNames.length; i++) {
        final currentFileName = _fileNames[i];
        File? tempFile;

        try {
          safePrint('开始处理文件 ${i + 1}/$totalFiles: $currentFileName');

          setState(() {
            _apiResult =
                '正在批量上传音频文件...\n\n'
                '📊 上传统计:\n'
                '• 总文件数: $totalFiles\n'
                '• 进度: ${i + 1}/$totalFiles\n'
                '• 当前文件: $currentFileName\n\n'
                '⏳ 处理中...';
          });

          // 从 assets 加载音频文件
          final ByteData audioData = await rootBundle.load(
            'assets/$currentFileName',
          );
          final Uint8List audioBytes = audioData.buffer.asUint8List();

          safePrint('音频文件大小: ${audioBytes.length} bytes');

          // 检查文件大小限制
          const int maxMbSize = 50;
          const int maxFileSize = maxMbSize * 1024 * 1024;
          if (audioBytes.length > maxFileSize) {
            final fileSizeMB = (audioBytes.length / (1024 * 1024))
                .toStringAsFixed(2);
            safePrint('文件 $currentFileName 大小超过限制: $fileSizeMB MB');
            continue; // 跳过这个文件，继续处理下一个
          }

          // 创建临时文件
          final tempDir = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          tempFile = File('${tempDir.path}/test_audio_${timestamp}_$i.mp3');
          await tempFile.writeAsBytes(audioBytes);
          tempFiles.add(tempFile);

          safePrint('临时文件创建成功: ${tempFile.path}');

          // 生成唯一的文件名
          final fileName = 'test_audio_${timestamp}_$i.mp3';

          setState(() {
            _apiResult =
                '正在批量上传音频文件...\n\n'
                '📊 上传统计:\n'
                '• 总文件数: $totalFiles\n'
                '• 进度: ${i + 1}/$totalFiles\n'
                '• 当前文件: $currentFileName\n'
                '• 目标文件名: $fileName\n'
                '• 文件大小: ${(audioBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
                '⏳ 上传中...';
          });

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
                'batchIndex': i.toString(),
              },
            ),
          );

          // 等待上传完成
          final uploadResult = await uploadOperation.result;

          safePrint('文件上传成功: ${uploadResult.uploadedItem.path}');

          // 保存上传的文件名（不含扩展名）
          final uploadedFileName = fileName.substring(
            0,
            fileName.lastIndexOf('.'),
          );
          uploadedFileNames.add(uploadedFileName);
          successCount++;
        } catch (e) {
          safePrint('文件 $currentFileName 上传失败: $e');
          // 继续处理下一个文件
        }
      }

      // 更新上传记录
      _uploadedFileNames = uploadedFileNames;

      setState(() {
        _apiResult =
            '✅ 批量音频文件上传完成!\n\n'
            '📊 上传统计:\n'
            '• 总文件数: $totalFiles\n'
            '• 成功上传: $successCount\n'
            '• 失败文件: ${totalFiles - successCount}\n\n'
            '📁 成功上传的文件:\n'
            '${uploadedFileNames.map((name) => '• $name').join('\n')}\n\n'
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
      });
    } catch (e) {
      safePrint('批量文件上传失败: $e');
      setState(() {
        _apiResult =
            '❌ 批量音频文件上传失败!\n\n'
            '错误信息: ${e.toString()}\n\n'
            '📊 上传统计:\n'
            '• 总文件数: $totalFiles\n'
            '• 成功上传: $successCount\n'
            '• 失败文件: ${totalFiles - successCount}\n\n'
            '🔍 可能的原因:\n'
            '1. S3 存储桶权限问题\n'
            '2. Cognito Identity Pool 权限不足\n'
            '3. 网络连接问题\n'
            '4. 文件格式或大小限制\n'
            '5. 临时文件创建失败\n\n'
            '💡 建议解决方案:\n'
            '1. 检查 S3 存储桶策略\n'
            '2. 确认 Identity Pool 角色权限\n'
            '3. 检查网络连接\n'
            '4. 确认设备存储空间充足';
        Logger().e('批量文件上传失败: $e');
      });
    } finally {
      // 清理所有临时文件
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

      setState(() {
        _isLoading = false;
      });
    }
  }

  // 功能4：批量获取转录结果
  Future<void> _getTranscriptionResult() async {
    if (_uploadedFileNames.isEmpty) {
      setState(() {
        _apiResult =
            '❌ 获取转录结果失败!\n\n'
            '错误信息: 没有找到上传的音频文件记录\n\n'
            '💡 解决方案:\n'
            '请先上传音频文件，然后再获取转录结果';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _apiResult = '正在批量获取转录结果...';
    });

    try {
      safePrint('开始批量获取转录结果...');

      int totalFiles = _uploadedFileNames.length;
      int successCount = 0;
      List<Map<String, dynamic>> allResults = [];

      setState(() {
        _apiResult =
            '正在批量获取转录结果...\n\n'
            '📊 获取统计:\n'
            '• 总文件数: $totalFiles\n'
            '• 进度: 0/$totalFiles\n\n'
            '⏳ 处理中...';
      });

      // 遍历所有上传的文件获取转录结果
      for (int i = 0; i < _uploadedFileNames.length; i++) {
        final uploadedFileName = _uploadedFileNames[i];

        try {
          safePrint('获取转录结果 ${i + 1}/$totalFiles: $uploadedFileName');

          setState(() {
            _apiResult =
                '正在批量获取转录结果...\n\n'
                '📊 获取统计:\n'
                '• 总文件数: $totalFiles\n'
                '• 进度: ${i + 1}/$totalFiles\n'
                '• 当前文件: $uploadedFileName\n\n'
                '⏳ 下载中...';
          });

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

          // 添加到结果列表
          allResults.add({
            'fileName': uploadedFileName,
            'transcriptText': transcriptText,
            'fileSize': (downloadResult.bytes.length / 1024).toStringAsFixed(2),
            'fullData': transcriptionData,
          });

          successCount++;
        } catch (e) {
          safePrint('获取转录结果失败: $uploadedFileName - $e');
          // 添加错误记录
          allResults.add({
            'fileName': uploadedFileName,
            'transcriptText': '获取失败: ${e.toString()}',
            'fileSize': 'N/A',
            'error': true,
          });
        }
      }

      // 合并所有转录文本并写入文件
      String mergedTranscriptText = '';
      String savedFilePath = '';

      if (successCount > 0) {
        // 提取并合并所有成功的转录文本
        List<String> transcriptTexts = [];
        for (var result in allResults) {
          if (result['error'] != true && result['fullData'] != null) {
            final fullData = result['fullData'] as Map<String, dynamic>;
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

        // 合并所有转录文本
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

      // 构建最终结果显示
      String resultMessage = '✅ 批量转录结果获取完成!\n\n';
      resultMessage += '📊 获取统计:\n';
      resultMessage += '• 总文件数: $totalFiles\n';
      resultMessage += '• 成功获取: $successCount\n';
      resultMessage += '• 失败文件: ${totalFiles - successCount}\n\n';

      resultMessage += '🎯 转录结果汇总:\n';
      for (int i = 0; i < allResults.length; i++) {
        final result = allResults[i];
        resultMessage += '\n--- 文件 ${i + 1}: ${result['fileName']} ---\n';

        if (result['error'] == true) {
          resultMessage += '❌ ${result['transcriptText']}\n';
        } else {
          resultMessage += '📄 文件大小: ${result['fileSize']} KB\n';
          resultMessage += '📝 转录文本: 「${result['transcriptText']}」\n';
        }
      }

      if (successCount > 0) {
        resultMessage += '\n📝 合并转录文本:\n';
        resultMessage += '「$mergedTranscriptText」\n\n';

        if (savedFilePath.isNotEmpty) {
          resultMessage += '💾 文本文件已保存:\n';
          resultMessage += '• 路径: $savedFilePath\n';
          resultMessage += '• 文件大小: ${mergedTranscriptText.length} 字符\n\n';
        }

        resultMessage += '💡 详细信息:\n';
        resultMessage += '• 可在开发者日志中查看完整 JSON 结果\n';
        resultMessage += '• S3 路径格式: transcripts/[文件名].json\n';
        resultMessage += '• 合并文本已保存到设备临时目录\n';
      }

      setState(() {
        _apiResult = resultMessage;
      });
    } catch (e) {
      safePrint('批量获取转录结果失败: $e');

      String errorMessage =
          '❌ 批量获取转录结果失败!\n\n'
          '错误信息: ${e.toString()}\n\n';

      // 根据错误类型提供不同的建议
      if (e.toString().contains('NoSuchKey') ||
          e.toString().contains('not found')) {
        errorMessage +=
            '🔍 可能的原因:\n'
            '1. 转录任务尚未完成\n'
            '2. 转录任务失败\n'
            '3. 文件路径不正确\n\n'
            '💡 建议解决方案:\n'
            '1. 等待几分钟后重试（转录需要时间）\n'
            '2. 检查 AWS CloudWatch 日志确认 Lambda 执行状态\n'
            '3. 确认 S3 中是否存在转录结果文件';
      } else if (e.toString().contains('AccessDenied')) {
        errorMessage +=
            '🔍 可能的原因:\n'
            '1. S3 存储桶权限问题\n'
            '2. Cognito Identity Pool 权限不足\n\n'
            '💡 建议解决方案:\n'
            '1. 检查 S3 存储桶策略\n'
            '2. 确认 Identity Pool 角色权限';
      } else {
        errorMessage +=
            '🔍 可能的原因:\n'
            '1. 网络连接问题\n'
            '2. 转录结果文件格式异常\n'
            '3. JSON 解析失败\n\n'
            '💡 建议解决方案:\n'
            '1. 检查网络连接\n'
            '2. 重新上传音频文件\n'
            '3. 检查转录结果文件格式';
      }

      setState(() {
        _apiResult = errorMessage;
      });

      Logger().e('批量获取转录结果失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 功能5：批量删除上传的音频文件和转录结果
  Future<void> _deleteUploadedFiles() async {
    if (_uploadedFileNames.isEmpty) {
      setState(() {
        _apiResult =
            '❌ 删除文件失败!\n\n'
            '错误信息: 没有找到上传的音频文件记录\n\n'
            '💡 解决方案:\n'
            '请先上传音频文件后再尝试删除';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _apiResult = '正在批量删除文件...';
    });

    try {
      safePrint('开始批量删除上传的文件...');

      int totalFiles = _uploadedFileNames.length;
      int deletedCount = 0;
      List<String> deletedFiles = [];
      List<String> errors = [];

      setState(() {
        _apiResult =
            '正在批量删除文件...\n\n'
            '📊 删除统计:\n'
            '• 总文件数: ${totalFiles * 2} (音频+转录)\n'
            '• 进度: 0/${totalFiles * 2}\n\n'
            '⏳ 处理中...';
      });

      // 遍历所有上传的文件进行删除
      for (int i = 0; i < _uploadedFileNames.length; i++) {
        final uploadedFileName = _uploadedFileNames[i];

        try {
          safePrint('删除文件 ${i + 1}/$totalFiles: $uploadedFileName');

          setState(() {
            _apiResult =
                '正在批量删除文件...\n\n'
                '📊 删除统计:\n'
                '• 总文件数: ${totalFiles * 2} (音频+转录)\n'
                '• 进度: ${(i * 2) + 1}/${totalFiles * 2}\n'
                '• 当前文件: $uploadedFileName\n\n'
                '⏳ 删除中...';
          });

          // 构造文件路径
          final audioFileName = '$uploadedFileName.mp3';
          final transcriptFileName = '$uploadedFileName.json';
          final transcriptPath = 'transcripts/$transcriptFileName';

          safePrint('准备删除音频文件: $audioFileName');
          safePrint('准备删除转录结果文件: $transcriptPath');

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

          setState(() {
            _apiResult =
                '正在批量删除文件...\n\n'
                '📊 删除统计:\n'
                '• 总文件数: ${totalFiles * 2} (音频+转录)\n'
                '• 进度: ${(i * 2) + 2}/${totalFiles * 2}\n'
                '• 当前文件: $uploadedFileName (转录结果)\n\n'
                '⏳ 删除中...';
          });

          // 删除转录结果文件（如果存在）
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
        } catch (e) {
          safePrint('处理文件 $uploadedFileName 时出错: $e');
          errors.add('处理文件失败: $uploadedFileName - ${e.toString()}');
        }
      }

      // 构建结果信息
      String resultMessage;

      if (deletedCount > 0) {
        resultMessage = '✅ 批量文件删除完成!\n\n';
        resultMessage += '📊 删除统计:\n';
        resultMessage += '• 预期删除: ${totalFiles * 2} 个文件\n';
        resultMessage += '• 成功删除: $deletedCount 个文件\n';
        resultMessage += '• 错误: ${errors.length} 个\n\n';

        if (deletedFiles.isNotEmpty) {
          resultMessage += '🗑️ 已删除文件:\n';
          for (String file in deletedFiles) {
            resultMessage += '• $file\n';
          }
          resultMessage += '\n';
        }

        if (errors.isNotEmpty) {
          resultMessage += '⚠️ 错误信息:\n';
          for (String error in errors) {
            resultMessage += '• $error\n';
          }
        }

        // 清空当前会话记录
        _uploadedFileNames.clear();
      } else {
        resultMessage =
            '❌ 批量删除文件失败!\n\n'
            '所有文件删除都失败了\n\n';

        if (errors.isNotEmpty) {
          resultMessage += '❌ 错误列表:\n';
          for (String error in errors) {
            resultMessage += '• $error\n';
          }
          resultMessage += '\n';
        }

        resultMessage +=
            '🔍 可能的原因:\n'
            '1. 文件已被手动删除\n'
            '2. S3 存储桶权限问题\n'
            '3. Cognito Identity Pool 权限不足\n'
            '4. 网络连接问题\n\n'
            '💡 建议解决方案:\n'
            '1. 检查 S3 存储桶中文件是否存在\n'
            '2. 确认删除权限配置\n'
            '3. 检查网络连接';
      }

      setState(() {
        _apiResult = resultMessage;
      });
    } catch (e) {
      safePrint('批量删除文件操作失败: $e');
      setState(() {
        _apiResult =
            '❌ 批量删除文件操作失败!\n\n'
            '错误信息: ${e.toString()}\n\n'
            '🔍 可能的原因:\n'
            '1. S3 存储桶权限问题\n'
            '2. Cognito Identity Pool 权限不足\n'
            '3. 网络连接问题\n'
            '4. AWS 服务异常\n\n'
            '💡 建议解决方案:\n'
            '1. 检查 S3 存储桶删除权限\n'
            '2. 确认 Identity Pool 角色权限\n'
            '3. 检查网络连接\n'
            '4. 稍后重试';
        Logger().e('批量删除文件失败: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

                    // API Gateway测试按钮
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _testAPIGateway,
                      icon:
                          _isLoading
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.health_and_safety),
                      label: Text(_isLoading ? '测试中...' : 'API Gateway测试'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 文件上传测试按钮
                    ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : _testFileUploadAndTranscribe,
                      icon:
                          _isLoading && _apiResult.contains('上传')
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.upload_file),
                      label: Text(
                        _isLoading && _apiResult.contains('上传')
                            ? '批量上传中...'
                            : '批量上传音频到S3 (uploadFile支持大文件)',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 获取转录结果按钮
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _getTranscriptionResult,
                      icon:
                          _isLoading && _apiResult.contains('获取转录结果')
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.download),
                      label: Text(
                        _isLoading && _apiResult.contains('获取转录结果')
                            ? '批量获取中...'
                            : '批量获取转录结果',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 删除文件按钮
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _deleteUploadedFiles,
                      icon:
                          _isLoading && _apiResult.contains('删除')
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.delete),
                      label: Text(
                        _isLoading && _apiResult.contains('删除')
                            ? '批量删除中...'
                            : '批量删除上传的文件',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
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
