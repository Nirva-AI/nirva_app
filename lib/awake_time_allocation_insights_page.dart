import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/data.dart';
import 'dart:math';

class AwakeTimeAllocationInsightsPage extends StatefulWidget {
  const AwakeTimeAllocationInsightsPage({super.key});

  @override
  State<AwakeTimeAllocationInsightsPage> createState() => _AwakeTimeAllocationInsightsPageState();
}

class _AwakeTimeAllocationInsightsPageState extends State<AwakeTimeAllocationInsightsPage> {
  String _selectedPeriod = 'Day';

  // Define the activity categories
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
          'Awake Time Allocation',
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
            
            // Chart Section
            _buildChartSection(),
            const SizedBox(height: 32),
            
            // Insights Section
            _buildInsightsSection(),
            const SizedBox(height: 32),
            
            // Activity Breakdown
            _buildActivityBreakdown(),
            const SizedBox(height: 32),
            
            // Time Distribution
            _buildTimeDistribution(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
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
                'Total Hours',
                '16.5h',
                Icons.access_time,
                const Color(0xFFe7bf57),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Most Active',
                'Work',
                Icons.work,
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
                'Productivity',
                '68%',
                Icons.trending_up,
                const Color(0xFFC8D4B8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Balance',
                'Good',
                Icons.balance,
                const Color(0xFFfdd78c),
              ),
            ),
          ],
        ),
      ],
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
              'Time Allocation',
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
          child: _selectedPeriod == 'Day' ? _buildBarChart() : _buildLineChart(),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
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

  Widget _buildBarChart() {
    final chartData = _getChartData();
    
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
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
          drawVerticalLine: false,
        ),
        barGroups: chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.spots.first.y,
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
    final chartData = _getChartData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
          drawVerticalLine: false,
        ),
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
        lineBarsData: chartData.map((data) => LineChartBarData(
          spots: data.spots,
          isCurved: true,
          color: data.color,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 3,
                color: Colors.white,
                strokeWidth: 2,
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

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
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

  Widget _buildActivityBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Breakdown',
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
            children: activityCategories.map((activity) {
              final hours = _getActivityHours(activity);
              final percentage = (hours / 16.5 * 100).round();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getActivityColor(activity),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        activity,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E3C26),
                        ),
                      ),
                    ),
                    Text(
                      '${hours.toStringAsFixed(1)}h',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E3C26),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
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

  Widget _buildTimeDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time Distribution',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
          child: PieChart(
            PieChartData(
              sections: activityCategories.map((activity) {
                final hours = _getActivityHours(activity);
                final percentage = (hours / 16.5 * 100);
                
                return PieChartSectionData(
                  color: _getActivityColor(activity),
                  value: percentage,
                  title: '${percentage.round()}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }

  List<ChartData> _getChartData() {
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

  double _getActivityHours(String activity) {
    final random = _getSeededRandom(activity);
    switch (activity.toLowerCase()) {
      case 'work':
        return 6.0 + random.nextDouble() * 2; // 6-8 hours
      case 'exercise':
        return 0.5 + random.nextDouble() * 1.5; // 0.5-2 hours
      case 'social':
        return 1.0 + random.nextDouble() * 2; // 1-3 hours
      case 'learning':
        return 1.0 + random.nextDouble() * 2; // 1-3 hours
      case 'self-care':
        return 0.5 + random.nextDouble() * 1.5; // 0.5-2 hours
      case 'others':
        return 1.0 + random.nextDouble() * 2; // 1-3 hours
      default:
        return 2.0 + random.nextDouble() * 2; // 2-4 hours
    }
  }

  Random _getSeededRandom(String seed) {
    int seedValue = seed.hashCode;
    return Random(seedValue);
  }

  Color _getActivityColor(String activity) {
    switch (activity.toLowerCase()) {
      case 'work':
        return const Color(0xFFdad5fd); // Purple
      case 'exercise':
        return const Color(0xFFC8D4B8); // Green
      case 'social':
        return const Color(0xFFfdd78c); // Yellow
      case 'learning':
        return const Color(0xFFB8C4D4); // Blue
      case 'self-care':
        return const Color(0xFF616a7f); // Gray
      case 'others':
        return const Color(0xFFD4C4A8); // Beige
      default:
        return const Color(0xFFe7bf57); // Default gold
    }
  }

  Widget _buildInsightsSection() {
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
            children: [
              _buildInsightItem(
                'Work takes up the majority of your awake hours this week.',
              ),
              const SizedBox(height: 16),
              _buildInsightItem(
                'Self-care and exercise time has increased compared to previous periods.',
              ),
              const SizedBox(height: 16),
              _buildInsightItem(
                'Consider increasing learning activities to meet your personal growth goals.',
              ),
            ],
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