import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/hardware_device.dart';
import 'hardware_service.dart';

class HardwareAudioCapture extends ChangeNotifier {
  final HardwareService _hardwareService;
  
  // Audio capture state
  bool _isCapturing = false;
  DateTime? _captureStartTime;
  String? _currentCapturePath;
  StreamSubscription<HardwareAudioPacket>? _audioSubscription;
  
  // Audio buffer for continuous capture
  final List<int> _audioBuffer = [];
  final int _maxBufferSize = 1024 * 1024; // 1MB buffer
  
  // Capture settings
  final String _audioDirectory = 'hardware_audio';
  final String _audioFileExtension = '.opus';
  final int _maxFileSize = 10 * 1024 * 1024; // 10MB max file size
  
  // File management
  int _currentFileSize = 0;
  int _fileCounter = 0;
  
  // Timer for periodic file rotation (every 1 minute)
  Timer? _fileRotationTimer;
  static const Duration _fileRotationInterval = Duration(minutes: 1);
  
  // Getters
  bool get isCapturing => _isCapturing;
  DateTime? get captureStartTime => _captureStartTime;
  String? get currentCapturePath => _currentCapturePath;
  Duration get captureDuration {
    if (_captureStartTime == null) return Duration.zero;
    return DateTime.now().difference(_captureStartTime!);
  }
  
  HardwareAudioCapture(this._hardwareService) {
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
      _audioBuffer.clear();
      _currentFileSize = 0;
      _fileCounter++;
      
      // Generate initial capture filename with timestamp
      final timestamp = DateTime.now();
      final filename = _generateFilename(timestamp);
      final capturePath = '${audioDir.path}/$filename';
      _currentCapturePath = capturePath;
      
      // Start periodic file rotation timer (every 1 minute)
      _startFileRotationTimer();
      
      // Start the audio stream from hardware
      await _hardwareService.startAudioStream();
      
      // Subscribe to audio stream from hardware
      _audioSubscription = _hardwareService.audioStream.listen(
        _onAudioPacketReceived,
        onError: (error) {
          debugPrint('Audio stream error during capture: $error');
        },
      );
      
      notifyListeners();
      
      debugPrint('HardwareAudioCapture.startCapture: Started automatic audio capture to: $capturePath');
      
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
      
      // Stop the audio stream from hardware first
      await _hardwareService.stopAudioStream();
      
      // Unsubscribe from audio stream
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      
      // Save final audio buffer
      String? savedPath;
      if (_audioBuffer.isNotEmpty && _currentCapturePath != null) {
        savedPath = await _saveAudioFile(_currentCapturePath!, _audioBuffer);
        debugPrint('Final audio capture saved to: $savedPath');
      }
      
      _resetCaptureState();
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error stopping capture: $e');
      _resetCaptureState();
      notifyListeners();
      rethrow;
    }
  }
  
  /// Handle incoming audio packets from hardware (automatic streaming)
  void _onAudioPacketReceived(HardwareAudioPacket packet) {
    // Double-check that we're still capturing
    if (!_isCapturing || _audioSubscription == null) return;
    
    try {
      // Add audio data to buffer
      _audioBuffer.addAll(packet.audioData);
      _currentFileSize += packet.audioData.length;
      
      // Check if we need to create a new file (file size limit reached)
      if (_currentFileSize >= _maxFileSize) {
        _rotateCaptureFile();
      }
      
      // Check buffer size limit
      if (_audioBuffer.length > _maxBufferSize) {
        debugPrint('Audio buffer size limit reached, trimming...');
        _audioBuffer.removeRange(0, _audioBuffer.length - _maxBufferSize);
      }
      
      // Notify listeners of buffer update
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error processing audio packet: $e');
    }
  }
  
  /// Start the timer for periodic file rotation (every 1 minute)
  void _startFileRotationTimer() {
    _fileRotationTimer?.cancel();
    _fileRotationTimer = Timer.periodic(_fileRotationInterval, (timer) {
      if (_isCapturing && _audioBuffer.isNotEmpty) {
        debugPrint('File rotation timer triggered - rotating capture file');
        _rotateCaptureFile();
      }
    });
    debugPrint('Started file rotation timer with ${_fileRotationInterval.inSeconds} second interval');
  }
  
  /// Stop the file rotation timer
  void _stopFileRotationTimer() {
    _fileRotationTimer?.cancel();
    _fileRotationTimer = null;
    debugPrint('Stopped file rotation timer');
  }
  
  /// Rotate to a new capture file when size limit is reached or timer triggers
  Future<void> _rotateCaptureFile() async {
    try {
      // Save current buffer to current file
      if (_audioBuffer.isNotEmpty && _currentCapturePath != null) {
        await _saveAudioFile(_currentCapturePath!, _audioBuffer);
        debugPrint('Audio capture file rotated: $_currentCapturePath');
      }
      
      // Clear buffer and reset file size
      _audioBuffer.clear();
      _currentFileSize = 0;
      _fileCounter++;
      
      // Generate new capture filename with timestamp
      final timestamp = DateTime.now();
      final audioDir = await _getAudioDirectory();
      final filename = _generateFilename(timestamp);
      final newCapturePath = '${audioDir.path}/$filename';
      _currentCapturePath = newCapturePath;
      
      debugPrint('Rotated to new capture file: $newCapturePath');
      
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
  
  /// Save audio buffer to file
  Future<String?> _saveAudioFile(String filePath, List<int> audioData) async {
    try {
      final file = File(filePath);
      await file.writeAsBytes(audioData);
      
      // Verify file was created
      if (await file.exists()) {
        final fileSize = await file.length();
        debugPrint('Audio file saved: $filePath ($fileSize bytes)');
        return filePath;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error saving audio file: $e');
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
    _audioBuffer.clear();
    _currentFileSize = 0;
    _stopFileRotationTimer();
    
    // Note: Audio stream is stopped in stopCapture() method
  }
  
  /// Get list of captured audio files
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
        debugPrint('Deleted captured file: $filePath');
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
      'bufferSize': _audioBuffer.length,
      'currentFileSize': _currentFileSize,
      'fileCounter': _fileCounter,
      'currentCapturePath': _currentCapturePath,
      'fileRotationInterval': _fileRotationInterval.inSeconds,
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
