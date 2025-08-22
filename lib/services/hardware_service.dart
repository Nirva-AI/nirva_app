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
import 'hardware_audio_recorder.dart';
import '../hive_helper.dart';
import '../my_hive_objects.dart';

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
  
  // Service state
  bool _isDisposed = false;
  
  // OMI audio processing services
  late OmiPacketReassembler _packetReassembler;
  late OpusDecoderService _opusDecoder;
  
  // Local audio processing services
  LocalAudioProcessor? _localAudioProcessor;
  
  // Audio recording service for automatic recording
  HardwareAudioCapture? _audioCapture;
  
  // Services and characteristics
  BluetoothService? _audioService;
  BluetoothService? _batteryService;
  BluetoothService? _deviceInfoService;
  
  // Getters
  List<HardwareDevice> get discoveredDevices => _discoveredDevices;
  HardwareDevice? get connectedDevice => _connectedDevice;
  HardwareConnectionState? get connectionState => _connectionState;
  BluetoothAdapterState get bluetoothState {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    // return _bluetoothState;
    return BluetoothAdapterState.unknown; // Return unknown state for now
  }
  bool get isScanning => _isScanning;
  
  // OMI service getters
  OmiPacketReassembler get packetReassembler => _packetReassembler;
  OpusDecoderService get opusDecoder => _opusDecoder;
  
  // Local audio processing getters
  LocalAudioProcessor? get localAudioProcessor => _localAudioProcessor;
  
  // Audio recording getters
  HardwareAudioCapture? get audioCapture => _audioCapture;
  
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
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    // _initializeBluetooth();
    // _startConnectionMonitoring();
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
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    // Listen to Bluetooth adapter state changes
    // FlutterBluePlus.adapterState.listen((state) {
    //   _bluetoothState = state;
    //   notifyListeners();
    // });
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
  
  /// Set the audio capture service for automatic recording
  void setAudioCapture(HardwareAudioCapture audioCapture) {
    _audioCapture = audioCapture;
    debugPrint('HardwareService: Audio capture service set for automatic recording');
    
    // If a device is already connected, start recording automatically
    if (isConnected && !_audioCapture!.isCapturing) {
      _startAutomaticRecording();
    }
  }
  
  /// Check if we should start automatic recording (called when audio capture becomes available)
  void checkAndStartAutomaticRecording() {
    if (_audioCapture != null && isConnected && !_audioCapture!.isCapturing) {
      debugPrint('HardwareService: Audio capture service available and device connected, starting automatic recording');
      _startAutomaticRecording();
    }
  }
  
  /// Start automatic recording (internal method)
  Future<void> _startAutomaticRecording() async {
    if (_audioCapture == null || _audioCapture!.isCapturing) {
      debugPrint('HardwareService: Cannot start automatic recording - audioCapture: ${_audioCapture != null}, isCapturing: ${_audioCapture?.isCapturing}');
      return;
    }
    
    try {
      debugPrint('HardwareService: Starting automatic recording...');
      
      // Add a small delay to ensure hardware is fully ready
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Initialize audio stream first
      await startAudioStream();
      debugPrint('HardwareService: Audio stream initialized for automatic recording');
      
      // Add another small delay to ensure audio stream is ready
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Then start recording
      await _audioCapture!.startCapture();
      debugPrint('HardwareService: Automatic recording started successfully');
    } catch (e) {
      debugPrint('HardwareService: Error starting automatic recording: $e');
    }
  }
  

  
  /// Request necessary permissions for Bluetooth and location
  Future<bool> requestPermissions() async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth permissions disabled for new BLE implementation testing');
    return true; // Return true to avoid blocking other functionality
  }
  
  /// Start scanning for hardware devices
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth scanning disabled for new BLE implementation testing');
    return;
  }
  
  /// Stop scanning for devices
  Future<void> stopScan() async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth scanning stop disabled for new BLE implementation testing');
    return;
  }
  
  /// Process scan results and add to discovered devices
  void _processScanResult(ScanResult result) {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth scan result processing disabled for new BLE implementation testing');
    return;
  }
  
  /// Connect to a hardware device
  Future<void> connectToDevice(HardwareDevice device) async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth connection disabled for new BLE implementation testing');
    return;
  }
  
  /// Disconnect from the current device
  Future<void> disconnect() async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth disconnect disabled for new BLE implementation testing');
    return;
  }
  
  /// Verify the current Bluetooth connection status
  Future<bool> verifyConnection() async {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    debugPrint('Bluetooth connection verification disabled for new BLE implementation testing');
    return false; // Return false to indicate no connection
  }
  
  /// Start periodic connection monitoring
  void _startConnectionMonitoring() {
    // DISABLED: Commenting out existing Bluetooth logic to test new BLE implementation
    // Timer.periodic(const Duration(seconds: 10), (timer) async { // Increased interval to 10 seconds
    //   if (_connectedDevice != null && _connectionState?.status == HardwareConnectionStatus.connected) {
    //     try {
    //     final isStillConnected = await verifyConnection();
    //     if (!isStillConnected) {
    //       debugPrint('Connection monitoring detected lost connection');
    //     } else {
    //       // If still connected, refresh battery level periodically
    //       await getBatteryLevel();
    //     }
    //     } catch (e) {
    //       debugPrint('Connection monitoring error: $e');
    //       // Don't fail the monitoring on errors
    //     }
    //   }
    // });
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
  
  /// Get battery level from connected device and update the device info
  Future<int?> getBatteryLevel() async {
    if (_batteryService == null || _connectedDevice == null) return null;
    
    try {
      final batteryChar = _batteryService!.characteristics.firstWhereOrNull(
        (c) => c.uuid.str128.toLowerCase() == hardwareBatteryLevelCharacteristicUuid.toLowerCase(),
      );
      
      if (batteryChar == null) return null;
      
      final value = await batteryChar.read();
      if (value.isNotEmpty) {
        final batteryLevel = value[0];
        
        // Update the connected device with the new battery level
        _connectedDevice = _connectedDevice!.copyWith(batteryLevel: batteryLevel);
        
        // Save the updated device info to persistent storage
        await _saveConnectedDevice();
        
        // Notify listeners about the battery level update
        notifyListeners();
        
        debugPrint('HardwareService.getBatteryLevel: Updated battery level to $batteryLevel%');
        return batteryLevel;
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

  /// Refresh device info for connected device (firmware version, hardware version, battery level, etc.)
  Future<void> refreshDeviceInfo() async {
    if (_connectedDevice == null) {
      debugPrint('HardwareService.refreshDeviceInfo: No connected device');
      return;
    }
    
    try {
      debugPrint('HardwareService.refreshDeviceInfo: Refreshing device info...');
      
      // Get device info if service is available
      Map<String, String> deviceInfo = {};
      if (_deviceInfoService != null) {
        deviceInfo = await getDeviceInfo();
        debugPrint('HardwareService.refreshDeviceInfo: Retrieved device info: $deviceInfo');
      }
      
      // Get battery level if service is available
      int? batteryLevel;
      if (_batteryService != null) {
        batteryLevel = await getBatteryLevel();
        debugPrint('HardwareService.refreshDeviceInfo: Retrieved battery level: $batteryLevel%');
      }
      
      // Update the connected device with new info
      _connectedDevice = _connectedDevice!.copyWith(
        firmwareVersion: deviceInfo['firmware'],
        hardwareVersion: deviceInfo['hardware'],
        manufacturer: deviceInfo['manufacturer'],
        batteryLevel: batteryLevel,
      );
      
      // Save to persistent storage
      await _saveConnectedDevice();
      
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

  // ===============================================================================
  // Device Persistence Methods
  // ===============================================================================

  /// Save discovered devices to persistent storage
  Future<void> _saveDiscoveredDevices() async {
    try {
      debugPrint('HardwareService: Saving ${_discoveredDevices.length} discovered devices to storage...');
      final devices = _discoveredDevices.map((device) {
        final isFavorite = device.id == _connectedDevice?.id; // Mark connected device as favorite
        return HardwareDeviceStorage.fromHardwareDevice(device, isFavorite: isFavorite);
      }).toList();
      
      debugPrint('HardwareService: Device IDs to save: ${devices.map((d) => d.id).join(', ')}');
      await HiveHelper.saveHardwareDevices(devices);
      debugPrint('HardwareService: Successfully saved ${devices.length} discovered devices to storage');
    } catch (e) {
      debugPrint('HardwareService: Error saving discovered devices: $e');
    }
  }

  /// Load discovered devices from persistent storage
  Future<void> _loadDiscoveredDevices() async {
    try {
      debugPrint('HardwareService: Attempting to load discovered devices from storage...');
      final storedDevices = HiveHelper.getHardwareDevices();
      debugPrint('HardwareService: Retrieved ${storedDevices.length} devices from storage');
      
      if (storedDevices.isNotEmpty) {
        _discoveredDevices = storedDevices.map((storage) => storage.toHardwareDevice()).toList();
        debugPrint('HardwareService: Successfully loaded ${_discoveredDevices.length} devices from storage');
        debugPrint('HardwareService: Device IDs: ${_discoveredDevices.map((d) => d.id).join(', ')}');
        notifyListeners();
      } else {
        debugPrint('HardwareService: No stored devices found');
      }
    } catch (e) {
      debugPrint('HardwareService: Error loading discovered devices: $e');
    }
  }

  /// Save the currently connected device ID
  Future<void> _saveConnectedDevice() async {
    if (_connectedDevice != null) {
      try {
        debugPrint('HardwareService: Saving connected device ID: ${_connectedDevice!.id}');
        await HiveHelper.saveLastConnectedDevice(_connectedDevice!.id);
        debugPrint('HardwareService: Successfully saved connected device ID: ${_connectedDevice!.id}');
      } catch (e) {
        debugPrint('HardwareService: Error saving connected device: $e');
      }
    } else {
      debugPrint('HardwareService: No connected device to save');
    }
  }

  /// Attempt to reconnect to the last connected device
  Future<void> _attemptReconnectToLastDevice() async {
    try {
      debugPrint('HardwareService: Attempting to reconnect to last connected device...');
      final lastDeviceId = HiveHelper.getLastConnectedDevice();
      debugPrint('HardwareService: Last connected device ID: $lastDeviceId');
      
      if (lastDeviceId != null) {
        debugPrint('HardwareService: Attempting to reconnect to last device: $lastDeviceId');
        debugPrint('HardwareService: Available discovered devices: ${_discoveredDevices.map((d) => d.id).join(', ')}');
        
        // Find the device in discovered devices
        final device = _discoveredDevices.firstWhereOrNull((d) => d.id == lastDeviceId);
        if (device != null) {
          debugPrint('HardwareService: Found last device in discovered devices, attempting reconnection');
          
          // Wait for Bluetooth to be ready before attempting connection
          await _waitForBluetoothReady();
          
          try {
            await connectToDevice(device);
            debugPrint('HardwareService: Reconnection successful!');
          } catch (e) {
            debugPrint('HardwareService: Reconnection failed: $e');
            debugPrint('HardwareService: Scheduling retry in 5 seconds...');
            _scheduleReconnectionRetry();
          }
        } else {
          debugPrint('HardwareService: Last device not found in discovered devices, will need to scan');
        }
      } else {
        debugPrint('HardwareService: No last connected device found');
      }
    } catch (e) {
      debugPrint('HardwareService: Error attempting reconnection: $e');
    }
  }
  
  /// Wait for Bluetooth to be ready before attempting connection
  Future<void> _waitForBluetoothReady() async {
    int retryCount = 0;
    const maxRetries = 10;
    const retryDelay = Duration(milliseconds: 500);
    
    while (retryCount < maxRetries) {
      try {
        // Check if Bluetooth is available
        final state = await FlutterBluePlus.adapterState.first;
        if (state == BluetoothAdapterState.on) {
          debugPrint('HardwareService: Bluetooth is ready, proceeding with connection');
          return;
        } else if (state == BluetoothAdapterState.off) {
          debugPrint('HardwareService: Bluetooth is off, waiting for it to turn on...');
        } else if (state == BluetoothAdapterState.turningOn) {
          debugPrint('HardwareService: Bluetooth is turning on, waiting...');
        } else if (state == BluetoothAdapterState.turningOff) {
          debugPrint('HardwareService: Bluetooth is turning off, waiting...');
        } else {
          debugPrint('HardwareService: Bluetooth state unknown, waiting...');
        }
        
        retryCount++;
        if (retryCount < maxRetries) {
          debugPrint('HardwareService: Waiting for Bluetooth to be ready (attempt $retryCount/$maxRetries)...');
          await Future.delayed(retryDelay);
        }
      } catch (e) {
        debugPrint('HardwareService: Error checking Bluetooth state: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(retryDelay);
        }
      }
    }
    
    debugPrint('HardwareService: Bluetooth not ready after $maxRetries attempts, proceeding anyway');
  }
  
  /// Schedule a retry of the reconnection after a delay
  void _scheduleReconnectionRetry() {
    debugPrint('HardwareService: Scheduling reconnection retry in 5 seconds...');
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isDisposed) {
        debugPrint('HardwareService: Executing scheduled reconnection retry...');
        _attemptReconnectToLastDevice();
      }
    });
  }

  /// Initialize device persistence and attempt reconnection
  Future<void> initializeDevicePersistence() async {
    try {
      debugPrint('HardwareService: Initializing device persistence...');
      
      // Load previously discovered devices
      await _loadDiscoveredDevices();
      
      // Wait a bit for the app to fully initialize before attempting reconnection
      debugPrint('HardwareService: Waiting for app to fully initialize before attempting reconnection...');
      await Future.delayed(const Duration(seconds: 2));
      
      // Attempt to reconnect to last connected device
      await _attemptReconnectToLastDevice();
      
      debugPrint('HardwareService: Device persistence initialization complete');
    } catch (e) {
      debugPrint('HardwareService: Error initializing device persistence: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopAudioStream();
    disconnect();
    super.dispose();
  }
}