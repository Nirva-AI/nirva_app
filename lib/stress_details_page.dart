import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

class StressDetailsPage extends StatefulWidget {
  const StressDetailsPage({super.key});

  @override
  State<StressDetailsPage> createState() => _StressDetailsPageState();
}

class _StressDetailsPageState extends State<StressDetailsPage> {
  StressChartType _selectedType = StressChartType.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Level'),
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
            // 包裹 TabBar、Stress Level 和折线图的 Card
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
                    // TabBar 模拟
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab('Day', StressChartType.day),
                        _buildTab('Week', StressChartType.week),
                        _buildTab('Month', StressChartType.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stress Level
                    const Center(
                      child: Text(
                        '3.3',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: StressChart(
                        type: _selectedType,
                        dayData: StressChartData.createDaySamples(),
                        weekData: StressChartData.createWeekSamples(),
                        monthData: StressChartData.createMonthSamples(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              DataManager().stressLevelDashboard.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  /// 构建按钮
  Widget _buildTab(String title, StressChartType type) {
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
    final List<String> displayInsights = insights.isNotEmpty
        ? insights
        : [
            'Your stress levels have decreased over this day.',
            'Meditation sessions appear to reduce stress levels significantly.',
            'Work-related stress peaks on Mondays and gradually decreases throughout the week.',
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
            )
          ],
        ),
      ),
    );
  }
}

enum StressChartType { day, week, month }

class StressChartData {
  final StressChartType type;
  final double value;
  StressChartData({required this.type, required this.value});

  // 生成最近的7天数据
  static List<StressChartData> createDaySamples() {
    return [
      StressChartData(type: StressChartType.day, value: 6.0),
      StressChartData(type: StressChartType.day, value: 3.0),
      StressChartData(type: StressChartType.day, value: 7.0),
      StressChartData(type: StressChartType.day, value: 5.0),
      StressChartData(type: StressChartType.day, value: 4.0),
      StressChartData(type: StressChartType.day, value: 3.0),
      StressChartData(type: StressChartType.day, value: 4.0),
    ];
  }

  // 生成最近的4周数据
  static List<StressChartData> createWeekSamples() {
    return [
      StressChartData(type: StressChartType.week, value: 5.5),
      StressChartData(type: StressChartType.week, value: 4.8),
      StressChartData(type: StressChartType.week, value: 4.0),
      StressChartData(type: StressChartType.week, value: 3.3),
    ];
  }

  // 生成最近的5个月数据
  static List<StressChartData> createMonthSamples() {
    return [
      StressChartData(type: StressChartType.month, value: 7.0),
      StressChartData(type: StressChartType.month, value: 5.5),
      StressChartData(type: StressChartType.month, value: 4.8),
      StressChartData(type: StressChartType.month, value: 4.0),
      StressChartData(type: StressChartType.month, value: 3.3),
    ];
  }
}

class StressChart extends StatelessWidget {
  final StressChartType type;
  final List<StressChartData> dayData;
  final List<StressChartData> weekData;
  final List<StressChartData> monthData;

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

  const StressChart({
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
  SideTitles _buildBottomTitles(StressChartType type) {
    switch (type) {
      case StressChartType.day:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatDayTitle(
                  value.toInt(),
                  DataManager().stressLevelDashboard.dateTime.weekday,
                  dayData.length,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case StressChartType.week:
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
      case StressChartType.month:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatMonthTitle(
                  value.toInt(),
                  DataManager().stressLevelDashboard.dateTime.month,
                  monthData.length,
                ),
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
  List<LineChartBarData> _buildLineBarsData(StressChartType type) {
    switch (type) {
      case StressChartType.day:
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
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case StressChartType.week:
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
            color: Colors.orange,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case StressChartType.month:
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
            color: Colors.amber,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
    }
  }

  /// 格式化月份标题
  String _formatMonthTitle(
    int widgetIndexValue,
    int currentMonth,
    int monthsCount,
  ) {
    int startMonth = (currentMonth - monthsCount) % 12;
    if (startMonth <= 0) startMonth += 12;
    int targetMonth = (startMonth + widgetIndexValue) % 12;
    if (targetMonth == 0) targetMonth = 12;
    return Utils.monthNames[targetMonth - 1];
  }

  // 格式化每天的标题
  String _formatDayTitle(
    int widgetIndexValue,
    int currentWeekDay,
    int dayCount,
  ) {
    // 计算从当前月份开始的正序排列
    int startWeekDay = (currentWeekDay - dayCount) % 7;
    if (startWeekDay <= 0) startWeekDay += 7;
    int targetWeekDay = (startWeekDay + widgetIndexValue) % 7;
    if (targetWeekDay == 0) targetWeekDay = 7;
    return Utils.weekDayNames[targetWeekDay - 1];
  }

  /// 显示最近的4个周
  String _formatWeekTitle(int widgetIndexValue) {
    List<String> weekNames = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    return weekNames[widgetIndexValue];
  }
}
