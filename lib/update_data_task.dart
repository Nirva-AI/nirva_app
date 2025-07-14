import 'dart:io';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:nirva_app/transcribe_file_name.dart';
import 'package:nirva_app/analyze_task.dart';
import 'package:nirva_app/transcription_task.dart';
import 'package:nirva_app/data.dart';

/// UpdateDataTask状态枚举
enum UpdateDataTaskStatus {
  idle, // 空闲
  preparing, // 准备文件
  uploading, // 上传中
  waitingTranscription, // 等待转录完成
  transcriptionReady, // 转录完成，可获取结果
  analyzingRequest, // 发送分析请求中
  waitingAnalysis, // 等待分析完成
  analysisReady, // 分析完成，可获取结果
  completed, // 全部完成
  failed, // 失败
}

/// UpdateDataTask类 - UploadAndTranscribeTask与AnalyzeTask的组合类
///
/// 完整的数据更新流程：
/// 1. executeTranscriptionUpload() - 上传音频并开始转录
/// 2. getTranscriptionResults() - 获取转录结果并保存
/// 3. executeAnalysisRequest() - 发送分析请求
/// 4. getAnalysisResults() - 获取分析结果
/// 5. cleanupFiles() - 清理S3文件
class UpdateDataTask {
  // update_data_task.dart
  // 基础属性
  final String userId;
  final List<String> assetFileNames;
  final List<String> pickedFileNames;
  final DateTime creationTime; // 用于命名的时间

  // 子任务实例
  UploadAndTranscribeTask? _uploadAndTranscribeTask;
  AnalyzeTask? _analyzeTask;

  // 状态和结果
  UpdateDataTaskStatus _status = UpdateDataTaskStatus.idle;
  String? _errorMessage;
  String? _transcriptFilePath;

  /// 构造函数
  UpdateDataTask({
    required this.userId,
    required this.creationTime,
    this.assetFileNames = const [],
    this.pickedFileNames = const [],
  });

  // =============================================================================
  // 公共属性访问器
  // =============================================================================

  /// 当前状态
  UpdateDataTaskStatus get status => _status;

  /// 错误信息
  String? get errorMessage => _errorMessage;

  /// 转录文件路径
  String? get transcriptFilePath => _transcriptFilePath;

  /// 分析结果
  JournalFile? get analysisResult => _analyzeTask?.journalFileResult;

  /// 上传的文件名列表
  List<String> get uploadedFileNames =>
      _uploadAndTranscribeTask?.uploadedFileNames ?? [];

  // =============================================================================
  // 子任务状态访问器（用于持久化）
  // =============================================================================

  /// 获取 UploadAndTranscribeTask 的状态信息
  Map<String, dynamic>? get uploadAndTranscribeTaskState {
    if (_uploadAndTranscribeTask == null) return null;

    return {
      'taskId': _uploadAndTranscribeTask!.taskId,
      'userId': _uploadAndTranscribeTask!.userId,
      'assetFileNames': _uploadAndTranscribeTask!.assetFileNames,
      'pickedFileNames': _uploadAndTranscribeTask!.pickedFileNames,
      'creationTime': _uploadAndTranscribeTask!.creationTime,
      'uploadedFileNames': _uploadAndTranscribeTask!.uploadedFileNames,
      'isUploaded': _uploadAndTranscribeTask!.isUploaded,
      'isTranscribed': _uploadAndTranscribeTask!.isTranscribed,
    };
  }

  /// 获取 AnalyzeTask 的状态信息
  Map<String, dynamic>? get analyzeTaskState {
    if (_analyzeTask == null) return null;

    return {
      'content': _analyzeTask!.content,
      'transcribeFileName': _analyzeTask!.transcribeFileName,
      'fileName': _analyzeTask!.fileName,
      'dateKey': _analyzeTask!.dateKey,
      'status': _analyzeTask!.status,
      'errorMessage': _analyzeTask!.errorMessage,
      'uploadResponseMessage': _analyzeTask!.uploadResponseMessage,
      'analyzeTaskId': _analyzeTask!.analyzeTaskId,
      'journalFileResult': _analyzeTask!.journalFileResult,
    };
  }

  // =============================================================================
  // 状态检查方法
  // =============================================================================

  /// 是否可以开始转录上传
  bool get canStartTranscriptionUpload => _status == UpdateDataTaskStatus.idle;

  /// 是否可以获取转录结果
  bool get canGetTranscriptionResults =>
      _status == UpdateDataTaskStatus.waitingTranscription;

