import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nirva_app/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/utils.dart';
import 'package:nirva_app/apis.dart';
import 'package:tuple/tuple.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final List<FileSystemEntity> _files = [];
  String _selectedFilePath = '';
  String _fileContent = '';
  String _taskId = '';

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
  }

  // 加载应用自身文档目录中的文件，添加过滤功能
  Future<void> _loadAppFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();

    // 应用过滤规则
    final filteredFiles =
        allFiles.where((file) {
          // 如果显示所有文件，则不过滤
          //if (_showFilteredFiles) return true;

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
    } catch (e) {
      Logger().d('选择或导入文件出错: $e');
      if (!mounted) return;

      setState(() {
        _fileContent = '选择文件出错: $e';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('选择文件失败')));
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
        Logger().d('文件不存在: $filePath');
        _showSnackBar('文件不存在');
        return null;
      }

      final content = await copiedFile.readAsString();

      // 在控制台记录日志
      Logger().d('文件已导入并读取: $fileName');
      Logger().d('文件路径: $filePath');
      Logger().d(
        '文件内容预览: ${content.length > 100 ? '${content.substring(0, 100)}...' : content}',
      );

      return content;
    } catch (readError) {
      Logger().d('读取文件出错: $readError');
      if (mounted) {
        setState(() {
          _selectedFilePath = filePath;
          _fileContent = '读取文件出错: $readError';
        });
        _showSnackBar('文件已导入，但读取失败');
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
      Logger().d('未能解析文件名或内容');
      _updateUIAfterProcess(filePath, content, '已导入并读取: $fileName (未解析)');
      return;
    }

    Logger().d('解析后的数据: $parsedData');

    // 尝试上传转录数据
    await _uploadAndAnalyzeData(content, parsedData);
    _updateUIAfterProcess(filePath, content, '已导入并读取: $fileName');
  }

  // 上传和分析数据
  Future<void> _uploadAndAnalyzeData(
    String content,
    Tuple3<DateTime, int, String> parsedData,
  ) async {
    final uploadResponse = await APIs.uploadTranscript(
      content,
      //parsedData.item1.toIso8601String(),
      JournalFile.dateTimeToKey(parsedData.item1),
      parsedData.item2,
      parsedData.item3,
    );

    if (uploadResponse == null) {
      Logger().d('上传转录数据失败');
      return;
    }

    Logger().d('上传转录数据成功: ${uploadResponse.message}');

    // 尝试分析数据 BackgroundTaskResponse
    final backgroundTaskResponse = await APIs.analyze(
      JournalFile.dateTimeToKey(parsedData.item1),
      parsedData.item2,
    );

    if (backgroundTaskResponse != null) {
      Logger().d('分析数据成功');
      _taskId = backgroundTaskResponse.task_id;
    } else {
      Logger().d('分析数据失败');
    }
  }

  // 更新UI显示
  void _updateUIAfterProcess(String filePath, String content, String message) {
    if (!mounted) return;

    setState(() {
      _selectedFilePath = filePath;
      _fileContent =
          content.length > 1000
              ? '${content.substring(0, 1000)}...(内容过长，已截断)'
              : content;
    });

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
  Future<void> _getResults() async {
    if (_selectedFilePath.isEmpty) {
      _showSnackBar('请先导入文件');
      return;
    }

    try {
      // 获取文件名和时间戳
      final fileName = _selectedFilePath.split('/').last;
      final parsedData = Utils.parseDataFromSpecialUploadFilename(fileName);
      if (parsedData == null) {
        Logger().d('未能解析文件名或内容');
        return;
      }
      Logger().d('解析后的数据: $parsedData');

      if (_taskId != '') {
        // 如果记录了任务ID，检查任务状态，
        final taskStatus = await APIs.getTaskStatus(_taskId);
        if (taskStatus == null) {
          _showSnackBar('任务状态获取失败');
          return;
        }

        final status = taskStatus["status"];
        Logger().d('任务状态: $status');
        if (status == 'pending' || status == 'processing') {
          _showSnackBar('任务仍在进行中，请稍后再试');
          return;
        } else if (status == 'failed') {
          _showSnackBar('任务执行失败，请检查日志');
          return;
        } else if (status != 'completed') {
          _showSnackBar('未知任务状态: $status');
          return;
        }
      }

      // 获取结果
      final journalFile = await APIs.getJournalFile(
        JournalFile.dateTimeToKey(parsedData.item1),
      );
      if (journalFile != null) {
        setState(() {
          _showSnackBar('获取结果成功');
          _fileContent = jsonEncode(journalFile.toJson());
        });
      }
    } catch (e) {
      _showSnackBar('异常提示: $e');
    }
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: _pickFileFromiOSFilesAndHandle,
                      child: const Text(
                        'Pick From iOS Files',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: _getResults,
                      child: const Text(
                        'Check Results',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          const Divider(),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select File: ${_selectedFilePath.isEmpty ? 'None' : _selectedFilePath.split('/').last}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Path: $_selectedFilePath'),
                  const SizedBox(height: 16),
                  const Text(
                    'File Content:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: double.infinity,
                    child: Text(_fileContent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
