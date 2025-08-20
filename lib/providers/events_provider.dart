import 'package:flutter/foundation.dart';
import '../services/events_service.dart';
import '../data.dart';

/// Provider for managing events from both backend and local sources
/// 
/// This provider wraps the EventsService and provides
/// easy access to merged events throughout the app
class EventsProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();
  
  /// Get events for a specific date, merging backend and local sources
  Future<List<EventAnalysis>> getEventsForDate(String dateKey) async {
    return await _eventsService.getEventsForDate(dateKey);
  }
  
  /// Refresh events for a specific date (clears cache and refetches)
  Future<List<EventAnalysis>> refreshEvents(String dateKey) async {
    return await _eventsService.refreshEvents(dateKey);
  }

  /// Manually trigger analysis for a specific date
  Future<void> triggerAnalysis(String dateKey) async {
    await _eventsService.triggerAnalysis(dateKey);
    notifyListeners();
  }
  
  /// Clear cache for a specific date
  void clearCache(String dateKey) {
    _eventsService.clearCache(dateKey);
    notifyListeners();
  }
  
  /// Clear all caches
  void clearAllCaches() {
    _eventsService.clearAllCaches();
    notifyListeners();
  }
  
  /// Get events for multiple dates
  Future<Map<String, List<EventAnalysis>>> getEventsForDates(List<String> dateKeys) async {
    final results = <String, List<EventAnalysis>>{};
    
    for (final dateKey in dateKeys) {
      final events = await _eventsService.getEventsForDate(dateKey);
      results[dateKey] = events;
    }
    
    return results;
  }
  
  /// Get events for a date range
  Future<Map<String, List<EventAnalysis>>> getEventsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final dateKeys = <String>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dateKeys.add(_formatDateKey(current));
      current = current.add(const Duration(days: 1));
    }
    
    return await getEventsForDates(dateKeys);
  }
  
  /// Format date to dateKey format (YYYY-MM-DD)
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  /// Get today's events
  Future<List<EventAnalysis>> getTodayEvents() async {
    final today = DateTime.now();
    final dateKey = _formatDateKey(today);
    return await _eventsService.getEventsForDate(dateKey);
  }
  
  /// Get yesterday's events
  Future<List<EventAnalysis>> getYesterdayEvents() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final dateKey = _formatDateKey(yesterday);
    return await _eventsService.getEventsForDate(dateKey);
  }
  
  /// Get events for this week
  Future<Map<String, List<EventAnalysis>>> getThisWeekEvents() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return await getEventsForDateRange(startOfWeek, endOfWeek);
  }
  
  /// Get events for this month
  Future<Map<String, List<EventAnalysis>>> getThisMonthEvents() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return await getEventsForDateRange(startOfMonth, endOfMonth);
  }
}
