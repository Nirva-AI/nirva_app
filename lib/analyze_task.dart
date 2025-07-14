import 'package:nirva_app/data.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/transcribe_file_name.dart';
import 'package:nirva_app/apis.dart';

/// 任务状态枚举
enum AnalyzeTaskStatus {
  idle, // 空闲状态
  uploading, // 上传中
  analyzing, // 分析中
  gettingResults, // 获取结果中
  completed, // 完成
  failed, // 失败
}

/// 分析任务类，包含上传、分析、获取结果三个独立步骤
class AnalyzeTask {
  // analyze_task.dart
  // 基础属性
  final String content;
  final TranscribeFileName transcribeFileName;
  final String fileName;
  final String dateKey;

  // 状态管理
  AnalyzeTaskStatus status = AnalyzeTaskStatus.idle;
  String? errorMessage;

  // 结果存储
  String? uploadResponseMessage;
  String? analyzeTaskId;
  JournalFile? journalFileResult;

  /// 构造函数
  AnalyzeTask({
    required this.content,
    required this.transcribeFileName,
    required this.fileName,
  }) : dateKey = JournalFile.dateTimeToKey(transcribeFileName.dateTime);

  /// 步骤1：上传转录数据
  Future<bool> uploadTranscript() async {
    try {
      status = AnalyzeTaskStatus.uploading;
      errorMessage = null;

      final uploadResponse = await APIs.uploadTranscript(
        content,
        dateKey,
        transcribeFileName.fileNumber,
        transcribeFileName.fileSuffix,
      );

      if (uploadResponse == null) {
        status = AnalyzeTaskStatus.failed;
        errorMessage = 'Failed to upload transcript data';
        Logger().d(errorMessage!);
        return false;
      }

      uploadResponseMessage = uploadResponse.message;
      Logger().d(
        'Successfully uploaded transcript data: ${uploadResponse.message}',
      );
      return true;
    } catch (e) {
      status = AnalyzeTaskStatus.failed;
      errorMessage = 'Error uploading transcript: $e';
      Logger().d(errorMessage!);
      return false;
    }
  }

  /// 步骤2：分析数据
  Future<bool> analyzeData() async {
    try {
      status = AnalyzeTaskStatus.analyzing;
      errorMessage = null;

      final backgroundTaskResponse = await APIs.analyze(
        dateKey,
        transcribeFileName.fileNumber,
      );

      if (backgroundTaskResponse != null) {
        analyzeTaskId = backgroundTaskResponse.task_id;
        Logger().d('Data analysis task created with ID: $analyzeTaskId');
        return true;
      } else {
        status = AnalyzeTaskStatus.failed;
        errorMessage = 'Data analysis failed';
        Logger().d(errorMessage!);
        return false;
      }
    } catch (e) {
      status = AnalyzeTaskStatus.failed;
      errorMessage = 'Error analyzing data: $e';
      Logger().d(errorMessage!);
      return false;
    }
  }

  /// 步骤3：获取分析结果
  Future<bool> getTaskResults() async {
    try {
      status = AnalyzeTaskStatus.gettingResults;
      errorMessage = null;

      final journalFile = await APIs.getJournalFile(dateKey);

      if (journalFile != null) {
        journalFileResult = journalFile;
        status = AnalyzeTaskStatus.completed;
        Logger().d('Successfully retrieved analysis results');
        return true;
      } else {
        status = AnalyzeTaskStatus.failed;
        errorMessage = 'Failed to retrieve results';
        Logger().d(errorMessage!);
        return false;
      }
    } catch (e) {
      status = AnalyzeTaskStatus.failed;
      errorMessage = 'Error retrieving task results: $e';
      Logger().d(errorMessage!);
      return false;
    }
  }

  /// 重置任务状态
  void reset() {
    status = AnalyzeTaskStatus.idle;
    errorMessage = null;
    uploadResponseMessage = null;
    analyzeTaskId = null;
    journalFileResult = null;
  }

  /// 检查任务是否完成
  bool get isCompleted => status == AnalyzeTaskStatus.completed;

  /// 检查任务是否失败
  bool get isFailed => status == AnalyzeTaskStatus.failed;

  /// 检查任务是否正在进行中
  bool get isInProgress =>
      status == AnalyzeTaskStatus.uploading ||
      status == AnalyzeTaskStatus.analyzing ||
      status == AnalyzeTaskStatus.gettingResults;

  // =============================================================================
  // 状态恢复方法（用于从持久化数据恢复任务状态）
  // =============================================================================

  /// 恢复私有状态（用于从持久化存储恢复）
  void restoreState({
    required AnalyzeTaskStatus status,
    String? errorMessage,
    String? uploadResponseMessage,
    String? analyzeTaskId,
    JournalFile? journalFileResult,
  }) {
    this.status = status;
    this.errorMessage = errorMessage;
    this.uploadResponseMessage = uploadResponseMessage;
    this.analyzeTaskId = analyzeTaskId;
    this.journalFileResult = journalFileResult;
  }
}

/*

*/
