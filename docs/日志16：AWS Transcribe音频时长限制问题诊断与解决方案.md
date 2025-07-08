# 日志16：AWS Transcribe音频时长限制问题诊断与解决方案

## 问题背景

在测试语音转文字功能时，发现最近一次上传的音频文件 `test_audio_1751954765399.mp3` 无法成功转录，需要诊断转录失败的原因。

## 问题诊断过程

### 1. Lambda 函数执行状态检查

通过 AWS CLI 查看 Lambda 函数日志：

```bash
# 查找 Lambda 日志组
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/S3Trigger" --region us-east-1

# 过滤特定文件的日志事件
aws logs filter-log-events --log-group-name "/aws/lambda/S3Trigger0f8e56ad-dev" --start-time 1751954000000 --region us-east-1 --filter-pattern "test_audio_1751954765399"
```

**Lambda 执行结果分析：**
- ✅ S3 事件成功触发 Lambda 函数
- ✅ Lambda 正确识别音频文件：`test_audio_1751954765399.mp3`
- ✅ 成功启动 Transcribe 任务：`transcribe-test_audio_1751954765399-1751954866859`
- ✅ 文件大小：154,877,840 bytes (约 147.8 MB)
- ✅ 事件类型：`ObjectCreated:CompleteMultipartUpload`

### 2. Transcribe 任务状态检查

```bash
# 检查转录任务详细状态
aws transcribe get-transcription-job --transcription-job-name "transcribe-test_audio_1751954765399-1751954866859" --region us-east-1
```

**Transcribe 任务结果：**
```json
{
    "TranscriptionJob": {
        "TranscriptionJobName": "transcribe-test_audio_1751954765399-1751954866859",
        "TranscriptionJobStatus": "FAILED",
        "MediaFormat": "mp3",
        "Media": {
            "MediaFileUri": "s3://nirvaappaudiostorage0e8a7-dev/test_audio_1751954765399.mp3"
        },
        "FailureReason": "Invalid file size: file size too large. Maximum audio duration is 4.000000 hours.Check the length of the file and try your request again."
    }
}
```

### 3. 原始音频文件分析

```bash
# 检查原始音频文件详细信息
ffprobe -i assets/record_2025_04_19.mp3 -show_format -show_streams -v quiet -of json
```

**音频文件详细信息：**
```json
{
    "streams": [
        {
            "duration": "38719.404000",  // 音频时长：38,719秒
            "bit_rate": "32000",
            "sample_rate": "16000",
            "channels": 1
        }
    ],
    "format": {
        "duration": "38719.404000",      // 约 10.75 小时
        "size": "154877840",             // 文件大小：147.8 MB
        "bit_rate": "32000"
    }
}
```

## 问题根本原因

**🚨 核心问题：音频时长超出 AWS Transcribe 限制**

- **实际音频时长**：38,719.404 秒 ≈ **10.75 小时**
- **AWS Transcribe 限制**：**最大 4 小时**
- **超出时长**：约 6.75 小时

虽然文件大小（147.8 MB）在合理范围内，但**音频时长是 AWS Transcribe 的关键限制因素**。

## 错误信息分析

```
FailureReason: "Invalid file size: file size too large. Maximum audio duration is 4.000000 hours.Check the length of the file and try your request again."
```

注意：错误信息中提到 "file size too large"，但实际指的是**音频时长过长**，而非文件大小过大。这是 AWS 错误信息的一个容易误导的地方。

## 解决方案

### 1. 立即解决方案
- 使用时长在 4 小时以内的测试音频文件
- 可以使用现有的 `poem_audio.mp3` 或 `record_test_audio.mp3` 进行测试

### 2. 长期解决方案

#### 方案A：音频分割处理
```bash
# 使用 ffmpeg 将长音频分割成 4 小时以内的片段
ffmpeg -i input.mp3 -t 14400 -c copy output_part1.mp3  # 前4小时
ffmpeg -i input.mp3 -ss 14400 -t 14400 -c copy output_part2.mp3  # 第二个4小时
```

#### 方案B：Lambda 函数增强
在 Lambda 函数中添加音频时长检查：
```javascript
// 检查音频时长（需要集成音频分析库）
const audioDuration = await getAudioDuration(mediaUri);
if (audioDuration > 4 * 60 * 60) { // 4小时
    console.log(`Audio too long: ${audioDuration}s, splitting required`);
    // 触发音频分割处理
}
```

#### 方案C：Flutter 端预处理
在上传前检查音频时长：
```dart
// 添加音频时长检查
const maxDurationSeconds = 4 * 60 * 60; // 4小时限制
if (audioDurationSeconds > maxDurationSeconds) {
    setState(() {
        _apiResult = '❌ 音频文件时长超过限制!\n\n'
            '• 当前时长: ${(audioDurationSeconds / 3600).toStringAsFixed(2)} 小时\n'
            '• 最大允许: 4.0 小时\n'
            '• 建议: 请使用较短的音频文件或分割处理';
    });
    return;
}
```

## 系统架构工作状态确认

✅ **S3 存储配置**：正常工作
✅ **Lambda 触发机制**：正常工作  
✅ **Transcribe 服务调用**：正常工作
✅ **文件上传流程**：正常工作
❌ **音频时长限制**：需要处理

## 经验总结

1. **AWS Transcribe 限制**：
   - 最大音频时长：4 小时
   - 最大文件大小：2 GB
   - 支持的格式：MP3, MP4, WAV, FLAC 等

2. **错误信息理解**：
   - "file size too large" 可能指文件大小或音频时长
   - 需要结合具体数值判断真实原因

3. **调试策略**：
   - 优先检查 Lambda 执行日志
   - 再检查 Transcribe 任务状态
   - 最后分析原始音频文件属性

4. **预防措施**：
   - 在客户端添加音频时长检查
   - 在 Lambda 函数中添加预验证
   - 提供清晰的错误提示信息

## 相关文件

- **Lambda 函数**：`/amplify/backend/function/S3Trigger0f8e56ad/src/index.js`
- **Flutter 测试页面**：`/lib/speech_to_text_test_page.dart`
- **测试音频文件**：`/assets/record_2025_04_19.mp3`
- **CloudWatch 日志组**：`/aws/lambda/S3Trigger0f8e56ad-dev`

## 下一步行动

1. 创建或使用较短的测试音频文件（< 4小时）
2. 在 Flutter 代码中添加音频时长预检查
3. 考虑实现音频分割功能支持长音频处理
4. 更新错误处理机制，提供更准确的错误提示

---

**调试日期**：2025年7月8日  
**问题状态**：已诊断，解决方案明确  
**影响范围**：仅影响超过4小时的音频文件转录
