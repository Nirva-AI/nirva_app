import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../my_hive_objects.dart';
import 'cloud_audio_processor.dart';
import '../hive_helper.dart'; // Added import for HiveHelper

/// Service for managing persistent storage of cloud ASR transcription results
/// 
/// This service handles:
/// 1. Storing transcription results in Hive database
/// 2. Managing audio files in persistent storage
/// 3. Retrieving stored results across app sessions
/// 4. Session management for grouping related transcriptions
class CloudAsrStorageService extends ChangeNotifier {
  static const String _resultsBoxName = 'cloudAsrResultsBox';
  static const String _sessionsBoxName = 'cloudAsrSessionsBox';
  
  late Box<CloudAsrResultStorage> _resultsBox;
  late Box<CloudAsrSessionStorage> _sessionsBox;
  
  String? _currentUserId;
  String? _currentSessionId;
  String? _currentDeviceInfo;
  
  bool _isInitialized = false;
  
  // Getters
  bool get isInitialized => _isInitialized;
  String? get currentUserId => _currentUserId;
  String? get currentSessionId => _currentSessionId;
  
  /// Initialize the storage service
  Future<bool> initialize({String? userId, String? deviceInfo}) async {
    if (_isInitialized) {
      debugPrint('CloudAsrStorageService: Already initialized');
      return true;
    }
    
    try {
      debugPrint('CloudAsrStorageService: Initializing storage service... [${DateTime.now().toIso8601String()}]');
      debugPrint('CloudAsrStorageService: User ID: $userId, Device Info: $deviceInfo');
      
      // Check if adapters are registered before opening boxes
      debugPrint('CloudAsrStorageService: Checking Hive adapters...');
      debugPrint('CloudAsrStorageService: CloudAsrResultStorageAdapter registered: ${Hive.isAdapterRegistered(13)}');
      debugPrint('CloudAsrStorageService: CloudAsrSessionStorageAdapter registered: ${Hive.isAdapterRegistered(14)}');
      
      // Wait for adapters to be registered (retry mechanism)
      int retryCount = 0;
      const maxRetries = 20; // Increased retries
      const retryDelay = Duration(milliseconds: 200); // Increased delay
      
      while ((!Hive.isAdapterRegistered(13) || !Hive.isAdapterRegistered(14)) && retryCount < maxRetries) {
        debugPrint('CloudAsrStorageService: Waiting for adapters to be registered... (attempt ${retryCount + 1}/$maxRetries)');
        debugPrint('CloudAsrStorageService: Current status - CloudAsrResultStorageAdapter: ${Hive.isAdapterRegistered(13)}, CloudAsrSessionStorageAdapter: ${Hive.isAdapterRegistered(14)}');
        await Future.delayed(retryDelay);
        retryCount++;
      }
      
      if (!Hive.isAdapterRegistered(13) || !Hive.isAdapterRegistered(14)) {
        debugPrint('CloudAsrStorageService: ERROR - Required Hive adapters not registered after $maxRetries retries!');
        debugPrint('CloudAsrStorageService: Cannot proceed without adapters');
        debugPrint('CloudAsrStorageService: Final check - CloudAsrResultStorageAdapter: ${Hive.isAdapterRegistered(13)}, CloudAsrSessionStorageAdapter: ${Hive.isAdapterRegistered(14)}');
        
        // Try to manually register adapters as a fallback
        debugPrint('CloudAsrStorageService: Attempting manual adapter registration...');
        try {
          if (!Hive.isAdapterRegistered(13)) {
            Hive.registerAdapter(CloudAsrResultStorageAdapter());
            debugPrint('CloudAsrStorageService: Manually registered CloudAsrResultStorageAdapter');
          }
          if (!Hive.isAdapterRegistered(14)) {
            Hive.registerAdapter(CloudAsrSessionStorageAdapter());
            debugPrint('CloudAsrStorageService: Manually registered CloudAsrSessionStorageAdapter');
          }
          
          if (Hive.isAdapterRegistered(13) && Hive.isAdapterRegistered(14)) {
            debugPrint('CloudAsrStorageService: Manual registration successful!');
          } else {
            debugPrint('CloudAsrStorageService: Manual registration failed');
            return false;
          }
        } catch (e) {
          debugPrint('CloudAsrStorageService: Manual registration error: $e');
          return false;
        }
      }
      
      debugPrint('CloudAsrStorageService: All required adapters are now registered');
      
      // Use pre-opened boxes from HiveHelper instead of opening them again
      try {
        _resultsBox = HiveHelper.getCloudAsrResultsBox();
        _sessionsBox = HiveHelper.getCloudAsrSessionsBox();
        debugPrint('CloudAsrStorageService: Using pre-opened boxes from HiveHelper');
      } catch (e) {
        debugPrint('CloudAsrStorageService: Error getting pre-opened boxes: $e');
        debugPrint('CloudAsrStorageService: Falling back to opening boxes manually...');
        // Fallback: open boxes manually if getting pre-opened boxes fails
        _resultsBox = await Hive.openBox<CloudAsrResultStorage>(_resultsBoxName);
        _sessionsBox = await Hive.openBox<CloudAsrSessionStorage>(_sessionsBoxName);
      }
      
      debugPrint('CloudAsrStorageService: Hive boxes ready - Results: ${_resultsBox.length}, Sessions: ${_sessionsBox.length}');
      
      // Set user ID and device info
      _currentUserId = userId ?? 'default_user';
      _currentDeviceInfo = deviceInfo ?? 'unknown_device';
      
      // Update file paths for existing results (in case app container ID changed)
      await _updateFilePathsForAppRestart();
      
      // Initialize current session
      await _initializeCurrentSession();
      
      _isInitialized = true;
      debugPrint('CloudAsrStorageService: Storage service initialized successfully');
      notifyListeners();
      
      return true;
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Failed to initialize: $e');
      _isInitialized = false;
      return false;
    }
  }
  
