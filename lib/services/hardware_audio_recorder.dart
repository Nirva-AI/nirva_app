import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/hardware_device.dart';
import 'hardware_service.dart';
import 'local_audio_processor.dart';

class HardwareAudioCapture extends ChangeNotifier {
  final HardwareService _hardwareService;
  final LocalAudioProcessor? _localAudioProcessor;
  
  // Audio capture state
  bool _isCapturing = false;
  DateTime? _captureStartTime;
  String? _currentCapturePath;
  StreamSubscription<HardwareAudioPacket>? _audioSubscription;
  
  // Audio buffer for continuous capture (now stores decoded PCM data)
  final List<int> _decodedPcmBuffer = [];
  final int _maxBufferSize = 1024 * 1024; // 1MB buffer for decoded PCM
  
  // Capture settings
  final String _audioDirectory = 'hardware_audio';
  final String _audioFileExtension = '.wav'; // Changed from .opus to .wav
  final int _maxFileSize = 10 * 1024 * 1024; // 10MB max file size
  
  // File management
  int _currentFileSize = 0;
  int _fileCounter = 0;
  
  // Timer for periodic file rotation (every 1 minute)
  Timer? _fileRotationTimer;
  static const Duration _fileRotationInterval = Duration(minutes: 1);
  
  // Statistics
  int _totalOpusPacketsReceived = 0;
  int _totalOpusBytesReceived = 0;
  int _totalPcmBytesDecoded = 0;
  int _failedDecodes = 0;
  
  // Getters
  bool get isCapturing => _isCapturing;
  bool get isTrulyStopped => !_isCapturing && _audioSubscription == null;
  DateTime? get captureStartTime => _captureStartTime;
  String? get currentCapturePath => _currentCapturePath;
  Duration get captureDuration {
    if (_captureStartTime == null) return Duration.zero;
    return DateTime.now().difference(_captureStartTime!);
  }
  
  // Statistics getters
  int get totalOpusPacketsReceived => _totalOpusPacketsReceived;
  int get totalOpusBytesReceived => _totalOpusBytesReceived;
  int get totalPcmBytesDecoded => _totalPcmBytesDecoded;
  int get failedDecodes => _failedDecodes;
  double get decodeSuccessRate => _totalOpusPacketsReceived > 0 
      ? (_totalOpusPacketsReceived - _failedDecodes) / _totalOpusPacketsReceived 
      : 0.0;
  
  HardwareAudioCapture(this._hardwareService, [this._localAudioProcessor]) {
    // Listen to hardware service changes to ensure we're always up to date
    _hardwareService.addListener(_onHardwareServiceChanged);
  }
  
