# 日志：使用aws-amplify实现音频转写方案确认

## 音频转写功能的工作流程概述

使用 AWS Amplify 构建的音频转写功能主要包含两个关键流程：**音频上传流程**和**结果查询流程**。整体设计采用简化的 Serverless 架构，依托于 AWS S3、Lambda 和 Transcribe 服务。

### 完整工作流程图

```text
音频上传与转写:
客户端 → Amplify Storage → S3 → Lambda 触发 → AWS Transcribe → 结果存储到 S3

结果查询:
客户端 → API Gateway → Lambda → 从 S3 获取结果 → 返回转写文本
```

## 音频上传流程详解

### 关键特性：客户端直接上传到 S3

在 AWS Amplify 架构中，客户端可以**直接上传文件到 S3**，无需通过 API Gateway 中转，这是因为：

1. **Amplify Storage 的设计原理**：
   - Amplify Storage 是对 S3 的高级封装
   - 使用预签名 URL (Pre-signed URL) 机制实现直接上传
   - 授权由 Cognito/IAM 在后台自动处理

2. **具体上传流程**：

   ```text
   客户端 → 请求上传授权 → 获取临时凭证 → 直接上传到 S3 → 触发 Lambda
   ```

3. **技术实现细节**：
   - 客户端使用 Amplify Storage API 发起上传
   - Amplify 库在后台自动获取临时上传凭证
   - 文件直接从客户端设备传输到 S3，不经过任何中间服务器
   - 上传完成后，S3 自动触发配置好的 Lambda 函数

### 客户端上传代码示例

```dart
Future<String> uploadAudio(File audioFile) async {
  // 生成唯一的文件路径，包含用户ID以确保隔离
  final key = 'audio/${userID}/${DateTime.now().millisecondsSinceEpoch}.wav';
  
  // 使用 Amplify Storage API 上传
  final result = await Amplify.Storage.uploadFile(
    localFile: AWSFile.fromPath(audioFile.path),
    key: key,
    options: StorageUploadFileOptions(
      accessLevel: StorageAccessLevel.private,
    )
  );
  
  print('音频文件上传完成: ${result.key}');
  return result.key;  // 返回 S3 中的文件键，作为后续查询的凭证
}
```

## Lambda 转写处理流程

### Lambda 函数的两个主要职责

Lambda 函数在转写过程中有两个关键角色：

1. **启动转写任务**：由 S3 上传事件触发
2. **查询转写结果**：由 API Gateway 请求触发

### 启动转写任务的 Lambda 实现

