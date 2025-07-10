const { TranscribeClient, StartTranscriptionJobCommand } = require('@aws-sdk/client-transcribe');

// 初始化 AWS 服务
const transcribeClient = new TranscribeClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async function (event) {
  console.log('🚀 Lambda triggered - Received S3 event:', JSON.stringify(event, null, 2));
  
  try {
    // 记录接收到的事件数量
    const recordCount = event.Records ? event.Records.length : 0;
    console.log(`Received ${recordCount} S3 event record(s)`);
    
    // 记录每种事件类型的数量
    const eventTypes = {};
    event.Records?.forEach(record => {
      const eventName = record.eventName;
      eventTypes[eventName] = (eventTypes[eventName] || 0) + 1;
    });
    console.log(`Event type summary:`, eventTypes);
    
    // 首先筛选出需要处理的音频文件记录
    const validRecords = [];
    
    // 预处理：筛选有效的音频文件记录
    for (let i = 0; i < event.Records.length; i++) {
      const record = event.Records[i];
      const eventName = record.eventName;
      const bucket = record.s3.bucket.name;
      const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
      
      console.log(`Pre-processing record ${i + 1}/${recordCount}: ${eventName} for ${key}`);
      
      // 1. 检查事件类型
      if (!isFileCreationEvent(eventName)) {
        console.log(`Skipping non-creation event: ${eventName}`);
        continue;
      }
      
      // 2. 检查文件是否为音频文件
      if (!isAudioFile(key)) {
        console.log(`Skipping non-audio file: ${key}`);
        continue;
      }
      
      // 3. 解析新的S3路径结构
      const pathInfo = parseS3Path(key);
      if (!pathInfo) {
        console.log(`Skipping file with unrecognized path structure: ${key}`);
        continue;
      }
      
      console.log(`✅ File ${key} is an audio file from creation event, will process with transcription`);
      console.log(`📂 Path info:`, pathInfo);
      
      // 添加到有效记录列表
      validRecords.push({ record, bucket, key, pathInfo });
    }
    
    console.log(`Found ${validRecords.length} valid audio files to process in parallel`);
    
    // 并行处理所有有效的音频文件记录
    const transcriptionPromises = validRecords.map(async ({ record, bucket, key, pathInfo }, index) => {
      try {
        console.log(`Starting parallel transcription ${index + 1}/${validRecords.length} for ${key}`);
        const jobName = await startTranscriptionJob(bucket, key, pathInfo);
        return { success: true, jobName, key };
      } catch (error) {
        console.error(`Failed to start transcription for ${key}:`, error);
        return { success: false, error: error.message, key };
      }
    });
    
    // 等待所有转录任务启动完成 (使用 allSettled 确保即使某些失败也能继续)
    console.log(`🚀 Starting ${transcriptionPromises.length} transcription jobs in parallel...`);
    const results = await Promise.allSettled(transcriptionPromises);
    
    // 收集成功启动的任务名称和处理结果统计
    const jobNames = [];
    const failedFiles = [];
    let successCount = 0;
    
    results.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        const { success, jobName, key, error } = result.value;
        if (success && jobName) {
          jobNames.push(jobName);
          successCount++;
          console.log(`✅ Successfully started transcription job for ${key}: ${jobName}`);
        } else {
          failedFiles.push({ key, error });
          console.log(`❌ Failed to start transcription job for ${key}: ${error}`);
        }
      } else {
        const key = validRecords[index]?.key || `record-${index}`;
        failedFiles.push({ key, error: result.reason });
        console.log(`❌ Promise rejected for ${key}:`, result.reason);
      }
    });
    
    console.log(`✅ Successfully processed all ${recordCount} S3 event record(s) in parallel`);
    console.log(`✅ Started ${jobNames.length} transcription job(s): ${jobNames.join(', ')}`);
    
    if (failedFiles.length > 0) {
      console.log(`⚠️ Failed to process ${failedFiles.length} file(s):`);
      failedFiles.forEach(({ key, error }) => {
        console.log(`   - ${key}: ${error}`);
      });
    }
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Successfully processed ${recordCount} S3 event record(s) in parallel`,
        totalRecords: recordCount,
        validAudioFiles: validRecords.length,
        successfulJobs: successCount,
        failedFiles: failedFiles.length,
        jobNames: jobNames,
        parallelProcessing: true
      })
    };
    
  } catch (error) {
    console.error('Error processing S3 event:', error);
    throw error;
  }
};

// 解析S3路径结构
// 支持两种格式:
// 1. 新格式: private/{userId}/tasks/{taskId}/audio/{filename}
// 2. 旧格式: {filename} (向后兼容)
function parseS3Path(key) {
  // 检查是否为新的路径结构
  const newPathMatch = key.match(/^private\/([^\/]+)\/tasks\/([^\/]+)\/audio\/(.+)$/);
  if (newPathMatch) {
    return {
      format: 'new',
      userId: newPathMatch[1],
      taskId: newPathMatch[2],
      filename: newPathMatch[3],
      type: 'audio'
    };
  }
  
  // 检查是否为旧的路径结构 (向后兼容)
  if (!key.includes('/') || key.indexOf('/') === key.lastIndexOf('/')) {
    // 简单文件名或只有一层目录
    const filename = key.includes('/') ? key.split('/').pop() : key;
    return {
      format: 'legacy',
      userId: null,
      taskId: null,
      filename: filename,
      type: 'audio'
    };
  }
  
  // 不支持的路径格式
  return null;
}

// 检查是否为文件创建事件
function isFileCreationEvent(eventName) {
  const creationEvents = [
    'ObjectCreated:Put',
    'ObjectCreated:Post', 
    'ObjectCreated:Copy',
    'ObjectCreated:CompleteMultipartUpload'
  ];
  return creationEvents.includes(eventName);
}

// 检查文件是否为音频文件
function isAudioFile(key) {
  const audioExtensions = ['.mp3', '.wav', '.flac', '.m4a', '.aac', '.ogg', '.wma', '.amr'];
  const extension = key.toLowerCase().substring(key.lastIndexOf('.'));
  return audioExtensions.includes(extension);
}

// 启动 Amazon Transcribe 任务
async function startTranscriptionJob(bucket, key, pathInfo) {
  try {
    // 生成唯一的任务名称（保留timestamp用于任务名称唯一性）
    const timestamp = Date.now();
    const filename = pathInfo.filename.substring(pathInfo.filename.lastIndexOf('/') + 1, pathInfo.filename.lastIndexOf('.'));
    
    // 根据路径格式生成不同的任务名称
    let jobName;
    if (pathInfo.format === 'new') {
      // 新格式: transcribe-{userId}-{taskId}-{filename}-{timestamp}
      jobName = `transcribe-${pathInfo.userId}-${pathInfo.taskId}-${filename}-${timestamp}`;
    } else {
      // 旧格式: transcribe-{filename}-{timestamp}
      jobName = `transcribe-${filename}-${timestamp}`;
    }
    
    // 构建 S3 URI
    const mediaUri = `s3://${bucket}/${key}`;
    
    // 构建输出 S3 URI
    let outputKey, outputUri;
    if (pathInfo.format === 'new') {
      // 新格式: private/{userId}/tasks/{taskId}/transcripts/{filename}.json
      outputKey = `private/${pathInfo.userId}/tasks/${pathInfo.taskId}/transcripts/${filename}.json`;
      outputUri = `s3://${bucket}/private/${pathInfo.userId}/tasks/${pathInfo.taskId}/transcripts/`;
    } else {
      // 旧格式: transcripts/{filename}.json (向后兼容)
      outputKey = `transcripts/${filename}.json`;
      outputUri = `s3://${bucket}/transcripts/`;
    }
    
    console.log(`Starting transcription job: ${jobName}`);
    console.log(`Media URI: ${mediaUri}`);
    console.log(`Output URI: ${outputUri}`);
    console.log(`Output Key: ${outputKey}`);
    console.log(`Path format: ${pathInfo.format}`);
    
    // 启动转录任务
    // 使用自动语言识别而不是硬编码语言
    const params = {
      TranscriptionJobName: jobName,
      Media: {
        MediaFileUri: mediaUri
      },
      MediaFormat: getMediaFormat(pathInfo.filename),
      // 替换固定语言代码，使用自动识别
      IdentifyLanguage: true,  // 启用自动语言识别
      // 可以指定可能的语言列表以提高准确性（可选）
      LanguageOptions: ['en-US', 'zh-CN'],
      OutputBucketName: bucket,
      OutputKey: outputKey,
      Settings: {
        ShowSpeakerLabels: true,
        MaxSpeakerLabels: 2
      }
    };
    
    const command = new StartTranscriptionJobCommand(params);
    const result = await transcribeClient.send(command);
    
    console.log(`Transcription job started successfully:`, result.TranscriptionJob.TranscriptionJobName);
    console.log(`Job status: ${result.TranscriptionJob.TranscriptionJobStatus}`);
    
    return result.TranscriptionJob.TranscriptionJobName;
    
  } catch (error) {
    console.error(`Error starting transcription job for ${key}:`, error);
    return null; // 返回null而不是抛出错误，让主函数可以继续处理其他文件
  }
}

// 根据文件扩展名确定媒体格式
function getMediaFormat(filename) {
  const extension = filename.toLowerCase().substring(filename.lastIndexOf('.'));
  
  switch (extension) {
    case '.mp3':
      return 'mp3';
    case '.wav':
      return 'wav';
    case '.flac':
      return 'flac';
    case '.m4a':
      return 'm4a';
    case '.aac':
      return 'mp4'; // AAC 通常使用 mp4 格式
    case '.ogg':
      return 'ogg';
    case '.amr':
      return 'amr';
    default:
      return 'mp3'; // 默认格式
  }
}