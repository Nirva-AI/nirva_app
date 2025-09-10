import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/mental_state_provider.dart';
import 'package:nirva_app/models/mental_state.dart';
import 'package:nirva_app/energy_insights_page.dart';

class EnergyTrendCard extends StatefulWidget {
  const EnergyTrendCard({super.key});

  @override
  State<EnergyTrendCard> createState() => _EnergyTrendCardState();
}

class _EnergyTrendCardState extends State<EnergyTrendCard> {
  String _selectedPeriod = 'Day';
  List<int> _dayBarHours = []; // Track which hours each bar represents

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
                      // Energy Trend Chart
                      SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: _buildEnergyTrendChart(),
                        ),
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

  Widget _buildEnergyTrendChart() {
    return Consumer<MentalStateProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.insights == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final List<MentalStatePoint> points;
        if (_selectedPeriod == 'Day') {
          points = provider.timeline24h.take(48).toList(); // Last 24 hours (48 30-min points)
        } else if (_selectedPeriod == 'Week') {
          points = _aggregateWeekData(provider.timeline7d); // 7 days aggregated
        } else {
          points = _aggregateMonthData(provider.timeline7d); // Month aggregated into weeks
        }
        
        if (points.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        
        // For day view, show as bars every 2 hours (12 bars)
        // For week view, show 7 bars (one per day)
        // For month view, show weekly bars
        final barGroups = _selectedPeriod == 'Day'
            ? _createDayBars(points)
            : _selectedPeriod == 'Week'
            ? _createWeekBars(points)
            : _createMonthBars(points);
        
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,  // Updated to 100 scale
            minY: 0,
            groupsSpace: 20,
            barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (_selectedPeriod == 'Day') {
                  // Show hour labels for day view (every 2 hours)
                  if (value.toInt() >= 0 && value.toInt() < barGroups.length) {
                    // Use the tracked hours for correct labeling
                    final hourIndex = value.toInt() < _dayBarHours.length 
                        ? _dayBarHours[value.toInt()] 
                        : (value.toInt() == _dayBarHours.length && _dayBarHours.isNotEmpty
                            ? (_dayBarHours.last + 2) % 24  // Next 2-hour period for empty bar
                            : 0);
                    final isEmptyBar = value.toInt() == barGroups.length - 1 && barGroups[value.toInt()].barRods.first.toY == 0;
                    return Text(
                      hourIndex.toString(),
                      style: TextStyle(
                        color: isEmptyBar ? const Color(0xFF0E3C26).withOpacity(0.4) : const Color(0xFF0E3C26),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                } else if (_selectedPeriod == 'Week') {
                  // Show day labels for week view
                  const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                  if (value.toInt() >= 0 && value.toInt() < barGroups.length) {
                    // Calculate which day this bar represents
                    final today = DateTime.now();
                    final numBarsWithData = barGroups.where((bar) => bar.barRods.first.toY > 0).length;
                    final isEmptyBar = value.toInt() >= numBarsWithData;
                    
                    // Calculate the date for this bar
                    // The last bar with data is today, work backwards from there
                    final daysFromToday = value.toInt() - (numBarsWithData - 1);
                    final barDate = today.add(Duration(days: daysFromToday));
                    final dayIndex = barDate.weekday % 7;
                    
                    // Check if this bar is the last one with data (today)
                    final isToday = value.toInt() == numBarsWithData - 1;
                    
                    return Column(
                      children: [
                        Text(
                          labels[dayIndex],
                          style: TextStyle(
                            color: isEmptyBar ? const Color(0xFF0E3C26).withOpacity(0.4) : const Color(0xFF0E3C26),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Circular indicator
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToday 
                                ? const Color(0xFFfdd78c) // Highlighted day (today)
                                : const Color(0xFFC8D4B8).withOpacity(0.6), // Other days
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  // Show week labels for month view
                  if (value.toInt() >= 0 && value.toInt() < barGroups.length) {
                    return Text(
                      'W${value.toInt() + 1}',
                      style: const TextStyle(
                        color: Color(0xFF0E3C26),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,  // Show at 0, 20, 40, 60, 80, 100
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xFF0E3C26),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
      },
    );
  }
  
  List<BarChartGroupData> _createDayBars(List<MentalStatePoint> points) {
    // Group points by 2-hour intervals (4 points per bar for 30-min intervals)
    final bars = <BarChartGroupData>[];
    final barHours = <int>[]; // Track which hours each bar represents
    final tempBars = <BarChartGroupData>[];
    final tempHours = <int>[];
    
    if (points.isEmpty) return bars;
    
    // First, create all bars from the actual data
    for (int i = 0; i < points.length; i += 4) {
      final hourPoints = points.skip(i).take(4).toList();
      if (hourPoints.isNotEmpty) {
        final avgEnergy = hourPoints
            .map((p) => p.energyScore)
            .reduce((a, b) => a + b) / hourPoints.length;
        
        // Get the hour from the LAST point in this group (most recent)
        final localTime = hourPoints.last.timestamp.toLocal();
        final actualHour = localTime.hour;
        
        tempBars.add(BarChartGroupData(
          x: tempBars.length,
          barRods: [
            BarChartRodData(
              toY: avgEnergy,
              color: const Color(0xFFe7bf57).withOpacity(0.2),
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ));
        tempHours.add(actualHour);
      }
    }
    
    // Keep only the most recent 11 bars
    int startIdx = tempBars.length > 11 ? tempBars.length - 11 : 0;
    for (int i = startIdx; i < tempBars.length; i++) {
      bars.add(BarChartGroupData(
        x: bars.length,
        barRods: tempBars[i].barRods,
      ));
      barHours.add(tempHours[i]);
    }
    
    // Store the hours for label display
    _dayBarHours = barHours;
    
    // Find and highlight the bar containing the current hour
    if (bars.isNotEmpty && barHours.isNotEmpty) {
      final now = DateTime.now();
      final currentHour = now.hour;
      
      // Find which bar matches the current hour
      int activeBarIndex = -1;
      for (int i = 0; i < barHours.length; i++) {
        if (barHours[i] == currentHour) {
          activeBarIndex = i;
          break;
        }
      }
      
      // If current hour not found (data is stale), use the last bar
      if (activeBarIndex == -1) {
        activeBarIndex = bars.length - 1;
      }
      
      if (activeBarIndex >= 0 && activeBarIndex < bars.length) {
        bars[activeBarIndex] = BarChartGroupData(
          x: activeBarIndex,
          barRods: [
            BarChartRodData(
              toY: bars[activeBarIndex].barRods.first.toY,
              color: const Color(0xFFe7bf57), // Full opacity for current hour
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        );
      }
    }
    
    // Always add one empty bar for the next 2-hour period
    bars.add(BarChartGroupData(
      x: bars.length,
      barRods: [
        BarChartRodData(
          toY: 0, // No bar at all for future time
          color: Colors.transparent,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    ));
    
    return bars;
  }
  
  List<BarChartGroupData> _createWeekBars(List<MentalStatePoint> points) {
    // Already aggregated by day
    final bars = <BarChartGroupData>[];
    final today = DateTime.now();
    
    // Skip the oldest day if we have 7 days to make room for tomorrow's empty bar
    int startIndex = points.length > 6 ? points.length - 6 : 0;
    
    // Add bars for actual data (max 6 bars to leave room for tomorrow)
    for (int i = startIndex; i < points.length; i++) {
      final dayEnergy = points[i].energyScore;
      
      bars.add(BarChartGroupData(
        x: bars.length,
        barRods: [
          BarChartRodData(
            toY: dayEnergy,
            color: const Color(0xFFe7bf57).withOpacity(0.2), // Will update highlight below
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ));
    }
    
    // Highlight the last bar with data (should be today after server fix)
    if (bars.isNotEmpty) {
      final lastDataIndex = bars.length - 1; // Last bar before the empty one
      if (lastDataIndex >= 0) {
        bars[lastDataIndex] = BarChartGroupData(
          x: lastDataIndex,
          barRods: [
            BarChartRodData(
              toY: bars[lastDataIndex].barRods.first.toY,
              color: const Color(0xFFe7bf57), // Full opacity for today
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        );
      }
    }
    
    // Always add one empty bar for tomorrow
    bars.add(BarChartGroupData(
      x: bars.length,
      barRods: [
        BarChartRodData(
          toY: 0, // No bar at all for future time
          color: Colors.transparent,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    ));
    
    return bars;
  }
  
  List<MentalStatePoint> _aggregateWeekData(List<MentalStatePoint> timeline) {
    // Aggregate 7-day timeline into daily averages
    if (timeline.isEmpty) return [];
    
    final Map<String, List<MentalStatePoint>> dailyPoints = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Group points by day, but only include past and today's data
    for (final point in timeline) {
      final date = point.timestamp;
      // Skip future data points
      if (date.isAfter(now)) continue;
      
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
        final avgEnergy = points
            .map((p) => p.energyScore)
            .reduce((a, b) => a + b) / points.length;
        final avgStress = points
            .map((p) => p.stressScore)
            .reduce((a, b) => a + b) / points.length;
        final avgConfidence = points
            .map((p) => p.confidence)
            .reduce((a, b) => a + b) / points.length;
        
        // Create a summary point with daily averages
        aggregated.add(MentalStatePoint(
          timestamp: points.first.timestamp,
          energyScore: avgEnergy,
          stressScore: avgStress,
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
        final avgEnergy = points
            .map((p) => p.energyScore)
            .reduce((a, b) => a + b) / points.length;
        final avgStress = points
            .map((p) => p.stressScore)
            .reduce((a, b) => a + b) / points.length;
        final avgConfidence = points
            .map((p) => p.confidence)
            .reduce((a, b) => a + b) / points.length;
        
        aggregated.add(MentalStatePoint(
          timestamp: points.first.timestamp,
          energyScore: avgEnergy,
          stressScore: avgStress,
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
  
  List<BarChartGroupData> _createMonthBars(List<MentalStatePoint> points) {
    // Already aggregated by week
    final bars = <BarChartGroupData>[];
    for (int i = 0; i < points.length && i < 4; i++) {
      final weekEnergy = points[i].energyScore;
      
      bars.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: weekEnergy,
            color: const Color(0xFFe7bf57).withOpacity(
              i == points.length - 1 ? 1.0 : 0.2  // Highlight current week (last one)
            ),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ));
    }
    
    // Always add one empty bar for next week if we have less than 4 weeks
    if (bars.length < 4) {
      bars.add(BarChartGroupData(
        x: bars.length,
        barRods: [
          BarChartRodData(
            toY: 0, // No bar at all for future time
            color: Colors.transparent,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ));
    }
    
    return bars;
  }

  Widget _buildDescription() {
    return Consumer<MentalStateProvider>(
      builder: (context, provider, child) {
        String description = 'Track your energy levels throughout the day.';
        
        if (provider.currentState != null) {
          final currentEnergy = provider.currentState!.energyScore;
          if (currentEnergy >= 70) {
            description = 'Your energy level is high. Great time for focused work!';
          } else if (currentEnergy >= 40) {
            description = 'Moderate energy levels. Consider a short break to recharge.';
          } else {
            description = 'Low energy detected. Time for rest or a refreshing activity.';
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
                    'Energy Bar',
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
                    builder: (context) => const EnergyInsightsPage(),
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
              // Fetch data when switching to Week view (7-day data)
              if (period == 'Week') {
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

 