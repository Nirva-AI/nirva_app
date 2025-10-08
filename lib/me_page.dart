import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/user_profile_page.dart';
// DISABLED: Old Amplify-based update data page
// import 'package:nirva_app/update_data_page.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/providers/events_provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/providers/notes_provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/hive_data_viewer_page.dart';
import 'package:nirva_app/mini_call_bar.dart';
import 'package:nirva_app/lifecycle_logs_page.dart';
import 'package:nirva_app/services/hardware_service.dart';
import 'package:nirva_app/hardware_ble_connection_test.dart';
import 'package:flutter/services.dart';
import 'package:nirva_app/services/native_s3_bridge.dart';
import 'package:nirva_app/services/s3_token_service.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/screens/login_screen.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:logger/logger.dart';

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
            // Navigate to BLE connection test V2 page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HardwareBleConnectionTest(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Consumer<HardwareService>(
            builder: (context, hardwareService, child) {
              final isConnected = hardwareService.isConnected;
              final deviceName = hardwareService.connectedDevice?.name ?? 'Nirva Necklace';
              
              return Column(
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
                            Text(
                              deviceName,
                              style: const TextStyle(
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
                                  decoration: BoxDecoration(
                                    color: isConnected ? Colors.green : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isConnected ? 'Connected' : 'Not Connected',
                                  style: TextStyle(
                                    color: isConnected ? Colors.green : Colors.grey,
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
                  Builder(
                    builder: (context) {
                      final connectedDevice = hardwareService.connectedDevice;
                      final batteryLevel = connectedDevice?.batteryLevel;
                      
                      // Default values when no device is connected
                      final displayBatteryLevel = batteryLevel ?? 0;
                      final batteryValue = displayBatteryLevel / 100.0;
                      final batteryText = isConnected ? '$displayBatteryLevel%' : 'Not Connected';
                      
                      // Choose battery icon and color based on level
                      IconData batteryIcon;
                      Color batteryColor;
                      Color progressColor;
                      if (!isConnected) {
                        batteryIcon = Icons.battery_unknown;
                        batteryColor = Colors.grey;
                        progressColor = Colors.grey;
                      } else if (displayBatteryLevel <= 20) {
                        batteryIcon = Icons.battery_alert;
                        batteryColor = Colors.red;
                        progressColor = Colors.red;
                      } else if (displayBatteryLevel <= 50) {
                        batteryIcon = Icons.battery_3_bar;
                        batteryColor = Colors.orange;
                        progressColor = Colors.orange;
                      } else if (displayBatteryLevel <= 80) {
                        batteryIcon = Icons.battery_5_bar;
                        batteryColor = const Color(0xFF0E3C26);
                        progressColor = const Color(0xFF0E3C26);
                      } else {
                        batteryIcon = Icons.battery_full;
                        batteryColor = Colors.green;
                        progressColor = Colors.green;
                      }
                      
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
                          color: batteryColor,
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progressColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    batteryText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isConnected ? const Color(0xFF0E3C26) : Colors.grey,
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
              
                // Device info and management
                Row(
                  children: [
                    if (isConnected) ...[
                      Icon(
                        Icons.bluetooth,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Device connected',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tap to connect',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E3C26).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isConnected ? 'Tap to manage' : 'Tap to connect',
                        style: const TextStyle(
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
            );
            },
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
              // DISABLED: Old Amplify-based update data feature
              // _buildSettingsItem(
              //   icon: Icons.upload,
              //   title: 'Update Data',
              //   subtitle: 'Upload your recorded audio',
              //   onTap: () {
              //     debugPrint('Update Data tapped');
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const UpdateDataPage(),
              //       ),
              //     );
              //   },
              // ),
              // _buildDivider(),
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
                icon: Icons.settings,
                title: 'Nirva Settings',
                subtitle: 'Customize Nirva\'s voice',
                onTap: () {
                  debugPrint('Nirva Settings tapped');
                },
              ),
              _buildDivider(),
              // Logout button at the bottom
              _buildLogoutItem(),
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

  Widget _buildLogoutItem() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleLogout,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
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
                child: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E3C26),
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sign out of your account',
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
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              fontFamily: 'Georgia',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0E3C26),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    // Perform logout
    try {
      final logger = Logger();
      logger.i('User initiated logout');
      
      // Call logout API
      await NirvaAPI.logout();
      
      // Clear all user data and provider caches
      logger.i('Clearing all user data and provider caches...');
      
      // Clear Hive user data
      await HiveHelper.clearUserData();
      
      // Clear all provider caches
      final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
      eventsProvider.clearAllCaches();
      
      final journalFilesProvider = Provider.of<JournalFilesProvider>(context, listen: false);
      journalFilesProvider.clearData();
      
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
      tasksProvider.clearData();
      
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      notesProvider.clearData();
      
      final chatHistoryProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
      chatHistoryProvider.clearData();
      
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      favoritesProvider.clearData();
      
      // Clear user data last
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUser();
      
      logger.i('Logout successful, all data cleared, navigating to login screen');
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false, // Remove all routes
        );
      }
    } catch (e) {
      final logger = Logger();
      logger.e('Logout failed: $e');
      
      // Even if logout API fails, still navigate to login screen
      // and clear local data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logout failed, but clearing local session'),
            backgroundColor: Colors.orange.shade600,
          ),
        );
        
        // Clear all user data and provider caches even on API failure
        await HiveHelper.clearUserData();
        
        // Clear all provider caches
        final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
        eventsProvider.clearAllCaches();
        
        final journalFilesProvider = Provider.of<JournalFilesProvider>(context, listen: false);
        journalFilesProvider.clearData();
        
        final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
        tasksProvider.clearData();
        
        final notesProvider = Provider.of<NotesProvider>(context, listen: false);
        notesProvider.clearData();
        
        final chatHistoryProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
        chatHistoryProvider.clearData();
        
        final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
        favoritesProvider.clearData();
        
        // Clear user data and navigate to login
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.clearUser();
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    }
  }
}
