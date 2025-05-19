import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到 MePage
          },
        ),
      ),
      body: const Center(
        child: Text('User Profile Page', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
