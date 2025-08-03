import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/awake_time_allocation_insights_page.dart';
import 'dart:math';

class AwakeTimeAllocationTrendCard extends StatefulWidget {
  const AwakeTimeAllocationTrendCard({super.key});

  @override
  State<AwakeTimeAllocationTrendCard> createState() => _AwakeTimeAllocationTrendCardState();
}

class _AwakeTimeAllocationTrendCardState extends State<AwakeTimeAllocationTrendCard> {
  // Period selector for the chart
  String _selectedPeriod = 'Day';

  // Define the activity categories as requested
  static const List<String> activityCategories = [
    'Work',
    'Exercise', 
    'Social',
    'Learning',
    'Self-care',
    'Others'
  ];

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
                      // Chart with padding
                      SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: _buildChart(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend (only show for Week and Month views)
                      if (_selectedPeriod != 'Day') Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildLegend(),
                      ),
                      if (_selectedPeriod != 'Day') const SizedBox(height: 16),
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



  Widget _buildChart() {
    return Consumer<JournalFilesProvider>(
      builder: (context, journalProvider, child) {
        if (_selectedPeriod == 'Day') {
          return _buildBarChart();
        } else {
          return _buildLineChart();
        }
      },
    );
  }

  Widget _buildBarChart() {
    final allChartData = _getAllActivitiesData();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 8,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 2,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value <= 8 && value % 2 == 0) {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < activityCategories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      activityCategories[value.toInt()],
                      style: const TextStyle(
                        color: Color(0xFF0E3C26),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: allChartData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.spots.first.y, // Use the first (and only) value for day view
                color: data.color,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLineChart() {
    final allChartData = _getAllActivitiesData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 2,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value <= 8 && value % 2 == 0) {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Text(
                    labels[value.toInt()],
                    style: const TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: allChartData.map((data) => LineChartBarData(
          spots: data.spots,
          isCurved: true,
          color: data.color,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: Colors.transparent,
                strokeWidth: 1.5,
                strokeColor: data.color,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        )).toList(),
        lineTouchData: LineTouchData(
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
          handleBuiltInTouches: false,
        ),
      ),
    );
  }

  List<ChartData> _getAllActivitiesData() {
    return activityCategories.map((activity) {
      final random = _getSeededRandom(activity);
      final spots = List.generate(7, (index) {
        double baseValue = 0;
        switch (activity.toLowerCase()) {
          case 'work':
            baseValue = 6.0 + random.nextDouble() * 2; // 6-8 hours
            break;
          case 'exercise':
            baseValue = 0.5 + random.nextDouble() * 1.5; // 0.5-2 hours
            break;
          case 'social':
            baseValue = 1.0 + random.nextDouble() * 2; // 1-3 hours
            break;
          case 'learning':
            baseValue = 1.0 + random.nextDouble() * 2; // 1-3 hours
            break;
          case 'self-care':
            baseValue = 0.5 + random.nextDouble() * 1.5; // 0.5-2 hours
            break;
          case 'others':
            baseValue = 1.0 + random.nextDouble() * 2; // 1-3 hours
            break;
          default:
            baseValue = 2.0 + random.nextDouble() * 2; // 2-4 hours
        }
        return FlSpot(index.toDouble(), baseValue);
      });
      
      return ChartData(
        spots: spots,
        color: _getActivityColor(activity),
        activity: activity,
      );
    }).toList();
  }



  Random _getSeededRandom(String seed) {
    int seedValue = seed.hashCode;
    return Random(seedValue);
  }

  Color _getActivityColor(String activity) {
    switch (activity.toLowerCase()) {
      case 'work':
        return const Color(0xFFdad5fd); // Purple from Experience page
      case 'exercise':
        return const Color(0xFFC8D4B8); // Green from Movement
      case 'social':
        return const Color(0xFFfdd78c); // Yellow from Memories/Emotions
      case 'learning':
        return const Color(0xFFB8C4D4); // Blue from Breathing
      case 'self-care':
        return const Color(0xFF616a7f); // Gray from Reflections
      case 'others':
        return const Color(0xFFD4C4A8); // Beige from Recap
      default:
        return const Color(0xFFe7bf57); // Default gold
    }
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: activityCategories.map((activity) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getActivityColor(activity),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              activity,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0E3C26),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDescription() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Awake Time Allocation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your time allocation across all activities over time.',
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
                builder: (context) => const AwakeTimeAllocationInsightsPage(),
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
}

class ChartData {
  final List<FlSpot> spots;
  final Color color;
  final String activity;

  ChartData({
    required this.spots,
    required this.color,
    required this.activity,
  });
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