  /// Initialize or resume current session
  Future<void> _initializeCurrentSession() async {
    try {
      // Look for active session for current user
      final activeSessions = _sessionsBox.values
          .where((session) => session.userId == _currentUserId && session.isActive)
          .toList();
      
      if (activeSessions.isNotEmpty) {
        // Resume existing active session
        _currentSessionId = activeSessions.first.sessionId;
        debugPrint('CloudAsrStorageService: Resumed existing session: $_currentSessionId');
      } else {
        // Create new session
        final newSession = CloudAsrSessionStorage.create(
          userId: _currentUserId!,
          deviceInfo: _currentDeviceInfo!,
        );
        _currentSessionId = newSession.sessionId;
        await _sessionsBox.add(newSession);
        debugPrint('CloudAsrStorageService: Created new session: $_currentSessionId');
      }
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error initializing session: $e');
    }
  }
  
  /// Store a cloud ASR result persistently
  Future<bool> storeResult(CloudAudioResult result) async {
    if (!_isInitialized || _currentUserId == null || _currentSessionId == null) {
      debugPrint('CloudAsrStorageService: Cannot store result - service not initialized');
      return false;
    }
    
    try {
      // Create storage object
      final storageResult = CloudAsrResultStorage.fromCloudAudioResult(
        result,
        _currentUserId!,
        _currentSessionId!,
      );
      
      // Store audio file persistently if it exists
      if (result.audioFilePath != null) {
        final persistentAudioPath = await _moveAudioToPersistentStorage(
          result.audioFilePath!,
          storageResult.id,
        );
        if (persistentAudioPath != null) {
          storageResult.audioFilePath = persistentAudioPath;
        }
      }
      
      // Store in Hive
      await _resultsBox.add(storageResult);
      
      // Update session with result ID
      final session = _sessionsBox.values
          .firstWhere((s) => s.sessionId == _currentSessionId);
      session.addResult(storageResult.id);
      await session.save();
      
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Failed to store result: $e');
      return false;
    }
  }
  
  /// Move audio file to persistent storage
  Future<String?> _moveAudioToPersistentStorage(String tempFilePath, String resultId) async {
    try {
      final tempFile = File(tempFilePath);
      if (!await tempFile.exists()) {
        debugPrint('CloudAsrStorageService: Temporary audio file not found: $tempFilePath');
        return null;
      }
      
      // Get persistent audio directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${appDocDir.path}/cloud_asr_audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      // Generate persistent filename
      final extension = tempFilePath.split('.').last;
      final persistentFilename = '$resultId.$extension';
      final persistentPath = '${audioDir.path}/$persistentFilename';
      
      // Copy file to persistent location
      await tempFile.copy(persistentPath);
      
      debugPrint('CloudAsrStorageService: Audio file moved to persistent storage: $persistentPath');
      return persistentPath;
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Failed to move audio file: $e');
      return null;
    }
  }
  