  /// Start automatically capturing audio from the hardware device
  Future<void> startCapture() async {
    if (_isCapturing) {
      throw Exception('Cannot start capture: Already capturing');
    }
    
    debugPrint('HardwareAudioCapture.startCapture: Starting capture process...');
    
    // Verify the device is actually connected
    if (!_hardwareService.isConnected) {
      throw Exception('Cannot start capture: No device connected');
    }
    
    // Double-check the connection status
    try {
      final isActuallyConnected = await _hardwareService.verifyConnection();
      if (!isActuallyConnected) {
        throw Exception('Cannot start capture: Device connection lost');
      }
    } catch (e) {
      throw Exception('Cannot start capture: Connection verification failed: $e');
    }
    
    try {
      // Request storage permissions
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission not granted');
      }
      
      // Create audio directory
      final audioDir = await _getAudioDirectory();
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      // Initialize capture
      _isCapturing = true;
      _captureStartTime = DateTime.now();
      _decodedPcmBuffer.clear();
      _currentFileSize = 0;
      _fileCounter++;
      
      // Reset statistics
      _totalOpusPacketsReceived = 0;
      _totalOpusBytesReceived = 0;
      _totalPcmBytesDecoded = 0;
      _failedDecodes = 0;
      
      // Generate initial capture filename with timestamp
      final timestamp = DateTime.now();
      final filename = _generateFilename(timestamp);
      final capturePath = '${audioDir.path}/$filename';
      _currentCapturePath = capturePath;
      
      // Start periodic file rotation timer (every 10 seconds)
      _startFileRotationTimer();
      
      // Start the audio stream from hardware
      await _hardwareService.startAudioStream();
      
      // Enable local audio processing if available
      if (_localAudioProcessor != null) {
        debugPrint('HardwareAudioCapture: Initializing local audio processor...');
        final initialized = await _localAudioProcessor!.initialize();
        debugPrint('HardwareAudioCapture: Local audio processor initialization result: $initialized');
        
        if (initialized) {
          _localAudioProcessor!.enable();
          debugPrint('HardwareAudioCapture: Local audio processing enabled');
        } else {
          debugPrint('HardwareAudioCapture: Failed to initialize local audio processor');
        }
      } else {
        debugPrint('HardwareAudioCapture: No local audio processor available');
      }
      
      // Subscribe to audio stream from hardware
      debugPrint('HardwareAudioCapture: Setting up audio stream subscription...');
      _audioSubscription = _hardwareService.audioStream.listen(
        _onAudioPacketReceived,
        onError: (error) {
          debugPrint('Audio stream error during capture: $error');
        },
        onDone: () {
          debugPrint('Audio stream subscription completed');
        },
      );
      debugPrint('HardwareAudioCapture: Audio stream subscription created successfully');
      
      notifyListeners();
      
      debugPrint('HardwareAudioCapture: Started audio capture to: $capturePath');
      
    } catch (e) {
      debugPrint('HardwareAudioCapture.startCapture: Error during capture setup: $e');
      _resetCaptureState();
      rethrow;
    }
  }
  
  /// Stop automatic audio capture
  Future<void> stopCapture() async {
    if (!_isCapturing) return;
    
    try {
      // Set capturing to false immediately to stop processing audio packets
      _isCapturing = false;
      
      // Stop the file rotation timer
      _stopFileRotationTimer();
      
      // Disable local audio processing if available
      if (_localAudioProcessor != null) {
        _localAudioProcessor!.disable();
        debugPrint('HardwareAudioCapture: Local audio processing disabled');
      }
      
      // Unsubscribe from audio stream FIRST (before stopping hardware stream)
      if (_audioSubscription != null) {
        await _audioSubscription!.cancel();
        _audioSubscription = null;
      }
      
      // Stop the audio stream from hardware
      await _hardwareService.stopAudioStream();
      
      // Reset packet reassembler to clear any pending packets
      _hardwareService.packetReassembler.reset();
      
      // Save final audio buffer as WAV file
      String? savedPath;
      if (_decodedPcmBuffer.isNotEmpty && _currentCapturePath != null) {
        savedPath = await _saveWavFile(_currentCapturePath!, _decodedPcmBuffer);
        debugPrint('HardwareAudioCapture: Final WAV file created: $savedPath');
      }
      
      _resetCaptureState();
      notifyListeners();
      
    } catch (e) {
      debugPrint('HardwareAudioCapture.stopCapture: Error stopping capture: $e');
      _resetCaptureState();
      notifyListeners();
      rethrow;
    }
  }
  
  /// Force stop all audio processing (emergency stop)
  Future<void> forceStop() async {
    try {
      // Set capturing to false immediately
      _isCapturing = false;
      
      // Cancel all timers
      _stopFileRotationTimer();
      
      // Cancel audio subscription
      if (_audioSubscription != null) {
        await _audioSubscription!.cancel();
        _audioSubscription = null;
      }
      
      // Stop hardware audio stream
      await _hardwareService.stopAudioStream();
      
      // Reset packet reassembler
      _hardwareService.packetReassembler.reset();
      
      // Reset state completely
      _resetCaptureState();
      notifyListeners();
      
    } catch (e) {
      debugPrint('HardwareAudioCapture.forceStop: Error during force stop: $e');
      // Even if there's an error, reset the state
      _resetCaptureState();
      notifyListeners();
    }
  }
  
  /// Handle incoming audio packets from hardware (automatic streaming)
  void _onAudioPacketReceived(HardwareAudioPacket packet) {
    // Double-check that we're still capturing and have an active subscription
    if (!_isCapturing || _audioSubscription == null) {
      return;
    }
    
    try {
      // Update Opus statistics
      _totalOpusPacketsReceived++;
      _totalOpusBytesReceived += packet.audioData.length;
      
      // Decode Opus data to PCM using our Opus decoder
      final decodedPcm = _hardwareService.opusDecoder.decodeOpus(packet.audioData);
      
      if (decodedPcm != null && decodedPcm.isNotEmpty) {
        // Add decoded PCM data to buffer
        _decodedPcmBuffer.addAll(decodedPcm);
        _currentFileSize += decodedPcm.length;
        _totalPcmBytesDecoded += decodedPcm.length;
        
        // Process audio with local VAD and ASR if available (asynchronously)
        if (_localAudioProcessor != null && _localAudioProcessor!.isEnabled) {
          // Process audio data asynchronously to prevent UI blocking
          _processAudioDataAsync(decodedPcm);
        }
        
        // Check if we need to create a new file (file size limit reached)
        if (_currentFileSize >= _maxFileSize) {
          _rotateCaptureFile();
        }
        
        // Check buffer size limit
        if (_decodedPcmBuffer.length > _maxBufferSize) {
          _decodedPcmBuffer.removeRange(0, _decodedPcmBuffer.length - _maxBufferSize);
        }
        
        // Notify listeners of buffer update
        notifyListeners();
        
      } else {
        _failedDecodes++;
        // Only log decode failures occasionally to avoid spam
        if (_failedDecodes % 50 == 0) {
          debugPrint('HardwareAudioCapture: Failed to decode $_failedDecodes Opus packets so far');
        }
      }
      
    } catch (e) {
      _failedDecodes++;
      debugPrint('Error processing audio packet: $e');
    }
  }
  
  /// Process audio data asynchronously to prevent UI blocking
  void _processAudioDataAsync(Uint8List decodedPcm) {
    // Process audio data directly - the isolate processor handles background processing
    try {
      _localAudioProcessor!.processAudioData(decodedPcm);
    } catch (e) {
      debugPrint('HardwareAudioCapture: Error processing audio data: $e');
    }
  }
  
  /// Start the timer for periodic file rotation (every 1 minute)
  void _startFileRotationTimer() {
    _fileRotationTimer?.cancel();
    _fileRotationTimer = Timer.periodic(_fileRotationInterval, (timer) {
      if (_isCapturing && _decodedPcmBuffer.isNotEmpty) {
        _rotateCaptureFile();
      }
    });
  }
  
  /// Stop the file rotation timer
  void _stopFileRotationTimer() {
    _fileRotationTimer?.cancel();
    _fileRotationTimer = null;
  }
  
  /// Rotate to a new capture file when size limit is reached or timer triggers
  Future<void> _rotateCaptureFile() async {
    try {
      // Process final audio chunk with local VAD and ASR if available
      if (_localAudioProcessor != null && _localAudioProcessor!.isEnabled) {
        _localAudioProcessor!.processAudioData(
          Uint8List.fromList(_decodedPcmBuffer),
          isFinal: true,
        );
        debugPrint('HardwareAudioCapture: Final audio chunk processed with local VAD/ASR');
      }
      
      // Save current PCM buffer as WAV file
      if (_decodedPcmBuffer.isNotEmpty && _currentCapturePath != null) {
        await _saveWavFile(_currentCapturePath!, _decodedPcmBuffer);
        debugPrint('HardwareAudioCapture: WAV file created: $_currentCapturePath');
      }
      
      // Clear buffer and reset file size
      _decodedPcmBuffer.clear();
      _currentFileSize = 0;
      _fileCounter++;
      
      // Generate new capture filename with timestamp
      final timestamp = DateTime.now();
      final audioDir = await _getAudioDirectory();
      final filename = _generateFilename(timestamp);
      final newCapturePath = '${audioDir.path}/$filename';
      _currentCapturePath = newCapturePath;
      
    } catch (e) {
      debugPrint('Error rotating capture file: $e');
    }
  }
  
  /// Generate a filename with timestamp and counter
  String _generateFilename(DateTime timestamp) {
    final dateStr = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}-${timestamp.minute.toString().padLeft(2, '0')}-${timestamp.second.toString().padLeft(2, '0')}';
    return 'hardware_audio_${dateStr}_${timeStr}_${_fileCounter.toString().padLeft(3, '0')}$_audioFileExtension';
  }
  


  /// Save PCM data as a WAV file
  Future<String?> _saveWavFile(String filePath, List<int> pcmData) async {
    try {
      // Convert PCM data to WAV format using our Opus decoder service
      final wavData = _hardwareService.opusDecoder.convertPcmToWav(
        Uint8List.fromList(pcmData),
        sampleRate: 16000,  // OMI firmware sample rate
        channels: 1,        // OMI firmware mono audio
        bitDepth: 16,       // OMI firmware 16-bit
      );
      
      if (wavData.isNotEmpty) {
        final file = File(filePath);
        await file.writeAsBytes(wavData);
        
        // Verify file was created
        if (await file.exists()) {
          final fileSize = await file.length();
          debugPrint('HardwareAudioCapture: WAV file created: $filePath ($fileSize bytes)');
          return filePath;
        }
      }
      
      debugPrint('Failed to create WAV file: $filePath');
      return null;
      
    } catch (e) {
      debugPrint('Error saving WAV file: $e');
      return null;
    }
  }
  
  /// Get the audio directory
  Future<Directory> _getAudioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/$_audioDirectory');
  }
  
  /// Request storage permission
  Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        return status.isGranted;
      } else if (Platform.isIOS) {
        // iOS doesn't require explicit storage permission
        return true;
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting storage permission: $e');
      return false;
    }
  }
  
  /// Reset capture state
  void _resetCaptureState() {
    _isCapturing = false;
    _captureStartTime = null;
    _currentCapturePath = null;
    _decodedPcmBuffer.clear();
    _currentFileSize = 0;
    _stopFileRotationTimer();
    
    // Ensure audio subscription is also cleared
    if (_audioSubscription != null) {
      _audioSubscription!.cancel();
      _audioSubscription = null;
    }
  }
  
  /// Get list of captured audio files (now WAV files)
  Future<List<FileSystemEntity>> getCapturedFiles() async {
    try {
      final audioDir = await _getAudioDirectory();
      if (!await audioDir.exists()) return [];
      
      final files = audioDir.listSync()
          .where((entity) => entity is File && entity.path.endsWith(_audioFileExtension))
          .toList();
      
      // Sort by modification time (newest first)
      files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      
      return files;
    } catch (e) {
      debugPrint('Error getting captured files: $e');
      return [];
    }
  }
  
  /// Delete a captured audio file
  Future<bool> deleteCapturedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted captured WAV file: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting captured file: $e');
      return false;
    }
  }
  
  /// Get capture statistics
  Map<String, dynamic> getCaptureStats() {
    return {
      'isCapturing': _isCapturing,
      'captureStartTime': _captureStartTime?.toIso8601String(),
      'captureDuration': captureDuration.inMilliseconds,
      'pcmBufferSize': _decodedPcmBuffer.length,
      'currentFileSize': _currentFileSize,
      'fileCounter': _fileCounter,
      'currentCapturePath': _currentCapturePath,
      'fileRotationInterval': _fileRotationInterval.inSeconds,
      'totalOpusPacketsReceived': _totalOpusPacketsReceived,
      'totalOpusBytesReceived': _totalOpusBytesReceived,
      'totalPcmBytesDecoded': _totalPcmBytesDecoded,
      'failedDecodes': _failedDecodes,
      'decodeSuccessRate': decodeSuccessRate,
      'localAudioProcessingEnabled': _localAudioProcessor?.isEnabled ?? false,
      'localAudioProcessingStats': _localAudioProcessor?.getStats(),
    };
  }
  
  /// Handle hardware service changes
  void _onHardwareServiceChanged() {
    // Notify listeners when hardware service state changes
    notifyListeners();
  }

  @override
  void dispose() {
    _hardwareService.removeListener(_onHardwareServiceChanged);
    _audioSubscription?.cancel();
    _fileRotationTimer?.cancel();
    super.dispose();
  }
}
