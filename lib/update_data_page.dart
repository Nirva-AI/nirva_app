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

  // 定义过滤列表，可以根据需要进行修改
  static const Set<String> _filteredExtensions = {
    '.hive',
    '.lock',
    '.Trash',
    '.DS_Store', // macOS系统文件
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

  // 加载应用自身文档目录中的文件，添加过滤功能
  Future<void> _loadAppFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();

    // 应用过滤规则
    final filteredFiles =
        allFiles.where((file) {
          final fileName = file.path.split('/').last;

          // 检查是否应该过滤此文件
          for (final extension in _filteredExtensions) {
            if (fileName.endsWith(extension) || fileName == extension) {
              return false;
            }
          }

          return true;
        }).toList();

    if (!mounted) return;

    setState(() {
      _files.clear();
      _files.addAll(filteredFiles);
    });
  }

  // 从iOS文件应用选择文件并直接读取内容
  Future<void> _pickFileFromiOSFilesAndHandle() async {
    try {
      final selectedFile = await _pickFile();
      if (selectedFile == null) return;

      final (file, fileName, newPath) = selectedFile;
      final content = await _readFileContent(newPath, fileName);
      if (content == null) return;

      await _processFileContent(fileName, content, newPath);
      await _loadAppFiles(); // 刷新文件列表
      _loadTasks(); // 刷新任务列表
    } catch (e) {
      Logger().d('Error selecting or importing file: $e');
      if (!mounted) return;

      setState(() {});
      _showSnackBar('Failed to select or import file: $e');
    }
  }

  // 选择文件并复制到应用文档目录
  Future<(File, String, String)?> _pickFile() async {
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
        _showSnackBar('File does not exist');
        return null;
      }

      final content = await copiedFile.readAsString();

      // 在控制台记录日志
      Logger().d('File imported and read: $fileName');
      Logger().d('File path: $filePath');
      Logger().d(
        'File content preview: ${content.length > 100 ? '${content.substring(0, 100)}...' : content}',
      );

      return content;
    } catch (readError) {
      Logger().d('Error reading file: $readError');
      if (mounted) {
        setState(() {});
        _showSnackBar('File imported, but failed to read');
      }
      return null;
    }
  }

  // 处理文件内容
  Future<void> _processFileContent(
    String fileName,
    String content,
    String filePath,
  ) async {
    // 解析文件名
    final parsedData = Utils.parseDataFromSpecialUploadFilename(fileName);

    if (parsedData == null) {
      Logger().d('Failed to parse filename or content');
      _updateUIAfterProcess(
        filePath,
        content,
        'Imported and read: $fileName (not parsed)',
      );
      return;
    }

    Logger().d('Parsed data: $parsedData');

    // 尝试上传转录数据
    await _uploadAndAnalyzeData(content, parsedData, fileName);
    _updateUIAfterProcess(filePath, content, 'Imported and read: $fileName');
  }

  // 上传和分析数据
  Future<void> _uploadAndAnalyzeData(
    String content,
    Tuple3<DateTime, int, String> parsedData,
    String fileName,
  ) async {
    final uploadResponse = await APIs.uploadTranscript(
      content,
      JournalFile.dateTimeToKey(parsedData.item1),
      parsedData.item2,
      parsedData.item3,
    );

    if (uploadResponse == null) {
      Logger().d('Failed to upload transcript data');
      return;
    }

    Logger().d(
      'Successfully uploaded transcript data: ${uploadResponse.message}',
    );

    // 尝试分析数据 BackgroundTaskResponse
    final backgroundTaskResponse = await APIs.analyze(
      JournalFile.dateTimeToKey(parsedData.item1),
      parsedData.item2,
    );

    if (backgroundTaskResponse != null) {
      Logger().d('Data analysis successful');

      AppRuntimeContext().storage.addUpdateDataTask(
        UpdateDataTask(
          id: backgroundTaskResponse.task_id,
          fileName: fileName,
          status: 0,
        ),
      );

      // 刷新任务列表
      _loadTasks();
    } else {
      Logger().d('Data analysis failed');
    }
  }

  // 更新UI显示
  void _updateUIAfterProcess(String filePath, String content, String message) {
    if (!mounted) return;

    setState(() {});

    _showSnackBar(message);
  }

  // 显示提示信息
  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // 获取结果
  Future<void> _getResults(String taskId, String fileName) async {
    try {
      // 获取文件名和时间戳
      final parsedData = Utils.parseDataFromSpecialUploadFilename(fileName);
      if (parsedData == null) {
        Logger().d('Failed to parse filename or content');
        _showSnackBar('Failed to parse filename or content');
        return;
      }
      Logger().d('Parsed data: $parsedData');

      // 获取结果
      final journalFile = await APIs.getJournalFile(
        JournalFile.dateTimeToKey(parsedData.item1),
      );

      if (journalFile != null) {
        //_showSnackBar('Results retrieved successfully');

        //
        await AppRuntimeContext().storage.updateUpdateDataTaskStatus(taskId, 1);

        setState(() {});
      } else {
        _showSnackBar('Failed to retrieve results');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  // 删除任务
  Future<void> _deleteTask(String id, String fileName) async {
    await AppRuntimeContext().storage.deleteUpdateDataTask(id, fileName);
    _loadTasks(); // 刷新任务列表
    _showSnackBar('Task deleted: $fileName');
  }

  // 构建任务卡片
  Widget _buildTaskCard(UpdateDataTask task) {
    String statusText = 'unknown';
    Color statusColor = Colors.grey;

    switch (task.status) {
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
    }

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
                Text('Task ID: ', style: const TextStyle(fontSize: 12)),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      statusColor.r.toInt(),
                      statusColor.g.toInt(),
                      statusColor.b.toInt(),
                      0.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'View Results',
                      onPressed: () => _getResults(task.id, task.fileName),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Update Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // 添加新的"+"按钮
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _pickFileFromiOSFilesAndHandle();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 任务列表标题
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'Update Data Task List',
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
                Text('Total: ${_tasks.length} tasks'),
              ],
            ),
          ),

          // 任务列表
          Expanded(
            flex: 3,
            child:
                _tasks.isEmpty
                    ? const Center(
                      child: Text(
                        'No tasks yet.\nClick the "+" button in the top right to add data',
                      ),
                    )
                    : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(_tasks[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
