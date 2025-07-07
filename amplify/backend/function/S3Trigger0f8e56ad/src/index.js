const { TranscribeClient, StartTranscriptionJobCommand } = require('@aws-sdk/client-transcribe');

// 初始化 AWS 服务
const transcribeClient = new TranscribeClient({ region: process.env.AWS_REGION || 'us-east-1' });

exports.handler = async function (event) {
  console.log('🚀 Lambda triggered - Received S3 event:', JSON.stringify(event, null, 2));
  
  try {
    // 记录接收到的事件数量
    const recordCount = event.Records ? event.Records.length : 0;
    console.log(`Received ${recordCount} S3 event record(s)`);
    
    // 处理每个 S3 事件记录
    // 注意：虽然当前测试只上传一个文件，但S3事件可能包含多个记录
    // 这是AWS Lambda S3触发器的标准处理方式
    // 但是，多段文件会出现多个转录任务，导致多个转录结果。
    for (let i = 0; i < event.Records.length; i++) {
      const record = event.Records[i];
      const bucket = record.s3.bucket.name;
      const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
      
      console.log(`Processing record ${i + 1}/${recordCount}: ${key} from bucket: ${bucket}`);
      
      // 1. 检查文件是否为音频文件
      if (!isAudioFile(key)) {
        console.log(`Skipping non-audio file: ${key}`);
        continue;
      }
      
      console.log(`✅ File ${key} is an audio file, proceeding with transcription`);
      
      // 2. 启动 Amazon Transcribe 任务
      await startTranscriptionJob(bucket, key);
    }
    
    console.log(`✅ Successfully processed all ${recordCount} S3 event record(s)`);
    
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Successfully processed ${recordCount} S3 event record(s)`
      })
    };
    
  } catch (error) {
    console.error('Error processing S3 event:', error);
    throw error;
  }
};

// 检查文件是否为音频文件
function isAudioFile(key) {
  const audioExtensions = ['.mp3', '.wav', '.flac', '.m4a', '.aac', '.ogg', '.wma', '.amr'];
  const extension = key.toLowerCase().substring(key.lastIndexOf('.'));
  return audioExtensions.includes(extension);
}

// 启动 Amazon Transcribe 任务
async function startTranscriptionJob(bucket, key) {
  try {
    // 生成唯一的任务名称
    const timestamp = Date.now();
    const filename = key.substring(key.lastIndexOf('/') + 1, key.lastIndexOf('.'));
    const jobName = `transcribe-${filename}-${timestamp}`;
    
    // 构建 S3 URI
    const mediaUri = `s3://${bucket}/${key}`;
    
    // 构建输出 S3 URI
    const outputKey = `transcripts/${filename}-${timestamp}.json`;
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
    
    return result;
    
  } catch (error) {
    console.error(`Error starting transcription job for ${key}:`, error);
    throw error;
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