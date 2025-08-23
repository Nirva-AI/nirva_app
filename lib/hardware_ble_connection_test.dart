import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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
  
  // Stream subscriptions
  StreamSubscription? _connectionEventsSub;
  StreamSubscription? _streamingEventsSub;
  StreamSubscription? _segmentEventsSub;
  
  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupEventListeners();
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
      final info = await _methodChannel.invokeMethod('getConnectionInfo');
      setState(() {
        _connectionInfo = Map<String, dynamic>.from(info as Map);
      });
      _addLog('Got connection info');
    } catch (e) {
      _addLog('Error getting info: $e');
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
  
  Future<void> _getDebugLog() async {
    try {
      final log = await _methodChannel.invokeMethod('getDebugLog');
      print('=== NATIVE DEBUG LOG ===');
      print(log);
      print('=== END DEBUG LOG ===');
      _addLog('Debug log retrieved (check console)');
    } catch (e) {
      _addLog('Error getting debug log: $e');
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