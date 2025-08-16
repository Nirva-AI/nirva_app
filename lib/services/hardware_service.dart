import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection/collection.dart';

import '../models/hardware_device.dart';
import 'hardware_constants.dart';
import 'omi_packet_reassembler.dart';
import 'opus_decoder_service.dart';
import 'local_audio_processor.dart';

class HardwareService extends ChangeNotifier {
  // Device management
  List<HardwareDevice> _discoveredDevices = [];
  HardwareDevice? _connectedDevice;
  HardwareConnectionState? _connectionState;
  
  // Bluetooth state
  BluetoothAdapterState _bluetoothState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  
  // Audio streaming
  StreamController<HardwareAudioPacket>? _audioStreamController;
  StreamSubscription<List<int>>? _audioSubscription;
  int _audioSequenceNumber = 0;
  
  // OMI audio processing services
  late OmiPacketReassembler _packetReassembler;
  late OpusDecoderService _opusDecoder;
  
  // Local audio processing services
  LocalAudioProcessor? _localAudioProcessor;
  
  // Services and characteristics
  BluetoothService? _audioService;
  BluetoothService? _batteryService;
  BluetoothService? _deviceInfoService;
  
  // Getters
  List<HardwareDevice> get discoveredDevices => _discoveredDevices;
  HardwareDevice? get connectedDevice => _connectedDevice;
  HardwareConnectionState? get connectionState => _connectionState;
  BluetoothAdapterState get bluetoothState => _bluetoothState;
  bool get isScanning => _isScanning;
  
  // OMI service getters
  OmiPacketReassembler get packetReassembler => _packetReassembler;
  OpusDecoderService get opusDecoder => _opusDecoder;
  
  // Local audio processing getters
  LocalAudioProcessor? get localAudioProcessor => _localAudioProcessor;
  
  bool get isConnected {
    final hasDevice = _connectedDevice != null;
    final hasConnectionState = _connectionState?.status == HardwareConnectionStatus.connected;
    final deviceIsConnected = hasDevice ? _connectedDevice!.isConnected : false;
    
    // Check if we have a connected device
    if (hasDevice && deviceIsConnected) {
      return true;
    }
    
    // Check if connection state indicates connected
    if (hasConnectionState) {
      return true;
    }
    
    return false;
  }
  
  // Stream getters
  Stream<HardwareAudioPacket> get audioStream => 
      _audioStreamController?.stream ?? Stream.empty();
  
  HardwareService() {
    _initializeBluetooth();
    _startConnectionMonitoring();
    // Note: OMI services are initialized in the async initialize() method
  }
  
  /// Initialize the service asynchronously
  /// This must be called before using the service
  Future<void> initialize() async {
    debugPrint('HardwareService: Starting async initialization...');
    debugPrint('HardwareService: About to call _initializeOmiServices()...');
    await _initializeOmiServices();
    debugPrint('HardwareService: Async initialization complete');
    debugPrint('HardwareService: Opus decoder status: ${_opusDecoder.getDebugInfo()}');
  }
  
  void _initializeBluetooth() {
    // Listen to Bluetooth adapter state changes
    FlutterBluePlus.adapterState.listen((state) {
      _bluetoothState = state;
      notifyListeners();
    });
  }
  
  /// Initialize OMI audio processing services
  Future<void> _initializeOmiServices() async {
    debugPrint('HardwareService: Initializing OMI audio processing services...');
    
    // Initialize packet reassembler
    _packetReassembler = OmiPacketReassembler();
    
    // Initialize Opus decoder
    _opusDecoder = OpusDecoderService();
    
    // Initialize the Opus decoder and WAIT for it to complete
    debugPrint('HardwareService: Waiting for Opus decoder initialization...');
    final result = await _opusDecoder.initialize();
    if (result) {
      debugPrint('HardwareService: Opus decoder initialized successfully');
    } else {
      debugPrint('HardwareService: ERROR - Opus decoder initialization failed');
    }
    
    // Listen to complete packets from reassembler
    _packetReassembler.completePackets.listen((completeOpusData) {
      _onCompleteOpusPacket(completeOpusData);
    });
    
    debugPrint('HardwareService: OMI services initialization complete');
  }
  
