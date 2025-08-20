import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transcription_sync_provider.dart';

/// Widget to display transcription sync status and provide manual sync controls
class TranscriptionSyncStatusWidget extends StatelessWidget {
  const TranscriptionSyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranscriptionSyncProvider>(
      builder: (context, syncProvider, child) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sync,
                      color: syncProvider.isSyncing 
                          ? Colors.orange 
                          : (syncProvider.lastSentTimestamp != null ? Colors.green : Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Transcription Sync',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (syncProvider.isSyncing)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildStatusRow('Status', syncProvider.isSyncing ? 'Syncing...' : 'Idle'),
                _buildStatusRow('Pending', '${syncProvider.pendingTranscriptionIds.length}'),
                if (syncProvider.lastSentTimestamp != null)
                  _buildStatusRow('Last Sync', _formatTimestamp(syncProvider.lastSentTimestamp!)),
                _buildStatusRow('Batch Interval', '5 minutes'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: syncProvider.isSyncing 
                            ? null 
                            : () => _syncPending(context, syncProvider),
                        icon: const Icon(Icons.sync),
                        label: const Text('Sync Now'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: syncProvider.isSyncing 
                            ? null 
                            : () => _syncAll(context, syncProvider),
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Sync All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
  
  Future<void> _syncPending(BuildContext context, TranscriptionSyncProvider syncProvider) async {
    try {
      final success = await syncProvider.syncPendingTranscriptions();
      if (success) {
        _showSnackBar(context, 'Pending transcriptions synced successfully', Colors.green);
      } else {
        _showSnackBar(context, 'Failed to sync pending transcriptions', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, 'Error during sync: $e', Colors.red);
    }
  }
  
  Future<void> _syncAll(BuildContext context, TranscriptionSyncProvider syncProvider) async {
    try {
      final success = await syncProvider.syncAllExistingTranscriptions();
      if (success) {
        _showSnackBar(context, 'All transcriptions synced successfully', Colors.green);
      } else {
        _showSnackBar(context, 'Failed to sync all transcriptions', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, 'Error during bulk sync: $e', Colors.red);
    }
  }
  
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
