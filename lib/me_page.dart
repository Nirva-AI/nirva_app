import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户信息部分
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: const Text(
                'Weiwei',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                debugPrint('User profile tapped');
              },
            ),
            const Divider(),

            // Nirva Necklace 部分
            ListTile(
              leading: const Icon(Icons.water_drop, size: 40, color: Colors.amber),
              title: const Text(
                'Nirva Necklace',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: const [
                  Icon(Icons.circle, size: 8, color: Colors.green),
                  SizedBox(width: 4),
                  Text('Connected', style: TextStyle(color: Colors.green)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('88%', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                debugPrint('Nirva Necklace tapped');
              },
            ),
            const Divider(),

            // 设置选项部分
            _buildSettingsOption(
              icon: Icons.restart_alt,
              title: 'Onboarding',
              subtitle: 'Restart the setup process',
              onTap: () {
                debugPrint('Onboarding tapped');
              },
            ),
            _buildSettingsOption(
              icon: Icons.access_time,
              title: 'Reflection Time',
              subtitle: 'Set when you want daily reflections',
              onTap: () {
                debugPrint('Reflection Time tapped');
              },
            ),
            _buildSettingsOption(
              icon: Icons.privacy_tip,
              title: 'Privacy Controls',
              subtitle: 'Manage your data and sharing preferences',
              onTap: () {
                debugPrint('Privacy Controls tapped');
              },
            ),
            _buildSettingsOption(
              icon: Icons.upload,
              title: 'Update Data',
              subtitle: 'Upload your recorded audio',
              onTap: () {
                debugPrint('Update Data tapped');
              },
            ),
            _buildSettingsOption(
              icon: Icons.settings,
              title: 'Nirva Settings',
              subtitle: 'Customize Nirva\'s voice',
              onTap: () {
                debugPrint('Nirva Settings tapped');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