  /// Update file paths for existing results when app container ID changes
  Future<void> _updateFilePathsForAppRestart() async {
    try {
      debugPrint('CloudAsrStorageService: Checking for file path updates due to app restart...');
      
      // Get current app documents directory
      final currentAppDir = await getApplicationDocumentsDirectory();
      final currentCloudAsrDir = Directory('${currentAppDir.path}/cloud_asr_audio');
      
      // Ensure the directory exists
      if (!await currentCloudAsrDir.exists()) {
        await currentCloudAsrDir.create(recursive: true);
        debugPrint('CloudAsrStorageService: Created cloud_asr_audio directory: ${currentCloudAsrDir.path}');
      }
      
      int updatedCount = 0;
      int copiedCount = 0;
      int missingCount = 0;
      
      // Check all existing results
      for (final result in _resultsBox.values) {
        if (result.audioFilePath != null) {
          final oldFile = File(result.audioFilePath!);
          
          // Check if the old file path is still valid
          if (await oldFile.exists()) {
            // debugPrint('CloudAsrStorageService: File still exists at old path: ${result.audioFilePath}');
            continue; // File is still accessible
          }
          
          // File doesn't exist at old path, try to find it in current app directory
          final fileName = result.audioFilePath!.split('/').last;
          final newPath = '${currentCloudAsrDir.path}/$fileName';
          final newFile = File(newPath);
          
          if (await newFile.exists()) {
            // File exists at new path, just update the stored path
            result.audioFilePath = newPath;
            await result.save();
            updatedCount++;
          } else {
            // Try to find the file in the old app container directory
            final oldAppContainerPath = result.audioFilePath!;
            final oldAppContainerDir = oldAppContainerPath.substring(0, oldAppContainerPath.indexOf('/Documents/'));
            final oldCloudAsrDir = Directory('$oldAppContainerDir/Documents/cloud_asr_audio');
            
            if (await oldCloudAsrDir.exists()) {
              final oldFileInOldContainer = File('${oldCloudAsrDir.path}/$fileName');
              if (await oldFileInOldContainer.exists()) {
                try {
                  // Copy the file to the new location
                  await oldFileInOldContainer.copy(newPath);
                  result.audioFilePath = newPath;
                  await result.save();
                  copiedCount++;
                  debugPrint('CloudAsrStorageService: Copied file from ${oldFileInOldContainer.path} to $newPath');
                } catch (e) {
                  debugPrint('CloudAsrStorageService: Failed to copy file: $e');
                  missingCount++;
                }
              } else {
                missingCount++;
                debugPrint('CloudAsrStorageService: File not found in old container: ${oldFileInOldContainer.path}');
              }
            } else {
              missingCount++;
              debugPrint('CloudAsrStorageService: Old container directory not found: ${oldCloudAsrDir.path}');
            }
          }
        }
      }
      
      debugPrint('CloudAsrStorageService: File path update complete - Updated: $updatedCount, Copied: $copiedCount, Missing: $missingCount');
      
      if (missingCount > 0) {
        debugPrint('CloudAsrStorageService: Warning: $missingCount audio files could not be located or copied');
      }
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error updating file paths: $e');
    }
  }
  
  /// Get all stored results for current user
  List<CloudAsrResultStorage> getAllResults() {
    if (!_isInitialized || _currentUserId == null) {
      debugPrint('CloudAsrStorageService: Cannot get results - initialized: $_isInitialized, userId: $_currentUserId');
      return [];
    }
    
    try {
      final results = _resultsBox.values
          .where((result) => result.userId == _currentUserId)
          .toList()
        ..sort((a, b) => DateTime.parse(b.processingTimeIso)
            .compareTo(DateTime.parse(a.processingTimeIso)));
      
      return results;
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error getting results: $e');
      return [];
    }
  }
  
