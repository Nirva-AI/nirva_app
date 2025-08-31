import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:nirva_app/services/hardware_service.dart';
import 'package:nirva_app/models/hardware_device.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/api_models.dart';
import 'package:intl/intl.dart';
import 'package:nirva_app/transcription_detail_page.dart';

/// Test page for the new background-first BLE connection system
class HardwareBleConnectionTest extends StatefulWidget {
  const HardwareBleConnectionTest({super.key});

  @override
  State<HardwareBleConnectionTest> createState() => _HardwareBleConnectionTestState();
}

class _HardwareBleConnectionTestState extends State<HardwareBleConnectionTest> {
  // Platform channels
  static const MethodChannel _methodChannel = MethodChannel('com.nirva.ble_audio_v2');
  static const EventChannel _connectionEventChannel = 
      EventChannel('com.nirva.ble_audio_v2/connection_events');
  static const EventChannel _streamingEventChannel = 
      EventChannel('com.nirva.ble_audio_v2/streaming_events');
  static const EventChannel _segmentEventChannel = 
      EventChannel('com.nirva.ble_audio_v2/segment_events');
  
  // State
  bool _isInitialized = false;
  String _connectionState = 'idle';
  bool _isScanning = false;
  bool _isStreaming = false;
  Map<String, dynamic> _connectionInfo = {};
  Map<String, dynamic> _streamingStats = {};
  final List<String> _eventLog = [];
  final Map<String, Map<String, dynamic>> _discoveredDevices = {};
  
  // Transcription state
  final List<TranscriptionItem> _transcriptions = [];
  bool _isLoadingTranscriptions = false;
  bool _hasMoreTranscriptions = false;
  int _currentPage = 1;  // API uses 1-based pagination
  String? _transcriptionsError;
  