```javascript
// Lambda 函数示例 (Node.js)
exports.handler = async (event) => {
  // 1. 从 S3 事件中提取信息
  const bucket = event.Records[0].s3.bucket.name;
  const key = decodeURIComponent(event.Records[0].s3.object.key);
  
  // 2. 提取用户ID (假设文件路径格式为: audio/{userID}/filename.wav)
  const pathParts = key.split('/');
  const userID = pathParts.length >= 2 ? pathParts[1] : 'unknown';
  
  // 3. 生成唯一的任务名称
  const jobName = `job-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
  
  // 4. 配置转写任务参数
  const params = {
    TranscriptionJobName: jobName,
    LanguageCode: 'zh-CN',  // 设置语言
    Media: {
      MediaFileUri: `s3://${bucket}/${key}`  // 音频文件位置
    },
    OutputBucketName: bucket,
    OutputKey: `transcriptions/${userID}/${jobName}.json`  // 结果存储位置
  };
  
  // 5. 启动转写任务
  try {
    const transcribeService = new AWS.TranscribeService();
    await transcribeService.startTranscriptionJob(params).promise();
    
    // 6. 在 S3 中存储任务映射信息，用于后续查询
    // 创建一个映射文件，将原始音频文件路径与转写任务ID关联
    const mapping = {
      audioKey: key,
      jobName: jobName,
      status: 'IN_PROGRESS',
      createdAt: new Date().toISOString()
    };
    
    await s3.putObject({
      Bucket: bucket,
      Key: `transcriptions/mappings/${userID}/${key.split('/').pop()}.json`,
      Body: JSON.stringify(mapping),
      ContentType: 'application/json'
    }).promise();
    
    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, jobName })
    };
  } catch (error) {
    console.error('启动转写任务失败:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: error.message })
    };
  }
};
```

## 结果查询流程

### 使用 API Gateway 查询转写状态和结果

查询转写状态和获取结果时需要使用 API Gateway 作为入口点：

1. **为什么需要 API Gateway**：
   - 提供统一的 HTTP 接口供客户端调用
   - 处理认证和授权
   - 支持请求验证和转换

2. **查询流程**：

   ```text
   客户端 → API Gateway → Lambda → 从 S3 读取结果 → 返回转写文本
   ```

### 查询 Lambda 函数实现

```javascript
exports.handler = async (event) => {
  // 1. 从查询参数中获取信息
  const queryParams = event.queryStringParameters || {};
  const audioKey = queryParams.audioKey;
  const userID = queryParams.userID;
  
  if (!audioKey || !userID) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "必须提供 audioKey 和 userID" })
    };
  }
  
  try {
    // 2. 查找映射文件，获取任务信息
    const audioFileName = audioKey.split('/').pop();
    const mappingKey = `transcriptions/mappings/${userID}/${audioFileName}.json`;
    
    const mappingObject = await s3.getObject({
      Bucket: process.env.BUCKET_NAME,
      Key: mappingKey
    }).promise();
    
    const mapping = JSON.parse(mappingObject.Body.toString());
    const jobName = mapping.jobName;
    
    // 3. 检查转写任务状态
    const transcribeService = new AWS.TranscribeService();
    const jobInfo = await transcribeService.getTranscriptionJob({
      TranscriptionJobName: jobName
    }).promise();
    
    const status = jobInfo.TranscriptionJob.TranscriptionJobStatus;
    
    // 4. 如果完成，获取并返回结果
    if (status === 'COMPLETED') {
      // 从 S3 中读取转写结果
      const resultKey = `transcriptions/${userID}/${jobName}.json`;
      const resultObject = await s3.getObject({
        Bucket: process.env.BUCKET_NAME,
        Key: resultKey
      }).promise();
      
      const transcribeResult = JSON.parse(resultObject.Body.toString());
      
      // 提取纯文本内容
      const transcript = transcribeResult.results.transcripts[0].transcript;
      
      return {
        statusCode: 200,
        body: JSON.stringify({
          status: 'COMPLETED',
          transcript: transcript
        })
      };
    } else {
      // 5. 如果未完成，返回当前状态
      return {
        statusCode: 200,
        body: JSON.stringify({
          status: status,
          jobName: jobName
        })
      };
    }
  } catch (error) {
    console.error('查询转写状态失败:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

### 客户端查询实现

```dart
Future<TranscriptionResult?> checkTranscription(String audioKey) async {
  try {
    // 通过 API Gateway 调用查询 Lambda
    final restOperation = Amplify.API.get(
      '/transcriptions/status',
      queryParameters: {
        'audioKey': audioKey,
        'userID': currentUserID
      }
    );
    
    final response = await restOperation.response;
    final data = response.decodeBody();
    
    if (data['status'] == 'COMPLETED') {
      return TranscriptionResult(
        text: data['transcript'],
        audioKey: audioKey
      );
    } else {
      // 未完成，返回 null
      return null;
    }
  } catch (e) {
    print('查询转写失败: $e');
    return null;
  }
}
```

## 唯一标识符与查询凭证

客户端需要一个标识符来查询转写结果。本设计使用**原始音频文件的 S3 路径**作为主要查询凭证：

1. **查询凭证组成**：
   - 音频文件在 S3 中的完整路径/键（key）
   - 包含用户 ID 前缀以确保隔离和安全

2. **查询路径**：

   ```text
   客户端存储音频 S3 路径 → 查询时提供此路径 → Lambda 查找对应映射 → 定位转写结果
   ```

3. **映射文件存储位置**：

   ```text
   s3://[bucket-name]/transcriptions/mappings/[userID]/[original-filename].json
   ```

4. **转写结果存储位置**：

   ```text
   s3://[bucket-name]/transcriptions/[userID]/[job-name].json
   ```

## 简化流程的完整数据流转图

```text
1. 音频上传阶段:
   客户端 → 上传音频到 S3 → S3 事件触发 Lambda → 启动 Transcribe 任务
   
2. 转写处理阶段:
   Transcribe 处理音频 → 结果自动存储到 S3 → 完成
   
3. 客户端查询阶段:
   客户端 → API Gateway → Lambda → 检索 S3 中的结果 → 返回转写文本
```

## 架构优势总结

1. **简单高效**：
   - 完全无服务器架构，按需付费
   - 不需要管理服务器或数据库
   - 利用 S3 作为统一存储，简化架构

2. **客户端简化**：
   - 上传直接对接 S3，高效可靠
   - 使用统一的 API 查询结果
   - 无需复杂的状态管理

3. **扩展性**：
   - 可轻松支持更多文件格式和语言
   - 可随业务增长无缝扩展
   - 为后续功能添加预留了架构空间

4. **成本控制**：
   - 仅在处理文件时产生费用
   - 避免了持续运行服务器的成本
   - S3 存储成本低于数据库选项

这种设计充分利用了 AWS 服务的优势，实现了简单高效的音频转写功能，特别适合项目初期使用。
