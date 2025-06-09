import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:share_plus/share_plus.dart';
//import 'package:nirva_app/app_runtime_context.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final List<FileSystemEntity> _files = [];
  String _selectedFilePath = '';
  String _fileContent = '';

  @override
  void initState() {
    super.initState();
    _loadAppFiles();
  }

  // 加载应用自身文档目录中的文件
  Future<void> _loadAppFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    if (!mounted) return;

    setState(() {
      _files.clear();
      _files.addAll(files);
    });
  }

  // 从iOS文件应用选择文件
  Future<void> _pickFileFromiOSFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        // 复制文件到应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        final newPath = '${appDir.path}/$fileName';
        await file.copy(newPath);

        await _loadAppFiles();

        if (!mounted) return;

        setState(() {
          _selectedFilePath = newPath;
          _fileContent = '选中了文件: $fileName';
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('已导入: $fileName')));
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _fileContent = '选择文件出错: $e';
      });
    }
  }

  // 读取文件内容
  Future<void> _readFileContent(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();

        if (!mounted) return;

        setState(() {
          _selectedFilePath = path;
          _fileContent =
              content.length > 1000
                  ? '${content.substring(0, 1000)}...(内容过长，已截断)'
                  : content;
        });
      } else {
        if (!mounted) return;

        setState(() {
          _fileContent = '文件不存在';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _fileContent = '读取文件出错: $e';
      });
    }
  }

  // 创建示例文本文件
  // Future<void> _createSampleTextFile() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final timestamp = DateTime.now().millisecondsSinceEpoch;
  //     final path = '${directory.path}/sample_file_$timestamp.txt';

  //     final file = File(path);
  //     await file.writeAsString('这是一个样例文件内容，创建于 ${DateTime.now()}');

  //     await _loadAppFiles();

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('已创建示例文件')));
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('创建文件出错: $e')));
  //   }
  // }

  // 导出Hive数据至JSON文件
  // Future<void> _exportHiveDataToJson() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final timestamp = DateTime.now().millisecondsSinceEpoch;
  //     final path = '${directory.path}/hive_data_$timestamp.json';

  //     // 获取Hive数据
  //     final hiveData = AppRuntimeContext().storage.getAllData();
  //     final jsonString = hiveData.toString();

  //     // 写入文件
  //     final file = File(path);
  //     await file.writeAsString(jsonString);

  //     await _loadAppFiles();

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('已导出Hive数据到JSON文件')));
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('导出Hive数据出错: $e')));
  //   }
  // }

  // 分享文件
  // Future<void> _shareFile(String path) async {
  //   try {
  //     await Share.shareXFiles([XFile(path)], text: '文件分享');
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('分享文件出错: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据更新'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到 MePage
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAppFiles),
        ],
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
                      onPressed: _pickFileFromiOSFiles,
                      child: const Text(
                        '从文件应用导入',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //     child: ElevatedButton(
                //       onPressed: _createSampleTextFile,
                //       child: const Text(
                //         '创建示例文件',
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //     child: ElevatedButton(
                //       onPressed: _exportHiveDataToJson,
                //       child: const Text(
                //         '导出Hive数据',
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                final fileName = file.path.split('/').last;
                final isDirectory = file is Directory;

                return ListTile(
                  leading: Icon(
                    isDirectory ? Icons.folder : Icons.insert_drive_file,
                    color: isDirectory ? Colors.amber : Colors.blue,
                  ),
                  title: Text(fileName),
                  subtitle: Text(file.path),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isDirectory)
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () => _readFileContent(file.path),
                        ),
                      // if (!isDirectory)
                      //   IconButton(
                      //     icon: const Icon(Icons.share),
                      //     onPressed: () => _shareFile(file.path),
                      //   ),
                    ],
                  ),
                  onTap: isDirectory ? null : () => _readFileContent(file.path),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选中文件: ${_selectedFilePath.isEmpty ? '无' : _selectedFilePath.split('/').last}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('路径: $_selectedFilePath'),
                  const SizedBox(height: 16),
                  const Text(
                    '文件内容:',
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