  // Stream subscriptions
  StreamSubscription? _connectionEventsSub;
  StreamSubscription? _streamingEventsSub;
  StreamSubscription? _segmentEventsSub;
  
  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupEventListeners();
    // Get initial connection info after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      print('HardwareBleConnectionTest: Getting initial connection info...');
      _getConnectionInfo();
      // Load transcriptions on page load
      _loadTranscriptions();
    });
  }
  
  @override
  void dispose() {
    _connectionEventsSub?.cancel();
    _streamingEventsSub?.cancel();
    _segmentEventsSub?.cancel();
    super.dispose();
  }
  
  Future<void> _initializeService() async {
    try {
      print('HardwareBleConnectionTest: Calling initialize on native side...');
      final result = await _methodChannel.invokeMethod('initialize');
      print('HardwareBleConnectionTest: Initialize result: $result');
      setState(() {
        _isInitialized = result == true;
        _addLog('Service initialized: $_isInitialized');
      });
    } catch (e) {
      print('HardwareBleConnectionTest: Error initializing: $e');
      _addLog('Error initializing: $e');
    }
  }
  
  void _setupEventListeners() {
    // Connection events
    _connectionEventsSub = _connectionEventChannel
        .receiveBroadcastStream()
        .listen((event) {
      if (event is Map) {
        _addLog('Connection Event: ${event['event']}');
        if (event['state'] != null) {
          setState(() {
            _connectionState = event['state'];
          });
          
          // Update HardwareService when connection state changes
          final hardwareService = context.read<HardwareService>();
          // The native side sends "subscribed" when fully connected and streaming
          if (event['state'] == 'subscribed') {
            print('HardwareBleConnectionTest: Device subscribed, updating HardwareService');
            
            // Use device info from the event if available
            final deviceId = event['deviceId'] ?? _connectionInfo['deviceId'] ?? '';
            final deviceName = event['name'] ?? event['deviceName'] ?? 'OMI Device';
            final batteryLevel = event['batteryLevel'] ?? 0;
            final rssi = event['rssi'] ?? 0;
            
            if (deviceId.isNotEmpty) {
              print('HardwareBleConnectionTest: Device info - name: $deviceName, battery: $batteryLevel%');
              
              // Create a HardwareDevice with the info from the event
              final device = HardwareDevice(
                id: deviceId,
                name: deviceName,
                address: event['address'] ?? deviceId,  // Use deviceId as fallback
                rssi: rssi,
                batteryLevel: batteryLevel,
                isConnected: true,
                discoveredAt: DateTime.now(),
                connectedAt: DateTime.now(),
              );
              hardwareService.updateConnectedDeviceFromBle(device);
              
              // Still fetch additional info but with shorter delay since we have basic info
              Future.delayed(const Duration(milliseconds: 200), () {
                print('HardwareBleConnectionTest: Fetching additional device info');
                _getConnectionInfo();  // This will fetch any additional device info
              });
            } else {
              print('HardwareBleConnectionTest: No device ID in subscribed event, fetching info...');
              // Fallback: fetch info immediately if not provided in event
              _getConnectionInfo();
            }
          } else if (event['state'] == 'disconnected' || event['state'] == 'idle' || event['state'] == 'backoff') {
            print('HardwareBleConnectionTest: Device disconnected/idle, clearing HardwareService');
            // Clear connected device when disconnected
            hardwareService.updateConnectedDeviceFromBle(null);
          }
        }
        // Handle device discovery
        if (event['event'] == 'deviceDiscovered') {
          setState(() {
            _discoveredDevices[event['deviceId']] = {
              'name': event['name'] ?? 'Unknown Device',
              'rssi': event['rssi'] ?? 0,
              'lastSeen': DateTime.now(),
            };
          });
        }
      }
    });
    
    // Streaming events
    _streamingEventsSub = _streamingEventChannel
        .receiveBroadcastStream()
        .listen((event) {
      if (event is Map) {
        setState(() {
          _streamingStats = Map<String, dynamic>.from(event);
          _isStreaming = event['isStreaming'] == true;
        });
      }
    });
    
    // Segment events
    _segmentEventsSub = _segmentEventChannel
        .receiveBroadcastStream()
        .listen((event) {
      if (event is Map) {
        _addLog('Segment Event: ${event['event']}');
      }
    });
  }
  
  void _addLog(String message) {
    setState(() {
      _eventLog.insert(0, '${DateTime.now().toString().substring(11, 19)}: $message');
      if (_eventLog.length > 100) {
        _eventLog.removeLast();
      }
    });
  }
  
  Future<void> _startScanning() async {
    try {
      print('HardwareBleConnectionTest: _startScanning called');
      _addLog('Starting scan...');
      setState(() => _isScanning = true);
      print('HardwareBleConnectionTest: Calling native startScanning method');
      final result = await _methodChannel.invokeMethod('startScanning');
      print('HardwareBleConnectionTest: Native startScanning returned: $result');
      _addLog('Start scanning result: $result');
    } catch (e) {
      print('HardwareBleConnectionTest: Error in _startScanning: $e');
      _addLog('Error starting scan: $e');
      setState(() => _isScanning = false);
    }
  }
  
  Future<void> _stopScanning() async {
    try {
      await _methodChannel.invokeMethod('stopScanning');
      setState(() {
        _isScanning = false;
        _discoveredDevices.clear();  // Clear discovered devices when stopping scan
      });
      _addLog('Stopped scanning');
    } catch (e) {
      _addLog('Error stopping scan: $e');
    }
  }
  
  Future<void> _connectToDevice(String deviceId) async {
    try {
      _addLog('Connecting to device: $deviceId');
      final result = await _methodChannel.invokeMethod('connectToDevice', {'deviceId': deviceId});
      _addLog('Connect result: $result');
    } catch (e) {
      _addLog('Error connecting to device: $e');
    }
  }
  
  Future<void> _disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
      _addLog('Disconnected');
    } catch (e) {
      _addLog('Error disconnecting: $e');
    }
  }
  
  Future<void> _forgetDevice() async {
    try {
      await _methodChannel.invokeMethod('forgetDevice');
      _addLog('Device forgotten');
    } catch (e) {
      _addLog('Error forgetting device: $e');
    }
  }
  
  Future<void> _getConnectionInfo() async {
    try {
      print('HardwareBleConnectionTest: Invoking getConnectionInfo...');
      final info = await _methodChannel.invokeMethod('getConnectionInfo');
      print('HardwareBleConnectionTest: Connection info received: $info');
      
      setState(() {
        _connectionInfo = Map<String, dynamic>.from(info as Map);
      });
      _addLog('Got connection info: ${_connectionInfo}');
      
      // Update HardwareService with connection info
      final hardwareService = context.read<HardwareService>();
      if (_connectionInfo['isConnected'] == true && _connectionInfo['deviceId'] != null) {
        print('HardwareBleConnectionTest: Device is connected, updating HardwareService');
        
        // Extract battery level - could be under different keys
        int batteryLevel = 0;
        if (_connectionInfo['batteryLevel'] != null) {
          batteryLevel = _connectionInfo['batteryLevel'] as int;
        } else if (_connectionInfo['battery'] != null) {
          batteryLevel = _connectionInfo['battery'] as int;
        } else if (_connectionInfo['batteryPercentage'] != null) {
          batteryLevel = _connectionInfo['batteryPercentage'] as int;
        }
        
        print('HardwareBleConnectionTest: Battery level: $batteryLevel%');
        
        // Create a HardwareDevice with the connection info
        final device = HardwareDevice(
          id: _connectionInfo['deviceId'] as String,
          name: _connectionInfo['deviceName'] ?? _connectionInfo['name'] ?? 'OMI Device',
          address: _connectionInfo['deviceAddress'] ?? _connectionInfo['address'] ?? _connectionInfo['deviceId'] as String,
          rssi: _connectionInfo['rssi'] ?? 0,
          batteryLevel: batteryLevel,
          isConnected: true,
          discoveredAt: DateTime.now(),
          connectedAt: DateTime.now(),
        );
        
        print('HardwareBleConnectionTest: Updating HardwareService with device: ${device.name}, battery: ${device.batteryLevel}%');
        hardwareService.updateConnectedDeviceFromBle(device);
      } else {
        print('HardwareBleConnectionTest: No device connected');
        hardwareService.updateConnectedDeviceFromBle(null);
      }
    } catch (e) {
      print('HardwareBleConnectionTest: Error getting connection info: $e');
      _addLog('Error getting info: $e');
    }
  }
  
  Future<void> _getBatteryLevel() async {
    try {
      // Try to get battery level from a dedicated method if available
      try {
        final batteryLevel = await _methodChannel.invokeMethod('getBatteryLevel');
        if (batteryLevel != null && batteryLevel is int) {
          print('HardwareBleConnectionTest: Got battery level: $batteryLevel%');
          final hardwareService = context.read<HardwareService>();
          hardwareService.updateBatteryLevel(batteryLevel);
          return;
        }
      } catch (e) {
        // getBatteryLevel method might not exist yet
        print('HardwareBleConnectionTest: getBatteryLevel not available: $e');
      }
      
      // Fallback to getting from connection info
      final info = await _methodChannel.invokeMethod('getConnectionInfo');
      if (info is Map && info['batteryLevel'] != null) {
        final hardwareService = context.read<HardwareService>();
        hardwareService.updateBatteryLevel(info['batteryLevel'] as int);
      }
    } catch (e) {
      _addLog('Error getting battery level: $e');
    }
  }
  
  Future<void> _getStreamingStats() async {
    try {
      final stats = await _methodChannel.invokeMethod('getStreamingStats');
      setState(() {
        _streamingStats = Map<String, dynamic>.from(stats as Map);
      });
    } catch (e) {
      _addLog('Error getting stats: $e');
    }
  }
  
  // Transcription methods
  Future<void> _loadTranscriptions({bool loadMore = false}) async {
    print('_loadTranscriptions called, loadMore: $loadMore, isLoading: $_isLoadingTranscriptions');
    _addLog('_loadTranscriptions called, isLoading: $_isLoadingTranscriptions');
    
    if (_isLoadingTranscriptions) {
      print('Already loading, returning early');
      return;
    }
    
    setState(() {
      _isLoadingTranscriptions = true;
      _transcriptionsError = null;
      
      if (!loadMore) {
        _currentPage = 1;
        _transcriptions.clear();
      } else {
        _currentPage++;
      }
    });
    
    try {
      
      final response = await NirvaAPI.getTranscriptions(
        page: _currentPage,
        pageSize: 50,
      );
      
      if (response != null) {
        setState(() {
          _transcriptions.addAll(response.items);
          _hasMoreTranscriptions = response.has_more;
          _isLoadingTranscriptions = false;
        });
        
        _addLog('Loaded ${response.items.length} transcriptions (page $_currentPage)');
      } else {
        setState(() {
          _transcriptionsError = 'Failed to load transcriptions';
          _isLoadingTranscriptions = false;
          // Reset page on error if we were loading more
          if (loadMore) _currentPage--;
        });
        _addLog('Error loading transcriptions');
      }
    } catch (e) {
      setState(() {
        _transcriptionsError = 'Error: $e';
        _isLoadingTranscriptions = false;
        // Reset page on error if we were loading more
        if (loadMore) _currentPage--;
      });
      _addLog('Exception loading transcriptions: $e');
    }
  }
  
  // Helper method to format relative time
  String _formatRelativeTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        return DateFormat('MMM d, y').format(dateTime);
      }
    } catch (e) {
      return isoTime;
    }
  }
  
  Future<void> _getDebugLog() async {
    try {
      final log = await _methodChannel.invokeMethod('getDebugLog');
      final logString = log.toString();
      
      // Parse the log to get all lines
      final allLines = logString.split('\n');
      
      // Extract critical info from the beginning (state summary)
      final criticalLines = <String>[];
      final s3Lines = <String>[];
      var foundLogStart = false;
      
      for (final line in allLines) {
        // Capture critical info at the beginning
        if (!foundLogStart) {
          if (line.contains('=== LOG START')) {
            foundLogStart = true;
          } else {
            criticalLines.add(line);
          }
        }
        
        // Capture S3-related lines
        if (line.contains('S3') || 
            line.contains('upload') || 
            line.contains('Upload') ||
            line.contains('segment') && line.contains('wav') ||
            line.contains('Segment') ||
            line.contains('credentials') ||
            line.contains('AWS') ||
            line.contains('Queued') ||
            line.contains('queueUpload')) {
          s3Lines.add(line);
        }
      }
      
      // Get the last 300 lines from the actual log
      final logStartIndex = allLines.indexWhere((line) => line.contains('=== LOG START'));
      final logLines = logStartIndex >= 0 
          ? allLines.sublist(logStartIndex + 1)
          : allLines;
      
      final last300Lines = logLines.length > 300 
          ? logLines.sublist(logLines.length - 300)
          : logLines;
      
      // Print to console
      print('\n' + '=' * 80);
      print('NATIVE DEBUG LOG - CRITICAL INFO');
      print('=' * 80);
      for (final line in criticalLines) {
        if (line.trim().isNotEmpty) {
          print(line);
        }
      }
      
      print('\n' + '=' * 80);
      print('S3 UPLOAD RELATED LOGS (${s3Lines.length} lines found)');
      print('=' * 80);
      if (s3Lines.isEmpty) {
        print('No S3-related logs found!');
        print('This means segments are NOT being queued for upload.');
      } else {
        // Show last 50 S3 lines
        final s3ToShow = s3Lines.length > 50 
            ? s3Lines.sublist(s3Lines.length - 50)
            : s3Lines;
        for (final line in s3ToShow) {
          print(line);
        }
        if (s3Lines.length > 50) {
          print('... (${s3Lines.length - 50} more S3 lines omitted)');
        }
      }
      
      print('\n' + '=' * 80);
      print('LAST 300 LINES OF DEBUG LOG');
      print('=' * 80);
      for (final line in last300Lines) {
        print(line);
      }
      print('=' * 80);
      print('END OF DEBUG LOG');
      print('=' * 80 + '\n');
      
      _addLog('Debug log printed to console (${allLines.length} total lines)');
    } catch (e) {
      _addLog('Error getting debug log: $e');
      print('Error getting debug log: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Connection Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Initialized: $_isInitialized'),
                    Text('Connection State: $_connectionState'),
                    Text('Scanning: $_isScanning'),
                    Text('Streaming: $_isStreaming'),
                    const Divider(),
                    Consumer<HardwareService>(
                      builder: (context, hardwareService, child) {
                        final device = hardwareService.connectedDevice;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HardwareService Status:', 
                              style: Theme.of(context).textTheme.titleSmall),
                            Text('Connected: ${hardwareService.isConnected}'),
                            if (device != null) ...[
                              Text('Device: ${device.name}'),
                              Text('Battery: ${device.batteryLevel}%'),
                              Text('ID: ${device.id}'),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Control Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: !_isInitialized ? null : (_isScanning ? _stopScanning : _startScanning),
                  child: Text(_isScanning ? 'Stop Scan' : 'Start Scan'),
                ),
                ElevatedButton(
                  onPressed: _connectionState == 'idle' ? null : _disconnect,
                  child: const Text('Disconnect'),
                ),
                ElevatedButton(
                  onPressed: _forgetDevice,
                  child: const Text('Forget Device'),
                ),
                ElevatedButton(
                  onPressed: _getConnectionInfo,
                  child: const Text('Get Info'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _getConnectionInfo();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated HardwareService')),
                      );
                    }
                  },
                  child: const Text('Update HW Service'),
                ),
                ElevatedButton(
                  onPressed: _getStreamingStats,
                  child: const Text('Get Stats'),
                ),
                ElevatedButton(
                  onPressed: _getDebugLog,
                  child: const Text('Debug Log'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Discovered Devices
            if (_isScanning && _discoveredDevices.isNotEmpty) ...[  
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discovered Devices', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._discoveredDevices.entries.map((entry) {
                        final deviceId = entry.key;
                        final deviceInfo = entry.value;
                        return ListTile(
                          title: Text(deviceInfo['name']),
                          subtitle: Text('ID: $deviceId\nRSSI: ${deviceInfo['rssi']}'),
                          trailing: ElevatedButton(
                            onPressed: () => _connectToDevice(deviceId),
                            child: const Text('Connect'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Connection Info
            if (_connectionInfo.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Connection Info', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._connectionInfo.entries.map((e) => 
                        Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Streaming Stats
            if (_streamingStats.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Streaming Stats', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._streamingStats.entries.map((e) => 
                        Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Transcriptions Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transcriptions', style: Theme.of(context).textTheme.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _isLoadingTranscriptions ? null : () => _loadTranscriptions(),
                          tooltip: 'Refresh transcriptions',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Error message
                    if (_transcriptionsError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _transcriptionsError!,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print('RETRY BUTTON PRESSED');
                                _addLog('Retry button pressed');
                                _loadTranscriptions();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Transcriptions list
                    Container(
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // List of transcriptions
                          Expanded(
                            child: _transcriptions.isEmpty && !_isLoadingTranscriptions
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        _transcriptionsError != null 
                                            ? 'Failed to load transcriptions'
                                            : 'No transcriptions yet',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _transcriptions.length + (_isLoadingTranscriptions && _transcriptions.isNotEmpty ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == _transcriptions.length) {
                                        // Loading indicator at the bottom
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      
                                      final transcription = _transcriptions[index];
                                      final isEven = index % 2 == 0;
                                      
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TranscriptionDetailPage(
                                                transcription: transcription,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: isEven ? Colors.grey.shade50 : Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _formatRelativeTime(transcription.start_time),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey.shade600,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      transcription.text,
                                                      style: const TextStyle(fontSize: 13),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          
                          // Loading indicator for initial load
                          if (_isLoadingTranscriptions && _transcriptions.isEmpty)
                            const LinearProgressIndicator(),
                          
                          // Load more button
                          if (_hasMoreTranscriptions && !_isLoadingTranscriptions)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () => _loadTranscriptions(loadMore: true),
                                child: const Text('Load More'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Event Log
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event Log', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,  // Fixed height for event log
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView.builder(
                        itemCount: _eventLog.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            child: Text(
                              _eventLog[index],
                              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}