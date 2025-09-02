import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/services/hardware_service.dart';

class StatusSection extends StatelessWidget {
  final bool isInitialized;
  final String connectionState;
  final bool isScanning;
  final bool isStreaming;

  const StatusSection({
    super.key,
    required this.isInitialized,
    required this.connectionState,
    required this.isScanning,
    required this.isStreaming,
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
            'Connection Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusRow('Service', isInitialized ? 'Ready' : 'Not initialized', isInitialized),
          _buildStatusRow('Connection', connectionState, connectionState == 'connected'),
          _buildStatusRow('Scanning', isScanning ? 'Active' : 'Inactive', isScanning),
          _buildStatusRow('Streaming', isStreaming ? 'Active' : 'Inactive', isStreaming),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          Consumer<HardwareService>(
            builder: (context, hardwareService, child) {
              final device = hardwareService.connectedDevice;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        device != null ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                        color: device != null ? const Color(0xFF0E3C26) : Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device?.name ?? 'No Device Connected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: device != null ? const Color(0xFF0E3C26) : Colors.grey.shade600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                  if (device != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCard(
                          Icons.battery_full,
                          '${device.batteryLevel}%',
                          'Battery',
                          const Color(0xFF0E3C26),
                        ),
                        _buildMetricCard(
                          Icons.signal_cellular_alt,
                          '${device.rssi} dBm',
                          'Signal',
                          const Color(0xFF0E3C26),
                        ),
                        _buildMetricCard(
                          Icons.mic,
                          'Ready',
                          'Audio',
                          const Color(0xFF0E3C26),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'Georgia',
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFF0E3C26) : Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isActive ? const Color(0xFF0E3C26) : Colors.grey.shade600,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Georgia',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}