import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../my_hive_objects.dart';
import '../nirva_api.dart';
import '../hive_helper.dart';

/// Service for syncing transcriptions to the backend
/// 
/// This service handles:
/// 1. Tracking the last sent transcription timestamp
/// 2. Batching new transcriptions every 5 minutes
/// 3. Sending transcriptions to the backend
/// 4. Handling the initial bulk upload for existing transcriptions
class TranscriptionSyncService extends ChangeNotifier {
  static const String _lastSentTimestampKey = 'last_sent_transcription_timestamp';
  static const Duration _batchInterval = Duration(minutes: 5);
  
  Timer? _batchTimer;
  bool _isInitialized = false;
  bool _isSyncing = false;
  DateTime? _lastSentTimestamp;
  final List<String> _pendingTranscriptionIds = [];
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSentTimestamp => _lastSentTimestamp;
  List<String> get pendingTranscriptionIds => List.unmodifiable(_pendingTranscriptionIds);
  
  /// Initialize the sync service
  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }
    
    try {
      // Load last sent timestamp from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final timestampString = prefs.getString(_lastSentTimestampKey);
      if (timestampString != null) {
        _lastSentTimestamp = DateTime.parse(timestampString);
      }
      
      _isInitialized = true;
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('TranscriptionSyncService: Initialization failed: $e');
      return false;
    }
  }
  
  /// Start the batch timer only when there are pending transcriptions
  void _startBatchTimer() {
    if (_pendingTranscriptionIds.isNotEmpty && _batchTimer == null) {
      _batchTimer = Timer(_batchInterval, () {
        _processBatchSync();
      });
    }
  }
  
  /// Stop the batch timer when no transcriptions are pending
  void _stopBatchTimer() {
    if (_batchTimer != null) {
      _batchTimer!.cancel();
      _batchTimer = null;
    }
  }
  
  /// Add a transcription to the pending queue
  void addPendingTranscription(String transcriptionId) {
    if (!_pendingTranscriptionIds.contains(transcriptionId)) {
      _pendingTranscriptionIds.add(transcriptionId);
      
      // Start timer if this is the first pending transcription
      _startBatchTimer();
      
      notifyListeners();
    }
  }
  
  /// Process batch sync when timer fires
  Future<void> _processBatchSync() async {
    if (_isSyncing || _pendingTranscriptionIds.isEmpty) {
      return;
    }
    
    await _syncPendingTranscriptions();
  }
  
  /// Manually trigger sync of pending transcriptions
  Future<bool> syncPendingTranscriptions() async {
    if (_isSyncing) {
      debugPrint('TranscriptionSyncService: Sync already in progress');
      return false;
    }
    
    return await _syncPendingTranscriptions();
  }
  
  /// Sync all pending transcriptions to the backend
  Future<bool> _syncPendingTranscriptions() async {
    if (_pendingTranscriptionIds.isEmpty) {
      debugPrint('TranscriptionSyncService: No pending transcriptions to sync');
      return true;
    }
    
    _isSyncing = true;
    notifyListeners();
    
    try {
      debugPrint('TranscriptionSyncService: Starting sync of ${_pendingTranscriptionIds.length} transcriptions');
      
      // Get the transcriptions from Hive
      final resultsBox = HiveHelper.getCloudAsrResultsBox();
      final transcriptions = <CloudAsrResultStorage>[];
      
      for (final id in _pendingTranscriptionIds) {
        try {
          final result = resultsBox.values.firstWhere((r) => r.id == id);
          transcriptions.add(result);
        } catch (e) {
          debugPrint('TranscriptionSyncService: Could not find transcription with ID: $id');
        }
      }
      
      if (transcriptions.isEmpty) {
        debugPrint('TranscriptionSyncService: No valid transcriptions found for sync');
        _pendingTranscriptionIds.clear();
        return true;
      }
      
      // Send ALL transcriptions in one single request (much more efficient!)
      final transcriptItems = transcriptions
          .where((t) => t.transcription != null && t.transcription!.isNotEmpty)
          .map((t) {
            // Send ISO timestamp with timezone information
            return {
              'time_stamp': t.startTimeIso,  // Already in ISO format with timezone
              'content': t.transcription!,
              'start_time': t.startTimeIso,
              'end_time': t.endTimeIso,
            };
          })
          .toList();
      
      debugPrint('TranscriptionSyncService: Sending ${transcriptItems.length} transcriptions in one request');
      
      // Send all transcriptions in one API call
      final response = await NirvaAPI.uploadTranscriptBatch(transcriptItems);
      final allSuccess = response != null;
      
      if (allSuccess) {
        // Update last sent timestamp and clear pending queue
        _lastSentTimestamp = DateTime.now();
        _pendingTranscriptionIds.clear();
        
        // Stop timer since queue is now empty
        _stopBatchTimer();
        
        // Save timestamp to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_lastSentTimestampKey, _lastSentTimestamp!.toIso8601String());
        
        debugPrint('TranscriptionSyncService: Successfully synced all transcriptions');
        
        // Trigger analysis for the date to convert transcripts to events
        await _triggerAnalysisAfterSync(transcriptItems);
        
        notifyListeners();
      }
      
      return allSuccess;
      
    } catch (e) {
      debugPrint('TranscriptionSyncService: Error during sync: $e');
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
  

  
  /// Sync all existing transcriptions (for initial setup)
  Future<bool> syncAllExistingTranscriptions() async {
    if (_isSyncing) {
      debugPrint('TranscriptionSyncService: Sync already in progress');
      return false;
    }
    
    _isSyncing = true;
    notifyListeners();
    
    try {
      debugPrint('TranscriptionSyncService: Starting bulk sync of all existing transcriptions');
      
      // Get all transcriptions from Hive
      final resultsBox = HiveHelper.getCloudAsrResultsBox();
      final allTranscriptions = resultsBox.values.toList();
      
      if (allTranscriptions.isEmpty) {
        debugPrint('TranscriptionSyncService: No existing transcriptions found');
        return true;
      }
      
      debugPrint('TranscriptionSyncService: Found ${allTranscriptions.length} existing transcriptions');
      
      // Send ALL transcriptions in one single request (much more efficient!)
      final transcriptItems = allTranscriptions
          .where((t) => t.transcription != null && t.transcription!.isNotEmpty)
          .map((t) {
            // Send ISO timestamp with timezone information
            return {
              'time_stamp': t.startTimeIso,  // Already in ISO format with timezone
              'content': t.transcription!,
              'start_time': t.startTimeIso,
              'end_time': t.endTimeIso,
            };
          })
          .toList();
      
      debugPrint('TranscriptionSyncService: Sending ${transcriptItems.length} transcriptions in one request');
      
      // Send all transcriptions in one API call
      final response = await NirvaAPI.uploadTranscriptBatch(transcriptItems);
      final allSuccess = response != null;
      
      if (allSuccess) {
        // Update last sent timestamp
        _lastSentTimestamp = DateTime.now();
        
        // Stop timer since all transcriptions are now synced
        _stopBatchTimer();
        
        // Save timestamp to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_lastSentTimestampKey, _lastSentTimestamp!.toIso8601String());
        
        debugPrint('TranscriptionSyncService: Successfully synced all existing transcriptions');
        
        // Trigger analysis for the date to convert transcripts to events
        await _triggerAnalysisAfterSync(transcriptItems);
        
        notifyListeners();
      }
      
      return allSuccess;
      
    } catch (e) {
      debugPrint('TranscriptionSyncService: Error during bulk sync: $e');
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
  
  /// Get sync status and statistics
  Map<String, dynamic> getSyncStatus() {
    return {
      'isInitialized': _isInitialized,
      'isSyncing': _isSyncing,
      'lastSentTimestamp': _lastSentTimestamp?.toIso8601String(),
      'pendingCount': _pendingTranscriptionIds.length,
      'batchIntervalMinutes': _batchInterval.inMinutes,
      'hasBatchTimer': _batchTimer != null,
    };
  }
  
  /// Trigger analysis after successful transcript sync
  Future<void> _triggerAnalysisAfterSync(List<Map<String, String>> transcriptItems) async {
    try {
      if (transcriptItems.isEmpty) return;
      
      // Group transcriptions by date
      final transcriptionsByDate = <String, List<Map<String, String>>>{};
      
      for (final transcript in transcriptItems) {
        final timestamp = transcript['time_stamp']!;
        final dateKey = timestamp.split(' ')[0]; // Extract YYYY-MM-DD part
        
        if (!transcriptionsByDate.containsKey(dateKey)) {
          transcriptionsByDate[dateKey] = [];
        }
        transcriptionsByDate[dateKey]!.add(transcript);
      }
      
      debugPrint('TranscriptionSyncService: Found transcriptions for ${transcriptionsByDate.length} dates: ${transcriptionsByDate.keys.join(', ')}');
      
      // Trigger analysis for each date
      for (final dateKey in transcriptionsByDate.keys) {
        debugPrint('TranscriptionSyncService: Triggering analysis for date: $dateKey');
        
        // Start analysis with file_number = 1 (assuming single file per day)
        final analysisResponse = await NirvaAPI.startAnalysis(dateKey, 1);
        
        if (analysisResponse != null && analysisResponse.containsKey('task_id')) {
          final taskId = analysisResponse['task_id'];
          debugPrint('TranscriptionSyncService: Analysis started with task_id: $taskId for $dateKey');
        } else {
          debugPrint('TranscriptionSyncService: Failed to start analysis for $dateKey');
        }
      }
      
    } catch (e) {
      debugPrint('TranscriptionSyncService: Error triggering analysis after sync: $e');
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _stopBatchTimer();
    super.dispose();
  }
}
