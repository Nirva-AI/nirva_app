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
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf9f5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF0E3C26),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Hardware Devices',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E3C26),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action buttons row
            _buildActionButtons(),
            
            const SizedBox(height: 24),
            
            // Main content
            if (!_isInitialized)
              _buildInitializationState()
            else
              Consumer<HardwareService>(
                builder: (context, hardwareService, child) {
                  return Column(
                    children: [
                      // Bluetooth status card
                      _buildBluetoothStatusCard(hardwareService),
                      
                      const SizedBox(height: 16),
                      
                      // Connection status card
                      if (hardwareService.isConnected)
                        _buildConnectionStatusCard(hardwareService),
                      
                      const SizedBox(height: 24),
                      
                      // Device list section
                      _buildDeviceListSection(hardwareService),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Scan button
        Consumer<HardwareService>(
          builder: (context, hardwareService, child) {
            return Expanded(
              child: Container(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: hardwareService.isScanning
                      ? () => hardwareService.stopScan()
                      : () => _startScan(hardwareService),
                  icon: Icon(
                    hardwareService.isScanning ? Icons.stop : Icons.search,
                    color: Colors.white,
                  ),
                  label: Text(
                    hardwareService.isScanning ? 'Stop Scan' : 'Start Scan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E3C26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(width: 12),
        
        // Recordings button
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToRecordings(),
              icon: const Icon(
                Icons.mic,
                color: Color(0xFF0E3C26),
              ),
              label: const Text(
                'Recordings',
                style: TextStyle(
                  color: Color(0xFF0E3C26),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Color(0xFF0E3C26),
                    width: 2,
                  ),
                ),
                elevation: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitializationState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0E3C26)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Initializing hardware...',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF0E3C26),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initializeHardware,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E3C26),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Retry Permission Check',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBluetoothStatusCard(HardwareService hardwareService) {
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bluetooth connection status',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (hardwareService.bluetoothState == BluetoothAdapterState.off)
            ElevatedButton(
              onPressed: () => _enableBluetooth(),
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Enable',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusCard(HardwareService hardwareService) {
    final device = hardwareService.connectedDevice;
    if (device == null) return const SizedBox.shrink();

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.device_hub,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connected to: ${device.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hardware device connected',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Device info rows
          _buildInfoRow('Connected', _formatDateTime(device.connectedAt!)),
          if (device.firmwareVersion != null)
            _buildInfoRow('Firmware', device.firmwareVersion!),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _refreshDeviceInfo(hardwareService),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E3C26),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _disconnectDevice(hardwareService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Disconnect',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0E3C26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceListSection(HardwareService hardwareService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Devices',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        
        if (hardwareService.discoveredDevices.isEmpty)
          _buildEmptyDeviceState(hardwareService)
        else
          _buildDeviceList(hardwareService),
      ],
    );
  }

  Widget _buildEmptyDeviceState(HardwareService hardwareService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hardwareService.isScanning
                ? 'Please wait while we search for nearby hardware devices'
                : 'Try starting a scan to discover available devices',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (!hardwareService.isScanning) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _startScan(hardwareService),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E3C26),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Start Scan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceList(HardwareService hardwareService) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hardwareService.discoveredDevices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final device = hardwareService.discoveredDevices[index];
        return _buildDeviceCard(hardwareService, device);
      },
    );
  }

  Widget _buildDeviceCard(HardwareService hardwareService, HardwareDevice device) {
    final isConnected = hardwareService.isConnected && 
                       hardwareService.connectedDevice?.id == device.id;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isConnected 
                        ? Colors.green.withOpacity(0.1)
                        : const Color(0xFF0E3C26).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isConnected ? Icons.device_hub : Icons.bluetooth,
                    color: isConnected ? Colors.green : const Color(0xFF0E3C26),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF0E3C26),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hardware Device',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isConnected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Connected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Device details
            _buildDeviceDetailRow('Device ID', device.id.substring(0, 8) + '...'),
            _buildDeviceDetailRow('RSSI', '${device.rssi} dBm'),
            _buildDeviceDetailRow('Discovered', _formatDateTime(device.discoveredAt)),
            
            const SizedBox(height: 16),
            
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isConnected
                    ? null
                    : () => _connectToDevice(hardwareService, device),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected 
                      ? Colors.grey[300]
                      : const Color(0xFF0E3C26),
                  foregroundColor: isConnected 
                      ? Colors.grey[600]
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isConnected ? 'Connected' : 'Connect',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isConnected ? Colors.grey[600] : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0E3C26),
              ),
            ),
          ),
        ],
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

  void _refreshDeviceInfo(HardwareService hardwareService) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Refresh device info
      await hardwareService.refreshDeviceInfo();
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device info refreshed successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh device info: $e'),
          backgroundColor: Colors.red,
        ),
      );
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

  void _refreshDeviceInfo(BuildContext context) async {
    try {
      // Get the HardwareService from the context
      final hardwareService = Provider.of<HardwareService>(context, listen: false);
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Refresh device info
      await hardwareService.refreshDeviceInfo();
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device info refreshed successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Close the details sheet to show updated info
      Navigator.of(context).pop();
      
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh device info: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          if (device.firmwareVersion != null)
            _buildDetailRow('Firmware', device.firmwareVersion!),
          if (device.hardwareVersion != null)
            _buildDetailRow('Hardware', device.hardwareVersion!),
          if (device.manufacturer != null)
            _buildDetailRow('Manufacturer', device.manufacturer!),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _refreshDeviceInfo(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Device Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
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