  /// Get results for a specific session
  List<CloudAsrResultStorage> getSessionResults(String sessionId) {
    if (!_isInitialized) {
      return [];
    }
    
    try {
      return _resultsBox.values
          .where((result) => result.sessionId == sessionId)
          .toList()
        ..sort((a, b) => DateTime.parse(b.processingTimeIso)
            .compareTo(DateTime.parse(a.processingTimeIso)));
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error getting session results: $e');
      return [];
    }
  }
  
  /// Get all sessions for current user
  List<CloudAsrSessionStorage> getAllSessions() {
    if (!_isInitialized || _currentUserId == null) {
      return [];
    }
    
    try {
      return _sessionsBox.values
          .where((session) => session.userId == _currentUserId)
          .toList()
        ..sort((a, b) => DateTime.parse(b.startTimeIso)
            .compareTo(DateTime.parse(a.startTimeIso)));
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error getting sessions: $e');
      return [];
    }
  }
  
  /// End current session
  Future<void> endCurrentSession() async {
    if (!_isInitialized || _currentSessionId == null) {
      return;
    }
    
    try {
      final session = _sessionsBox.values
          .firstWhere((s) => s.sessionId == _currentSessionId);
      session.endSession();
      await session.save();
      
      debugPrint('CloudAsrStorageService: Ended session: $_currentSessionId');
      _currentSessionId = null;
      
      // Create new session for next recording
      await _initializeCurrentSession();
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error ending session: $e');
    }
  }
  
  /// Delete a specific result and its audio file
  Future<bool> deleteResult(String resultId) async {
    if (!_isInitialized) {
      return false;
    }
    
    try {
      final result = _resultsBox.values
          .firstWhere((r) => r.id == resultId);
      
      // Delete audio file if it exists
      if (result.audioFilePath != null) {
        final audioFile = File(result.audioFilePath!);
        if (await audioFile.exists()) {
          await audioFile.delete();
          debugPrint('CloudAsrStorageService: Deleted audio file: ${result.audioFilePath}');
        }
      }
      
      // Remove from Hive
      await result.delete();
      
      // Remove from session
      final session = _sessionsBox.values
          .firstWhere((s) => s.sessionId == result.sessionId);
      session.resultIds.remove(resultId);
      await session.save();
      
      debugPrint('CloudAsrStorageService: Deleted result: $resultId');
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error deleting result: $e');
      return false;
    }
  }
  
  /// Clear all results for current user
  Future<void> clearAllResults() async {
    if (!_isInitialized || _currentUserId == null) {
      return;
    }
    
    try {
      final userResults = _resultsBox.values
          .where((result) => result.userId == _currentUserId)
          .toList();
      
      // Delete audio files
      for (final result in userResults) {
        if (result.audioFilePath != null) {
          final audioFile = File(result.audioFilePath!);
          if (await audioFile.exists()) {
            await audioFile.delete();
          }
        }
      }
      
      // Clear from Hive
      await _resultsBox.clear();
      
      // Clear sessions
      await _sessionsBox.clear();
      
      debugPrint('CloudAsrStorageService: Cleared all results for user: $_currentUserId');
      notifyListeners();
      
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error clearing results: $e');
    }
  }
  
  /// Get storage statistics
  Map<String, dynamic> getStorageStats() {
    if (!_isInitialized || _currentUserId == null) {
      return {};
    }
    
    try {
      final userResults = _resultsBox.values
          .where((result) => result.userId == _currentUserId)
          .toList();
      
      final userSessions = _sessionsBox.values
          .where((session) => session.userId == _currentUserId)
          .toList();
      
      final totalAudioSize = userResults.fold<int>(
        0, (sum, result) => sum + result.audioDataSize);
      
      return {
        'totalResults': userResults.length,
        'totalSessions': userSessions.length,
        'totalAudioSizeBytes': totalAudioSize,
        'totalAudioSizeMB': (totalAudioSize / (1024 * 1024)).toStringAsFixed(2),
        'activeSessions': userSessions.where((s) => s.isActive).length,
      };
    } catch (e) {
      debugPrint('CloudAsrStorageService: Error getting storage stats: $e');
      return {};
    }
  }
  
  /// Dispose resources
  @override
  void dispose() {
    _resultsBox.close();
    _sessionsBox.close();
    super.dispose();
  }
}