  /// 是否可以开始分析请求
  bool get canStartAnalysisRequest =>
      _status == UpdateDataTaskStatus.transcriptionReady;

  /// 是否可以获取分析结果
  bool get canGetAnalysisResults =>
      _status == UpdateDataTaskStatus.waitingAnalysis;

  /// 是否可以清理文件
  bool get canCleanup =>
      _status == UpdateDataTaskStatus.completed ||
      _status == UpdateDataTaskStatus.analysisReady;

  /// 是否已完成
  bool get isCompleted => _status == UpdateDataTaskStatus.completed;

  /// 是否失败
  bool get isFailed => _status == UpdateDataTaskStatus.failed;

  /// 是否正在进行中
  bool get isInProgress =>
      _status != UpdateDataTaskStatus.idle &&
      _status != UpdateDataTaskStatus.transcriptionReady &&
      _status != UpdateDataTaskStatus.analysisReady &&
      _status != UpdateDataTaskStatus.completed &&
      _status != UpdateDataTaskStatus.failed;

  // =============================================================================
  // 主要流程方法
  // =============================================================================

  /// 步骤1：执行转录上传流程
  ///
  /// 包含：准备文件 + 上传文件
  /// 状态变化：idle → preparing → uploading → waitingTranscription
  Future<bool> executeTranscriptionUpload() async {
    if (!canStartTranscriptionUpload) {
      _errorMessage = '当前状态不允许开始转录上传: $_status';
      Logger().d(_errorMessage!);
      return false;
    }

    try {
      _status = UpdateDataTaskStatus.preparing;
      _errorMessage = null;

      // 创建UploadAndTranscribeTask实例
      _uploadAndTranscribeTask = UploadAndTranscribeTask(
        userId: userId,
        assetFileNames: assetFileNames,
        pickedFileNames: pickedFileNames,
        creationTime: creationTime,
      );

      Logger().d('UpdateDataTask: 开始准备文件...');

      // 准备文件
      final prepareSuccess = await _uploadAndTranscribeTask!.prepareFiles();
      if (!prepareSuccess) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '准备文件失败';
        Logger().d(_errorMessage!);
        return false;
      }

      _status = UpdateDataTaskStatus.uploading;
      Logger().d('UpdateDataTask: 开始上传文件...');

      // 上传文件
      final uploadResult = await _uploadAndTranscribeTask!.uploadFiles();
      if (!uploadResult.success) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '上传文件失败: ${uploadResult.errors.join(', ')}';
        Logger().d(_errorMessage!);
        return false;
      }

