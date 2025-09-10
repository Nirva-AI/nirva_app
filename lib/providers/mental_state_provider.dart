import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mental_state.dart';
import '../nirva_api.dart';
import '../api_models.dart';
import '../utils/timezone_utils.dart';

class MentalStateProvider extends ChangeNotifier {
  MentalStateInsights? _insights;
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  DateTime? _lastFetchTime;

  // Getters
  MentalStateInsights? get insights => _insights;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  MentalStatePoint? get currentState => _insights?.currentState;
  List<MentalStatePoint> get timeline24h => _insights?.timeline24h ?? [];
  List<MentalStatePoint> get timeline7d => _insights?.timeline7d ?? [];
  DailyMentalStateStats? get dailyStats => _insights?.dailyStats;
  List<String> get recommendations => _insights?.recommendations ?? [];
  
  // Get energy and stress for chart display
  List<double> get energyData24h => 
      timeline24h.map((p) => p.energyScore).toList();
  List<double> get stressData24h => 
      timeline24h.map((p) => p.stressScore).toList();
  
  // Get timestamps for x-axis
  List<String> get timeLabels24h => 
      timeline24h.map((p) => DateFormat('HH:mm').format(p.timestamp)).toList();

  MentalStateProvider() {
    // Start auto-refresh when provider is created
    startAutoRefresh();
  }

  Future<void> fetchInsights({DateTime? date}) async {
    // Don't fetch if we recently fetched (within 30 seconds for testing)
    if (_lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!).inSeconds < 30) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Format date for API
      final dateStr = date != null 
          ? DateFormat('yyyy-MM-dd').format(date)
          : null;

      // Call API
      final response = await NirvaAPI.getMentalStateInsights(
        date: dateStr,
        timezone: TimezoneUtils.getDeviceTimezone(),
      );

      if (response != null) {
        try {
          _insights = MentalStateInsights.fromJson(response as Map<String, dynamic>);
          _lastFetchTime = DateTime.now();
          _error = null;
        } catch (parseError) {
          _error = 'Failed to parse mental state data';
          debugPrint('Error parsing mental state response: $parseError');
        }
      } else {
        _error = 'Failed to fetch mental state insights';
      }
    } catch (e) {
      _error = 'Error fetching insights: $e';
      debugPrint('Error fetching mental state insights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startAutoRefresh() {
    // Cancel existing timer if any
    _refreshTimer?.cancel();
    
    // Fetch immediately
    fetchInsights();
    
    // Then refresh every 30 minutes
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) => fetchInsights(),
    );
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // Get current mental state zone
  String getMentalStateZone() {
    if (currentState == null) return 'Unknown';
    
    final energy = currentState!.energyScore;
    final stress = currentState!.stressScore;
    
    if (energy >= 70 && stress <= 30) {
      return 'Optimal';
    } else if (energy >= 70 && stress >= 70) {
      return 'Wired';
    } else if (energy <= 30 && stress <= 30) {
      return 'Resting';
    } else if (energy <= 30 && stress >= 70) {
      return 'Burnout Risk';
    } else {
      return 'Functioning';
    }
  }

  // Get zone color for UI
  Color getZoneColor() {
    switch (getMentalStateZone()) {
      case 'Optimal':
        return const Color(0xFF4CAF50); // Green
      case 'Wired':
        return const Color(0xFFFF9800); // Orange
      case 'Resting':
        return const Color(0xFF2196F3); // Blue
      case 'Burnout Risk':
        return const Color(0xFFF44336); // Red
      case 'Functioning':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return const Color(0xFF757575); // Dark grey
    }
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}