  /// Set local audio processor for VAD and ASR
  void setLocalAudioProcessor(LocalAudioProcessor processor) {
    _localAudioProcessor = processor;
    debugPrint('HardwareService: Local audio processor set');
  }
  

  
  /// Request necessary permissions for Bluetooth and location
  Future<bool> requestPermissions() async {
    try {
      // Request Bluetooth permissions
      if (Platform.isAndroid) {
        final bluetoothScan = await Permission.bluetoothScan.request();
        final bluetoothConnect = await Permission.bluetoothConnect.request();
        final bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
        
        // Request location permission (required for BLE scanning on Android)
        final location = await Permission.location.request();
        
        return bluetoothScan.isGranted && 
               bluetoothConnect.isGranted && 
               bluetoothAdvertise.isGranted && 
               location.isGranted;
      } else if (Platform.isIOS) {
        // On iOS, we need to trigger the permission by attempting a Bluetooth operation
        // The permission_handler doesn't trigger the system dialog for Bluetooth on iOS
        try {
          // First check if Bluetooth is available (this triggers permission dialog)
          final isAvailable = await FlutterBluePlus.isAvailable;
          if (!isAvailable) {
            debugPrint('Bluetooth is not available on this device');
            return false;
          }
          
          // Check current Bluetooth state - this will trigger permission dialog if needed
          final state = await FlutterBluePlus.adapterState.first;
          if (state == BluetoothAdapterState.unauthorized) {
            // Permission denied
            return false;
          }
          
          // Try to turn on Bluetooth if it's off (this also triggers permission)
          if (state == BluetoothAdapterState.off) {
            try {
              await FlutterBluePlus.turnOn();
            } catch (e) {
              debugPrint('Could not turn on Bluetooth: $e');
              // This is expected if permission is not granted
            }
          }
          
          return state != BluetoothAdapterState.unauthorized;
        } catch (e) {
          debugPrint('Error checking Bluetooth state on iOS: $e');
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }
  
  /// Start scanning for hardware devices
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (_isScanning) return;
    
    try {
      // Check Bluetooth state
      if (_bluetoothState != BluetoothAdapterState.on) {
        throw Exception('Bluetooth is not enabled');
      }
      
      // Request permissions
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Required permissions not granted');
      }
      
      _isScanning = true;
      _discoveredDevices.clear();
      notifyListeners();
      
      // Start scanning with specific service UUIDs
      await FlutterBluePlus.startScan(
        timeout: timeout,
        withServices: [
          Guid(hardwareAudioServiceUuid),
          Guid(hardwareButtonServiceUuid),
        ],
      );
      
      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          _processScanResult(result);
        }
      });
      
