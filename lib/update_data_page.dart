import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/utils.dart';
import 'package:nirva_app/apis.dart';
import 'package:tuple/tuple.dart';
import 'package:nirva_app/hive_object.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final List<FileSystemEntity> _files = [];
  List<UpdateDataTask> _tasks = [];

  // 定义过滤列表
  static const Set<String> _filteredExtensions = {
    '.hive',
    '.lock',
    '.Trash',
    '.DS_Store',
    '.log',
  };

  @override
  void initState() {
    super.initState();
    _loadAppFiles();
    _loadTasks();
  }

  // 加载更新数据任务列表
  void _loadTasks() {
    setState(() {
      _tasks = AppRuntimeContext().storage.getAllUpdateDataTasks();
    });
  }

  // 加载并过滤应用文档目录中的文件
  Future<void> _loadAppFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final allFiles = directory.listSync();

      final filteredFiles = allFiles.where(_shouldIncludeFile).toList();

      if (!mounted) return;

      setState(() {
        _files.clear();
        _files.addAll(filteredFiles);
      });
    } catch (e) {
      Logger().d('Error loading app files: $e');
      _showDialog('Failed to load app files');
    }
  }

  // 文件过滤逻辑
  bool _shouldIncludeFile(FileSystemEntity file) {
    final fileName = file.path.split('/').last;

    for (final extension in _filteredExtensions) {
      if (fileName.endsWith(extension) || fileName == extension) {
        return false;
      }
    }
    return true;
  }

  // 处理文件选择流程
  Future<void> _handleFileSelection() async {
    try {
      // 1. 选择文件
      final selectedFileResult = await _selectAndImportFile();
      if (selectedFileResult == null) return;

      final (file, fileName, newPath) = selectedFileResult;

      // 2. 读取文件内容
      final content = await _readFileContent(newPath, fileName);
      if (content == null) return;

      // 3. 处理文件内容
      await _processFileContent(fileName, content);

      // 4. 刷新UI
      await _loadAppFiles();
      _loadTasks();
    } catch (e) {
      Logger().d('Error in file selection process: $e');
      _showDialog('Error processing file: $e');
    }
  }

  // 选择并导入文件到应用目录
  Future<(File, String, String)?> _selectAndImportFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    // 复制文件到应用文档目录
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = '${appDir.path}/$fileName';
    await file.copy(newPath);

    return (file, fileName, newPath);
  }

  // 读取文件内容
  Future<String?> _readFileContent(String filePath, String fileName) async {
    try {
      final copiedFile = File(filePath);
      if (!await copiedFile.exists()) {
        Logger().d('File does not exist: $filePath');
        _showDialog('File does not exist');
        return null;
      }

      final content = await copiedFile.readAsString();
      Logger().d('File imported: $fileName');
      return content;
    } catch (readError) {
      Logger().d('Error reading file: $readError');
      _showDialog('Failed to read file content');
      return null;
    }
  }

  // 处理文件内容
  Future<void> _processFileContent(String fileName, String content) async {
    // 1. 解析文件名
    final parsedData = Utils.parseDataFromSpecialUploadFilename(fileName);
    if (parsedData == null) {
      Logger().d('Failed to parse filename or content');
      _showDialog('Invalid file format or name');
      return;
    }

    // 2. 上传数据
    final success = await _uploadAndAnalyzeData(content, parsedData, fileName);

    // 3. 显示结果
    if (success) {
      //_showSnackBar('File processed successfully');
    } else {
      _showDialog('Failed to process file');
    }
  }

  // 上传和分析数据
  Future<bool> _uploadAndAnalyzeData(
    String content,
    Tuple3<DateTime, int, String> parsedData,
    String fileName,
  ) async {
    // 1. 上传转录数据
    final dateKey = JournalFile.dateTimeToKey(parsedData.item1);
    final uploadResponse = await APIs.uploadTranscript(
      content,
      dateKey,
      parsedData.item2,
      parsedData.item3,
    );

    if (uploadResponse == null) {
      Logger().d('Failed to upload transcript data');
      return false;
    }

    Logger().d(
      'Successfully uploaded transcript data: ${uploadResponse.message}',
    );

    // 2. 分析数据
    final backgroundTaskResponse = await APIs.analyze(
      dateKey,
      parsedData.item2,
    );

    if (backgroundTaskResponse != null) {
      Logger().d('Data analysis task created');

      // 添加任务到本地存储
      AppRuntimeContext().storage.addUpdateDataTask(
        UpdateDataTask(
          id: backgroundTaskResponse.task_id,
          fileName: fileName,
          status: 0, // 处理中
        ),
      );

      return true;
    } else {
      Logger().d('Data analysis failed');
      return false;
    }
  }

  // 获取分析结果
  Future<void> _getTaskResults(String taskId, String fileName) async {
    try {
      // 解析文件名获取日期信息
      final parsedData = Utils.parseDataFromSpecialUploadFilename(fileName);
      if (parsedData == null) {
        _showDialog('Invalid file name format');
        return;
      }

      final dateKey = JournalFile.dateTimeToKey(parsedData.item1);
      final journalFile = await APIs.getJournalFile(dateKey);

      if (journalFile != null) {
        // 更新任务状态为已完成
        await AppRuntimeContext().storage.updateUpdateDataTaskStatus(taskId, 1);
        _loadTasks();
        //_showSnackBar('Results retrieved successfully');
      } else {
        _showDialog('Failed to retrieve results');
      }
    } catch (e) {
      Logger().d('Error retrieving task results: $e');
      _showDialog('Error: $e');
    }
  }

  // 删除任务
  Future<void> _deleteTask(String id, String fileName) async {
    try {
      await AppRuntimeContext().storage.deleteUpdateDataTask(id, fileName);
      _loadTasks();
      //_showSnackBar('Task deleted: $fileName');
    } catch (e) {
      Logger().d('Error deleting task: $e');
      _showDialog('Failed to delete task');
    }
  }

  // 更轻量级的模态提示 - 自动消失
  // 显示提示信息 - 使用模态对话框替代SnackBar
  void _showDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // 构建任务状态指示器
  Widget _buildStatusIndicator(int status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = 'processing';
        statusColor = Colors.blue;
        break;
      case 1:
        statusText = 'completed';
        statusColor = Colors.green;
        break;
      case -1:
        statusText = 'failed';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'unknown';
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(
          (0.2 * 255).round(),
        ), // 修改此行，使用withAlpha替代withOpacity
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: statusColor, fontSize: 12),
      ),
    );
  }

  // 构建任务卡片
  Widget _buildTaskCard(UpdateDataTask task) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filename: ${task.fileName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Task ID: ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    task.id,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusIndicator(task.status),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'View Results',
                      onPressed: () => _getTaskResults(task.id, task.fileName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete Task',
                      onPressed: () => _deleteTask(task.id, task.fileName),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建空任务提示
  Widget _buildEmptyTasksMessage() {
    return const Center(
      child: Text(
        'No tasks yet.\nClick the "+" button in the top right to add data',
        textAlign: TextAlign.center,
      ),
    );
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
            icon: const Icon(Icons.add),
            onPressed: _handleFileSelection,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child:
                _tasks.isEmpty
                    ? _buildEmptyTasksMessage()
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder:
                          (context, index) => _buildTaskCard(_tasks[index]),
                    ),
          ),
        ],
      ),
    );
  }
}
