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

  //下面的2个换名字测试。
  //record_test_audio
  //poem_audio
  final String _fileName = 'poem_audio.mp3';

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

  // 功能3：上传音频到S3->事件触发Lambda->启动Transcribe任务->输出的转录结果JSON再次存入S3
  Future<void> _testFileUploadAndTranscribe() async {
    setState(() {
      _isLoading = true;
      _apiResult = '正在准备音频文件...';
    });

    File? tempFile;
    try {
      safePrint('开始上传音频文件到 S3...');

      // 从 assets 加载音频文件
      final ByteData audioData = await rootBundle.load('assets/$_fileName');
      final Uint8List audioBytes = audioData.buffer.asUint8List();

      safePrint('音频文件大小: ${audioBytes.length} bytes');

      // 创建临时文件
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      tempFile = File('${tempDir.path}/test_audio_$timestamp.mp3');
      await tempFile.writeAsBytes(audioBytes);

      safePrint('临时文件创建成功: ${tempFile.path}');

      // 生成唯一的文件名
      final fileName = 'test_audio_$timestamp.mp3';

      setState(() {
        _apiResult =
            '正在上传音频文件到 S3...\n\n'
            '📁 文件信息:\n'
            '• 文件名: $fileName\n'
            '• 文件大小: ${(audioBytes.length / 1024).toStringAsFixed(2)} KB\n'
            '• 目标桶: nirvaappaudiostorage0e8a7-dev\n'
            '• 上传方式: uploadFile (支持大文件)\n\n'
            '⏳ 上传进行中...';
      });

      // 上传文件到 S3 (使用 uploadFile 支持大文件)
      // 后续优化需要添加 uploadOperation.progress.listen()
      final uploadOperation = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(tempFile.path),
        path: StoragePath.fromString(fileName),
        options: StorageUploadFileOptions(
          metadata: {
            'fileType': 'audio',
            'originalName': _fileName,
            'uploadTime': 'auto-generated',
            'uploadMethod': 'uploadFile',
          },
        ),
      );

      // 等待上传完成
      final uploadResult = await uploadOperation.result;

      safePrint('文件上传成功: ${uploadResult.uploadedItem.path}');

      setState(() {
        _apiResult =
            '✅ 音频文件上传成功!\n\n'
            '📁 文件信息:\n'
            '• 文件名: $fileName\n'
            '• 文件大小: ${(audioBytes.length / 1024).toStringAsFixed(2)} KB\n'
            '• S3 路径: ${uploadResult.uploadedItem.path}\n'
            '• 目标桶: nirvaappaudiostorage0e8a7-dev\n'
            '• 上传方式: uploadFile (支持大文件)\n\n'
            '🎯 上传结果:\n'
            '• 状态: 成功\n'
            '• ETag: ${uploadResult.uploadedItem.eTag ?? "N/A"}\n\n'
            '📋 下一步:\n'
            '• S3 事件应该已经触发 Lambda 函数\n'
            '• 检查 AWS CloudWatch 日志查看 Lambda 执行情况\n'
            '• Lambda 函数名: S3Trigger0f8e56ad-dev\n\n'
            '💡 优势:\n'
            '• 使用 uploadFile 支持大文件流式上传\n'
            '• 自动处理多部分上传 (>100MB)\n'
            '• 实时进度监控';
      });
    } catch (e) {
      safePrint('文件上传失败: $e');
      setState(() {
        _apiResult =
            '❌ 音频文件上传失败!\n\n'
            '错误信息: ${e.toString()}\n\n'
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
        Logger().e('文件上传失败: $e');
      });
    } finally {
      // 清理临时文件
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
          safePrint('临时文件已清理: ${tempFile.path}');
        } catch (e) {
          safePrint('清理临时文件失败: $e');
        }
      }

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
                      '语音转文字测试',
                      style: TextStyle(
                        fontSize: 18,
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
                            ? '上传中...'
                            : '上传音频到S3 (uploadFile支持大文件)',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
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