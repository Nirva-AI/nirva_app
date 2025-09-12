import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/mental_state_provider.dart';
import 'package:nirva_app/models/mental_state.dart';
import 'package:nirva_app/stress_insights_page.dart';

class TrendsCard extends StatefulWidget {
  const TrendsCard({super.key});

  @override
  State<TrendsCard> createState() => _TrendsCardState();
}

class _TrendsCardState extends State<TrendsCard> {
  String _selectedPeriod = 'Week';

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
                      // Chart
                      SizedBox(
                        height: 200,
                        child: _buildChart(),
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

  Widget _buildChart() {
    return Consumer<MentalStateProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.insights == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final List<MentalStatePoint> points;
        if (_selectedPeriod == 'Week') {
          // Week view - sample every 3rd point to reduce density (hourly instead of every 30 min)
          final allPoints = provider.timeline7d;
          final sampledPoints = <MentalStatePoint>[];
          for (int i = 0; i < allPoints.length; i += 3) {
            sampledPoints.add(allPoints[i]);
          }
          points = sampledPoints;
        } else if (_selectedPeriod == 'Month') {
          // Month view - sample every 6th point for even less density
          final allPoints = provider.timeline7d;
          final sampledPoints = <MentalStatePoint>[];
          for (int i = 0; i < allPoints.length; i += 6) {
            sampledPoints.add(allPoints[i]);
          }
          points = sampledPoints;
        } else {
          // For day view, show all 24 hours of data
          points = provider.timeline24h.toList();
        }
        
        if (points.isEmpty) {
          return const Center(child: Text('No stress data available'));
        }
        
        // Prepare stress data points
        final stressSpots = <FlSpot>[];
        for (int i = 0; i < points.length; i++) {
          final stress = points[i].stressScore;
          stressSpots.add(FlSpot(i.toDouble(), stress));
        }
        
        // Find current time index for highlighting (only in day view)
        int? currentTimeIndex;
        if (_selectedPeriod == 'Day' && points.isNotEmpty) {
          // The last point should be the most recent (current time)
          // Since server returns data up to current time
          currentTimeIndex = points.length - 1;
        }
        
        return Stack(
          children: [
            // Chart
            LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,  // Updated to 100 scale
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,  // Show at 0, 20, 40, 60, 80, 100
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Color(0xFF0E3C26),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
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
                      interval: 1, // Check every point
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= points.length) {
                          return const Text('');
                        }
                        
                        if (_selectedPeriod == 'Week') {
                          // Show labels at regular intervals for week view
                          // With ~56 points over 7 days (after sampling), show every ~8 points (1 day)
                          if (index % 8 != 0) {
                            return const Text('');
                          }
                          
                          const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                          final dayOfWeek = points[index].timestamp.weekday % 7;
                          return Text(
                            labels[dayOfWeek],
                            style: const TextStyle(
                              color: Color(0xFF0E3C26),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else if (_selectedPeriod == 'Month') {
                          // Show labels at regular intervals for month view
                          // With ~28 points over 7 days (after sampling every 6th), show every ~4 points
                          if (index % 4 != 0) {
                            return const Text('');
                          }
                          
                          // Show day of month instead of week number
                          final date = points[index].timestamp.toLocal();
                          return Text(
                            '${date.month}/${date.day}',
                            style: const TextStyle(
                              color: Color(0xFF0E3C26),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          // Day view - show every 2 hours (4 points = 2 hours)
                          // Only show label at specific intervals
                          if (index % 4 != 0) {
                            return const Text('');
                          }
                          
                          final localTime = points[index].timestamp.toLocal();
                          final hour = localTime.hour;
                          return Text(
                            hour.toString(),
                            style: const TextStyle(
                              color: Color(0xFF0E3C26),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: stressSpots,
                    isCurved: true,
                    color: const Color(0xFFe7bf57),
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    // Only show dot for current time
                    return currentTimeIndex != null && spot.x.toInt() == currentTimeIndex;
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: const Color(0xFFe7bf57),
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFFe7bf57).withOpacity(0.2),
                    ),
                  ),
                ],
                extraLinesData: ExtraLinesData(
                  verticalLines: currentTimeIndex != null ? [
                    VerticalLine(
                      x: currentTimeIndex!.toDouble(),
                      color: const Color(0xFF0E3C26).withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ] : [],
                ),
                lineTouchData: LineTouchData(
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                  handleBuiltInTouches: false,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  List<MentalStatePoint> _aggregateWeekData(List<MentalStatePoint> timeline) {
    // Aggregate 7-day timeline into daily averages
    if (timeline.isEmpty) return [];
    
    final Map<String, List<MentalStatePoint>> dailyPoints = {};
    
    // Group points by day
    for (final point in timeline) {
      final date = point.timestamp;
      final dayKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      if (!dailyPoints.containsKey(dayKey)) {
        dailyPoints[dayKey] = [];
      }
      dailyPoints[dayKey]!.add(point);
    }
    
    // Calculate daily averages and create aggregated points
    final List<MentalStatePoint> aggregated = [];
    dailyPoints.forEach((day, points) {
      if (points.isNotEmpty) {
        final avgStress = points
            .map((p) => p.stressScore)
            .reduce((a, b) => a + b) / points.length;
        final avgEnergy = points
            .map((p) => p.energyScore)
            .reduce((a, b) => a + b) / points.length;
        final avgMood = points
            .map((p) => p.moodScore ?? 65.0)
            .reduce((a, b) => a + b) / points.length;
        final avgConfidence = points
            .map((p) => p.confidence)
            .reduce((a, b) => a + b) / points.length;
        
        // Create a summary point with daily averages
        aggregated.add(MentalStatePoint(
          timestamp: points.first.timestamp,
          stressScore: avgStress,
          energyScore: avgEnergy,
          moodScore: avgMood,
          confidence: avgConfidence,
          dataSource: 'aggregated',
          eventId: null,
        ));
      }
    });
    
    // Sort by date and limit to 7 days
    aggregated.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return aggregated.take(7).toList();
  }

  List<MentalStatePoint> _aggregateMonthData(List<MentalStatePoint> timeline) {
    // For month view, aggregate into weekly averages (up to 4 weeks)
    if (timeline.isEmpty) return [];
    
    // Get the last 30 days of data
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final monthData = timeline.where((p) => p.timestamp.isAfter(thirtyDaysAgo)).toList();
    
    if (monthData.isEmpty) return [];
    
    // Group by week
    final Map<int, List<MentalStatePoint>> weeklyPoints = {};
    for (final point in monthData) {
      final weekNumber = ((now.difference(point.timestamp).inDays) / 7).floor();
      if (!weeklyPoints.containsKey(weekNumber)) {
        weeklyPoints[weekNumber] = [];
      }
      weeklyPoints[weekNumber]!.add(point);
    }
    
    // Calculate weekly averages
    final List<MentalStatePoint> aggregated = [];
    weeklyPoints.forEach((week, points) {
      if (points.isNotEmpty) {
        final avgStress = points
            .map((p) => p.stressScore)
            .reduce((a, b) => a + b) / points.length;
        final avgEnergy = points
            .map((p) => p.energyScore)
            .reduce((a, b) => a + b) / points.length;
        final avgMood = points
            .map((p) => p.moodScore ?? 65.0)
            .reduce((a, b) => a + b) / points.length;
        final avgConfidence = points
            .map((p) => p.confidence)
            .reduce((a, b) => a + b) / points.length;
        
        aggregated.add(MentalStatePoint(
          timestamp: points.first.timestamp,
          stressScore: avgStress,
          energyScore: avgEnergy,
          moodScore: avgMood,
          confidence: avgConfidence,
          dataSource: 'aggregated',
          eventId: null,
        ));
      }
    });
    
    // Sort by date (most recent first, then reverse for chart)
    aggregated.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return aggregated.reversed.toList();
  }

  Widget _buildDescription() {
    return Consumer<MentalStateProvider>(
      builder: (context, provider, child) {
        String description = 'Monitor your stress levels throughout the day.';
        
        if (provider.currentState != null) {
          final currentStress = provider.currentState!.stressScore;
          if (currentStress >= 70) {
            description = 'High stress detected. Consider taking a break or practicing relaxation.';
          } else if (currentStress >= 40) {
            description = 'Moderate stress levels. Stay mindful of your workload.';
          } else {
            description = 'Low stress levels. You\'re managing well!';
          }
        }
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stress Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E3C26),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
                    builder: (context) => const StressInsightsPage(),
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
      },
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
              // Fetch data when switching views
              if (period == 'Week' || period == 'Month') {
                context.read<MentalStateProvider>().fetchInsights();
              }
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

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0E3C26).withOpacity(0.3)
      ..strokeWidth = 1;

    const dashHeight = 3;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 