      _status = UpdateDataTaskStatus.waitingTranscription;
      Logger().d('UpdateDataTask: 文件上传成功，等待转录完成...');
      return true;
    } catch (e) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '转录上传过程异常: $e';
      Logger().d(_errorMessage!);
      return false;
    }
  }

  /// 步骤2：获取转录结果
  ///
  /// 状态变化：waitingTranscription → transcriptionReady
  Future<bool> getTranscriptionResults() async {
    if (!canGetTranscriptionResults) {
      _errorMessage = '当前状态不允许获取转录结果: $_status';
      Logger().d(_errorMessage!);
      return false;
    }

    if (_uploadAndTranscribeTask == null) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '转录任务实例不存在';
      Logger().d(_errorMessage!);
      return false;
    }

    try {
      Logger().d('UpdateDataTask: 开始获取转录结果...');

      final transcriptionResult =
          await _uploadAndTranscribeTask!.getTranscriptionResults();
      if (!transcriptionResult.success) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '获取转录结果失败: ${transcriptionResult.errors.join(', ')}';
        Logger().d(_errorMessage!);
        return false;
      }

      _transcriptFilePath = transcriptionResult.savedFilePath;
      _status = UpdateDataTaskStatus.transcriptionReady;
      Logger().d('UpdateDataTask: 转录结果获取成功，文件路径: $_transcriptFilePath');
      return true;
    } catch (e) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '获取转录结果异常: $e';
      Logger().d(_errorMessage!);
      return false;
    }
  }

  /// 步骤3：执行分析请求流程
  ///
  /// 包含：读取转录文件 + 上传转录数据 + 发送分析请求
  /// 状态变化：transcriptionReady → analyzingRequest → waitingAnalysis
  Future<bool> executeAnalysisRequest() async {
    if (!canStartAnalysisRequest) {
      _errorMessage = '当前状态不允许开始分析请求: $_status';
      Logger().d(_errorMessage!);
      return false;
    }

    if (_transcriptFilePath == null || _transcriptFilePath!.isEmpty) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '转录文件路径为空';
      Logger().d(_errorMessage!);
      return false;
    }

    try {
      _status = UpdateDataTaskStatus.analyzingRequest;
      Logger().d('UpdateDataTask: 开始分析请求流程...');

      // 读取转录文件内容
      final transcriptFile = File(_transcriptFilePath!);
      if (!await transcriptFile.exists()) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '转录文件不存在: $_transcriptFilePath';
        Logger().d(_errorMessage!);
        return false;
      }

      final transcriptContent = await transcriptFile.readAsString(
        encoding: utf8,
      );
      if (transcriptContent.isEmpty) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '转录文件内容为空';
        Logger().d(_errorMessage!);
        return false;
      }

      // 从文件名创建TranscribeFileName对象
      final fileName = transcriptFile.path.split('/').last;
      final transcribeFileName = TranscribeFileName.tryFromFilename(fileName);
      if (transcribeFileName == null) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '无法从文件名创建TranscribeFileName: $fileName';
        Logger().d(_errorMessage!);
        return false;
      }

      // 创建AnalyzeTask实例
      _analyzeTask = AnalyzeTask(
        content: transcriptContent,
        transcribeFileName: transcribeFileName,
        fileName: fileName,
      );

      Logger().d('UpdateDataTask: 开始上传转录数据...');

      // 上传转录数据
      final uploadSuccess = await _analyzeTask!.uploadTranscript();
      if (!uploadSuccess) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '上传转录数据失败: ${_analyzeTask!.errorMessage}';
        Logger().d(_errorMessage!);
        return false;
      }

      Logger().d('UpdateDataTask: 开始分析数据...');

      // 发送分析请求
      final analyzeSuccess = await _analyzeTask!.analyzeData();
      if (!analyzeSuccess) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '发送分析请求失败: ${_analyzeTask!.errorMessage}';
        Logger().d(_errorMessage!);
        return false;
      }

      _status = UpdateDataTaskStatus.waitingAnalysis;
      Logger().d('UpdateDataTask: 分析请求发送成功，等待分析完成...');
      return true;
    } catch (e) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '分析请求过程异常: $e';
      Logger().d(_errorMessage!);
      return false;
    }
  }

  /// 步骤4：获取分析结果
  ///
  /// 状态变化：waitingAnalysis → analysisReady → completed
  Future<bool> getAnalysisResults() async {
    if (!canGetAnalysisResults) {
      _errorMessage = '当前状态不允许获取分析结果: $_status';
      Logger().d(_errorMessage!);
      return false;
    }

    if (_analyzeTask == null) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '分析任务实例不存在';
      Logger().d(_errorMessage!);
      return false;
    }

    try {
      Logger().d('UpdateDataTask: 开始获取分析结果...');

      final resultSuccess = await _analyzeTask!.getTaskResults();
      if (!resultSuccess) {
        _status = UpdateDataTaskStatus.failed;
        _errorMessage = '获取分析结果失败: ${_analyzeTask!.errorMessage}';
        Logger().d(_errorMessage!);
        return false;
      }

      _status = UpdateDataTaskStatus.analysisReady;
      Logger().d('UpdateDataTask: 分析结果获取成功');

      // 自动转换到完成状态
      _status = UpdateDataTaskStatus.completed;
      Logger().d('UpdateDataTask: 所有流程完成');
      return true;
    } catch (e) {
      _status = UpdateDataTaskStatus.failed;
      _errorMessage = '获取分析结果异常: $e';
      Logger().d(_errorMessage!);
      return false;
    }
  }

  /// 步骤5：清理文件
  ///
  /// 清理S3中的任务文件和本地临时文件
  Future<bool> cleanupFiles() async {
    if (!canCleanup) {
      _errorMessage = '当前状态不允许清理文件: $_status';
      Logger().d(_errorMessage!);
      return false;
    }

    if (_uploadAndTranscribeTask == null) {
      Logger().d('UpdateDataTask: 没有需要清理的文件');
      return true;
    }

    try {
      Logger().d('UpdateDataTask: 开始清理文件...');

      final cleanupSuccess = await _uploadAndTranscribeTask!.deleteTaskFiles();
      if (cleanupSuccess) {
        Logger().d('UpdateDataTask: 文件清理完成');
      } else {
        Logger().d('UpdateDataTask: 文件清理部分失败');
      }

      return cleanupSuccess;
    } catch (e) {
      _errorMessage = '清理文件异常: $e';
      Logger().d(_errorMessage!);
      return false;
    }
  }

  /// 重置任务状态
  void reset() {
    _status = UpdateDataTaskStatus.idle;
    _errorMessage = null;
    _transcriptFilePath = null;
    _uploadAndTranscribeTask = null;
    _analyzeTask = null;
    Logger().d('UpdateDataTask: 任务状态已重置');
  }

  /// 获取状态描述文本
  String getStatusDescription() {
    switch (_status) {
      case UpdateDataTaskStatus.idle:
        return '空闲';
      case UpdateDataTaskStatus.preparing:
        return '准备文件中...';
      case UpdateDataTaskStatus.uploading:
        return '上传文件中...';
      case UpdateDataTaskStatus.waitingTranscription:
        return '等待转录完成...';
      case UpdateDataTaskStatus.transcriptionReady:
        return '转录完成，可开始分析';
      case UpdateDataTaskStatus.analyzingRequest:
        return '发送分析请求中...';
      case UpdateDataTaskStatus.waitingAnalysis:
        return '等待分析完成...';
      case UpdateDataTaskStatus.analysisReady:
        return '分析完成';
      case UpdateDataTaskStatus.completed:
        return '全部完成';
      case UpdateDataTaskStatus.failed:
        return '失败: ${_errorMessage ?? "未知错误"}';
    }
  }

  // =============================================================================
  // 状态恢复方法（用于从持久化数据恢复任务状态）
  // =============================================================================

  /// 恢复任务的状态信息
  ///
  /// 用于从持久化存储中恢复任务的完整状态，包括私有字段
  /// [status] 任务状态
  /// [errorMessage] 错误信息
  /// [transcriptFilePath] 转录文件路径
  void restoreTaskState({
    required UpdateDataTaskStatus status,
    String? errorMessage,
    String? transcriptFilePath,
  }) {
    _status = status;
    _errorMessage = errorMessage;
    _transcriptFilePath = transcriptFilePath;
  }

  /// 恢复子任务状态
  ///
  /// 从持久化数据重建子任务实例
  /// [uploadTaskData] UploadAndTranscribeTask的构造数据
  /// [analyzeTaskData] AnalyzeTask的构造数据
  void restoreSubTasks({
    Map<String, dynamic>? uploadTaskData,
    Map<String, dynamic>? analyzeTaskData,
  }) {
    // 恢复 UploadAndTranscribeTask
    if (uploadTaskData != null) {
      _uploadAndTranscribeTask = UploadAndTranscribeTask(
        userId: uploadTaskData['userId'],
        assetFileNames: List<String>.from(uploadTaskData['assetFileNames']),
        pickedFileNames: List<String>.from(uploadTaskData['pickedFileNames']),
        creationTime: uploadTaskData['creationTime'],
      );

      // 恢复私有状态（如果有相关方法）
      if (uploadTaskData.containsKey('isUploaded') &&
          uploadTaskData.containsKey('isTranscribed') &&
          uploadTaskData.containsKey('uploadedFileNames')) {
        _uploadAndTranscribeTask!.restoreState(
          isUploaded: uploadTaskData['isUploaded'],
          isTranscribed: uploadTaskData['isTranscribed'],
          uploadedFileNames: List<String>.from(
            uploadTaskData['uploadedFileNames'],
          ),
        );
      }
    }

    // 恢复 AnalyzeTask
    if (analyzeTaskData != null) {
      _analyzeTask = AnalyzeTask(
        content: analyzeTaskData['content'],
        transcribeFileName: analyzeTaskData['transcribeFileName'],
        fileName: analyzeTaskData['fileName'],
      );

      // 恢复私有状态
      _analyzeTask!.restoreState(
        status: analyzeTaskData['status'],
        errorMessage: analyzeTaskData['errorMessage'],
        uploadResponseMessage: analyzeTaskData['uploadResponseMessage'],
        analyzeTaskId: analyzeTaskData['analyzeTaskId'],
        journalFileResult: analyzeTaskData['journalFileResult'],
      );
    }
  }

  @override
  String toString() {
    return 'UpdateDataTask{userId: $userId, status: $_status, '
        'assetFiles: ${assetFileNames.length}, pickedFiles: ${pickedFileNames.length}, '
        'creationTime: $creationTime}';
  }
}
