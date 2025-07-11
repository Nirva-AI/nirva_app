import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
  Future<void> _addUpdateDataTask() async {
    try {} catch (e) {
      Logger().d('Error in file selection process: $e');
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
            icon: const Icon(Icons.add),
            onPressed: _addUpdateDataTask,
          ),
        ],
      ),
    );
  }
}


/*

*/