import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nirva_app/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/transcribe_file_name.dart';
import 'package:nirva_app/apis.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  @override
  void initState() {
    super.initState();
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
    final transcribeFileName = TranscribeFileName.tryFromFilename(fileName);
    if (transcribeFileName == null) {
      Logger().d('Failed to parse filename or content');
      _showDialog('Invalid file format or name');
      return;
    }

    // 2. 上传数据
    final success = await _uploadAndAnalyzeData(
      content,
      transcribeFileName,
      fileName,
    );

    // 3. 显示结果
    if (success) {
    } else {
      _showDialog('Failed to process file');
    }
  }

  // 上传和分析数据
  Future<bool> _uploadAndAnalyzeData(
    String content,
    TranscribeFileName transcribeFileName,
    String fileName,
  ) async {
    // 1. 上传转录数据
    final dateKey = JournalFile.dateTimeToKey(transcribeFileName.dateTime);
    final uploadResponse = await APIs.uploadTranscript(
      content,
      dateKey,
      transcribeFileName.fileNumber,
      transcribeFileName.fileSuffix,
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
      transcribeFileName.fileNumber,
    );

    if (backgroundTaskResponse != null) {
      Logger().d('Data analysis task created');

      return true;
    } else {
      Logger().d('Data analysis failed');
      return false;
    }
  }

  // 获取分析结果
  // ignore: unused_element
  Future<void> _getTaskResults(String taskId, String fileName) async {
    try {
      // 解析文件名获取日期信息
      final transcribeFileName = TranscribeFileName.tryFromFilename(fileName);
      if (transcribeFileName == null) {
        _showDialog('Invalid file name format');
        return;
      }

      final dateKey = JournalFile.dateTimeToKey(transcribeFileName.dateTime);
      final journalFile = await APIs.getJournalFile(dateKey);

      if (journalFile != null) {
      } else {
        _showDialog('Failed to retrieve results');
      }
    } catch (e) {
      Logger().d('Error retrieving task results: $e');
      _showDialog('Error: $e');
    }
  }

  // 删除任务
  // ignore: unused_element
  Future<void> _deleteTask(String id, String fileName) async {
    try {} catch (e) {
      Logger().d('Error deleting task: $e');
      _showDialog('Failed to delete task');
    }
  }

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
    );
  }
}
