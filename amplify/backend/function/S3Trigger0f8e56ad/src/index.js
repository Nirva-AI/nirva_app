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
    
    // 收集所有启动的转录任务JobNames
    const jobNames = [];
    
    // 处理每个 S3 事件记录
    // 注意：虽然当前测试只上传一个文件，但S3事件可能包含多个记录
    // 这是AWS Lambda S3触发器的标准处理方式
    for (let i = 0; i < event.Records.length; i++) {
      const record = event.Records[i];
      const eventName = record.eventName;
      const bucket = record.s3.bucket.name;
      const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
      
      console.log(`Processing record ${i + 1}/${recordCount}: ${eventName} for ${key}`);
      
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
      
      console.log(`✅ File ${key} is an audio file from creation event, proceeding with transcription`);
      
      // 3. 启动 Amazon Transcribe 任务
      const jobName = await startTranscriptionJob(bucket, key);
      if (jobName) {
        jobNames.push(jobName);
      }
    }
    
    console.log(`✅ Successfully processed all ${recordCount} S3 event record(s)`);
    console.log(`✅ Started ${jobNames.length} transcription job(s): ${jobNames.join(', ')}`);
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Successfully processed ${recordCount} S3 event record(s)`,
        jobNames: jobNames
      })
    };
    
  } catch (error) {
    console.error('Error processing S3 event:', error);
    throw error;
  }
};

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
async function startTranscriptionJob(bucket, key) {
  try {
    // 生成唯一的任务名称（保留timestamp用于任务名称唯一性）
    const timestamp = Date.now();
    const filename = key.substring(key.lastIndexOf('/') + 1, key.lastIndexOf('.'));
    const jobName = `transcribe-${filename}-${timestamp}`;
    
    // 构建 S3 URI
    const mediaUri = `s3://${bucket}/${key}`;
    
    // 构建输出 S3 URI（简化文件名，去掉timestamp）
    const outputKey = `transcripts/${filename}.json`;
    const outputUri = `s3://${bucket}/transcripts/`;
    
    console.log(`Starting transcription job: ${jobName}`);
    console.log(`Media URI: ${mediaUri}`);
    console.log(`Output URI: ${outputUri}`);
    
    // 启动转录任务
    // 使用自动语言识别而不是硬编码语言
    const params = {
      TranscriptionJobName: jobName,
      Media: {
        MediaFileUri: mediaUri
      },
      MediaFormat: getMediaFormat(key),
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
function getMediaFormat(key) {
  const extension = key.toLowerCase().substring(key.lastIndexOf('.'));
  
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