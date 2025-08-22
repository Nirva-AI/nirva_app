import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Represents a discovered BLE device
class BleDevice {
  final String id;
  final String name;
  final int rssi;

  BleDevice({required this.id, required this.name, required this.rssi});

  factory BleDevice.fromMap(Map map) {
    return BleDevice(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown Device',
      rssi: (map['rssi'] is int) ? map['rssi'] as int : (map['rssi'] is num) ? (map['rssi'] as num).toInt() : 0,
    );
  }

  @override
  String toString() => 'BleDevice(id: $id, name: $name, rssi: ${rssi}dBm)';
}

/// Flutter service for BLE audio functionality
/// 
/// This service provides a bridge to the native iOS BLE audio service
/// Currently implements basic scanning and connection functionality
class BleAudioService extends ChangeNotifier {
  
  // MARK: - Properties
  
  /// Platform channel for native communication
  static const MethodChannel _channel = MethodChannel('com.nirva.ble_audio');
  static const EventChannel _eventChannel = EventChannel('com.nirva.ble_audio/events');
  
  /// Current connection state
  String _connectionState = 'idle';
  
  /// Whether currently scanning
  bool _isScanning = false;
  
  /// List of discovered devices
  final List<BleDevice> _discoveredDevices = [];
  
  /// Event stream subscription
  StreamSubscription<dynamic>? _eventSubscription;
  
  // MARK: - Getters
  
  String get connectionState => _connectionState;
  bool get isScanning => _isScanning;
  List<BleDevice> get discoveredDevices => List.unmodifiable(_discoveredDevices);
  
  // MARK: - Constructor
  
  BleAudioService() {
    _initializePlatformChannel();
    _initializeEventStream();
  }
  
  // MARK: - Platform Channel Setup
  
  void _initializePlatformChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  void _initializeEventStream() {
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        _handleBleEvent(event);
      },
      onError: (dynamic error) {
        // Silent error handling
      },
    );
  }
  
  void _handleBleEvent(dynamic event) {
    if (event is Map) {
      final eventType = event['event'] as String?;
      
      switch (eventType) {
        case 'deviceDiscovered':
          _handleDeviceDiscovered(event['device']);
          break;
        case 'connectionStateChanged':
          _handleConnectionStateChanged(event['state']);
          break;
      }
    }
  }
  
  void _handleDeviceDiscovered(dynamic deviceData) {
    if (deviceData is Map) {
      try {
        final device = BleDevice.fromMap(deviceData);
        
        // Check if device already exists
        final existingIndex = _discoveredDevices.indexWhere((d) => d.id == device.id);
        if (existingIndex >= 0) {
          // Update existing device
          _discoveredDevices[existingIndex] = device;
        } else {
          // Add new device
          _discoveredDevices.add(device);
        }
        
        notifyListeners();
      } catch (e) {
        // Silent error handling
      }
    }
  }
  
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onConnectionStateChanged':
        _handleConnectionStateChanged(call.arguments);
        break;
    }
  }
  
  void _handleConnectionStateChanged(dynamic arguments) {
    if (arguments is String) {
      _connectionState = arguments;
      notifyListeners();
    }
  }
  
  // MARK: - Public Methods
  
  /// Start scanning for BLE devices
  Future<bool> startScanning() async {
    try {
      // Clear previous discovered devices
      _discoveredDevices.clear();
      
      final result = await _channel.invokeMethod('startScanning');
      _isScanning = true;
      notifyListeners();
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Stop scanning for BLE devices
  Future<bool> stopScanning() async {
    try {
      final result = await _channel.invokeMethod('stopScanning');
      _isScanning = false;
      notifyListeners();
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Disconnect from current device
  Future<bool> disconnect() async {
    try {
      final result = await _channel.invokeMethod('disconnect');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Connect to a specific device
  Future<bool> connectToDevice(String deviceId) async {
    try {
      final result = await _channel.invokeMethod('connectToDevice', {'deviceId': deviceId});
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Get current connection state
  Future<String> getConnectionState() async {
    try {
      final result = await _channel.invokeMethod('getConnectionState');
      return result ?? 'unknown';
    } catch (e) {
      return 'error';
    }
  }
  
  /// Get Bluetooth state from native side
  Future<String> getBluetoothState() async {
    try {
      final result = await _channel.invokeMethod('getBluetoothState');
      return result ?? 'unknown';
    } catch (e) {
      return 'error';
    }
  }
  
  /// Get count of discovered devices
  Future<int> getDiscoveredDevicesCount() async {
    try {
      final result = await _channel.invokeMethod('getDiscoveredDevicesCount');
      return result ?? 0;
    } catch (e) {
      return 0;
    }
  }
  
  // MARK: - Cleanup
  
  @override
  void dispose() {
    // Stop scanning if active
    if (_isScanning) {
      stopScanning();
    }
    
    // Cancel event subscription
    _eventSubscription?.cancel();
    
    super.dispose();
  }
}
