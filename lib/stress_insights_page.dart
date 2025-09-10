import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class StressInsightsPage extends StatefulWidget {
  const StressInsightsPage({super.key});

  @override
  State<StressInsightsPage> createState() => _StressInsightsPageState();
}

class _StressInsightsPageState extends State<StressInsightsPage> {
  String _selectedPeriod = 'Day';

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
          'Stress Insights',
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
            
            // Stress Triggers
            _buildStressTriggers(),
            const SizedBox(height: 32),
            
            // Daily Breakdown
            _buildDailyBreakdown(),
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
                'Avg Stress',
                '28',
                Icons.psychology,
                const Color(0xFF616a7f),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Peak Time',
                '2 PM',
                Icons.trending_up,
                const Color(0xFFfdd78c),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Calm Time',
                '7 PM',
                Icons.trending_down,
                const Color(0xFFC8D4B8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Recovery',
                'Fast',
                Icons.restore,
                const Color(0xFFdad5fd),
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
              'Stress Levels',
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
          child: _buildStressChart(),
        ),
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
                color: isSelected ? const Color(0xFF616a7f) : Colors.transparent,
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

  Widget _buildStressChart() {
    final chartData = _getStressChartData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
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
              interval: 20,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value <= 100 && value % 20 == 0) {
                  return Text(
                    '${value.toInt()}',
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
                final labels = _getTimeLabels();
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
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: true,
            color: const Color(0xFF616a7f),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF616a7f),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF616a7f).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  Widget _buildStressTriggers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stress Triggers',
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
            children: [
              _buildTriggerItem('Work Deadlines', '35%', 'High Impact', const Color(0xFFfdd78c)),
              const SizedBox(height: 16),
              _buildTriggerItem('Social Events', '25%', 'Medium Impact', const Color(0xFF616a7f)),
              const SizedBox(height: 16),
              _buildTriggerItem('Physical Fatigue', '20%', 'Medium Impact', const Color(0xFFdad5fd)),
              const SizedBox(height: 16),
              _buildTriggerItem('Time Pressure', '20%', 'Low Impact', const Color(0xFFC8D4B8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerItem(String title, String percentage, String impact, Color color) {
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
                impact,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Breakdown',
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
            children: _getDailyBreakdownData().map((day) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        day['day'],
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
                                'Avg: ${day['avg']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0E3C26),
                                ),
                              ),
                              Text(
                                'Range: ${day['range']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: day['avg'] / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              day['avg'] <= 30 ? const Color(0xFFC8D4B8) :
                              day['avg'] <= 50 ? const Color(0xFFe7bf57) :
                              const Color(0xFF616a7f),
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
                'Your stress levels peak around 2 PM, often coinciding with work deadlines.',
              ),
              const SizedBox(height: 16),
              _buildInsightItem(
                'You recover quickly from stress, typically returning to baseline within 2 hours.',
              ),
              const SizedBox(height: 16),
              _buildInsightItem(
                'Your lowest stress levels occur in the evening around 7 PM during relaxation time.',
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

  List<FlSpot> _getStressChartData() {
    final random = Random(24); // Seeded for consistency
    
    if (_selectedPeriod == 'Day') {
      // 24 hours data points (every hour)
      return List.generate(24, (index) {
        double stress;
        if (index >= 9 && index <= 17) {
          // Work hours - generally higher stress
          if (index == 14) {
            stress = 40 + random.nextDouble() * 30; // 2 PM peak
          } else {
            stress = 25 + random.nextDouble() * 25; // Other work hours
          }
        } else if (index >= 19 && index <= 21) {
          stress = 10 + random.nextDouble() * 15; // Evening relaxation
        } else if (index >= 22 || index <= 6) {
          stress = 5 + random.nextDouble() * 10; // Night/sleep
        } else {
          stress = 15 + random.nextDouble() * 20; // Other times
        }
        return FlSpot(index.toDouble(), stress);
      });
    } else if (_selectedPeriod == 'Week') {
      // 7 days data
      return List.generate(7, (index) {
        double stress;
        if (index < 5) {
          stress = 25 + random.nextDouble() * 20; // Weekdays
        } else {
          stress = 15 + random.nextDouble() * 15; // Weekends
        }
        return FlSpot(index.toDouble(), stress);
      });
    } else {
      // 30 days data
      return List.generate(30, (index) {
        double stress = 20 + random.nextDouble() * 25;
        return FlSpot(index.toDouble(), stress);
      });
    }
  }

  List<String> _getTimeLabels() {
    if (_selectedPeriod == 'Day') {
      return ['12AM', '3AM', '6AM', '9AM', '12PM', '3PM', '6PM', '9PM'];
    } else if (_selectedPeriod == 'Week') {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else {
      return ['1', '5', '10', '15', '20', '25', '30'];
    }
  }

  List<Map<String, dynamic>> _getDailyBreakdownData() {
    return [
      {'day': 'Mon', 'avg': 35.0, 'range': '20-55'},
      {'day': 'Tue', 'avg': 28.0, 'range': '15-45'},
      {'day': 'Wed', 'avg': 32.0, 'range': '18-50'},
      {'day': 'Thu', 'avg': 40.0, 'range': '25-60'},
      {'day': 'Fri', 'avg': 30.0, 'range': '20-45'},
      {'day': 'Sat', 'avg': 22.0, 'range': '10-35'},
      {'day': 'Sun', 'avg': 18.0, 'range': '8-30'},
    ];
  }
}