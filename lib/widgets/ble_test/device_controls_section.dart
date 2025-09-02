import 'package:flutter/material.dart';
import 'common_widgets.dart';

class DeviceControlsSection extends StatelessWidget {
  final bool isInitialized;
  final bool isScanning;
  final String connectionState;
  final VoidCallback? onStartScan;
  final VoidCallback? onStopScan;
  final VoidCallback? onDisconnect;
  final VoidCallback? onForgetDevice;
  final VoidCallback? onGetInfo;
  final VoidCallback? onGetStats;
  final VoidCallback? onDebugLog;

  const DeviceControlsSection({
    super.key,
    required this.isInitialized,
    required this.isScanning,
    required this.connectionState,
    required this.onStartScan,
    required this.onStopScan,
    required this.onDisconnect,
    required this.onForgetDevice,
    required this.onGetInfo,
    required this.onGetStats,
    required this.onDebugLog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device Controls',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BleActionButton(
                onPressed: !isInitialized ? null : (isScanning ? onStopScan : onStartScan),
                icon: isScanning ? Icons.stop : Icons.bluetooth_searching,
                label: isScanning ? 'Stop Scan' : 'Start Scan',
                isPrimary: !isScanning,
              ),
              BleActionButton(
                onPressed: connectionState == 'idle' ? null : onDisconnect,
                icon: Icons.bluetooth_disabled,
                label: 'Disconnect',
              ),
              BleActionButton(
                onPressed: onForgetDevice,
                icon: Icons.delete_outline,
                label: 'Forget Device',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          const Text(
            'Diagnostics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BleActionButton(
                onPressed: onGetInfo,
                icon: Icons.info_outline,
                label: 'Get Info',
              ),
              BleActionButton(
                onPressed: onGetStats,
                icon: Icons.analytics_outlined,
                label: 'Get Stats',
              ),
              BleActionButton(
                onPressed: onDebugLog,
                icon: Icons.bug_report_outlined,
                label: 'Debug Log',
              ),
            ],
          ),
        ],
      ),
    );
  }
}