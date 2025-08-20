import 'package:flutter/foundation.dart';
import '../services/transcription_sync_service.dart';

/// Provider for managing transcription synchronization
/// 
/// This provider wraps the TranscriptionSyncService and provides
/// easy access to sync functionality throughout the app
class TranscriptionSyncProvider extends ChangeNotifier {
  final TranscriptionSyncService _syncService = TranscriptionSyncService();
  
  // Getters that delegate to the sync service
  bool get isInitialized => _syncService.isInitialized;
  bool get isSyncing => _syncService.isSyncing;
  DateTime? get lastSentTimestamp => _syncService.lastSentTimestamp;
  List<String> get pendingTranscriptionIds => _syncService.pendingTranscriptionIds;
  
  /// Initialize the sync service
  Future<bool> initialize() async {
    final success = await _syncService.initialize();
    if (success) {
      // Listen to changes in the sync service
      _syncService.addListener(_onSyncServiceChanged);
    }
    return success;
  }
  
  /// Add a transcription to the pending queue
  void addPendingTranscription(String transcriptionId) {
    _syncService.addPendingTranscription(transcriptionId);
  }
  
  /// Manually trigger sync of pending transcriptions
  Future<bool> syncPendingTranscriptions() async {
    return await _syncService.syncPendingTranscriptions();
  }
  
  /// Sync all existing transcriptions (for initial setup)
  Future<bool> syncAllExistingTranscriptions() async {
    return await _syncService.syncAllExistingTranscriptions();
  }
  
  /// Get sync status and statistics
  Map<String, dynamic> getSyncStatus() {
    return _syncService.getSyncStatus();
  }
  
  /// Handle changes from the sync service
  void _onSyncServiceChanged() {
    notifyListeners();
  }
  
  /// Dispose resources
  @override
  void dispose() {
    _syncService.removeListener(_onSyncServiceChanged);
    _syncService.dispose();
    super.dispose();
  }
}
