import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
//import 'package:nirva_app/utils.dart';

class MoodTrackingDetailsPage extends StatefulWidget {
  const MoodTrackingDetailsPage({super.key});

  @override
  State<MoodTrackingDetailsPage> createState() =>
      _MoodTrackingDetailsPageState();
}

class _MoodTrackingDetailsPageState extends State<MoodTrackingDetailsPage> {
  MoodTrackingChartType _selectedType = MoodTrackingChartType.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 包裹 TabBar、平均情绪得分和折线图的 Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TabBar 选择栏
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab('Day', MoodTrackingChartType.day),
                        _buildTab('Week', MoodTrackingChartType.week),
                        _buildTab('Month', MoodTrackingChartType.month),
                      ],
                    ),
                    const SizedBox(height: 16 * 2),

                    // 平均情绪得分
                    // Center(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'Average Mood Score',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.grey[600],
                    //         ),
                    //       ),
                    //       const SizedBox(height: 4),
                    //       Text(
                    //         _getAverageMoodScore(_selectedType),
                    //         style: const TextStyle(
                    //           fontSize: 48,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: MoodTrackingChart(
                        type: _selectedType,
                        dayData: MoodTrackingChartData.createDaySamples(),
                        weekData: MoodTrackingChartData.createWeekSamples(),
                        monthData: MoodTrackingChartData.createMonthSamples(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(DataManager().moodTrackingDashboard.insights),
          ],
        ),
      ),
    );
  }

  // String _getAverageMoodScore(MoodTrackingChartType type) {
  //   switch (type) {
  //     case MoodTrackingChartType.day:
  //       return "7.8";
  //     case MoodTrackingChartType.week:
  //       return "7.5";
  //     case MoodTrackingChartType.month:
  //       return "7.2";
  //   }
  // }

  // // 构建情绪分布图表
  // Widget _buildMoodDistribution(MoodTrackingChartType type) {
  //   // 根据选择的类型返回不同的数据
  //   Map<String, double> distributionData;

  //   switch (type) {
  //     case MoodTrackingChartType.day:
  //       distributionData = {
  //         'Happy': 50,
  //         'Calm': 30,
  //         'Stressed': 10,
  //         'Focused': 10,
  //       };
  //       break;
  //     case MoodTrackingChartType.week:
  //       distributionData = {
  //         'Happy': 45,
  //         'Calm': 25,
  //         'Stressed': 15,
  //         'Focused': 15,
  //       };
  //       break;
  //     case MoodTrackingChartType.month:
  //       distributionData = {
  //         'Happy': 40,
  //         'Calm': 20,
  //         'Stressed': 20,
  //         'Focused': 20,
  //       };
  //       break;
  //   }

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children:
  //         distributionData.entries.map((entry) {
  //           return Column(
  //             children: [
  //               Container(
  //                 width: 60,
  //                 height: 100,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(8),
  //                   color: _getMoodColor(entry.key),
  //                 ),
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   '${entry.value.toInt()}%',
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(entry.key, style: const TextStyle(fontSize: 12)),
  //             ],
  //           );
  //         }).toList(),
  //   );
  // }

  // 获取情绪对应的颜色
  // Color _getMoodColor(String moodName) {
  //   if (moodName == 'Happy') {
  //     return Colors.blue;
  //   } else if (moodName == 'Calm') {
  //     return Colors.green;
  //   } else if (moodName == 'Stressed') {
  //     return Colors.red;
  //   } else if (moodName == 'Focused') {
  //     return Colors.orange;
  //   }
  //   return Colors.grey; // 默认颜色
  // }

  /// 构建按钮
  Widget _buildTab(String title, MoodTrackingChartType type) {
    final bool isSelected = _selectedType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedType = type; // 更新选中的类型
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 提取 Insights 卡片部分为独立函数
  Widget _buildInsightsCard(List<String> insights) {
    // 如果insights为空，提供一些默认值
    final List<String> displayInsights =
        insights.isNotEmpty
            ? insights
            : [
              // 'Happiness and calmness are your dominant emotions this day.',
              // 'Stress levels peak during midweek but decrease on weekends.',
              // 'Focus appears to be strongest in the mornings - consider scheduling important tasks then.',
            ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...displayInsights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(insight, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MoodTrackingChartType { day, week, month }

class MoodTrackingChartData {
  final MoodTrackingChartType type;
  final double value;
  final String mood;

  MoodTrackingChartData({
    required this.type,
    required this.value,
    required this.mood,
  });

  // 生成最近的7天数据
  static List<MoodTrackingChartData> createDaySamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 7.0,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 6.0,
        mood: 'Calm',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 8.0,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 7.0,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 5.0,
        mood: 'Stressed',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 6.0,
        mood: 'Calm',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: 7.8,
        mood: 'Happy',
      ),
    ];
  }

  // 生成最近的4周数据
  static List<MoodTrackingChartData> createWeekSamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: 6.8,
        mood: 'Calm',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: 7.2,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: 6.5,
        mood: 'Focused',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: 7.5,
        mood: 'Happy',
      ),
    ];
  }

  // 生成最近的5个月数据
  static List<MoodTrackingChartData> createMonthSamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: 6.2,
        mood: 'Calm',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: 6.7,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: 7.3,
        mood: 'Happy',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: 6.8,
        mood: 'Focused',
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: 7.2,
        mood: 'Happy',
      ),
    ];
  }
}

