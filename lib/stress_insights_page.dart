import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'providers/mental_state_provider.dart';

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
    return Consumer<MentalStateProvider>(
      builder: (context, mentalStateProvider, child) {
        final stressData = _getStressDataForPeriod(mentalStateProvider);
        final avgStress = _calculateAverage(stressData);
        final peakTime = _findStressPeakTime(mentalStateProvider);
        final calmTime = _findStressCalmTime(mentalStateProvider);
        final recovery = _calculateStressRecovery(stressData);

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
                    avgStress.toInt().toString(),
                    Icons.psychology,
                    const Color(0xFF616a7f),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Peak Time',
                    peakTime,
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
                    calmTime,
                    Icons.trending_down,
                    const Color(0xFFC8D4B8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Recovery',
                    recovery,
                    Icons.restore,
                    const Color(0xFFdad5fd),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
    return Consumer<MentalStateProvider>(
      builder: (context, mentalStateProvider, child) {
        final chartData = _getStressChartDataReal(mentalStateProvider);
        
        if (chartData.isEmpty) {
          return const Center(
            child: Text(
              'No stress data available',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 16,
              ),
            ),
          );
        }
        
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
                  interval: _getXAxisInterval(chartData.length),
                  getTitlesWidget: (value, meta) {
                    final labels = _getRealStressTimeLabels(mentalStateProvider);
                    final index = _getXAxisLabelIndex(value, chartData.length, labels.length);
                    if (index >= 0 && index < labels.length) {
                      return Text(
                        labels[index],
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
            minX: 0,
            maxX: (chartData.length - 1).toDouble(),
            minY: 0,
            maxY: 100,
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
      },
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
    return Consumer<MentalStateProvider>(
      builder: (context, mentalStateProvider, child) {
        final dailyData = _getRealStressDailyBreakdownData(mentalStateProvider);
        
        if (dailyData.isEmpty) {
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
                child: const Center(
                  child: Text(
                    'No daily breakdown data available',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

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
                children: dailyData.map((day) {
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
                                    'Avg: ${day['avg'].toInt()}',
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
      },
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

  // Real data helper methods for stress
  List<double> _getStressDataForPeriod(MentalStateProvider provider) {
    switch (_selectedPeriod) {
      case 'Day':
        return provider.stressData24h;
      case 'Week':
        return provider.timeline7d.map((p) => p.stressScore).toList();
      case 'Month':
        // For month, use 7-day data as placeholder until month data is available
        return provider.timeline7d.map((p) => p.stressScore).toList();
      default:
        return provider.stressData24h;
    }
  }

  List<FlSpot> _getStressChartDataReal(MentalStateProvider provider) {
    final stressData = _getStressDataForPeriod(provider);
    
    return stressData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  List<String> _getRealStressTimeLabels(MentalStateProvider provider) {
    switch (_selectedPeriod) {
      case 'Day':
        // Show every 3 hours: 0, 3, 6, 9, 12, 15, 18, 21
        return ['0', '3', '6', '9', '12', '15', '18', '21'];
      case 'Week':
        // Show first point of every day
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'Month':
        // Show evenly spaced points for month view
        return ['1', '5', '10', '15', '20', '25', '30'];
      default:
        return [];
    }
  }

  double _calculateAverage(List<double> data) {
    if (data.isEmpty) return 0.0;
    return data.reduce((a, b) => a + b) / data.length;
  }

  String _findStressPeakTime(MentalStateProvider provider) {
    final timeline = _selectedPeriod == 'Day' ? provider.timeline24h : provider.timeline7d;
    if (timeline.isEmpty) return 'N/A';
    
    double maxStress = 0;
    int maxIndex = 0;
    for (int i = 0; i < timeline.length; i++) {
      if (timeline[i].stressScore > maxStress) {
        maxStress = timeline[i].stressScore;
        maxIndex = i;
      }
    }
    
    if (_selectedPeriod == 'Day') {
      return DateFormat('h a').format(timeline[maxIndex].timestamp);
    } else {
      return DateFormat('E').format(timeline[maxIndex].timestamp);
    }
  }

  String _findStressCalmTime(MentalStateProvider provider) {
    final timeline = _selectedPeriod == 'Day' ? provider.timeline24h : provider.timeline7d;
    if (timeline.isEmpty) return 'N/A';
    
    double minStress = 100;
    int minIndex = 0;
    for (int i = 0; i < timeline.length; i++) {
      if (timeline[i].stressScore < minStress) {
        minStress = timeline[i].stressScore;
        minIndex = i;
      }
    }
    
    if (_selectedPeriod == 'Day') {
      return DateFormat('h a').format(timeline[minIndex].timestamp);
    } else {
      return DateFormat('E').format(timeline[minIndex].timestamp);
    }
  }

  String _calculateStressRecovery(List<double> data) {
    if (data.isEmpty) return 'N/A';
    if (data.length < 2) return 'Limited Data';
    
    // Calculate how quickly stress returns to baseline after peaks
    final avg = _calculateAverage(data);
    final peaks = data.where((s) => s > avg + 20).toList();
    
    if (peaks.length < 2) return 'Good';
    
    // Simple heuristic: if average stress is low, recovery is fast
    if (avg < 30) return 'Fast';
    if (avg < 50) return 'Moderate';
    return 'Slow';
  }

  List<Map<String, dynamic>> _getRealStressDailyBreakdownData(MentalStateProvider provider) {
    final timeline7d = provider.timeline7d;
    if (timeline7d.isEmpty) return [];
    
    // Group by day of week
    Map<String, List<double>> dailyData = {};
    for (final point in timeline7d) {
      final dayKey = DateFormat('E').format(point.timestamp);
      dailyData[dayKey] ??= [];
      dailyData[dayKey]!.add(point.stressScore);
    }
    
    return dailyData.entries.map((entry) {
      final avg = _calculateAverage(entry.value);
      final minVal = entry.value.reduce(min);
      final maxVal = entry.value.reduce(max);
      return {
        'day': entry.key,
        'avg': avg,
        'range': '${minVal.toInt()}-${maxVal.toInt()}',
      };
    }).toList();
  }

  double _getXAxisInterval(int dataLength) {
    switch (_selectedPeriod) {
      case 'Day':
        // For day view, show every 3 hours (every 3rd data point if hourly data)
        return (dataLength / 8).clamp(1.0, double.infinity);
      case 'Week':
        // For week view, show every day
        return (dataLength / 7).clamp(1.0, double.infinity);
      case 'Month':
        // For month view, show every 5 days
        return (dataLength / 6).clamp(1.0, double.infinity);
      default:
        return 1.0;
    }
  }

  int _getXAxisLabelIndex(double value, int dataLength, int labelCount) {
    if (dataLength <= 1 || labelCount <= 1) return 0;
    
    // Map the x-axis value to label index
    final ratio = value / (dataLength - 1);
    final labelIndex = (ratio * (labelCount - 1)).round();
    return labelIndex.clamp(0, labelCount - 1);
  }
}