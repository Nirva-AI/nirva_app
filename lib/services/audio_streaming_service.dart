import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'hardware_audio_recorder.dart';

/// Audio streaming service that integrates hardware recording with S3 upload and transcription
/// 
/// This service automatically uploads WAV files created by the hardware audio recorder
/// to S3, which triggers the existing Lambda function to start transcription.
class AudioStreamingService extends ChangeNotifier {
  final HardwareAudioCapture _audioRecorder;
  final String _userId;
  
  // Stream subscription for monitoring new WAV files
  StreamSubscription<FileSystemEvent>? _fileWatcher;
  
  // Upload state
  bool _isUploading = false;
  final List<String> _uploadedFiles = [];
  final List<String> _uploadErrors = [];
  
  // File monitoring
  Directory? _audioDirectory;
  final List<String> _processedFiles = [];
  
  // Getters
  bool get isUploading => _isUploading;
  List<String> get uploadedFiles => List.unmodifiable(_uploadedFiles);
  List<String> get uploadErrors => List.unmodifiable(_uploadErrors);
  List<String> get processedFiles => List.unmodifiable(_processedFiles);
  
  AudioStreamingService(this._audioRecorder, this._userId) {
    _initializeFileWatcher();
  }
  
  /// Initialize file watcher to monitor for new WAV files
  Future<void> _initializeFileWatcher() async {
    try {
      _audioDirectory = await _getAudioDirectory();
      if (!await _audioDirectory!.exists()) {
        await _audioDirectory!.create(recursive: true);
      }
      
      // Start watching for new files
      _fileWatcher = _audioDirectory!.watch(events: FileSystemEvent.create)
          .listen(_onNewFileCreated, onError: (error) {
        debugPrint('AudioStreamingService: File watcher error: $error');
      });
      
      debugPrint('AudioStreamingService: File watcher initialized for directory: ${_audioDirectory!.path}');
      
      // Process any existing WAV files that haven't been processed
      await _processExistingFiles();
      
    } catch (e) {
      debugPrint('AudioStreamingService: Error initializing file watcher: $e');
    }
  }
  
  /// Handle new file creation events
  void _onNewFileCreated(FileSystemEvent event) {
    if (event.type == FileSystemEvent.create && event.path.endsWith('.wav')) {
      debugPrint('AudioStreamingService: New WAV file detected: ${event.path}');
      
      // Wait a moment for the file to be fully written
      Timer(const Duration(milliseconds: 500), () {
        _processNewWavFile(event.path);
      });
    }
  }
  
  /// Process existing WAV files that haven't been uploaded yet
  Future<void> _processExistingFiles() async {
    try {
      final files = await _audioRecorder.getCapturedFiles();
      for (final fileEntity in files) {
        if (fileEntity is File && fileEntity.path.endsWith('.wav')) {
          final filePath = fileEntity.path;
          if (!_processedFiles.contains(filePath)) {
            debugPrint('AudioStreamingService: Processing existing WAV file: $filePath');
            await _processNewWavFile(filePath);
          }
        }
      }
    } catch (e) {
      debugPrint('AudioStreamingService: Error processing existing files: $e');
    }
  }
  
  /// Process a new WAV file by uploading it to S3
  Future<void> _processNewWavFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('AudioStreamingService: File no longer exists: $filePath');
        return;
      }
      
      // Check if file is already processed
      if (_processedFiles.contains(filePath)) {
        debugPrint('AudioStreamingService: File already processed: $filePath');
        return;
      }
      
      // Check if file is still being written (size is stable)
      final initialSize = await file.length();
      await Future.delayed(const Duration(milliseconds: 100));
      final finalSize = await file.length();
      
      if (initialSize != finalSize) {
        debugPrint('AudioStreamingService: File still being written, waiting...');
        // Wait a bit more and try again
        Timer(const Duration(seconds: 2), () {
          _processNewWavFile(filePath);
        });
        return;
      }
      
      // Upload file to S3
      await _uploadWavFileToS3(file);
      
      // Mark as processed
      _processedFiles.add(filePath);
      
    } catch (e) {
      debugPrint('AudioStreamingService: Error processing WAV file $filePath: $e');
      _uploadErrors.add('Failed to process $filePath: $e');
      notifyListeners();
    }
  }
  
  /// Upload a WAV file to S3
  Future<void> _uploadWavFileToS3(File wavFile) async {
    try {
      _isUploading = true;
      notifyListeners();
      
      debugPrint('AudioStreamingService: Starting S3 upload for: ${wavFile.path}');
      
      // Generate unique task ID for this upload
      final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
      
      // Generate unique filename
      final originalFilename = wavFile.path.split('/').last;
      final uniqueFilename = '${DateTime.now().millisecondsSinceEpoch}_$originalFilename';
      
      // Build S3 path using the existing S3PathHelper pattern
      final s3Path = 'private/$_userId/tasks/$taskId/audio/$uniqueFilename';
      
      debugPrint('AudioStreamingService: Uploading to S3 path: $s3Path');
      
      // Upload file to S3 using Amplify Storage
      final uploadOperation = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(wavFile.path),
        path: StoragePath.fromString(s3Path),
        options: StorageUploadFileOptions(
          metadata: {
            'fileType': 'audio',
            'originalName': originalFilename,
            'uploadTime': DateTime.now().toIso8601String(),
            'uploadMethod': 'hardware_recorder',
            'userId': _userId,
            'taskId': taskId,
            'source': 'hardware_audio_capture',
            'audioFormat': 'wav',
            'sampleRate': '16000',
            'channels': '1',
            'bitDepth': '16',
          },
        ),
      );
      
      // Wait for upload to complete
      await uploadOperation.result;
      
      debugPrint('AudioStreamingService: S3 upload successful: $s3Path');
      
      // Add to uploaded files list
      _uploadedFiles.add(s3Path);
      
      // The S3 upload will automatically trigger the Lambda function (S3Trigger0f8e56ad)
      // which will start the transcription job
      debugPrint('AudioStreamingService: Transcription job will be automatically started by Lambda');
      
    } catch (e) {
      final errorMsg = 'Failed to upload ${wavFile.path}: $e';
      debugPrint('AudioStreamingService: $errorMsg');
      _uploadErrors.add(errorMsg);
      rethrow;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
  
  /// Get the audio directory
  Future<Directory> _getAudioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/hardware_audio');
  }
  
  /// Manually trigger processing of all existing WAV files
  Future<void> processAllExistingFiles() async {
    try {
      debugPrint('AudioStreamingService: Manually processing all existing WAV files...');
      await _processExistingFiles();
      debugPrint('AudioStreamingService: Manual processing complete');
    } catch (e) {
      debugPrint('AudioStreamingService: Error in manual processing: $e');
    }
  }
  
  /// Get service statistics
  Map<String, dynamic> getStats() {
    return {
      'isUploading': _isUploading,
      'uploadedFilesCount': _uploadedFiles.length,
      'uploadErrorsCount': _uploadErrors.length,
      'processedFilesCount': _processedFiles.length,
      'audioDirectory': _audioDirectory?.path,
      'isFileWatcherActive': _fileWatcher != null,
    };
  }
  
  /// Clear upload history
  void clearHistory() {
    _uploadedFiles.clear();
    _uploadErrors.clear();
    _processedFiles.clear();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _fileWatcher?.cancel();
    super.dispose();
  }
}
