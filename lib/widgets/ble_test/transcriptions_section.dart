import 'package:flutter/material.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/transcription_detail_page.dart';
import 'package:intl/intl.dart';
import 'common_widgets.dart';

class TranscriptionsSection extends StatelessWidget {
  final List<TranscriptionItem> transcriptions;
  final bool isLoadingTranscriptions;
  final bool hasMoreTranscriptions;
  final String? transcriptionsError;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;

  const TranscriptionsSection({
    super.key,
    required this.transcriptions,
    required this.isLoadingTranscriptions,
    required this.hasMoreTranscriptions,
    required this.transcriptionsError,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transcriptions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                  fontFamily: 'Georgia',
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                  onPressed: isLoadingTranscriptions ? null : onRefresh,
                  tooltip: 'Refresh transcriptions',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Error message
          if (transcriptionsError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transcriptionsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Transcriptions list
          if (transcriptions.isEmpty && !isLoadingTranscriptions)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.mic_none,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      transcriptionsError != null 
                          ? 'Failed to load transcriptions'
                          : 'No transcriptions yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (transcriptions.isNotEmpty || isLoadingTranscriptions)
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: transcriptions.length + (isLoadingTranscriptions && transcriptions.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == transcriptions.length) {
                    // Loading indicator at the bottom
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  final transcription = transcriptions[index];
                  
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TranscriptionDetailPage(
                            transcription: transcription,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFe7bf57).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Color(0xFFe7bf57),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatRelativeTime(transcription.start_time),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  transcription.text,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0E3C26),
                                    fontFamily: 'Georgia',
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Loading indicator for initial load
          if (isLoadingTranscriptions && transcriptions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // Load more button
          if (hasMoreTranscriptions && !isLoadingTranscriptions)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: BleActionButton(
                  onPressed: onLoadMore,
                  icon: Icons.expand_more,
                  label: 'Load More',
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatRelativeTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else {
        return DateFormat('MMM d, y').format(dateTime);
      }
    } catch (e) {
      return isoTime;
    }
  }
}