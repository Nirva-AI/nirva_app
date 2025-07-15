import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nirva_app/app_service.dart';
import 'package:nirva_app/update_data_task.dart';
import 'package:nirva_app/my_hive_objects.dart';
import 'package:nirva_app/hive_helper.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  // 单个任务实例
  UpdateDataTask? _updateDataTask;

  // 是否正在创建任务
  bool _isCreatingTask = false;

  // 是否已经加载过保存的任务
  bool _hasLoadedSavedTask = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 确保只加载一次保存的任务
    if (!_hasLoadedSavedTask) {
      _hasLoadedSavedTask = true;
      _loadSavedTask();
    }
  }

  // =============================================================================
  // 任务存储相关方法
  // =============================================================================

  /// 加载保存的任务
  Future<void> _loadSavedTask() async {
    try {
      //final hiveManager = AppService().hiveManager;

      if (HiveHelper.hasUpdateDataTask()) {
        final constructorData = HiveHelper.getUpdateDataTaskConstructorData();
        if (constructorData != null) {
          // 从存储数据重建 UpdateDataTask
          _updateDataTask = UpdateDataTask(
            id: constructorData['id'], // 添加 id 参数
            userId: constructorData['userId'],
            assetFileNames: List<String>.from(
              constructorData['assetFileNames'],
            ),
            pickedFileNames: List<String>.from(
              constructorData['pickedFileNames'],
            ),
            creationTime: constructorData['creationTime'],
          );

          // 恢复任务状态
          _updateDataTask!.restoreTaskState(
            status: constructorData['status'],
            errorMessage: constructorData['errorMessage'],
            transcriptFilePath: constructorData['transcriptFilePath'],
          );

          // 恢复子任务状态
          _updateDataTask!.restoreSubTasks(
            uploadTaskData: constructorData['uploadAndTranscribeTaskData'],
            analyzeTaskData: constructorData['analyzeTaskData'],
          );

          setState(() {});

          Logger().d('已加载保存的任务: ${_updateDataTask.toString()}');

          // 使用 post-frame callback 来在构建完成后显示 SnackBar
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Previous task restored'),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      Logger().e('加载保存的任务失败: $e');
      // 加载失败时显示错误但不阻止操作
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to restore task: $e'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }

  /// 保存当前任务状态
  Future<void> _saveCurrentTask() async {
    if (_updateDataTask == null) return;

    try {
      //final hiveManager = AppService().hiveManager;

      // 获取子任务存储数据
      UploadAndTranscribeTaskStorage? uploadStorage;
      AnalyzeTaskStorage? analyzeStorage;

      // 保存UploadAndTranscribeTask状态
      final uploadState = _updateDataTask!.uploadAndTranscribeTaskState;
      if (uploadState != null) {
        uploadStorage = UploadAndTranscribeTaskStorage.create(
          taskId: uploadState['taskId'],
          userId: uploadState['userId'],
          assetFileNames: List<String>.from(uploadState['assetFileNames']),
          pickedFileNames: List<String>.from(uploadState['pickedFileNames']),
          creationTime: uploadState['creationTime'],
          uploadedFileNames: List<String>.from(
            uploadState['uploadedFileNames'],
          ),
          isUploaded: uploadState['isUploaded'],
          isTranscribed: uploadState['isTranscribed'],
        );
      }

      // 保存AnalyzeTask状态
      final analyzeState = _updateDataTask!.analyzeTaskState;
      if (analyzeState != null) {
        analyzeStorage = AnalyzeTaskStorage.create(
          id: analyzeState['id'], // 添加 id 参数
          content: analyzeState['content'],
          transcribeFileName: analyzeState['transcribeFileName'],
          fileName: analyzeState['fileName'],
          dateKey: analyzeState['dateKey'],
          status: analyzeState['status'],
          errorMessage: analyzeState['errorMessage'],
          uploadResponseMessage: analyzeState['uploadResponseMessage'],
          analyzeTaskId: analyzeState['analyzeTaskId'],
          journalFileResult: analyzeState['journalFileResult'],
        );
      }

      await HiveHelper.saveUpdateDataTaskFromData(
        id: _updateDataTask!.id, // 添加 id 参数
        userId: _updateDataTask!.userId,
        assetFileNames: _updateDataTask!.assetFileNames,
        pickedFileNames: _updateDataTask!.pickedFileNames,
        creationTime: _updateDataTask!.creationTime,
        status: _updateDataTask!.status,
        errorMessage: _updateDataTask!.errorMessage,
        transcriptFilePath: _updateDataTask!.transcriptFilePath,
        uploadAndTranscribeTaskStorage: uploadStorage,
        analyzeTaskStorage: analyzeStorage,
      );

      Logger().d('任务状态已保存');
    } catch (e) {
      Logger().e('保存任务状态失败: $e');
      // 保存失败时阻止操作
      throw Exception('保存任务状态失败: $e');
    }
  }

  /// 删除保存的任务
  Future<void> _deleteSavedTask() async {
    try {
      //final hiveManager = AppService().hiveManager;
      await HiveHelper.deleteUpdateDataTask();
      Logger().d('已删除保存的任务');
    } catch (e) {
      Logger().e('删除保存的任务失败: $e');
      // 删除失败时不阻止操作，因为这不是关键操作
    }
  }

  // 创建新任务（空任务）

  Future<void> _createUpdateDataTask() async {
    if (_isCreatingTask) return;

    setState(() {
      _isCreatingTask = true;
    });

    try {
      if (_updateDataTask != null) {
        // 已有任务，询问是否替换
        final shouldReplace = await _showReplaceTaskDialog();
        if (!shouldReplace) {
          return;
        }
      }

      // 创建空任务
      await _createEmptyTask();
    } catch (e) {
      Logger().e('创建任务时出错: $e');
      _showErrorDialog('Failed to create task: $e');
    } finally {
      setState(() {
        _isCreatingTask = false;
      });
    }
  }

  // 添加文件到任务
  Future<void> _addFileToTask() async {
    if (_updateDataTask == null) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.paths.first != null) {
        final selectedFilePath = result.paths.first!;
        await _addFileToExistingTask(selectedFilePath);
      } else {
        Logger().d('用户取消了文件选择');
      }
    } catch (e) {
      Logger().e('添加文件时出错: $e');
      _showErrorDialog('Failed to add file: $e');
    }
  }

  // 创建空任务
  Future<void> _createEmptyTask() async {
    // 获取用户ID
    final userId = AppService().user.id;

    if (userId.isEmpty) {
      _showErrorDialog('User ID is empty, please ensure you are logged in');
      return;
    }

    // 创建空的 UpdateDataTask 实例
    _updateDataTask = UpdateDataTask(
      userId: userId,
      creationTime: DateTime.now(), // 使用当前时间作为创建时间
      assetFileNames: [], // 不使用 assets 文件
      pickedFileNames: [], // 空文件列表
    );

    // 保存任务状态
    try {
      await _saveCurrentTask();
    } catch (e) {
      _showErrorDialog('Failed to save task: $e');
      _updateDataTask = null; // 创建失败时清空任务
      return;
    }

    setState(() {});

    Logger().d('创建空任务: ${_updateDataTask.toString()}');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully! Please add files.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // 添加文件到现有任务
  Future<void> _addFileToExistingTask(String filePath) async {
    if (_updateDataTask == null) return;

    // 检查文件是否已存在
    if (_updateDataTask!.pickedFileNames.contains(filePath)) {
      _showErrorDialog(
        'This file is already in the task, no need to add again.',
      );
      return;
    }

    // 创建新的任务实例（因为pickedFileNames是final的）
    final newPickedFiles = [..._updateDataTask!.pickedFileNames, filePath];

    _updateDataTask = UpdateDataTask(
      id: _updateDataTask!.id, // 保持相同的 ID
      userId: _updateDataTask!.userId,
      creationTime: _updateDataTask!.creationTime, // 保持原始创建时间
      assetFileNames: _updateDataTask!.assetFileNames,
      pickedFileNames: newPickedFiles,
    );

    // 保存任务状态
    try {
      await _saveCurrentTask();
    } catch (e) {
      _showErrorDialog('Failed to save task: $e');
      return;
    }

    setState(() {});

    Logger().d('文件添加成功: $filePath');
    Logger().d('当前文件总数: ${_updateDataTask!.pickedFileNames.length}');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'File added successfully! Total ${_updateDataTask!.pickedFileNames.length} files',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // 显示错误对话框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // 显示替换任务确认对话框
  Future<bool> _showReplaceTaskDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Task'),
            content: const Text(
              'A task already exists. Creating a new task will replace the current task. Are you sure you want to continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: const Text('Create New Task'),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  // 删除任务
  void _removeTask() {
    setState(() {
      _updateDataTask = null;
    });

    // 删除保存的任务
    _deleteSavedTask();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // 执行转录上传
  Future<void> _executeTranscriptionUpload(UpdateDataTask task) async {
    try {
      final success = await task.executeTranscriptionUpload();

      // 保存任务状态
      try {
        await _saveCurrentTask();
      } catch (e) {
        _showErrorDialog('Failed to save task state: $e');
        return;
      }

      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Transcription upload successful, waiting for transcription completion...',
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        _showErrorDialog('Transcription upload failed: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('转录上传异常: $e');
      _showErrorDialog('Transcription upload exception: $e');
      setState(() {});
    }
  }

  // 获取转录结果
  Future<void> _getTranscriptionResults(UpdateDataTask task) async {
    try {
      final success = await task.getTranscriptionResults();

      // 保存任务状态
      try {
        await _saveCurrentTask();
      } catch (e) {
        _showErrorDialog('Failed to save task state: $e');
        return;
      }

      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transcription results retrieved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showErrorDialog(
          'Failed to get transcription results: ${task.errorMessage}',
        );
      }
    } catch (e) {
      Logger().e('获取转录结果异常: $e');
      _showErrorDialog('Get transcription results exception: $e');
      setState(() {});
    }
  }

  // 执行分析请求
  Future<void> _executeAnalysisRequest(UpdateDataTask task) async {
    try {
      final success = await task.executeAnalysisRequest();

      // 保存任务状态
      try {
        await _saveCurrentTask();
      } catch (e) {
        _showErrorDialog('Failed to save task state: $e');
        return;
      }

      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Analysis request sent successfully, waiting for analysis completion...',
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        _showErrorDialog('Analysis request failed: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('分析请求异常: $e');
      _showErrorDialog('Analysis request exception: $e');
      setState(() {});
    }
  }

  // 获取分析结果
  Future<void> _getAnalysisResults(UpdateDataTask task) async {
    try {
      final success = await task.getAnalysisResults();

      // 保存任务状态
      try {
        await _saveCurrentTask();
      } catch (e) {
        _showErrorDialog('Failed to save task state: $e');
        return;
      }

      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Analysis results retrieved successfully, process completed!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }

        // 如果有分析结果，可以添加到全局数据中
        if (task.analysisResult != null) {
          AppService().addJournalFile(task.analysisResult!);
          Logger().d('分析结果已添加到全局数据');
        }
      } else {
        _showErrorDialog(
          'Failed to get analysis results: ${task.errorMessage}',
        );
      }
    } catch (e) {
      Logger().e('获取分析结果异常: $e');
      _showErrorDialog('Get analysis results exception: $e');
      setState(() {});
    }
  }

  // 清理文件
  Future<void> _cleanupFiles(UpdateDataTask task) async {
    try {
      final success = await task.cleanupFiles();
      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File cleanup completed'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File cleanup partially failed'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      Logger().e('清理文件异常: $e');
      _showErrorDialog('File cleanup exception: $e');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Update Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_updateDataTask != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmDialog,
              tooltip: 'Delete Task',
            ),
          IconButton(
            icon:
                _isCreatingTask
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.add),
            onPressed: _isCreatingTask ? null : _createUpdateDataTask,
            tooltip: 'Create New Task',
          ),
        ],
      ),
      body:
          _updateDataTask == null
              ? _buildEmptyState()
              : SingleChildScrollView(child: _buildTaskView()),
    );
  }

  // 构建空状态界面
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.audio_file, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Tasks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Click the + button in the top right corner to create a new task',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 构建任务视图
  Widget _buildTaskView() {
    if (_updateDataTask == null) return _buildEmptyState();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildTaskCard(_updateDataTask!, 0),
    );
  }

  // 构建任务卡片
  Widget _buildTaskCard(UpdateDataTask task, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 任务基本信息
            _buildTaskInfo(task),
            const SizedBox(height: 16),

            // 文件列表
            _buildFileList(task),
            const SizedBox(height: 16),

            // 状态信息
            _buildStatusInfo(task),
            const SizedBox(height: 16),

            // 操作按钮组
            _buildActionButtons(task),

            // 错误信息（如果有）
            if (task.errorMessage != null) ...[
              const SizedBox(height: 12),
              _buildErrorInfo(task),
            ],

            // 结果信息（如果有）
            if (task.transcriptFilePath != null ||
                task.analysisResult != null) ...[
              const SizedBox(height: 12),
              _buildResultInfo(task),
            ],
          ],
        ),
      ),
    );
  }

  // 构建任务基本信息
  Widget _buildTaskInfo(UpdateDataTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.blue.shade600, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Task Information',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'ID: ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    task.id,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Creation Time: ${task.creationTime.toString().substring(0, 19)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // 构建文件列表
  Widget _buildFileList(UpdateDataTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_open, color: Colors.blue.shade600, size: 16),
              const SizedBox(width: 8),
              Text(
                'File List (${task.pickedFileNames.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              // 添加文件按钮
              if (task.status == UpdateDataTaskStatus.idle)
                TextButton.icon(
                  onPressed: _addFileToTask,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add File'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (task.pickedFileNames.isEmpty)
            const Text(
              'No Files',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          else
            ...task.pickedFileNames.asMap().entries.map((entry) {
              final index = entry.key;
              final filePath = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${index + 1}.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          filePath,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                          maxLines: null, // 允许多行
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // 构建状态信息
  Widget _buildStatusInfo(UpdateDataTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getStatusColor(task).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(task).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(task), color: _getStatusColor(task), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.getStatusDescription(),
              style: TextStyle(
                color: _getStatusColor(task),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (task.isInProgress)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(_getStatusColor(task)),
              ),
            ),
        ],
      ),
    );
  }

  // 构建操作按钮组
  Widget _buildActionButtons(UpdateDataTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Action Steps',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),

        // 第一行按钮
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    task.canStartTranscriptionUpload
                        ? () => _executeTranscriptionUpload(task)
                        : null,
                icon: const Icon(Icons.upload, size: 16),
                label: const Text('Upload Transcription'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    task.canGetTranscriptionResults
                        ? () => _getTranscriptionResults(task)
                        : null,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Get Transcription'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 第二行按钮
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    task.canStartAnalysisRequest
                        ? () => _executeAnalysisRequest(task)
                        : null,
                icon: const Icon(Icons.analytics, size: 16),
                label: const Text('Analysis Request'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    task.canGetAnalysisResults
                        ? () => _getAnalysisResults(task)
                        : null,
                icon: const Icon(Icons.assessment, size: 16),
                label: const Text('Get Analysis'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),

        // 清理按钮
        if (task.canCleanup) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _cleanupFiles(task),
              icon: const Icon(Icons.cleaning_services, size: 16),
              label: const Text('Cleanup Files'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // 构建错误信息
  Widget _buildErrorInfo(UpdateDataTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error: ${task.errorMessage}',
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // 构建结果信息
  Widget _buildResultInfo(UpdateDataTask task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.transcriptFilePath != null) ...[
            Row(
              children: [
                Icon(Icons.description, color: Colors.green.shade600, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Transcription file saved',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task.transcriptFilePath!.split('/').last,
              style: TextStyle(fontSize: 12, color: Colors.green.shade700),
            ),
          ],

          if (task.analysisResult != null) ...[
            if (task.transcriptFilePath != null) const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.green.shade600, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Analysis results generated',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // 显示 AnalyzeTask ID
            if (task.analysisResult != null &&
                task.analyzeTaskState != null) ...[
              const SizedBox(height: 4),
              Text(
                'Analysis Task ID: ${task.analyzeTaskState!['id']}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green.shade700,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // 显示删除确认对话框
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this task? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _removeTask();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  // 获取状态颜色
  Color _getStatusColor(UpdateDataTask task) {
    switch (task.status) {
      case UpdateDataTaskStatus.idle:
        return Colors.grey;
      case UpdateDataTaskStatus.preparing:
      case UpdateDataTaskStatus.uploading:
      case UpdateDataTaskStatus.analyzingRequest:
        return Colors.blue;
      case UpdateDataTaskStatus.waitingTranscription:
      case UpdateDataTaskStatus.waitingAnalysis:
        return Colors.orange;
      case UpdateDataTaskStatus.transcriptionReady:
      case UpdateDataTaskStatus.analysisReady:
        return Colors.green;
      case UpdateDataTaskStatus.completed:
        return Colors.teal;
      case UpdateDataTaskStatus.failed:
        return Colors.red;
    }
  }

  // 获取状态图标
  IconData _getStatusIcon(UpdateDataTask task) {
    switch (task.status) {
      case UpdateDataTaskStatus.idle:
        return Icons.play_circle_outline;
      case UpdateDataTaskStatus.preparing:
        return Icons.folder_open;
      case UpdateDataTaskStatus.uploading:
        return Icons.cloud_upload;
      case UpdateDataTaskStatus.waitingTranscription:
        return Icons.hourglass_empty;
      case UpdateDataTaskStatus.transcriptionReady:
        return Icons.description;
      case UpdateDataTaskStatus.analyzingRequest:
        return Icons.analytics;
      case UpdateDataTaskStatus.waitingAnalysis:
        return Icons.hourglass_bottom;
      case UpdateDataTaskStatus.analysisReady:
        return Icons.assessment;
      case UpdateDataTaskStatus.completed:
        return Icons.check_circle;
      case UpdateDataTaskStatus.failed:
        return Icons.error;
    }
  }
}
