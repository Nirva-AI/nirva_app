# 日志11：Flutter端上传音频到S3触发Lambda的完整流程验证记录

## 背景

本次实践目标是实现并验证Flutter应用中"上传本地音频文件到S3->事件触发Lambda->启动Transcribe任务"的完整流程。这是构建语音转文字功能的第一步验证，确保各环节能够正确连接和工作。

## 已完成的工作

### 1. Flutter端音频上传功能

在`speech_to_text_test_page.dart`中实现了完整的音频上传功能：

- 从应用assets目录加载mp3格式音频文件
- 使用Amplify Storage API将音频上传到S3
- 实现了完整的UI反馈和错误处理
- 添加了必要的依赖（amplify_storage_s3）并在主程序中注册插件

关键代码片段：

```dart
// 从 assets 加载音频文件
final ByteData audioData = await rootBundle.load('assets/test_audio.mp3');
final Uint8List audioBytes = audioData.buffer.asUint8List();

// 生成唯一的文件名
final fileName = 'test_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';

// 上传文件到 S3
final uploadResult = await Amplify.Storage.uploadData(
  data: S3DataPayload.bytes(audioBytes),
  path: StoragePath.fromString(fileName),
  options: const StorageUploadDataOptions(
    metadata: {
      'fileType': 'audio',
      'originalName': 'test_audio.mp3',
      'uploadTime': 'auto-generated',
    },
  ),
).result;
```

### 2. 测试音频文件准备

使用macOS `say`命令和ffmpeg工具生成了测试用的mp3音频文件：

1. 使用`say`命令生成AIFF格式音频
2. 使用ffmpeg将AIFF转换为mp3格式
3. 将生成的mp3文件放入assets目录供应用使用

### 3. S3文件上传验证

通过AWS CLI验证了文件成功上传到S3：

```bash
aws s3 ls s3://nirvaappaudiostorage0e8a7-dev/test_audio_1751535099203.mp3
```

结果显示文件已成功上传：

```bash
2025-07-03 17:31:42     174332 test_audio_1751535099203.mp3
```

### 4. Lambda函数触发验证

通过AWS CloudWatch日志验证了S3事件成功触发Lambda函数：

```bash
aws logs tail /aws/lambda/S3Trigger0f8e56ad-dev --since 1h
```

日志显示Lambda函数已成功触发并执行：

```bash
2025-07-03T09:31:42.655Z c092c692-4509-4e6c-9613-eae604e2e5b9 INFO Received S3 event: {
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "awsRegion": "us-east-1",
      "eventTime": "2025-07-03T09:31:41.758Z",
      "eventName": "ObjectCreated:Put",
      ...
      "s3": {
        "s3SchemaVersion": "1.0",
        ...
        "bucket": {
          "name": "nirvaappaudiostorage0e8a7-dev",
          ...
        },
        "object": {
          "key": "test_audio_1751535099203.mp3",
          "size": 174332,
          ...
        }
      }
    }
  ]
}
```

### 5. 权限配置验证

验证了AWS IAM权限配置，确认Flutter应用通过Cognito Identity Pool获取临时凭证，使用未认证角色（unauthRole）访问S3资源。确保了该角色具有足够的S3访问权限。

## 当前状态

目前已完成：

- Flutter端上传音频文件到S3功能
- S3事件成功触发Lambda函数执行
- Lambda函数能够正确识别并记录上传的文件信息

Lambda函数当前实现（非常简单）：

```javascript
exports.handler = async function (event) {
  console.log('Received S3 event:', JSON.stringify(event, null, 2));
  const bucket = event.Records[0].s3.bucket.name;
  const key = event.Records[0].s3.object.key;
  console.log(`Bucket: ${bucket}`, `Key: ${key}`);
};
```

## 下一步工作

1. **完善Lambda函数**：
   - 添加启动Amazon Transcribe任务的代码
   - 为Lambda函数添加访问Amazon Transcribe的IAM权限
   - 配置Transcribe任务参数和输出位置

2. **处理转写结果**：
   - 实现监听Transcribe任务完成的机制
   - 处理和存储转写结果
   - 在Flutter应用中展示转写结果

3. **错误处理与优化**：
   - 完善错误处理机制
   - 优化用户体验
   - 考虑添加进度指示和状态查询功能

## 技术要点总结

1. **AWS服务集成**：
   - Amplify框架与Flutter应用集成
   - S3存储服务使用
   - Lambda函数触发与执行
   - Cognito Identity Pool提供临时凭证

2. **权限管理**：
   - 使用IAM角色进行权限控制
   - 配置未认证访问权限（unauthRole）

3. **事件驱动架构**：
   - S3事件触发Lambda执行
   - 后续可扩展为完整的事件驱动工作流

4. **客户端-服务器通信**：
   - 前端上传文件
   - 后端处理与转换
   - 结果存储与获取

## 参考命令

**查看S3存储桶内容**：

```bash
aws s3 ls s3://nirvaappaudiostorage0e8a7-dev/
```

**检查Lambda日志**：

```bash
aws logs tail /aws/lambda/S3Trigger0f8e56ad-dev --since 1h
```

**查看IAM角色**：

```bash
aws iam list-roles | grep -i nirva
```

**检查角色权限**：

```bash
aws iam list-attached-role-policies --role-name amplify-nirvaapp-dev-0e8a7-unauthRole
```
