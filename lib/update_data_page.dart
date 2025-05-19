import 'package:flutter/material.dart';

class UpdateDataPage extends StatelessWidget {
  const UpdateDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到 MePage
          },
        ),
      ),
      body: const Center(
        child: Text('Update Data Page', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
