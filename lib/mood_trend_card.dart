import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/constants/mood_colors.dart';
import 'package:nirva_app/constants/mood_chart_constants.dart';
import 'package:nirva_app/mood_insights_page.dart';
import 'package:intl/intl.dart';
import 'dart:async';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class MoodTrendCard extends StatefulWidget {
  const MoodTrendCard({super.key});

  // Session-based cache - all events fetched once per session
  static Map<String, List<EventAnalysis>>? _sessionEventsCache;
  static DateTime? _lastFetchTime;

  // Static methods to access session cache from other pages
  static Map<String, List<EventAnalysis>>? getSessionEventsCache() {
    return _sessionEventsCache;
  }
  
  static DateTime? getLastFetchTime() {
    return _lastFetchTime;
  }
  
  static void setSessionEventsCache(Map<String, List<EventAnalysis>> cache) {
    _sessionEventsCache = cache;
  }
  
  static void setLastFetchTime(DateTime time) {
    _lastFetchTime = time;
  }

  @override
  State<MoodTrendCard> createState() => _MoodTrendCardState();
}

class _MoodTrendCardState extends State<MoodTrendCard> {
  String _selectedPeriod = 'Week';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load session data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSessionDataLoaded();
    });
  }

  // Ensure session data is loaded (like Energy charts do)
  Future<void> _ensureSessionDataLoaded() async {
    // If we have recent session data (within 5 minutes), use it
    if (MoodTrendCard._sessionEventsCache != null && 
        MoodTrendCard._lastFetchTime != null && 
        DateTime.now().difference(MoodTrendCard._lastFetchTime!).inMinutes < 5) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Fetch events for last 30 days (covers all periods)
      MoodTrendCard._sessionEventsCache = await _fetchAllEventsForSession();
      MoodTrendCard._lastFetchTime = DateTime.now();
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Fetch all events once per session
  Future<Map<String, List<EventAnalysis>>> _fetchAllEventsForSession() async {
    final Map<String, List<EventAnalysis>> allEvents = {};
    final now = DateTime.now();
    
    // Fetch last 30 days to cover all possible periods
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final timeStamp = DateFormat("yyyy-MM-dd").format(date);
      
      try {
        final response = await NirvaAPI.getEvents(timeStamp);
        if (response != null && response['events'] != null) {
          final eventsList = response['events'] as List;
          final events = eventsList
              .map((json) => EventAnalysis.fromJson(json as Map<String, dynamic>))
              .toList();
          allEvents[timeStamp] = events;
        } else {
          allEvents[timeStamp] = [];
        }
      } catch (e) {
        allEvents[timeStamp] = [];
      }
    }
    
    return allEvents;
  }
  
  // Calculate mood data from session cache for a specific period
  Map<String, double> _calculateMoodDataForPeriod(String period) {
    if (MoodTrendCard._sessionEventsCache == null) return {};
    
    Map<String, double> moodDuration = {};
    double totalDuration = 0;
    
    // Get date range for the selected period
    final now = DateTime.now();
    final dates = _getDateRangeForPeriod(now, period);
    
    // Use cached events for each date
    for (var date in dates) {
      final timeStamp = DateFormat("yyyy-MM-dd").format(date);
      final events = MoodTrendCard._sessionEventsCache![timeStamp] ?? [];
      
      for (var event in events) {
        for (var mood in event.mood_labels) {
          moodDuration[mood] = (moodDuration[mood] ?? 0) + event.duration_minutes.toDouble();
          totalDuration += event.duration_minutes.toDouble();
        }
      }
    }
    
    // Convert to percentages and return top 7 moods
    Map<String, double> percentages = {};
    if (totalDuration > 0) {
      moodDuration.forEach((mood, duration) {
        percentages[mood] = (duration / totalDuration) * 100;
      });
    }
    
    // Sort by percentage and get top 7
    var sortedMoods = percentages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    Map<String, double> topMoods = {};
    for (int i = 0; i < sortedMoods.length && i < 7; i++) {
      topMoods[sortedMoods[i].key] = sortedMoods[i].value;
    }
    
    return topMoods;
  }
  
  DateTime _getStartDateForPeriod(DateTime now, String period) {
    switch (period) {
      case 'Day':
        return DateTime(now.year, now.month, now.day);
      case 'Week':
        return now.subtract(Duration(days: 7));
      case 'Month':
        return now.subtract(Duration(days: 30));
      default:
        return now.subtract(Duration(days: 7));
    }
  }
  
  List<DateTime> _getDateRangeForPeriod(DateTime now, String period) {
    List<DateTime> dates = [];
    final today = DateTime(now.year, now.month, now.day);
    
    switch (period) {
      case 'Day':
        // Only today's data
        dates.add(today);
        break;
      case 'Week':
        // Last 7 days including today
        for (int i = 0; i < 7; i++) {
          dates.add(today.subtract(Duration(days: i)));
        }
        break;
      case 'Month':
        // Last 30 days including today
        for (int i = 0; i < 30; i++) {
          dates.add(today.subtract(Duration(days: i)));
        }
        break;
    }
    
    print('DEBUG: Date range for $period: ${dates.map((d) => DateFormat('yyyy-MM-dd').format(d)).join(', ')}');
    return dates;
  }
  
  
  double _getMoodSize(double percentage, int index) {
    final baseSize = index < MoodChartConstants.baseBubbleSizes.length 
        ? MoodChartConstants.baseBubbleSizes[index] 
        : MoodChartConstants.defaultBubbleSize;
    
    // Add percentage-based scaling
    return baseSize + (percentage * MoodChartConstants.sizingScalingFactor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf0ebd8),
            Color(0xFFece6d2),
            Color(0xFFe8e2cc),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Container with Period Switcher
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Background pattern with diagonal stripes for entire container
                Positioned.fill(
                  child: CustomPaint(
                    painter: DiagonalStripesPainter(),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Mood Trend Chart
                      SizedBox(
                        height: 200,
                        child: _buildMoodTrendChart(),
                      ),
                      const SizedBox(height: 16),
                      // Time Period Switcher
                      _buildPeriodSwitcher(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Description
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildMoodTrendChart() {
    if (_isLoading) {
      return _buildLoadingState();
    }
    
    final moodData = _calculateMoodDataForPeriod(_selectedPeriod);
    if (moodData.isEmpty) {
      return _buildEmptyState();
    }
    
    final sortedMoods = moodData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Center(
      child: Container(
        width: MoodChartConstants.chartWidth,
        height: MoodChartConstants.chartHeight,
        child: Stack(
          children: _buildMoodBubbles(sortedMoods),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  List<Widget> _buildMoodBubbles(List<MapEntry<String, double>> sortedMoods) {
    List<Widget> bubbles = [];
    
    for (int i = 0; i < sortedMoods.length && i < 7; i++) {
      final mood = sortedMoods[i].key;
      final percentage = sortedMoods[i].value;
      final position = MoodChartConstants.bubblePositions[i];
      final size = _getMoodSize(percentage, i);
      final color = MoodColors.getMoodColor(mood);
      
      // Ensure bubble stays within bounds by adjusting position based on size
      final radius = size / 2;
      final safeLeft = (position['left']! - radius)
          .clamp(0.0, MoodChartConstants.chartWidth - size);
      final safeTop = (position['top']! - radius)
          .clamp(0.0, MoodChartConstants.chartHeight - size);
      
      bubbles.add(
        Positioned(
          left: safeLeft,
          top: safeTop,
          child: _buildMoodBubble(
            mood,
            color,
            size,
            fontSize: _getFontSize(size),
            textColor: _getTextColor(color),
          ),
        ),
      );
    }
    
    return bubbles;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mood_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No mood data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start journaling to see your mood trends',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  double _getFontSize(double bubbleSize) {
    for (final entry in MoodChartConstants.fontSizeBreakpoints.entries) {
      if (bubbleSize > entry.key) {
        return entry.value;
      }
    }
    return MoodChartConstants.fontSizeBreakpoints[0.0]!;
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > MoodChartConstants.textColorLuminanceThreshold 
        ? Colors.grey.shade700 
        : const Color(0xFFfaf9f5);
  }

  String _generateInsightText() {
    final moodData = _calculateMoodDataForPeriod(_selectedPeriod);
    if (moodData.isEmpty) {
      return 'No mood data available for the selected period.';
    }

    final sortedMoods = moodData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topMood = sortedMoods.first;
    final period = _selectedPeriod.toLowerCase();
    
    // Create insight based on dominant mood and period
    if (topMood.value > 40) {
      return '${topMood.key.capitalize()} dominated your $period with ${topMood.value.toStringAsFixed(1)}% of your time.';
    } else if (sortedMoods.length >= 3) {
      final topThree = sortedMoods.take(3).map((e) => e.key).join(', ');
      return 'Your emotional landscape shows varied states this $period: $topThree.';
    } else {
      return 'Your mood was primarily ${topMood.key} this $period.';
    }
  }

  Widget _buildMoodBubble(String mood, Color color, double size, {double fontSize = 14, Color? textColor}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          mood,
          style: TextStyle(
            color: textColor ?? Colors.grey.shade600,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final insightText = _generateInsightText();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mood Track',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                insightText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Detail button
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodInsightsPage(),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward_outlined,
              color: Color(0xFF0E3C26),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSwitcher() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
            final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    // No timers to cancel in session-based approach
    super.dispose();
  }
}

class DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFe7bf57).withOpacity(0.1)
      ..strokeWidth = 2;

    const spacing = 8.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 