class MoodTrackingChart extends StatelessWidget {
  final MoodTrackingChartType type;
  final List<MoodTrackingChartData> dayData;
  final List<MoodTrackingChartData> weekData;
  final List<MoodTrackingChartData> monthData;

  final double _minY = 0; // 最小值
  final double _maxY = 10; // 最大值
  final double _interval = 2; // 刻度间隔

  List<double> get yAxisValues {
    return List.generate(
      ((_maxY - _minY) / _interval).toInt() + 1,
      (index) => _minY + index * _interval,
    );
  }

  String _convertYValueToString(double value) {
    if (yAxisValues.contains(value)) {
      return value.toInt().toString();
    }
    return '';
  }

  const MoodTrackingChart({
    super.key,
    required this.type,
    required this.dayData,
    required this.weekData,
    required this.monthData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // 确保图表居中
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 1.0,
        child: LineChart(
          LineChartData(
            minY: _minY,
            maxY: _maxY,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _interval,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    var valueToString = _convertYValueToString(value);
                    if (valueToString.isNotEmpty) {
                      return Text(
                        valueToString,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(sideTitles: _buildBottomTitles(type)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: _buildLineBarsData(type),
          ),
        ),
      ),
    );
  }

  /// 构建底部标题的逻辑
  SideTitles _buildBottomTitles(MoodTrackingChartType type) {
    switch (type) {
      case MoodTrackingChartType.day:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatDayTitle(value.toInt()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case MoodTrackingChartType.week:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatWeekTitle(value.toInt()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case MoodTrackingChartType.month:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatMonthTitle(value.toInt()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
    }
  }

  /// 构建 lineBarsData 的逻辑
  List<LineChartBarData> _buildLineBarsData(MoodTrackingChartType type) {
    switch (type) {
      case MoodTrackingChartType.day:
        return [
          LineChartBarData(
            spots:
                dayData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case MoodTrackingChartType.week:
        return [
          LineChartBarData(
            spots:
                weekData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case MoodTrackingChartType.month:
        return [
          LineChartBarData(
            spots:
                monthData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
    }
  }

  // 格式化每天的标题
  String _formatDayTitle(int value) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[value % days.length];
  }

  /// 显示最近的4个周
  String _formatWeekTitle(int value) {
    List<String> weekNames = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    return weekNames[value];
  }

  /// 格式化月份标题
  String _formatMonthTitle(int value) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    int monthIndex = (now.month - 5 + value) % 12;
    if (monthIndex == 0) monthIndex = 12;
    return months[monthIndex - 1];
  }
}
