import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/constants/mood_colors.dart';
import 'package:nirva_app/mood_trend_card.dart';
import 'package:nirva_app/providers/mental_state_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class MoodInsightsPage extends StatefulWidget {
  const MoodInsightsPage({super.key});

  @override
  State<MoodInsightsPage> createState() => _MoodInsightsPageState();
}

class _MoodInsightsPageState extends State<MoodInsightsPage> {
  String _selectedPeriod = 'Week';
  String _selectedTimelinePeriod = 'Day';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSessionDataLoaded();
    });
  }

  // Access session data from MoodTrendCard (session-based caching)
  Future<void> _ensureSessionDataLoaded() async {
    // If we have recent session data (within 5 minutes), use it
    if (MoodTrendCard.getSessionEventsCache() != null && 
        MoodTrendCard.getLastFetchTime() != null && 
        DateTime.now().difference(MoodTrendCard.getLastFetchTime()!).inMinutes < 5) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Use same session cache loading logic as MoodTrendCard
      final allEvents = await _fetchAllEventsForSession();
      MoodTrendCard.setSessionEventsCache(allEvents);
      MoodTrendCard.setLastFetchTime(DateTime.now());
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

  // Fetch all events once per session (same logic as MoodTrendCard)
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

  // Calculate mood data from session cache for a specific period (same logic as MoodTrendCard)
  Map<String, double> _calculateMoodDataForPeriod(String period) {
    final sessionCache = MoodTrendCard.getSessionEventsCache();
    if (sessionCache == null) return {};
    
    Map<String, double> moodDuration = {};
    double totalDuration = 0;
    
    // Get date range for the selected period
    final now = DateTime.now();
    final dates = _getDateRangeForPeriod(now, period);
    
    // Use cached events for each date
    for (var date in dates) {
      final timeStamp = DateFormat("yyyy-MM-dd").format(date);
      final events = sessionCache[timeStamp] ?? [];
      
      for (var event in events) {
        for (var mood in event.mood_labels) {
          moodDuration[mood] = (moodDuration[mood] ?? 0) + event.duration_minutes.toDouble();
          totalDuration += event.duration_minutes.toDouble();
        }
      }
    }
    
    // Convert to percentages and return all moods (not limited to top 7 like the card)
    Map<String, double> percentages = {};
    if (totalDuration > 0) {
      moodDuration.forEach((mood, duration) {
        percentages[mood] = (duration / totalDuration) * 100;
      });
    }
    
    return percentages;
  }

  List<DateTime> _getDateRangeForPeriod(DateTime now, String period) {
    List<DateTime> dates = [];
    final today = DateTime(now.year, now.month, now.day);
    
    switch (period) {
      case 'Day':
        dates.add(today);
        break;
      case 'Week':
        for (int i = 0; i < 7; i++) {
          dates.add(today.subtract(Duration(days: i)));
        }
        break;
      case 'Month':
        for (int i = 0; i < 30; i++) {
          dates.add(today.subtract(Duration(days: i)));
        }
        break;
    }
    
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf9f5),
        surfaceTintColor: const Color(0xFFfaf9f5),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Color(0xFF0E3C26)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mood Insights',
          style: TextStyle(
            color: Color(0xFF0E3C26),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFfaf9f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 32),
            
            // Pie Chart Section
            _buildChartSection(),
            const SizedBox(height: 32),
            
            // Mood Timeline Section
            _buildTimelineSection(),
            const SizedBox(height: 32),
            
            // Insights Section
            _buildInsightsSection(),
            const SizedBox(height: 32),
            
            // Mood Patterns
            _buildMoodPatterns(),
            const SizedBox(height: 32),
            
            // Period Analysis
            _buildPeriodAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (_isLoading) {
      return _buildLoadingSummaryCards();
    }

    // Use mood score data from timeline instead of mood labels
    final moodScoreData = _getMoodScoreDataForPeriod();
    final averageMoodScore = moodScoreData.isNotEmpty 
        ? (moodScoreData.reduce((a, b) => a + b) / moodScoreData.length).toInt()
        : 65;
    final moodTrend = _calculateMoodTrend(moodScoreData);
    final moodVariety = _calculateMoodDataForPeriod(_selectedPeriod).length;
    final totalEvents = _getTotalEventsCount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Average Score',
                '$averageMoodScore',
                Icons.sentiment_satisfied,
                _getMoodScoreColor(averageMoodScore),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Mood Variety',
                '$moodVariety',
                Icons.palette,
                const Color(0xFFdad5fd),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Trend Score',
                '${_getTrendScore(moodScoreData)}',
                moodTrend['icon'] as IconData,
                moodTrend['color'] as Color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Events',
                '$totalEvents',
                Icons.event,
                const Color(0xFFfdd78c),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLoadingSummaryCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildLoadingSummaryCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildLoadingSummaryCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildLoadingSummaryCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingSummaryCard() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
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
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E3C26),
              ),
            ),
            _buildPeriodToggle(),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _isLoading ? _buildLoadingChart() : _buildMoodPieChart(),
        ),
      ],
    );
  }

  Widget _buildLoadingChart() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildMoodPieChart() {
    final moodData = _calculateMoodDataForPeriod(_selectedPeriod);
    if (moodData.isEmpty) {
      return _buildEmptyChart();
    }

    // Get top 7 moods for the pie chart
    final sortedMoods = moodData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topMoods = sortedMoods.take(7).toList();

    return Row(
      children: [
        // Pie Chart
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: topMoods.map((moodEntry) {
                final mood = moodEntry.key;
                final percentage = moodEntry.value;
                
                return PieChartSectionData(
                  color: MoodColors.getMoodColor(mood),
                  value: percentage,
                  title: '${percentage.round()}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 35,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Legend
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: topMoods.map((moodEntry) {
              final mood = moodEntry.key;
              final percentage = moodEntry.value;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: MoodColors.getMoodColor(mood),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mood.capitalize(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF0E3C26),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${percentage.round()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0E3C26),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 64,
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
            'Start journaling to see your mood distribution',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 12,
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

  Widget _buildInsightsSection() {
    final insights = _generateMoodInsights();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
            children: insights.map((insight) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildInsightItem(insight),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF0E3C26),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0E3C26),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodPatterns() {
    final moodData = _calculateMoodDataForPeriod(_selectedPeriod);
    final topMoods = moodData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3Moods = topMoods.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mood Patterns',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: top3Moods.map((moodEntry) {
              final mood = moodEntry.key;
              final percentage = moodEntry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPatternItem(
                  mood.capitalize(),
                  '${percentage.round()}%',
                  _getMoodLevel(percentage),
                  MoodColors.getMoodColor(mood),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPatternItem(String title, String value, String level, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0E3C26),
                ),
              ),
              Text(
                level,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Period Analysis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _getPeriodAnalysisData().map((period) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        period['period'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E3C26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Top: ${period['topMood']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0E3C26),
                                ),
                              ),
                              Text(
                                'Variety: ${period['variety']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: period['consistency'] / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              period['consistency'] >= 70 ? const Color(0xFFC8D4B8) :
                              period['consistency'] >= 50 ? const Color(0xFFe7bf57) :
                              const Color(0xFFfdd78c),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Helper methods for data calculation
  int _getTotalEventsCount() {
    final sessionCache = MoodTrendCard.getSessionEventsCache();
    if (sessionCache == null) return 0;
    
    final dates = _getDateRangeForPeriod(DateTime.now(), _selectedPeriod);
    int totalEvents = 0;
    
    for (var date in dates) {
      final timeStamp = DateFormat("yyyy-MM-dd").format(date);
      final events = sessionCache[timeStamp] ?? [];
      totalEvents += events.length;
    }
    
    return totalEvents;
  }

  String _calculateEmotionalBalance(Map<String, double> moodData) {
    if (moodData.isEmpty) return 'No Data';
    
    final values = moodData.values.toList();
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) / values.length;
    final standardDeviation = variance.sqrt();
    
    if (standardDeviation < 10) return 'Stable';
    if (standardDeviation < 20) return 'Good';
    if (standardDeviation < 30) return 'Fair';
    return 'Variable';
  }

  String _getMoodLevel(double percentage) {
    if (percentage >= 40) return 'Dominant';
    if (percentage >= 20) return 'Frequent';
    if (percentage >= 10) return 'Moderate';
    return 'Occasional';
  }

  List<String> _generateMoodInsights() {
    final moodData = _calculateMoodDataForPeriod(_selectedPeriod);
    if (moodData.isEmpty) {
      return ['No mood data available for the selected period.'];
    }

    final sortedMoods = moodData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    List<String> insights = [];
    
    // Dominant mood insight
    if (sortedMoods.isNotEmpty) {
      final topMood = sortedMoods.first;
      if (topMood.value > 40) {
        insights.add('${topMood.key.capitalize()} is your dominant mood this ${_selectedPeriod.toLowerCase()}, representing ${topMood.value.toStringAsFixed(1)}% of your emotional time.');
      }
    }
    
    // Variety insight
    final variety = moodData.length;
    if (variety >= 5) {
      insights.add('You experienced a rich emotional variety with $variety different moods, indicating a dynamic emotional life.');
    } else if (variety <= 2) {
      insights.add('Your emotional range was focused this ${_selectedPeriod.toLowerCase()}, with only $variety main moods recorded.');
    }
    
    // Balance insight
    final balance = _calculateEmotionalBalance(moodData);
    if (balance == 'Very Stable') {
      insights.add('Your emotional state shows remarkable consistency, suggesting good emotional regulation.');
    } else if (balance == 'Variable') {
      insights.add('You experienced significant emotional variation, which can be normal during periods of change or stress.');
    }
    
    // Default insight if none generated
    if (insights.isEmpty) {
      insights.add('Your mood patterns show a balanced emotional landscape this ${_selectedPeriod.toLowerCase()}.');
    }
    
    return insights;
  }

  List<Map<String, dynamic>> _getPeriodAnalysisData() {
    // Generate period analysis based on current period selection
    if (_selectedPeriod == 'Day') {
      return [
        {'period': 'Today', 'topMood': 'Calm', 'variety': 5, 'consistency': 75.0},
      ];
    } else if (_selectedPeriod == 'Week') {
      return [
        {'period': 'Mon', 'topMood': 'Focused', 'variety': 4, 'consistency': 80.0},
        {'period': 'Tue', 'topMood': 'Happy', 'variety': 6, 'consistency': 65.0},
        {'period': 'Wed', 'topMood': 'Calm', 'variety': 5, 'consistency': 70.0},
        {'period': 'Thu', 'topMood': 'Stressed', 'variety': 3, 'consistency': 85.0},
        {'period': 'Fri', 'topMood': 'Content', 'variety': 7, 'consistency': 60.0},
        {'period': 'Sat', 'topMood': 'Relaxed', 'variety': 4, 'consistency': 75.0},
        {'period': 'Sun', 'topMood': 'Peaceful', 'variety': 5, 'consistency': 70.0},
      ];
    } else {
      return [
        {'period': 'Week 1', 'topMood': 'Happy', 'variety': 8, 'consistency': 70.0},
        {'period': 'Week 2', 'topMood': 'Focused', 'variety': 6, 'consistency': 75.0},
        {'period': 'Week 3', 'topMood': 'Calm', 'variety': 7, 'consistency': 65.0},
        {'period': 'Week 4', 'topMood': 'Content', 'variety': 9, 'consistency': 60.0},
      ];
    }
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mood Timeline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E3C26),
              ),
            ),
            _buildTimelinePeriodToggle(),
          ],
        ),
        const SizedBox(height: 16),
        _buildTimelineChart(),
      ],
    );
  }

  Widget _buildTimelineChart() {
    return Consumer<MentalStateProvider>(
      builder: (context, mentalStateProvider, child) {
        final timeline = _getTimelineForPeriod(mentalStateProvider);
        
        if (timeline.isEmpty) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Loading mood timeline...',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: timeline.length / 6,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < timeline.length) {
                              String label = _getTimelineLabelForIndex(index, timeline);
                              return Text(
                                label,
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 12,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 25,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: timeline.length.toDouble() - 1,
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: timeline.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            entry.value.moodScore ?? 65.0,  // Default mood score if null
                          );
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.8),
                            Colors.blue.withOpacity(0.3),
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.withOpacity(0.2),
                              Colors.blue.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to get mood score data from timeline
  List<double> _getMoodScoreDataForPeriod() {
    final mentalStateProvider = Provider.of<MentalStateProvider>(context, listen: false);
    List<double> moodData = [];
    
    switch (_selectedPeriod) {
      case 'Day':
        moodData = mentalStateProvider.moodData24h;
        break;
      case 'Week':
        // Use 7-day timeline data
        final timeline7d = mentalStateProvider.timeline7d;
        moodData = timeline7d.map((point) => point.moodScore ?? 65.0).toList();
        break;
      case 'Month':
        // For month, we'd need to aggregate more data - use 7-day for now
        final timeline7d = mentalStateProvider.timeline7d;
        moodData = timeline7d.map((point) => point.moodScore ?? 65.0).toList();
        break;
    }
    
    // Filter out zero values which are placeholder data
    return moodData.where((score) => score > 0).toList();
  }

  // Helper method to get color based on mood score
  Color _getMoodScoreColor(int score) {
    if (score >= 80) return const Color(0xFF4CAF50); // Green - Great mood
    if (score >= 65) return const Color(0xFF8BC34A); // Light Green - Good mood
    if (score >= 50) return const Color(0xFFFFC107); // Amber - Neutral mood
    if (score >= 35) return const Color(0xFFFF9800); // Orange - Low mood
    return const Color(0xFFFF5722); // Deep Orange - Very low mood
  }

  // Helper method to get numeric trend score
  int _getTrendScore(List<double> moodData) {
    if (moodData.length < 2) return 0;

    final midPoint = moodData.length ~/ 2;
    final firstHalf = moodData.take(midPoint).toList();
    final secondHalf = moodData.skip(midPoint).toList();
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    final difference = secondAvg - firstAvg;
    
    return difference.round();
  }

  // Helper method to calculate mood trend
  Map<String, dynamic> _calculateMoodTrend(List<double> moodData) {
    if (moodData.length < 2) {
      return {
        'text': 'Stable',
        'icon': Icons.trending_flat,
        'color': const Color(0xFF9E9E9E),
      };
    }

    // Calculate trend by comparing first half vs second half
    final midPoint = moodData.length ~/ 2;
    final firstHalf = moodData.take(midPoint).toList();
    final secondHalf = moodData.skip(midPoint).toList();
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    final difference = secondAvg - firstAvg;

    if (difference > 5) {
      return {
        'text': 'Improving',
        'icon': Icons.trending_up,
        'color': const Color(0xFF4CAF50),
      };
    } else if (difference < -5) {
      return {
        'text': 'Declining',
        'icon': Icons.trending_down,
        'color': const Color(0xFFFF5722),
      };
    } else {
      return {
        'text': 'Stable',
        'icon': Icons.trending_flat,
        'color': const Color(0xFF2196F3),
      };
    }
  }

  Widget _buildTimelinePeriodToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = period == _selectedTimelinePeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimelinePeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 12,
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

  List<dynamic> _getTimelineForPeriod(MentalStateProvider mentalStateProvider) {
    switch (_selectedTimelinePeriod) {
      case 'Day':
        return mentalStateProvider.timeline24h;
      case 'Week':
        return mentalStateProvider.timeline7d;
      case 'Month':
        // For month, use 7-day timeline as placeholder
        return mentalStateProvider.timeline7d;
      default:
        return mentalStateProvider.timeline24h;
    }
  }

  String _getTimelineLabelForIndex(int index, List<dynamic> timeline) {
    if (index < 0 || index >= timeline.length) return '';
    
    final timestamp = timeline[index].timestamp as DateTime;
    
    switch (_selectedTimelinePeriod) {
      case 'Day':
        // Show hours for day view
        return DateFormat('HH:mm').format(timestamp);
      case 'Week':
        // Show day of week for week view
        return DateFormat('E').format(timestamp); // Mon, Tue, etc.
      case 'Month':
        // Show date for month view
        return DateFormat('M/d').format(timestamp); // 1/15, 2/3, etc.
      default:
        return DateFormat('HH:mm').format(timestamp);
    }
  }
}

extension DoubleExtension on double {
  double sqrt() => math.sqrt(this);
}