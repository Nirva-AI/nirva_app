import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'models/hardware_device.dart';
import 'services/hardware_service.dart';

import 'hardware_recording_page.dart';

class HardwareDevicePage extends StatefulWidget {
  const HardwareDevicePage({super.key});

  @override
  State<HardwareDevicePage> createState() => _HardwareDevicePageState();
}

class _HardwareDevicePageState extends State<HardwareDevicePage> {
  Timer? _scanTimer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHardware();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeHardware() async {
    try {
      final hardwareService = context.read<HardwareService>();
      
      // Request permissions
      final hasPermissions = await hardwareService.requestPermissions();
      if (!hasPermissions) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Bluetooth permissions are required. Please grant permission when prompted.'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => _initializeHardware(),
              ),
            ),
          );
        }
        return;
      }
      
      setState(() {
        _isInitialized = true;
      });
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing hardware: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _initializeHardware(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hardware Devices'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Consumer<HardwareService>(
            builder: (context, hardwareService, child) {
              return IconButton(
                icon: Icon(
                  hardwareService.isScanning ? Icons.stop : Icons.search,
                ),
                onPressed: hardwareService.isScanning
                    ? () => hardwareService.stopScan()
                    : () => _startScan(hardwareService),
                tooltip: hardwareService.isScanning ? 'Stop Scan' : 'Start Scan',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => _navigateToRecordings(),
            tooltip: 'Recordings',
          ),
        ],
      ),
      body: !_isInitialized
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Initializing hardware...'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeHardware,
                    child: const Text('Retry Permission Check'),
                  ),
                ],
              ),
            )
          : Consumer<HardwareService>(
              builder: (context, hardwareService, child) {
                return Column(
                  children: [
                    // Bluetooth status
                    _buildBluetoothStatus(hardwareService),
                    
                    // Connection status
                    if (hardwareService.isConnected)
                      _buildConnectionStatus(hardwareService),
                    
                    // Device list
                    Expanded(
                      child: _buildDeviceList(hardwareService),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildBluetoothStatus(HardwareService hardwareService) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (hardwareService.bluetoothState) {
      case BluetoothAdapterState.on:
        statusColor = Colors.green;
        statusText = 'Bluetooth Enabled';
        statusIcon = Icons.bluetooth_connected;
        break;
      case BluetoothAdapterState.off:
        statusColor = Colors.red;
        statusText = 'Bluetooth Disabled';
        statusIcon = Icons.bluetooth_disabled;
        break;
      case BluetoothAdapterState.turningOn:
        statusColor = Colors.orange;
        statusText = 'Bluetooth Turning On...';
        statusIcon = Icons.bluetooth_searching;
        break;
      case BluetoothAdapterState.turningOff:
        statusColor = Colors.orange;
        statusText = 'Bluetooth Turning Off...';
        statusIcon = Icons.bluetooth_searching;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Bluetooth Unknown';
        statusIcon = Icons.bluetooth;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: statusColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (hardwareService.bluetoothState == BluetoothAdapterState.off)
            ElevatedButton(
              onPressed: () => _enableBluetooth(),
              child: const Text('Enable'),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(HardwareService hardwareService) {
    final device = hardwareService.connectedDevice;
    if (device == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.device_hub, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected to: ${device.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (device.connectedAt != null)
                  Text(
                    'Connected: ${_formatDateTime(device.connectedAt!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _disconnectDevice(hardwareService),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(HardwareService hardwareService) {
    if (hardwareService.discoveredDevices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_searching,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              hardwareService.isScanning
                  ? 'Scanning for devices...'
                  : 'No devices found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            if (!hardwareService.isScanning) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _startScan(hardwareService),
                child: const Text('Start Scan'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: hardwareService.discoveredDevices.length,
      itemBuilder: (context, index) {
        final device = hardwareService.discoveredDevices[index];
        return _buildDeviceTile(hardwareService, device);
      },
    );
  }

  Widget _buildDeviceTile(HardwareService hardwareService, HardwareDevice device) {
    final isConnected = hardwareService.isConnected && 
                       hardwareService.connectedDevice?.id == device.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isConnected ? Colors.green : Colors.blue,
          child: Icon(
            isConnected ? Icons.device_hub : Icons.bluetooth,
            color: Colors.white,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${device.id.substring(0, 8)}...'),
            Text('RSSI: ${device.rssi} dBm'),
            Text('Discovered: ${_formatDateTime(device.discoveredAt)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnected) ...[
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
            ],
            ElevatedButton(
              onPressed: isConnected
                  ? null
                  : () => _connectToDevice(hardwareService, device),
              child: Text(isConnected ? 'Connected' : 'Connect'),
            ),
          ],
        ),
        onTap: () => _showDeviceDetails(device),
      ),
    );
  }

  void _startScan(HardwareService hardwareService) async {
    try {
      await hardwareService.startScan(timeout: const Duration(seconds: 15));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scanning for hardware devices...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting scan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _connectToDevice(HardwareService hardwareService, HardwareDevice device) async {
    try {
      await hardwareService.connectToDevice(device);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${device.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error connecting to device: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _disconnectDevice(HardwareService hardwareService) async {
    try {
      await hardwareService.disconnect();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device disconnected'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error disconnecting: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _enableBluetooth() async {
    try {
      // This would typically open Bluetooth settings
      // For now, show a message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable Bluetooth in your device settings'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error enabling Bluetooth: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeviceDetails(HardwareDevice device) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _DeviceDetailsSheet(device: device),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  void _navigateToRecordings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HardwareAudioPage(),
      ),
    );
  }
}

class _DeviceDetailsSheet extends StatelessWidget {
  final HardwareDevice device;

  const _DeviceDetailsSheet({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.device_hub, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hardware Device',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailRow('Device ID', device.id),
          _buildDetailRow('Address', device.address),
          _buildDetailRow('RSSI', '${device.rssi} dBm'),
          _buildDetailRow('Discovered', _formatDateTime(device.discoveredAt)),
          if (device.lastSeenAt != null)
            _buildDetailRow('Last Seen', _formatDateTime(device.lastSeenAt!)),
          if (device.connectedAt != null)
            _buildDetailRow('Connected', _formatDateTime(device.connectedAt!)),
          if (device.batteryLevel != null)
            _buildDetailRow('Battery', '${device.batteryLevel}%'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
