import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到 MePage
          },
        ),
      ),
      body: Column(
        children: [
          // 头像部分
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  onPressed: () {
                    debugPrint('Change profile picture tapped');
                  },
                ),
              ],
            ),
          ),

          // 名称和登录管理部分
          Expanded(
            child: ListView(
              children: [
                // Name
                ListTile(
                  title: const Text('Account Name'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppRuntimeContext().user.username,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    debugPrint('Name tapped');
                  },
                ),
                const Divider(height: 1),

                // Nick Name
                ListTile(
                  title: const Text('Nick Name'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppRuntimeContext().user.displayName,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    debugPrint('Nick Name tapped');
                  },
                ),
                const Divider(height: 1),

                // Manage My Logins
                ListTile(
                  title: const Text('Manage My Logins'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppRuntimeContext().dio.options.baseUrl,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    debugPrint('Manage My Logins tapped');
                  },
                ),
                const Divider(height: 1),

                // Log Out 按钮
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () {
                        // 使用 SnackBar 显示消息而不是 debugPrint
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logging out...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('Log Out'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*

*/
