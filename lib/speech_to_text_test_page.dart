import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

import 'package:logger/logger.dart';

class SpeechToTextTestPage extends StatefulWidget {
  const SpeechToTextTestPage({super.key});

  @override
  State<SpeechToTextTestPage> createState() => _SpeechToTextTestPageState();
}

class _SpeechToTextTestPageState extends State<SpeechToTextTestPage> {
  String _apiResult = '点击测试按钮开始语音转文字测试...';
  bool _isLoading = false;
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

  // 功能3：上传音频到S3->事件触发Lambda->启动Transcribe任务
  Future<void> _testFileUploadAndTranscribe() async {
    debugPrint('_testFileUploadAndTranscribe...');
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
                      onPressed: _testFileUploadAndTranscribe,
                      icon: const Icon(Icons.upload_file),
                      label: Text('上传音频到S3->事件触发Lambda->启动Transcribe任务'),
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
