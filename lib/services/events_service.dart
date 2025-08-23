import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../data.dart';
import '../nirva_api.dart';
import '../hive_helper.dart';

/// Service for managing events from both backend and local sources
/// 
/// This service handles:
/// 1. Fetching events from the backend API
/// 2. Merging backend events with local events
/// 3. Logging event data for debugging
/// 4. Providing unified event access
class EventsService extends ChangeNotifier {
  final Logger _logger = Logger();
  
  /// Cache for backend events by date
  final Map<String, List<EventAnalysis>> _backendEventsCache = {};
  
  /// Cache for merged events by date
  final Map<String, List<EventAnalysis>> _mergedEventsCache = {};
  
  /// Track pending analysis tasks by date
  final Map<String, String> _pendingAnalysisTasks = {};
  
  /// Get events for a specific date, merging backend and local sources
  Future<List<EventAnalysis>> getEventsForDate(String dateKey) async {
    try {
      // _logger.d('EventsService: Getting events for date: $dateKey');
      
      // Check cache first
      if (_mergedEventsCache.containsKey(dateKey)) {
        // _logger.d('EventsService: Returning cached merged events for $dateKey');
        return _mergedEventsCache[dateKey]!;
      }
      
      // Get local events from Hive
      final localEvents = await _getLocalEvents(dateKey);
      // _logger.d('EventsService: Found ${localEvents.length} local events for $dateKey');
      
      // Get backend events
      final backendEvents = await _getBackendEvents(dateKey);
      // _logger.d('EventsService: Found ${backendEvents.length} backend events for $dateKey');
      
      // Merge events (backend events take precedence for duplicates)
      final mergedEvents = _mergeEvents(localEvents, backendEvents);
      // _logger.d('EventsService: Merged into ${mergedEvents.length} total events for $dateKey');
      
      // Cache the result
      _mergedEventsCache[dateKey] = mergedEvents;
      
      // Log detailed event information
      // _logEventsInfo(dateKey, localEvents, backendEvents, mergedEvents);
      
      return mergedEvents;
      
    } catch (e) {
      _logger.e('EventsService: Error getting events for $dateKey: $e');
      // Fallback to local events only
      final localEvents = await _getLocalEvents(dateKey);
      return localEvents;
    }
  }
  
  /// Get local events from Hive storage
  Future<List<EventAnalysis>> _getLocalEvents(String dateKey) async {
    try {
      final journalFiles = HiveHelper.retrieveJournalFiles();
      
      // Find journal file by date key
      final journalFile = journalFiles.firstWhere(
        (file) => file.time_stamp.startsWith(dateKey),
        orElse: () => JournalFile.createEmpty(),
      );
      
      if (journalFile.time_stamp.isEmpty) {
        return [];
      }
      
      return journalFile.events;
      
    } catch (e) {
      _logger.e('EventsService: Error getting local events: $e');
      return [];
    }
  }
  
  /// Get events from backend API
  Future<List<EventAnalysis>> _getBackendEvents(String dateKey) async {
    try {
      // Check cache first
      if (_backendEventsCache.containsKey(dateKey)) {
        return _backendEventsCache[dateKey]!;
      }
      
      final response = await NirvaAPI.getEvents(dateKey);
      if (response == null) {
        _logger.w('EventsService: No response from backend for $dateKey');
        return [];
      }
      
      // Parse backend events
      final events = _parseBackendEvents(response);
      
      // Cache backend events
      _backendEventsCache[dateKey] = events;
      
      return events;
      
    } catch (e) {
      _logger.e('EventsService: Error getting backend events: $e');
      return [];
    }
  }
  
  /// Parse backend API response into EventAnalysis objects
  List<EventAnalysis> _parseBackendEvents(Map<String, dynamic> response) {
    try {
      final events = <EventAnalysis>[];
      
      if (response.containsKey('events') && response['events'] is List) {
        final eventsList = response['events'] as List;
        
        for (final eventData in eventsList) {
          try {
            // Convert backend event format to EventAnalysis
            final event = EventAnalysis(
              event_id: eventData['event_id'] ?? '',
              event_title: eventData['title'] ?? eventData['event_title'] ?? 'Untitled Event',
              time_range: eventData['time_range'] ?? 'Unknown Time',
              duration_minutes: eventData['duration_minutes'] ?? 0,
              location: eventData['location'] ?? 'Unknown Location',
              mood_labels: _parseStringList(eventData['mood_labels']),
              mood_score: eventData['mood_score'] ?? 0,
              stress_level: eventData['stress_level'] ?? 0,
              energy_level: eventData['energy_level'] ?? 0,
              activity_type: eventData['activity_type'] ?? 'Unknown',
              people_involved: _parseStringList(eventData['people_involved']),
              interaction_dynamic: eventData['interaction_dynamic'] ?? 'Unknown',
              inferred_impact_on_user_name: eventData['inferred_impact_on_user_name'] ?? 'Unknown',
              topic_labels: _parseStringList(eventData['topic_labels']),
              one_sentence_summary: eventData['one_sentence_summary'] ?? 'No summary available',
              first_person_narrative: eventData['first_person_narrative'] ?? 'No narrative available',
              action_item: eventData['action_item'] ?? 'No action items',
            );
            
            events.add(event);
            
          } catch (e) {
            _logger.w('EventsService: Error parsing individual event: $e');
            continue;
          }
        }
      }
      
      // _logger.d('EventsService: Successfully parsed ${events.length} backend events');
      return events;
      
    } catch (e) {
      _logger.e('EventsService: Error parsing backend events: $e');
      return [];
    }
  }
  
