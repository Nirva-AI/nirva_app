import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/transcription_task.dart';
import 'package:nirva_app/transcription_error_messages.dart';

class TestAWSAmplifyS3TranscribeApp extends StatelessWidget {
  const TestAWSAmplifyS3TranscribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS Amplify S3 Transcribe Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TestAWSAmplifyS3TranscribeTestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestAWSAmplifyS3TranscribeTestPage extends StatefulWidget {
  const TestAWSAmplifyS3TranscribeTestPage({super.key});

  @override
  State<TestAWSAmplifyS3TranscribeTestPage> createState() =>
      _TestAWSAmplifyS3TranscribeTestPageState();
}

class _TestAWSAmplifyS3TranscribeTestPageState
    extends State<TestAWSAmplifyS3TranscribeTestPage> {
  String _apiResult = '点击测试按钮开始语音转文字测试...';
  bool _isLoading = false;

  // 新增：任务管理
  UploadAndTranscribeTask? _currentTask;
  bool _canGetResults = false;
  bool _canDelete = false;

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

  // 新方法：步骤1 - 使用任务类上传文件
  Future<void> _taskStep1Upload() async {
    _updateState(isLoading: true, result: '正在创建新任务并准备文件...');

    try {
      // 创建新任务poem_audio
      _currentTask = UploadAndTranscribeTask(
        userId: context.read<UserProvider>().user.id,
        assetFileNames: ['record_test_audio.mp3'],
        pickedFileNames: [],
        // 使用默认的当前时间进行命名
      );

      // 步骤1.1：准备文件
      _updateState(isLoading: true, result: '正在准备文件...');
      final readySuccess = await _currentTask!.prepareFiles();
      if (!readySuccess) {
        // 准备文件失败，清理任务
        _currentTask = null;
        setState(() {
          _canGetResults = false;
          _canDelete = false;
        });
        _updateState(
          isLoading: false,
          result: '❌ 文件准备失败!\n\n请检查文件是否存在或文件大小是否超过限制（50MB）。',
        );
        return;
      }

      // 步骤1.2：上传文件
      _updateState(isLoading: true, result: '文件准备完成，正在上传到S3...');
      final uploadResult = await _currentTask!.uploadFiles();

      if (uploadResult.success) {
        setState(() {
          _canGetResults = true;
          _canDelete = false;
        });

        _updateState(
          isLoading: false,
          result: _buildTaskUploadSuccessMessage(uploadResult),
        );
      } else {
        // 上传失败，清理任务
        _currentTask = null;
        setState(() {
          _canGetResults = false;
          _canDelete = false;
        });

        _updateState(
          isLoading: false,
          result: _buildTaskUploadErrorMessage(uploadResult),
        );
      }
    } catch (e) {
      _currentTask = null;
      setState(() {
        _canGetResults = false;
        _canDelete = false;
      });

      _updateState(isLoading: false, result: '❌ 创建任务失败!\n\n错误信息: $e');
    }
  }

  // 新方法：步骤2 - 获取转录结果
  Future<void> _taskStep2GetResults() async {
    if (_currentTask == null) {
      _updateState(isLoading: false, result: '❌ 没有活动的任务!\n\n请先执行步骤1上传文件。');
      return;
    }

    _updateState(isLoading: true, result: '正在获取转录结果...');

    try {
      final transcriptionResult = await _currentTask!.getTranscriptionResults();

      if (transcriptionResult.success) {
        setState(() {
          _canDelete = true;
        });

        _updateState(
          isLoading: false,
          result: _buildTaskTranscriptionSuccessMessage(transcriptionResult),
        );
      } else {
        _updateState(
          isLoading: false,
          result: _buildTaskTranscriptionErrorMessage(transcriptionResult),
        );
      }
    } catch (e) {
      _updateState(isLoading: false, result: '❌ 获取转录结果失败!\n\n错误信息: $e');
    }
  }

  // 新方法：步骤3 - 删除任务文件
  Future<void> _taskStep3Delete() async {
    if (_currentTask == null) {
      _updateState(isLoading: false, result: '❌ 没有活动的任务!\n\n请先执行前面的步骤。');
      return;
    }

    _updateState(isLoading: true, result: '正在删除任务文件...');

    try {
      final deleteSuccess = await _currentTask!.deleteTaskFiles();

      // 清理任务状态
      _currentTask = null;
      setState(() {
        _canGetResults = false;
        _canDelete = false;
      });

      if (deleteSuccess) {
        _updateState(
          isLoading: false,
          result: _buildTaskDeleteSuccessMessage(),
        );
      } else {
        _updateState(isLoading: false, result: _buildTaskDeleteErrorMessage());
      }
    } catch (e) {
      _updateState(isLoading: false, result: '❌ 删除任务文件失败!\n\n错误信息: $e');
    }
  }

  // 构建任务上传成功消息
  String _buildTaskUploadSuccessMessage(UploadResult result) {
    if (_currentTask == null) {
      return '❌ 任务未初始化，请先执行步骤1上传文件。';
    }

    final buffer = StringBuffer();
    buffer.write('✅ 步骤1：文件上传完成!\n\n');
    buffer.write('📊 上传统计:\n');
    buffer.write('• 任务ID: ${result.taskId}\n');
    buffer.write('• 总文件数: ${_currentTask!.sourceFileNames.length}\n');
    buffer.write('• 成功上传: ${result.uploadedFileNames.length}\n');
    buffer.write('• 耗时: ${result.duration.inSeconds} 秒\n\n');

    buffer.write('📁 上传文件:\n');
    for (String fileName in result.uploadedFileNames) {
      buffer.write('• $fileName\n');
    }

    buffer.write('\n🎯 任务详情:\n');
    buffer.write('• 使用任务类封装业务逻辑\n');
    buffer.write('• 并行上传，最大并发8个文件\n');
    buffer.write('• 严格成功标准：全部成功才算成功\n');
    buffer.write('• 自动生成唯一文件名避免冲突\n');
    buffer.write('• S3路径: private/{userId}/tasks/{taskId}/audio/\n\n');

    buffer.write('📋 下一步:\n');
    buffer.write('• ⏳ 等待转录中...\n');
    buffer.write('• 🔄 S3事件已触发Lambda启动转录任务\n');
    buffer.write('• 📥 请手动点击"步骤2"获取转录结果\n');
    buffer.write('• 💡 建议等待30-60秒后再获取结果\n');

    return buffer.toString();
  }

  // 构建任务上传错误消息
  String _buildTaskUploadErrorMessage(UploadResult result) {
    if (_currentTask == null) {
      return '❌ 任务未初始化，请先执行步骤1上传文件。';
    }

    final buffer = StringBuffer();
    buffer.write('❌ 步骤1：文件上传失败!\n\n');
    buffer.write('📊 上传统计:\n');
    buffer.write('• 任务ID: ${result.taskId}\n');
    buffer.write('• 总文件数: ${_currentTask!.sourceFileNames.length}\n');
    buffer.write('• 成功上传: ${result.uploadedFileNames.length}\n');
    buffer.write(
      '• 失败文件: ${_currentTask!.sourceFileNames.length - result.uploadedFileNames.length}\n',
    );
    buffer.write('• 耗时: ${result.duration.inSeconds} 秒\n\n');

    if (result.errors.isNotEmpty) {
      buffer.write('❌ 错误信息:\n');
      for (String error in result.errors) {
        buffer.write('• $error\n');
      }
      buffer.write('\n');
    }

    buffer.write('💡 解决方案:\n');
    buffer.write('• 任务已自动清理，请重新创建新任务\n');
    buffer.write('• 检查网络连接和AWS权限配置\n');
    buffer.write('• 确认文件大小不超过50MB限制\n');

    return buffer.toString();
  }

  // 构建任务转录成功消息
  String _buildTaskTranscriptionSuccessMessage(TranscriptionResult result) {
    final buffer = StringBuffer();
    buffer.write('✅ 步骤2：转录结果获取完成!\n\n');
    buffer.write('📊 转录统计:\n');
    buffer.write('• 任务ID: ${result.taskId}\n');
    buffer.write('• 总文件数: ${result.transcripts.length}\n');
    buffer.write('• 成功转录: ${result.transcripts.length}\n');
    buffer.write('• 合并文本长度: ${result.mergedText.length} 字符\n');
    buffer.write('• 耗时: ${result.duration.inSeconds} 秒\n\n');

    buffer.write('🎯 转录结果:\n');
    for (int i = 0; i < result.transcripts.length; i++) {
      final transcript = result.transcripts[i];
      buffer.write('\n--- 文件 ${i + 1}: ${transcript.fileName} ---\n');
      buffer.write('📄 大小: ${transcript.fileSizeKB} KB\n');
      buffer.write('📝 内容: 「${transcript.transcriptText}」\n');
    }

    buffer.write('\n📝 合并文本:\n');
    buffer.write('「${result.mergedText}」\n\n');

    if (result.savedFilePath.isNotEmpty) {
      buffer.write('💾 文件已保存:\n');
      buffer.write('• 路径: ${result.savedFilePath}\n\n');
    }

    buffer.write('✨ 任务优势:\n');
    buffer.write('• 使用任务类封装，业务逻辑清晰\n');
    buffer.write('• 并行获取，提升处理速度\n');
    buffer.write('• 严格成功标准：全部成功才算成功\n');
    buffer.write('• 自动合并文本并保存到文件\n\n');

    buffer.write('📋 下一步:\n');
    buffer.write('• 🗑️ 可以点击"步骤3"清理任务文件\n');
    buffer.write('• 📄 转录文本已完整获取并合并\n');
    buffer.write('• 💾 可以进行后续的文本处理工作\n');

    return buffer.toString();
  }

  // 构建任务转录错误消息
  String _buildTaskTranscriptionErrorMessage(TranscriptionResult result) {
    final buffer = StringBuffer();
    buffer.write('❌ 步骤2：转录结果获取失败!\n\n');
    buffer.write('📊 转录统计:\n');
    buffer.write('• 任务ID: ${result.taskId}\n');
    buffer.write('• 成功获取: ${result.transcripts.length}\n');
    buffer.write('• 预期文件数: 通过步骤1上传的文件数\n');
    buffer.write('• 耗时: ${result.duration.inSeconds} 秒\n\n');

    if (result.errors.isNotEmpty) {
      buffer.write('❌ 错误信息:\n');
      for (String error in result.errors) {
        buffer.write('• $error\n');
      }
      buffer.write('\n');
    }

    buffer.write('💡 可能原因:\n');
    buffer.write('• 转录任务尚未完成（需要更多时间）\n');
    buffer.write('• Lambda函数执行失败\n');
    buffer.write('• 音频文件格式不支持或质量问题\n');
    buffer.write('• S3权限配置问题\n\n');

    buffer.write('🔧 建议解决方案:\n');
    buffer.write('• 等待更长时间后重试步骤2\n');
    buffer.write('• 检查AWS CloudWatch日志\n');
    buffer.write('• 确认Lambda函数是否正常执行\n');
    buffer.write('• 任务状态保持，可以继续重试\n');

    return buffer.toString();
  }

  // 构建任务删除成功消息
  String _buildTaskDeleteSuccessMessage() {
    return '✅ 步骤3：任务清理完成!\n\n'
        '🗑️ 删除操作:\n'
        '• 已删除S3中的所有任务文件\n'
        '• 包括音频文件和转录结果\n'
        '• 已清理本地临时文件\n'
        '• 任务状态已重置\n\n'
        '✨ 任务优势:\n'
        '• 一键清理所有相关文件\n'
        '• 自动管理资源生命周期\n'
        '• 避免S3存储费用累积\n\n'
        '📋 任务完成:\n'
        '• 🎉 完整的转录流程已结束\n'
        '• 🆕 可以创建新任务开始下一轮测试\n'
        '• 💾 转录文本已保存到本地文件\n';
  }

  // 构建任务删除错误消息
  String _buildTaskDeleteErrorMessage() {
    return '⚠️ 步骤3：任务清理未完全成功!\n\n'
        '🗑️ 删除状态:\n'
        '• 部分文件可能删除失败\n'
        '• 任务状态已重置\n'
        '• 本地临时文件已清理\n\n'
        '💡 说明:\n'
        '• 删除失败不影响任务完成\n'
        '• 可能是文件已被手动删除\n'
        '• 或者网络连接问题\n\n'
        '📋 后续操作:\n'
        '• 任务流程已完成\n'
        '• 可以创建新任务\n'
        '• 如需彻底清理，可手动检查S3\n';
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
    final userId = context.read<UserProvider>().user.id;
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
                    Text(
                      "用户ID: $userId",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildTestButton(
                      label: 'API Gateway测试',
                      loadingLabel: '测试中...',
                      icon: Icons.health_and_safety,
                      backgroundColor: Colors.green.shade600,
                      onPressed: _testAPIGateway,
                    ),

                    const SizedBox(height: 8),

                    // 分割线
                    const Divider(color: Colors.grey),

                    // 任务类测试区域标题
                    const Text(
                      "任务类测试 (分步执行)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 步骤1：上传文件
                    _buildTestButton(
                      label: '步骤1：上传文件并创建任务',
                      loadingLabel: '上传中...',
                      icon: Icons.upload,
                      backgroundColor: Colors.blue.shade600,
                      onPressed: _taskStep1Upload,
                      loadingKeyword: '正在创建新任务',
                    ),

                    const SizedBox(height: 8),

                    // 步骤2：获取转录结果
                    _buildTestButton(
                      label: '步骤2：获取转录结果',
                      loadingLabel: '获取中...',
                      icon: Icons.download,
                      backgroundColor:
                          _canGetResults ? Colors.green.shade600 : Colors.grey,
                      onPressed: _canGetResults ? _taskStep2GetResults : null,
                      loadingKeyword: '正在获取转录结果',
                    ),

                    const SizedBox(height: 8),

                    // 步骤3：删除任务文件
                    _buildTestButton(
                      label: '步骤3：删除任务文件',
                      loadingLabel: '删除中...',
                      icon: Icons.delete_forever,
                      backgroundColor:
                          _canDelete ? Colors.red.shade600 : Colors.grey,
                      onPressed: _canDelete ? _taskStep3Delete : null,
                      loadingKeyword: '正在删除任务文件',
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
