import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/ble_audio_service.dart';

/// Simple test page for BLE audio functionality
/// 
/// This page provides basic controls to test the BLE service:
/// - Start/Stop scanning
/// - Disconnect
/// - View connection state
class HardwareBleTestPage extends StatefulWidget {
  const HardwareBleTestPage({super.key});

  @override
  State<HardwareBleTestPage> createState() => _HardwareBleTestPageState();
}

class _HardwareBleTestPageState extends State<HardwareBleTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Audio Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<BleAudioService>(
        builder: (context, bleService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Connection State: ${bleService.connectionState}'),
                        Text('Scanning: ${bleService.isScanning ? "Yes" : "No"}'),
                        Text('Discovered Devices: ${bleService.discoveredDevices.length}'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Control Buttons
                ElevatedButton(
                  onPressed: bleService.isScanning 
                    ? null 
                    : () => _startScanning(bleService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Start Scanning'),
                ),
                
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: bleService.isScanning 
                    ? () => _stopScanning(bleService)
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Stop Scanning'),
                ),
                
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () => _disconnect(bleService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Disconnect'),
                ),
                
                const SizedBox(height: 24),
                
                // Discovered Devices
                Text(
                  'Discovered Devices:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                
                Expanded(
                  child: bleService.discoveredDevices.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No devices found.\nStart scanning to discover BLE devices.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: bleService.discoveredDevices.length,
                          itemBuilder: (context, index) {
                            final device = bleService.discoveredDevices[index];
                            final isConnected = bleService.connectionState == 'connected';
                            final isConnecting = bleService.connectionState == 'connecting';
                            
                            return Card(
                              child: ListTile(
                                title: Text(
                                  device.name.isNotEmpty ? device.name : 'Unknown Device',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${device.id}\nRSSI: ${device.rssi} dBm'),
                                isThreeLine: true,
                                leading: Icon(
                                  Icons.bluetooth,
                                  color: isConnected ? Colors.green : Colors.blue[600],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: isConnecting 
                                      ? null 
                                      : () => _connectToDevice(bleService, device.id, device.name),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isConnected ? Colors.green : Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    isConnecting ? 'Connecting...' : 
                                    isConnected ? 'Connected' : 'Connect',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Future<void> _startScanning(BleAudioService bleService) async {
    try {
      final success = await bleService.startScanning();
      if (success) {
        _showSnackBar('Scanning started successfully');
      } else {
        _showSnackBar('Failed to start scanning', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error starting scan: $e', isError: true);
    }
  }
  
  Future<void> _stopScanning(BleAudioService bleService) async {
    try {
      final success = await bleService.stopScanning();
      if (success) {
        _showSnackBar('Scanning stopped successfully');
      } else {
        _showSnackBar('Failed to stop scanning', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error stopping scan: $e', isError: true);
    }
  }
  
  Future<void> _disconnect(BleAudioService bleService) async {
    try {
      final success = await bleService.disconnect();
      if (success) {
        _showSnackBar('Disconnect completed');
      } else {
        _showSnackBar('Failed to disconnect', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error disconnecting: $e', isError: true);
    }
  }
  
  Future<void> _connectToDevice(BleAudioService bleService, String deviceId, String deviceName) async {
    try {
      _showSnackBar('Connecting to ${deviceName.isNotEmpty ? deviceName : 'device'}...');
      final success = await bleService.connectToDevice(deviceId);
      if (success) {
        _showSnackBar('Connection initiated to ${deviceName.isNotEmpty ? deviceName : 'device'}');
      } else {
        _showSnackBar('Failed to start connection', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error connecting: $e', isError: true);
    }
  }
  
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
