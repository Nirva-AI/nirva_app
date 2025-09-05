import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:nirva_app/services/hardware_service.dart';
import 'package:nirva_app/models/hardware_device.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/api_models.dart';

// Import widget components
import 'widgets/ble_test/status_section.dart';
import 'widgets/ble_test/device_controls_section.dart';
import 'widgets/ble_test/discovered_devices_section.dart';
import 'widgets/ble_test/transcriptions_section.dart';
import 'widgets/ble_test/event_log_section.dart';
import 'widgets/ble_test/connection_info_section.dart';
import 'widgets/ble_test/streaming_stats_section.dart';

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
  int _currentPage = 1;
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
      final result = await _methodChannel.invokeMethod('initialize');
      setState(() {
        _isInitialized = result == true;
        _addLog('Service initialized: $_isInitialized');
      });
    } catch (e) {
      debugPrint('ERROR: Failed to initialize BLE service: $e');
      _addLog('Error initializing: $e');
    }
  }
  
  void _setupEventListeners() {
    // Single unified connection event listener for all events
    _connectionEventsSub = _connectionEventChannel
        .receiveBroadcastStream()
        .listen((event) {
      // Debug: Log all connection events
      _addLog('Connection Event: ${event.toString()}');
      debugPrint('BLE Connection Event: $event');
      
      if (event is Map) {
        // Handle connection state changes with auto-refresh
        if (event['state'] != null) {
          setState(() {
            _connectionState = event['state'];
          });
          
          // Update HardwareService when connection state changes
          if (!mounted) return;
          final hardwareService = context.read<HardwareService>();
          
          // The native side sends "subscribed" when fully connected and streaming
          if (event['state'] == 'subscribed') {
            debugPrint('HardwareBleConnectionTest: Device subscribed, updating HardwareService');
            
            // Use device info from the event if available
            final deviceId = event['deviceId'] ?? _connectionInfo['deviceId'] ?? '';
            final deviceName = event['name'] ?? event['deviceName'] ?? 'OMI Device';
            final batteryLevel = event['batteryLevel'] ?? 0;
            final rssi = event['rssi'] ?? 0;
            
            if (deviceId.isNotEmpty) {
              debugPrint('HardwareBleConnectionTest: Device info - name: $deviceName, battery: $batteryLevel%');
              
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
              
              // Update connection info state
              setState(() {
                _connectionInfo = {
                  'deviceId': deviceId,
                  'deviceName': deviceName,
                  'name': deviceName,
                  'batteryLevel': batteryLevel,
                  'battery': batteryLevel,
                  'batteryPercentage': batteryLevel,
                  'rssi': rssi,
                  'isConnected': true,
                };
              });
              
              // Still fetch additional info but with shorter delay since we have basic info
              Future.delayed(const Duration(milliseconds: 200), () {
                debugPrint('HardwareBleConnectionTest: Fetching additional device info');
                _getConnectionInfo();  // This will fetch any additional device info
              });
            } else {
              debugPrint('HardwareBleConnectionTest: No device ID in subscribed event, fetching info...');
              // Fallback: fetch info immediately if not provided in event
              _getConnectionInfo();
              _getBatteryLevel();
            }
          } else if (event['state'] == 'connected') {
            // Initial connection - fetch info
            Future.delayed(const Duration(milliseconds: 200), () {
              _getConnectionInfo();
            });
          } else if (event['state'] == 'disconnected' || event['state'] == 'idle' || event['state'] == 'backoff') {
            debugPrint('HardwareBleConnectionTest: Device disconnected/idle, clearing HardwareService');
            // Clear connected device when disconnected
            hardwareService.updateConnectedDeviceFromBle(null);
            setState(() {
              _connectionInfo = {};
            });
          }
        }
        
        // Handle device discovery events
        if (event['event'] == 'deviceDiscovered') {
          final deviceId = event['deviceId'] ?? event['id'];
          final deviceName = event['name'] ?? 'Unknown Device';
          final rssi = event['rssi'] ?? 0;
          
          if (deviceId != null) {
            setState(() {
              _discoveredDevices[deviceId] = {
                'id': deviceId,
                'name': deviceName,
                'rssi': rssi,
                'deviceId': deviceId,
              };
            });
            _addLog('Discovered: $deviceName (RSSI: $rssi dBm)');
          }
        }
        // Keep backward compatibility
        else if (event['event'] == 'discoveredDevice' && event['device'] != null) {
          final device = event['device'] as Map;
          final deviceId = device['id'] ?? device['deviceId'];
          if (deviceId != null) {
            setState(() {
              _discoveredDevices[deviceId] = Map<String, dynamic>.from(device);
            });
            _addLog('Discovered: ${device['name']} (${device['rssi']} dBm)');
          }
        }
      }
    });
    
    // Streaming events
    _streamingEventsSub = _streamingEventChannel
        .receiveBroadcastStream()
        .listen((event) {
      if (event is Map) {
        if (event['isStreaming'] != null) {
          setState(() {
            _isStreaming = event['isStreaming'];
          });
        }
        _addLog('Streaming Event: $event');
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
      final timestamp = DateTime.now().toString().split('.')[0].split(' ')[1];
      _eventLog.add('[$timestamp] $message');
      // Keep only last 100 log entries
      if (_eventLog.length > 100) {
        _eventLog.removeAt(0);
      }
    });
  }
  
  Future<void> _startScanning() async {
    try {
      setState(() {
        _isScanning = true;
        _discoveredDevices.clear();  // Clear previous scan results
      });
      await _methodChannel.invokeMethod('startScanning');
      _addLog('Started scanning');
    } catch (e) {
      _addLog('Error starting scan: $e');
      setState(() => _isScanning = false);
    }
  }
  
  Future<void> _stopScanning() async {
    try {
      await _methodChannel.invokeMethod('stopScanning');
      setState(() {
        _isScanning = false;
        _discoveredDevices.clear();
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
      
      // Auto-refresh connection info after successful connection
      if (result == true || result == 'success' || result == 'connected') {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _getConnectionInfo();
          _getBatteryLevel();
        });
      }
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
      
      // Update HardwareService with connection info
      if (!mounted) return;
      final hardwareService = context.read<HardwareService>();
      if (_connectionInfo['isConnected'] == true && _connectionInfo['deviceId'] != null) {
        // Extract battery level
        int batteryLevel = 0;
        if (_connectionInfo['batteryLevel'] != null) {
          batteryLevel = _connectionInfo['batteryLevel'] as int;
        } else if (_connectionInfo['battery'] != null) {
          batteryLevel = _connectionInfo['battery'] as int;
        } else if (_connectionInfo['batteryPercentage'] != null) {
          batteryLevel = _connectionInfo['batteryPercentage'] as int;
        }
        
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
        
        hardwareService.updateConnectedDeviceFromBle(device);
      } else {
        hardwareService.updateConnectedDeviceFromBle(null);
      }
    } catch (e) {
      debugPrint('ERROR: Failed to get connection info: $e');
      _addLog('Error getting info: $e');
    }
  }
  
  Future<void> _getBatteryLevel() async {
    try {
      final battery = await _methodChannel.invokeMethod('getBatteryLevel');
      if (battery != null) {
        _addLog('Battery level: $battery%');
        
        // Update connection info with battery level if we have it
        if (_connectionInfo.isNotEmpty) {
          setState(() {
            _connectionInfo['batteryLevel'] = battery;
            _connectionInfo['battery'] = battery;
            _connectionInfo['batteryPercentage'] = battery;
          });
          
          // Update HardwareService with new battery level
          if (!mounted) return;
          final hardwareService = context.read<HardwareService>();
          if (_connectionInfo['isConnected'] == true && _connectionInfo['deviceId'] != null) {
            final device = HardwareDevice(
              id: _connectionInfo['deviceId'] as String,
              name: _connectionInfo['deviceName'] ?? _connectionInfo['name'] ?? 'OMI Device',
              address: _connectionInfo['deviceAddress'] ?? _connectionInfo['address'] ?? _connectionInfo['deviceId'] as String,
              rssi: _connectionInfo['rssi'] ?? 0,
              batteryLevel: battery as int,
              isConnected: true,
              discoveredAt: DateTime.now(),
              connectedAt: DateTime.now(),
            );
            hardwareService.updateConnectedDeviceFromBle(device);
          }
        }
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
    if (_isLoadingTranscriptions) {
      return;
    }
    
    setState(() {
      _isLoadingTranscriptions = true;
      _transcriptionsError = null;
      if (!loadMore) {
        _currentPage = 1;
        _hasMoreTranscriptions = false;
      }
    });
    
    try {
      final response = await NirvaAPI.getTranscriptions(page: _currentPage);
      
      if (response != null && response.items.isNotEmpty) {
        setState(() {
          if (loadMore) {
            _transcriptions.addAll(response.items);
          } else {
            _transcriptions.clear();
            _transcriptions.addAll(response.items);
          }
          _hasMoreTranscriptions = response.items.length >= 20;
          if (_hasMoreTranscriptions) {
            _currentPage++;
          }
          _isLoadingTranscriptions = false;
        });
        _addLog('Loaded ${response.items.length} transcriptions');
      } else {
        setState(() {
          _hasMoreTranscriptions = false;
          _isLoadingTranscriptions = false;
        });
      }
    } catch (e) {
      debugPrint('ERROR: Failed to load transcriptions: $e');
      setState(() {
        _transcriptionsError = 'Failed to load: $e';
        _isLoadingTranscriptions = false;
        _hasMoreTranscriptions = false;
      });
      _addLog('Error loading transcriptions: $e');
    }
  }
  
  Future<void> _getDebugLog() async {
    try {
      final log = await _methodChannel.invokeMethod('getDebugLog');
      final logString = log.toString();
      
      // Parse the log to get all lines
      final allLines = logString.split('\n');
      
      // Extract critical info from the beginning
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
      debugPrint('\n${'=' * 80}');
      debugPrint('NATIVE DEBUG LOG - CRITICAL INFO');
      debugPrint('=' * 80);
      for (final line in criticalLines) {
        if (line.trim().isNotEmpty) {
          debugPrint(line);
        }
      }
      
      debugPrint('\n${'=' * 80}');
      debugPrint('S3 UPLOAD RELATED LOGS (${s3Lines.length} lines found)');
      debugPrint('=' * 80);
      if (s3Lines.isEmpty) {
        debugPrint('No S3-related logs found!');
        debugPrint('This means segments are NOT being queued for upload.');
      } else {
        // Show last 50 S3 lines
        final s3ToShow = s3Lines.length > 50 
            ? s3Lines.sublist(s3Lines.length - 50)
            : s3Lines;
        for (final line in s3ToShow) {
          debugPrint(line);
        }
        if (s3Lines.length > 50) {
          debugPrint('... (${s3Lines.length - 50} more S3 lines omitted)');
        }
      }
      
      debugPrint('\n${'=' * 80}');
      debugPrint('LAST 300 LINES OF DEBUG LOG');
      debugPrint('=' * 80);
      for (final line in last300Lines) {
        debugPrint(line);
      }
      debugPrint('=' * 80);
      debugPrint('END OF DEBUG LOG');
      debugPrint('${'=' * 80}\n');
      
      _addLog('Debug log printed (${allLines.length} lines)');
    } catch (e) {
      _addLog('Error getting debug log: $e');
      debugPrint('Error getting debug log: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: const Color(0xFFfaf9f5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0E3C26)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Hardware Connection',
            style: TextStyle(
              color: Color(0xFF0E3C26),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Georgia',
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            StatusSection(
              isInitialized: _isInitialized,
              connectionState: _connectionState,
              isScanning: _isScanning,
              isStreaming: _isStreaming,
            ),
            
            const SizedBox(height: 24),
            
            // Device Controls Section
            DeviceControlsSection(
              isInitialized: _isInitialized,
              isScanning: _isScanning,
              connectionState: _connectionState,
              onStartScan: _startScanning,
              onStopScan: _stopScanning,
              onDisconnect: _disconnect,
              onForgetDevice: _forgetDevice,
              onGetInfo: _getConnectionInfo,
              onGetStats: _getStreamingStats,
              onDebugLog: _getDebugLog,
            ),
            
            // Discovered Devices section
            if (_isScanning) ...[
              const SizedBox(height: 24),
              if (_discoveredDevices.isEmpty)
                Container(
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
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFFe7bf57),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Scanning for devices...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                )
              else
                DiscoveredDevicesSection(
                  discoveredDevices: _discoveredDevices,
                  onConnectDevice: _connectToDevice,
                ),
            ],
            
            // Connection Info (only show when available)
            if (_connectionInfo.isNotEmpty) ...[
              const SizedBox(height: 24),
              ConnectionInfoSection(connectionInfo: _connectionInfo),
            ],
            
            // Streaming Stats (only show when available)
            if (_streamingStats.isNotEmpty) ...[
              const SizedBox(height: 24),
              StreamingStatsSection(streamingStats: _streamingStats),
            ],
            
            // Transcriptions Section
            const SizedBox(height: 24),
            TranscriptionsSection(
              transcriptions: _transcriptions,
              isLoadingTranscriptions: _isLoadingTranscriptions,
              hasMoreTranscriptions: _hasMoreTranscriptions,
              transcriptionsError: _transcriptionsError,
              onRefresh: () => _loadTranscriptions(),
              onLoadMore: () => _loadTranscriptions(loadMore: true),
              onRetry: () {
                _loadTranscriptions();
              },
            ),
            
            // Event Log
            const SizedBox(height: 24),
            EventLogSection(eventLog: _eventLog),
            
            // Bottom padding
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}