  /// Parse string list from backend response
  List<String> _parseStringList(dynamic data) {
    if (data is List) {
      return data.map((item) => item.toString()).toList();
    } else if (data is String) {
      // Handle comma-separated string
      return data.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }
  
  /// Merge local and backend events, with backend events taking precedence
  List<EventAnalysis> _mergeEvents(
    List<EventAnalysis> localEvents,
    List<EventAnalysis> backendEvents,
  ) {
    final merged = <EventAnalysis>[];
    final usedIds = <String>{};
    
    // Add backend events first (they take precedence)
    for (final backendEvent in backendEvents) {
      if (backendEvent.event_id.isNotEmpty) {
        merged.add(backendEvent);
        usedIds.add(backendEvent.event_id);
      }
    }
    
    // Add local events that don't conflict with backend events
    for (final localEvent in localEvents) {
      if (!usedIds.contains(localEvent.event_id)) {
        merged.add(localEvent);
        usedIds.add(localEvent.event_id);
      }
    }
    
    // Sort by time range if possible
    merged.sort((a, b) {
      try {
        final timeA = _extractTimeFromRange(a.time_range);
        final timeB = _extractTimeFromRange(b.time_range);
        return timeA.compareTo(timeB);
      } catch (e) {
        return 0;
      }
    });
    
    return merged;
  }
  
  /// Extract time from time range string for sorting
  DateTime _extractTimeFromRange(String timeRange) {
    try {
      // Try to parse time range like "10:00-11:00" or "10:00 AM - 11:00 AM"
      final parts = timeRange.split('-');
      if (parts.isNotEmpty) {
        final startTime = parts[0].trim();
        // Convert to 24-hour format for comparison
        if (startTime.contains('PM') && !startTime.contains('12')) {
          final hour = int.parse(startTime.split(':')[0]) + 12;
          return DateTime(2024, 1, 1, hour);
        } else if (startTime.contains('AM') && startTime.contains('12')) {
          return DateTime(2024, 1, 1, 0);
        } else {
          final hour = int.parse(startTime.split(':')[0]);
          return DateTime(2024, 1, 1, hour);
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return DateTime.now();
  }
  
  /// Log detailed information about events for debugging
  void _logEventsInfo(
    String dateKey,
    List<EventAnalysis> localEvents,
    List<EventAnalysis> backendEvents,
    List<EventAnalysis> mergedEvents,
  ) {
    _logger.d('''
EventsService: Events summary for $dateKey:
  Local events: ${localEvents.length}
  Backend events: ${backendEvents.length}
  Merged events: ${mergedEvents.length}
  
Local events:
${localEvents.map((e) => '  - ${e.event_title} (${e.time_range})').join('\n')}
  
Backend events:
${backendEvents.map((e) => '  - ${e.event_title} (${e.time_range})').join('\n')}
  
Merged events:
${mergedEvents.map((e) => '  - ${e.event_title} (${e.time_range}) [${e.event_id}]').join('\n')}
''');
  }
  
  /// Clear cache for a specific date
  void clearCache(String dateKey) {
    _backendEventsCache.remove(dateKey);
    _mergedEventsCache.remove(dateKey);
    _logger.d('EventsService: Cleared cache for $dateKey');
  }
  
  /// Clear all caches
  void clearAllCaches() {
    _backendEventsCache.clear();
    _mergedEventsCache.clear();
    _logger.d('EventsService: Cleared all caches');
  }
  
  /// Refresh events for a specific date
  Future<List<EventAnalysis>> refreshEvents(String dateKey) async {
    clearCache(dateKey);
    return await getEventsForDate(dateKey);
  }

  /// Manually trigger analysis for a specific date
  Future<void> triggerAnalysis(String dateKey) async {
    try {
      _logger.d('EventsService: Manually triggering analysis for $dateKey');
      
      // Start analysis with file_number = 1 (assuming single file per day)
      final analysisResponse = await NirvaAPI.startAnalysis(dateKey, 1);
      
      if (analysisResponse != null && analysisResponse.containsKey('task_id')) {
        final taskId = analysisResponse['task_id'];
        _logger.d('EventsService: Analysis started with task_id: $taskId for $dateKey');
      } else {
        _logger.w('EventsService: Failed to start analysis for $dateKey');
      }
      
    } catch (e) {
      _logger.e('EventsService: Error manually triggering analysis: $e');
    }
  }
}
