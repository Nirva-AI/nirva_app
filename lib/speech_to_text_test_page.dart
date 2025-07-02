import 'package:flutter/material.dart';

class SpeechToTextTestPage extends StatefulWidget {
  const SpeechToTextTestPage({super.key});

  @override
  State<SpeechToTextTestPage> createState() => _SpeechToTextTestPageState();
}

class _SpeechToTextTestPageState extends State<SpeechToTextTestPage> {
  @override
  void initState() {
    super.initState();
  }

  // 功能1：API健康检查
  Future<void> _testAPIHealth() async {
    debugPrint('开始API健康检查...');
  }

  // 功能2：验证后测试音频
  Future<void> _validateAndTestTranscribe() async {
    debugPrint('开始验证音频文件...');
  }

  // 功能3：测试文件上传
  Future<void> _testFileUpload() async {
    debugPrint('开始测试文件上传...');
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

                    // API健康检查按钮
                    ElevatedButton.icon(
                      onPressed: _testAPIHealth,
                      icon: const Icon(Icons.health_and_safety),
                      label: Text('API健康检查'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 验证后测试音频按钮
                    ElevatedButton.icon(
                      onPressed: _validateAndTestTranscribe,
                      icon: const Icon(Icons.verified),
                      label: Text('验证音频并测试转录'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 文件上传测试按钮
                    ElevatedButton.icon(
                      onPressed: _testFileUpload,
                      icon: const Icon(Icons.upload_file),
                      label: Text('测试文件上传'),
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
                              '点击测试按钮开始语音转文字测试...',
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
