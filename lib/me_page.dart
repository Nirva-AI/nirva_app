import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/user_profile_page.dart';
import 'package:nirva_app/update_data_page.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/hive_data_viewer_page.dart';
import 'package:nirva_app/mini_call_bar.dart';
import 'package:nirva_app/hardware_device_page.dart';
import 'package:nirva_app/lifecycle_logs_page.dart';
import 'package:nirva_app/services/hardware_service.dart';
import 'package:nirva_app/hardware_ble_test_page.dart';
import 'package:nirva_app/hardware_ble_connection_test.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header matching other pages
              const Text(
                'Me',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 32),
              

              
              // Nirva Necklace section
              _buildNirvaNecklaceSection(),
              const SizedBox(height: 32),
              
              // Settings section
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildNirvaNecklaceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf0ebd8),
            Color(0xFFece6d2),
            Color(0xFFe8e2cc),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('Nirva Necklace tapped');
            // Navigate to hardware device page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HardwareDevicePage(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and status
              Row(
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 48,
                    color: Color(0xFFe7bf57),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nirva Necklace',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E3C26),
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Connected',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Battery level indicator
              Consumer<HardwareService>(
                builder: (context, hardwareService, child) {
                  final connectedDevice = hardwareService.connectedDevice;
                  final batteryLevel = connectedDevice?.batteryLevel;
                  final isConnected = hardwareService.isConnected;
                  
                  // Default values when no device is connected
                  final displayBatteryLevel = batteryLevel ?? 0;
                  final batteryValue = displayBatteryLevel / 100.0;
                  final batteryText = isConnected ? '$displayBatteryLevel%' : 'Not Connected';
                  final batteryIcon = isConnected 
                      ? (displayBatteryLevel > 20 ? Icons.battery_full : Icons.battery_alert)
                      : Icons.battery_unknown;
                  
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          batteryIcon,
                          color: const Color(0xFF0E3C26),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Battery Level',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0E3C26),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: isConnected ? batteryValue : 0.0,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF0E3C26),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    batteryText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0E3C26),
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isConnected)
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 16),
                            onPressed: () async {
                              try {
                                await hardwareService.getBatteryLevel();
                                // The service will update the device info automatically
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to refresh battery level: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            tooltip: 'Refresh battery level',
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Last sync info
              Row(
                children: [
                  Icon(
                    Icons.sync,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last synced 2 hours ago',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E3C26).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tap to manage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0E3C26),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsItem(
                icon: Icons.restart_alt,
                title: 'Onboarding',
                subtitle: 'Restart the setup process',
                onTap: () {
                  debugPrint('Onboarding tapped');
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.access_time,
                title: 'Reflection Time',
                subtitle: 'Set when you want daily reflections',
                onTap: () {
                  debugPrint('Reflection Time tapped');
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Controls',
                subtitle: 'Manage your data and sharing preferences',
                onTap: () {
                  debugPrint('Privacy Controls tapped');
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.upload,
                title: 'Update Data',
                subtitle: 'Upload your recorded audio',
                onTap: () {
                  debugPrint('Update Data tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateDataPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.storage,
                title: 'Local Data',
                subtitle: 'View local data stored in Hive',
                onTap: () {
                  debugPrint('Local Data tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HiveDataViewerPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.analytics,
                title: 'App Lifecycle Logs',
                subtitle: 'View app state changes and kill events',
                onTap: () {
                  debugPrint('App Lifecycle Logs tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LifecycleLogsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.bluetooth,
                title: 'BLE Audio Test',
                subtitle: 'Test BLE audio functionality',
                onTap: () {
                  debugPrint('BLE Audio Test tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HardwareBleTestPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.bluetooth_searching,
                title: 'BLE Connection Test (V2)',
                subtitle: 'Test new background BLE connection',
                onTap: () {
                  debugPrint('BLE Connection Test V2 tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HardwareBleConnectionTest(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                icon: Icons.settings,
                title: 'Nirva Settings',
                subtitle: 'Customize Nirva\'s voice',
                onTap: () {
                  debugPrint('Nirva Settings tapped');
                },
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFe7bf57).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: const Color(0xFF0E3C26),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E3C26),
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF0E3C26),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.grey.shade200,
    );
  }
}