      // Stop scanning after timeout
      Timer(timeout, () {
        stopScan();
      });
      
    } catch (e) {
      _isScanning = false;
      notifyListeners();
      debugPrint('Error starting scan: $e');
      rethrow;
    }
  }
  
  /// Stop scanning for devices
  Future<void> stopScan() async {
    if (!_isScanning) return;
    
    try {
      await FlutterBluePlus.stopScan();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
  }
  
  /// Process scan results and add to discovered devices
  void _processScanResult(ScanResult result) {
    final device = result.device;
    final advertisementData = result.advertisementData;
    
    // Check if device already exists
    final existingIndex = _discoveredDevices.indexWhere((d) => d.id == device.id.id);
    if (existingIndex != -1) {
      // Update existing device
      _discoveredDevices[existingIndex] = _discoveredDevices[existingIndex].copyWith(
        rssi: result.rssi,
        lastSeenAt: DateTime.now(),
      );
    } else {
      // Add new device
      final hardwareDevice = HardwareDevice(
        id: device.id.id,
        name: advertisementData.localName.isNotEmpty 
            ? advertisementData.localName 
            : device.platformName.isNotEmpty 
                ? device.platformName 
                : 'Unknown Device',
        address: device.id.id,
        rssi: result.rssi,
        isConnected: false,
        discoveredAt: DateTime.now(),
        lastSeenAt: DateTime.now(),
      );
      
      _discoveredDevices.add(hardwareDevice);
    }
    
    notifyListeners();
  }
  
  /// Connect to a hardware device
  Future<void> connectToDevice(HardwareDevice device) async {
    try {
      debugPrint('HardwareService.connectToDevice: Starting connection to ${device.id}');
      _updateConnectionState(device.id, HardwareConnectionStatus.connecting);
      
      final bluetoothDevice = BluetoothDevice.fromId(device.id);
      
      // Connect to device
      debugPrint('HardwareService.connectToDevice: Attempting Bluetooth connection...');
      await bluetoothDevice.connect(timeout: const Duration(seconds: 10));
      debugPrint('HardwareService.connectToDevice: Bluetooth connection established');
      
      // Discover services
      debugPrint('HardwareService.connectToDevice: Discovering services...');
      final services = await bluetoothDevice.discoverServices();
      debugPrint('HardwareService.connectToDevice: Found ${services.length} services');
      
      // Log all available services for debugging
      for (final service in services) {
        debugPrint('HardwareService.connectToDevice: Service: ${service.uuid.str128}');
        for (final char in service.characteristics) {
          debugPrint('  - Characteristic: ${char.uuid.str128} (${char.properties})');
        }
      }
      
      // Find required services
      _audioService = services.firstWhereOrNull(
        (s) => s.uuid.str128.toLowerCase() == hardwareAudioServiceUuid.toLowerCase(),
      );
      
      _batteryService = services.firstWhereOrNull(
        (s) => s.uuid.str128.toLowerCase() == hardwareBatteryServiceUuid.toLowerCase(),
      );
      
      _deviceInfoService = services.firstWhereOrNull(
        (s) => s.uuid.str128.toLowerCase() == hardwareDeviceInfoServiceUuid.toLowerCase(),
      );
      
      debugPrint('HardwareService.connectToDevice: Audio service found: ${_audioService != null}');
      debugPrint('HardwareService.connectToDevice: Battery service found: ${_batteryService != null}');
      debugPrint('HardwareService.connectToDevice: Device info service found: ${_deviceInfoService != null}');
      
      if (_audioService == null) {
        throw Exception('Audio service not found on device. Expected UUID: $hardwareAudioServiceUuid');
      }
      
      // Request MTU for better audio streaming
      if (Platform.isAndroid) {
        try {
          await bluetoothDevice.requestMtu(hardwareDefaultMtu);
          debugPrint('HardwareService.connectToDevice: MTU request successful');
        } catch (e) {
          debugPrint('HardwareService.connectToDevice: MTU request failed: $e');
        }
      }
      
      // Get device info including firmware version
      Map<String, String> deviceInfo = {};
      if (_deviceInfoService != null) {
        try {
          deviceInfo = await getDeviceInfo();
          debugPrint('HardwareService.connectToDevice: Device info retrieved: $deviceInfo');
        } catch (e) {
          debugPrint('HardwareService.connectToDevice: Failed to get device info: $e');
        }
      }
      
      // Update device state with firmware and hardware info
      _setConnectedDevice(device.copyWith(
        isConnected: true,
        connectedAt: DateTime.now(),
        firmwareVersion: deviceInfo['firmware'],
        hardwareVersion: deviceInfo['hardware'],
        manufacturer: deviceInfo['manufacturer'],
      ));
      
      // Ensure connection state is properly set
      _updateConnectionState(device.id, HardwareConnectionStatus.connected);
      
      debugPrint('HardwareService.connectToDevice: Device connected successfully');
      
      // Automatically enable local audio processing when hardware connects
      if (_localAudioProcessor != null) {
        _localAudioProcessor!.enable();
        debugPrint('HardwareService: Local audio processing enabled automatically');
      }
      
      // Note: Audio stream will be initialized manually when recording starts
      notifyListeners();
      
    } catch (e) {
      debugPrint('HardwareService.connectToDevice: Error connecting to device: $e');
      _updateConnectionState(device.id, HardwareConnectionStatus.error, e.toString());
      rethrow;
    }
  }
  
  /// Disconnect from the current device
  Future<void> disconnect() async {
    if (_connectedDevice == null) return;
    
    try {
      // Stop audio streaming
      await stopAudioStream();
      
      // Disable local audio processing when hardware disconnects
      if (_localAudioProcessor != null) {
        _localAudioProcessor!.disable();
        debugPrint('HardwareService: Local audio processing disabled automatically');
      }
      
      // Reset packet reassembler
      _packetReassembler.reset();
      debugPrint('HardwareService.disconnect: Packet reassembler reset');
      
      // Disconnect from device
      final bluetoothDevice = BluetoothDevice.fromId(_connectedDevice!.id);
      await bluetoothDevice.disconnect();
      
      // Update state
      _connectedDevice = _connectedDevice!.copyWith(isConnected: false);
      _updateConnectionState(_connectedDevice!.id, HardwareConnectionStatus.disconnected);
      
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }
  
  /// Verify the current Bluetooth connection status
  Future<bool> verifyConnection() async {
    if (_connectedDevice == null) {
      debugPrint('HardwareService.verifyConnection: No connected device');
      return false;
    }
    
    try {
      // debugPrint('HardwareService.verifyConnection: Checking connection for device ${_connectedDevice!.id}');
      final bluetoothDevice = BluetoothDevice.fromId(_connectedDevice!.id);
      final isConnected = await bluetoothDevice.isConnected;
      // debugPrint('HardwareService.verifyConnection: Bluetooth device reports isConnected=$isConnected');
      
      if (!isConnected) {
        // Connection was lost, update state
        debugPrint('HardwareService.verifyConnection: Connection lost, updating state');
        _updateConnectionState(_connectedDevice!.id, HardwareConnectionStatus.disconnected);
        // Don't clear the device, just mark it as disconnected
        _connectedDevice = _connectedDevice!.copyWith(isConnected: false);
        notifyListeners();
        return false;
      }
      
      // If we get here, the connection is verified, so ensure the state is correct
      if (_connectionState?.status != HardwareConnectionStatus.connected) {
        // debugPrint('HardwareService.verifyConnection: Connection verified but state was wrong, fixing it');
        _updateConnectionState(_connectedDevice!.id, HardwareConnectionStatus.connected);
        _connectedDevice = _connectedDevice!.copyWith(isConnected: true);
        notifyListeners();
      }
      
      // debugPrint('HardwareService.verifyConnection: Connection verified successfully');
      return true;
    } catch (e) {
      debugPrint('Error verifying connection: $e');
      // Connection verification failed, but don't assume disconnected - just log the error
      debugPrint('HardwareService.verifyConnection: Verification failed but keeping device connected: $e');
      return true; // Assume still connected if verification fails
    }
  }
  
  /// Start periodic connection monitoring
  void _startConnectionMonitoring() {
    Timer.periodic(const Duration(seconds: 10), (timer) async { // Increased interval to 10 seconds
      if (_connectedDevice != null && _connectionState?.status == HardwareConnectionStatus.connected) {
        try {
          final isStillConnected = await verifyConnection();
          if (!isStillConnected) {
            debugPrint('Connection monitoring detected lost connection');
          }
        } catch (e) {
          debugPrint('Connection monitoring error: $e');
          // Don't fail the monitoring on errors
        }
      }
    });
  }

  /// Initialize audio streaming from the device
  Future<void> _initializeAudioStream() async {
    if (_audioService == null || _connectedDevice == null) {
      debugPrint('HardwareService._initializeAudioStream: Cannot initialize - audioService=${_audioService != null}, connectedDevice=${_connectedDevice != null}');
      return;
    }
    
    try {
      debugPrint('HardwareService._initializeAudioStream: Starting audio stream initialization');
      
      // Create new stream controller
      _audioStreamController = StreamController<HardwareAudioPacket>.broadcast();
      
      // Find audio data characteristic
      final audioDataChar = _audioService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareAudioDataCharacteristicUuid.toLowerCase(),
      );
      
      if (audioDataChar == null) {
        debugPrint('HardwareService._initializeAudioStream: Audio data characteristic not found. Available characteristics:');
        for (final char in _audioService!.characteristics) {
          debugPrint('  - ${char.uuid.str128} (${char.properties})');
        }
        throw Exception('Audio data characteristic not found. Expected: $hardwareAudioDataCharacteristicUuid');
      }
      
      debugPrint('HardwareService._initializeAudioStream: Found audio data characteristic: ${audioDataChar.uuid.str128}');
      
      // Subscribe to audio data notifications
      _audioSubscription = audioDataChar.lastValueStream.listen(
        (data) {
          if (data.isNotEmpty) {
            _processAudioData(data);
          }
        },
        onError: (error) {
          debugPrint('Audio stream error: $error');
        },
      );
      
      // Enable notifications
      await audioDataChar.setNotifyValue(true);
      debugPrint('HardwareService._initializeAudioStream: Notifications enabled');
      
      // Verify subscription was created
      if (_audioSubscription != null) {
        debugPrint('HardwareService._initializeAudioStream: Audio subscription created successfully');
      } else {
        debugPrint('HardwareService._initializeAudioStream: WARNING - Audio subscription is null after creation');
      }
      
      debugPrint('HardwareService._initializeAudioStream: Audio stream initialized successfully');
      
      // Notify listeners that audio stream is ready
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error initializing audio stream: $e');
      // Don't rethrow - this is not critical for connection
    }
  }
  
  /// Start audio streaming manually (called when recording starts)
  Future<void> startAudioStream() async {
    if (_audioStreamController != null) {
      debugPrint('HardwareService.startAudioStream: Audio stream already active');
      return;
    }
    
    debugPrint('HardwareService.startAudioStream: Starting audio stream...');
    await _initializeAudioStream();
  }
  
  /// Stop audio streaming manually (called when recording stops)
  Future<void> stopAudioStream() async {
    debugPrint('HardwareService.stopAudioStream: Stopping audio stream...');
    await _stopAudioStream();
  }
  
  /// Stop audio streaming (internal method)
  Future<void> _stopAudioStream() async {
    debugPrint('HardwareService._stopAudioStream: Stopping audio stream...');
    
    // Cancel audio subscription
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    
    // Close stream controller
    await _audioStreamController?.close();
    _audioStreamController = null;
    
    // Reset sequence number
    _audioSequenceNumber = 0;
    
    // Disable Bluetooth characteristic notifications to stop incoming data
    try {
      if (_audioService != null) {
        final audioDataChar = _audioService!.characteristics.firstWhereOrNull(
          (c) => c.uuid.str128.toLowerCase() == hardwareAudioDataCharacteristicUuid.toLowerCase(),
        );
        if (audioDataChar != null) {
          await audioDataChar.setNotifyValue(false);
          debugPrint('HardwareService._stopAudioStream: Bluetooth notifications disabled');
        }
      }
    } catch (e) {
      debugPrint('HardwareService._stopAudioStream: Error disabling notifications: $e');
    }
    
    debugPrint('HardwareService._stopAudioStream: Audio stream stopped');
  }
  
  /// Process incoming audio data and convert to audio packet
  void _processAudioData(List<int> data) {
    if (_connectedDevice == null) return;
    
    try {
      // Send raw packet data to OMI packet reassembler
      // This will handle the fragmented packet reassembly
      _packetReassembler.processPacket(data);
      
    } catch (e) {
      debugPrint('Error processing audio data: $e');
    }
  }
  
  /// Handle complete Opus packets from the packet reassembler
  void _onCompleteOpusPacket(List<int> completeOpusData) {
    if (_connectedDevice == null || _audioStreamController == null || _audioStreamController!.isClosed) {
      debugPrint('HardwareService._onCompleteOpusPacket: Cannot process - no device or stream closed');
      return;
    }
    
    try {
      // Create audio packet with complete Opus data
      final audioPacket = HardwareAudioPacket(
        deviceId: _connectedDevice!.id,
        audioData: completeOpusData,
        format: HardwareAudioFormat.opus,
        timestamp: DateTime.now(),
        sequenceNumber: _audioSequenceNumber++,
        sampleRate: hardwareSampleRate,
        bitDepth: hardwareBitDepth,
        channels: hardwareChannels,
      );
      
      // Add to audio stream
      _audioStreamController!.add(audioPacket);
      
    } catch (e) {
      debugPrint('Error processing complete Opus packet: $e');
    }
  }
  
  /// Update connection state
  void _updateConnectionState(String deviceId, HardwareConnectionStatus status, [String? errorMessage]) {
    _connectionState = HardwareConnectionState(
      deviceId: deviceId,
      status: status,
      errorMessage: errorMessage,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }
  
  /// Get battery level from connected device
  Future<int?> getBatteryLevel() async {
    if (_batteryService == null || _connectedDevice == null) return null;
    
    try {
      final batteryChar = _batteryService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareBatteryLevelCharacteristicUuid.toLowerCase(),
      );
      
      if (batteryChar == null) return null;
      
      final value = await batteryChar.read();
      if (value.isNotEmpty) {
        return value[0];
      }
      
      return null;
    } catch (e) {
      debugPrint('Error reading battery level: $e');
      return null;
    }
  }
  
  /// Refresh connection status
  Future<void> refreshConnectionStatus() async {
    if (_connectedDevice != null) {
      await verifyConnection();
    }
  }
  
  /// Force set connection state (for debugging)
  void forceSetConnectionState(HardwareConnectionStatus status) {
    if (_connectedDevice != null) {
      debugPrint('HardwareService.forceSetConnectionState: Setting status to $status');
      _updateConnectionState(_connectedDevice!.id, status);
      // Also update the device's isConnected flag to match
      if (status == HardwareConnectionStatus.connected) {
        _connectedDevice = _connectedDevice!.copyWith(isConnected: true);
      } else if (status == HardwareConnectionStatus.disconnected) {
        _connectedDevice = _connectedDevice!.copyWith(isConnected: false);
      }
      notifyListeners();
    }
  }
  
  /// Set connected device with debugging
  void _setConnectedDevice(HardwareDevice? device) {
    if (_connectedDevice != null && device == null) {
      debugPrint('HardwareService._setConnectedDevice: WARNING - Device being set to null!');
    }
    _connectedDevice = device;
    // Don't notify listeners here - let the calling method handle it
  }
  
  /// Reconnect to the current device if connection state is wrong
  Future<void> reconnectDevice() async {
    if (_connectedDevice == null) {
      debugPrint('HardwareService.reconnectDevice: No device to reconnect to');
      return;
    }
    
    try {
      debugPrint('HardwareService.reconnectDevice: Attempting to reconnect to ${_connectedDevice!.id}');
      
      // Check if we're actually still connected
      final bluetoothDevice = BluetoothDevice.fromId(_connectedDevice!.id);
      final isActuallyConnected = await bluetoothDevice.isConnected;
      
      if (isActuallyConnected) {
        debugPrint('HardwareService.reconnectDevice: Device is actually connected, fixing state');
        _updateConnectionState(_connectedDevice!.id, HardwareConnectionStatus.connected);
        _connectedDevice = _connectedDevice!.copyWith(isConnected: true);
        notifyListeners();
      } else {
        debugPrint('HardwareService.reconnectDevice: Device is not connected, attempting reconnection');
        // Try to reconnect
        await connectToDevice(_connectedDevice!);
      }
    } catch (e) {
      debugPrint('HardwareService.reconnectDevice: Error during reconnection: $e');
    }
  }
  
  /// Auto-recover device if connection state is inconsistent
  Future<void> autoRecoverDevice() async {
    if (_connectedDevice == null && _connectionState?.status == HardwareConnectionStatus.connected) {
      debugPrint('HardwareService.autoRecoverDevice: Attempting auto-recovery');
      
      // Try to find the device in discovered devices
      final deviceId = _connectionState!.deviceId;
      final discoveredDevice = _discoveredDevices.firstWhereOrNull((d) => d.id == deviceId);
      
      if (discoveredDevice != null) {
        debugPrint('HardwareService.autoRecoverDevice: Found device in discovered devices, attempting reconnection');
        try {
          await connectToDevice(discoveredDevice);
        } catch (e) {
          debugPrint('HardwareService.autoRecoverDevice: Reconnection failed: $e');
        }
      } else {
        debugPrint('HardwareService.autoRecoverDevice: Device not found in discovered devices');
      }
    }
  }
  
  /// Get device information
  Future<Map<String, String>> getDeviceInfo() async {
    if (_deviceInfoService == null || _connectedDevice == null) return {};
    
    try {
      final info = <String, String>{};
      
      // Model number
      final modelChar = _deviceInfoService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareModelNumberCharacteristicUuid.toLowerCase(),
      );
      if (modelChar != null) {
        final value = await modelChar.read();
        if (value.isNotEmpty) {
          info['model'] = String.fromCharCodes(value);
        }
      }
      
      // Firmware revision
      final firmwareChar = _deviceInfoService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareFirmwareRevisionCharacteristicUuid.toLowerCase(),
      );
      if (firmwareChar != null) {
        final value = await firmwareChar.read();
        if (value.isNotEmpty) {
          info['firmware'] = String.fromCharCodes(value);
        }
      }
      
      // Hardware revision
      final hardwareChar = _deviceInfoService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareHardwareRevisionCharacteristicUuid.toLowerCase(),
      );
      if (hardwareChar != null) {
        final value = await hardwareChar.read();
        if (value.isNotEmpty) {
          info['hardware'] = String.fromCharCodes(value);
        }
      }
      
      // Manufacturer name
      final manufacturerChar = _deviceInfoService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareManufacturerNameCharacteristicUuid.toLowerCase(),
      );
      if (manufacturerChar != null) {
        final value = await manufacturerChar.read();
        if (value.isNotEmpty) {
          info['manufacturer'] = String.fromCharCodes(value);
        }
      }
      
      return info;
    } catch (e) {
      debugPrint('Error reading device info: $e');
      return {};
    }
  }
  
  /// Check if audio stream is properly initialized
  bool get isAudioStreamReady {
    final hasStreamController = _audioStreamController != null;
    final hasAudioSubscription = _audioSubscription != null;
    final hasAudioService = _audioService != null;
    
    debugPrint('HardwareService.isAudioStreamReady: controller=$hasStreamController, subscription=$hasAudioSubscription, service=$hasAudioService');
    
    final isReady = hasStreamController && hasAudioSubscription && hasAudioService;
    debugPrint('HardwareService.isAudioStreamReady: Returning $isReady');
    
    return isReady;
  }
  
  /// Get audio stream status for debugging
  Map<String, dynamic> getAudioStreamStatus() {
    return {
      'hasStreamController': _audioStreamController != null,
      'hasAudioSubscription': _audioSubscription != null,
      'hasAudioService': _audioService != null,
      'isConnected': isConnected,
      'connectedDevice': _connectedDevice?.id,
      'connectionState': _connectionState?.status.toString(),
      'hasRequiredAudioCapabilities': hasRequiredAudioCapabilities,
      'deviceCapabilities': getDeviceCapabilities(),
    };
  }

  /// Check if device has required audio capabilities
  bool get hasRequiredAudioCapabilities {
    if (_audioService == null) {
      debugPrint('HardwareService.hasRequiredAudioCapabilities: No audio service');
      return false;
    }
    
    // Check for audio data characteristic
    final hasAudioDataChar = _audioService!.characteristics.any(
      (c) => c.uuid.str128.toLowerCase() == hardwareAudioDataCharacteristicUuid.toLowerCase(),
    );
    
    debugPrint('HardwareService.hasRequiredAudioCapabilities: hasAudioDataChar=$hasAudioDataChar');
    
    return hasAudioDataChar;
  }
  
  /// Get detailed device capabilities for debugging
  Map<String, dynamic> getDeviceCapabilities() {
    return {
      'hasAudioService': _audioService != null,
      'hasBatteryService': _batteryService != null,
      'hasDeviceInfoService': _deviceInfoService != null,
      'hasRequiredAudioCapabilities': hasRequiredAudioCapabilities,
      'audioServiceUuid': _audioService?.uuid.str128,
      'audioCharacteristics': _audioService?.characteristics.map((c) => {
        'uuid': c.uuid.str128,
        'properties': c.properties.toString(),
      }).toList() ?? [],
    };
  }

  /// Force reinitialize audio stream (for debugging)
  Future<void> forceReinitializeAudioStream() async {
    debugPrint('HardwareService.forceReinitializeAudioStream: Forcing audio stream reinitialization');
    
    try {
      // Stop current audio stream
      await stopAudioStream();
      
      // Wait a bit
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Reinitialize if we have a connected device
      if (_connectedDevice != null && _audioService != null) {
        await startAudioStream();
        debugPrint('HardwareService.forceReinitializeAudioStream: Audio stream reinitialized');
      } else {
        debugPrint('HardwareService.forceReinitializeAudioStream: Cannot reinitialize - no device or audio service');
      }
    } catch (e) {
      debugPrint('HardwareService.forceReinitializeAudioStream: Error during reinitialization: $e');
    }
  }

  /// Force refresh connection state and notify listeners
  Future<void> forceRefreshConnectionState() async {
    debugPrint('HardwareService.forceRefreshConnectionState: Forcing connection state refresh');
    
    if (_connectedDevice != null) {
      // Verify the actual connection
      final isActuallyConnected = await verifyConnection();
      debugPrint('HardwareService.forceRefreshConnectionState: Connection verification result: $isActuallyConnected');
      
      // Force notify listeners to update UI
      notifyListeners();
    }
  }

  /// Get current connection status for debugging
  Map<String, dynamic> getCurrentConnectionStatus() {
    return {
      'hasConnectedDevice': _connectedDevice != null,
      'deviceId': _connectedDevice?.id,
      'deviceIsConnected': _connectedDevice?.isConnected ?? false,
      'connectionStateStatus': _connectionState?.status.toString(),
      'connectionStateDeviceId': _connectionState?.deviceId,
      'isConnected': isConnected,
      'isAudioStreamReady': isAudioStreamReady,
      'hasAudioService': _audioService != null,
      'hasAudioStreamController': _audioStreamController != null,
      'hasAudioSubscription': _audioSubscription != null,
      'audioStreamControllerIsClosed': _audioStreamController?.isClosed ?? true,
      'audioSubscriptionIsPaused': _audioSubscription?.isPaused ?? true,
      
      // OMI service debug information
      'packetReassemblerActivePackets': _packetReassembler.activePacketCount,
      'opusDecoderInitialized': _opusDecoder.isInitialized,
      'opusDecoderDecoding': _opusDecoder.isDecoding,
      'opusDecoderTotalPackets': _opusDecoder.totalPacketsDecoded,
      'opusDecoderSuccessRate': _opusDecoder.successRate,
    };
  }

  /// Refresh device info for connected device (firmware version, hardware version, etc.)
  Future<void> refreshDeviceInfo() async {
    if (_connectedDevice == null || _deviceInfoService == null) {
      debugPrint('HardwareService.refreshDeviceInfo: No connected device or device info service');
      return;
    }
    
    try {
      debugPrint('HardwareService.refreshDeviceInfo: Refreshing device info...');
      final deviceInfo = await getDeviceInfo();
      debugPrint('HardwareService.refreshDeviceInfo: Retrieved device info: $deviceInfo');
      
      // Update the connected device with new info
      _connectedDevice = _connectedDevice!.copyWith(
        firmwareVersion: deviceInfo['firmware'],
        hardwareVersion: deviceInfo['hardware'],
        manufacturer: deviceInfo['manufacturer'],
      );
      
      notifyListeners();
      debugPrint('HardwareService.refreshDeviceInfo: Device info refreshed successfully');
    } catch (e) {
      debugPrint('HardwareService.refreshDeviceInfo: Error refreshing device info: $e');
    }
  }

  /// Test audio stream by sending a test packet
  Future<bool> testAudioStream() async {
    if (!isAudioStreamReady) {
      debugPrint('HardwareService.testAudioStream: Audio stream not ready');
      return false;
    }
    
    try {
      debugPrint('HardwareService.testAudioStream: Sending test packet');
      
      // Create a test audio packet
      final testPacket = HardwareAudioPacket(
        deviceId: _connectedDevice!.id,
        audioData: [0x01, 0x02, 0x03, 0x04], // Test data
        format: HardwareAudioFormat.opus,
        timestamp: DateTime.now(),
        sequenceNumber: -1, // Test sequence
        sampleRate: hardwareSampleRate,
        bitDepth: hardwareBitDepth,
        channels: hardwareChannels,
      );
      
      // Send the test packet
      _audioStreamController!.add(testPacket);
      debugPrint('HardwareService.testAudioStream: Test packet sent successfully');
      
      return true;
    } catch (e) {
      debugPrint('HardwareService.testAudioStream: Error sending test packet: $e');
      return false;
    }
  }

  @override
  void dispose() {
    stopAudioStream();
    disconnect();
    super.dispose();
  }
}