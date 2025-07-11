import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/update_data_task.dart';

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

  @override
  void initState() {
    super.initState();
  } // 创建或添加文件到任务

  Future<void> _createUpdateDataTask() async {
    if (_isCreatingTask) return;

    setState(() {
      _isCreatingTask = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.paths.first != null) {
        final selectedFilePath = result.paths.first!;

        if (_updateDataTask == null) {
          // 创建新任务
          await _createNewTask(selectedFilePath);
        } else {
          // 添加文件到现有任务
          await _addFileToExistingTask(selectedFilePath);
        }
      } else {
        Logger().d('用户取消了文件选择');
      }
    } catch (e) {
      Logger().e('处理文件时出错: $e');
      _showErrorDialog('处理文件失败: $e');
    } finally {
      setState(() {
        _isCreatingTask = false;
      });
    }
  }

  // 创建新任务
  Future<void> _createNewTask(String filePath) async {
    // 获取用户ID
    final userId = AppRuntimeContext().runtimeData.user.id;

    if (userId.isEmpty) {
      _showErrorDialog('用户ID为空，请确保已登录');
      return;
    }

    // 创建 UpdateDataTask 实例
    _updateDataTask = UpdateDataTask(
      userId: userId,
      assetFileNames: [], // 不使用 assets 文件
      pickedFileNames: [filePath], // 单个文件
    );

    setState(() {});

    Logger().d('创建新任务: ${_updateDataTask.toString()}');
    Logger().d('初始文件: $filePath');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任务创建成功！'), backgroundColor: Colors.green),
      );
    }
  }

  // 添加文件到现有任务
  Future<void> _addFileToExistingTask(String filePath) async {
    if (_updateDataTask == null) return;

    // 检查任务状态，只有在idle状态才能添加文件
    if (_updateDataTask!.status != UpdateDataTaskStatus.idle) {
      _showErrorDialog('任务已开始，无法添加新文件。请先重置任务或创建新任务。');
      return;
    }

    // 检查文件是否已存在
    if (_updateDataTask!.pickedFileNames.contains(filePath)) {
      _showErrorDialog('该文件已在任务中，无需重复添加。');
      return;
    }

    // 创建新的任务实例（因为pickedFileNames是final的）
    final newPickedFiles = [..._updateDataTask!.pickedFileNames, filePath];

    _updateDataTask = UpdateDataTask(
      userId: _updateDataTask!.userId,
      assetFileNames: _updateDataTask!.assetFileNames,
      pickedFileNames: newPickedFiles,
    );

    setState(() {});

    Logger().d('文件添加成功: $filePath');
    Logger().d('当前文件总数: ${_updateDataTask!.pickedFileNames.length}');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '文件添加成功！当前共 ${_updateDataTask!.pickedFileNames.length} 个文件',
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
            title: const Text('错误'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }

  // 删除任务
  void _removeTask() {
    setState(() {
      _updateDataTask = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任务已删除'), backgroundColor: Colors.orange),
      );
    }
  }

  // 重置任务
  void _resetTask() {
    if (_updateDataTask == null) return;

    _updateDataTask!.reset();
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('任务已重置'), backgroundColor: Colors.blue),
      );
    }
  }

  // 执行转录上传
  Future<void> _executeTranscriptionUpload(UpdateDataTask task) async {
    try {
      final success = await task.executeTranscriptionUpload();
      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('转录上传成功，等待转录完成...'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        _showErrorDialog('转录上传失败: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('转录上传异常: $e');
      _showErrorDialog('转录上传异常: $e');
      setState(() {});
    }
  }

  // 获取转录结果
  Future<void> _getTranscriptionResults(UpdateDataTask task) async {
    try {
      final success = await task.getTranscriptionResults();
      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('转录结果获取成功'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showErrorDialog('获取转录结果失败: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('获取转录结果异常: $e');
      _showErrorDialog('获取转录结果异常: $e');
      setState(() {});
    }
  }

  // 执行分析请求
  Future<void> _executeAnalysisRequest(UpdateDataTask task) async {
    try {
      final success = await task.executeAnalysisRequest();
      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('分析请求发送成功，等待分析完成...'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        _showErrorDialog('分析请求失败: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('分析请求异常: $e');
      _showErrorDialog('分析请求异常: $e');
      setState(() {});
    }
  }

  // 获取分析结果
  Future<void> _getAnalysisResults(UpdateDataTask task) async {
    try {
      final success = await task.getAnalysisResults();
      setState(() {});

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('分析结果获取成功，流程完成！'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // 如果有分析结果，可以添加到全局数据中
        if (task.analysisResult != null) {
          AppRuntimeContext().addJournalFile(task.analysisResult!);
          Logger().d('分析结果已添加到全局数据');
        }
      } else {
        _showErrorDialog('获取分析结果失败: ${task.errorMessage}');
      }
    } catch (e) {
      Logger().e('获取分析结果异常: $e');
      _showErrorDialog('获取分析结果异常: $e');
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
              content: Text('文件清理完成'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('文件清理部分失败'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      Logger().e('清理文件异常: $e');
      _showErrorDialog('清理文件异常: $e');
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
          ),
        ],
      ),
      body: _updateDataTask == null ? _buildEmptyState() : _buildTaskView(),
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
            '暂无任务',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '点击右上角的 + 按钮选择音频文件开始',
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
            // 任务头部信息
            _buildTaskHeader(task, index),
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

  // 构建任务头部
  Widget _buildTaskHeader(UpdateDataTask task, int index) {
    return Row(
      children: [
        // 状态图标
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(task).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _getStatusIcon(task),
            color: _getStatusColor(task),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

        // 任务信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '任务 ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '用户: ${task.userId}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '文件数: ${task.pickedFileNames.length}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // 操作按钮
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmDialog();
            } else if (value == 'reset') {
              _resetTask();
            } else if (value == 'add_file') {
              _createUpdateDataTask(); // 复用添加文件的逻辑
            }
          },
          itemBuilder:
              (context) => [
                if (task.status == UpdateDataTaskStatus.idle)
                  const PopupMenuItem(
                    value: 'add_file',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('添加文件'),
                      ],
                    ),
                  ),
                if (task.status != UpdateDataTaskStatus.idle)
                  const PopupMenuItem(
                    value: 'reset',
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('重置任务'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('删除任务'),
                    ],
                  ),
                ),
              ],
          child: const Icon(Icons.more_vert),
        ),
      ],
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
          '操作步骤',
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
                label: const Text('转录上传'),
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
                label: const Text('获取转录'),
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
                label: const Text('分析请求'),
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
                label: const Text('获取分析'),
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
              label: const Text('清理文件'),
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
              '错误: ${task.errorMessage}',
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
                  '转录文件已保存',
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
                  '分析结果已生成',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
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
            title: const Text('确认删除'),
            content: const Text('确定要删除这个任务吗？此操作无法撤销。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _removeTask();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('删除'),
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


/*

*/