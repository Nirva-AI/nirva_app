import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

class MoodScoreDetailsPage extends StatefulWidget {
  const MoodScoreDetailsPage({super.key});

  @override
  State<MoodScoreDetailsPage> createState() => _MoodScoreDetailsPageState();
}

class _MoodScoreDetailsPageState extends State<MoodScoreDetailsPage> {
  MoodScoreChartType _selectedType = MoodScoreChartType.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Score'),
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
            // 包裹 TabBar、Mood Score 和折线图的 Card
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
                        _buildTab('Day', MoodScoreChartType.day),
                        _buildTab('Week', MoodScoreChartType.week),
                        _buildTab('Month', MoodScoreChartType.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mood Score
                    const Center(
                      child: Text(
                        '85',
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
                      child: MoodScoreChart(
                        type: _selectedType,
                        dayData: MoodScoreChartData.createDaySamples(),
                        weekData: MoodScoreChartData.createWeekSamples(),
                        monthData: MoodScoreChartData.createMonthSamples(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              DataManager().moodScoreInsights.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  /// 构建按钮
  Widget _buildTab(String title, MoodScoreChartType type) {
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
            if (insights.isNotEmpty)
              ...insights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(insight, style: const TextStyle(fontSize: 14)),
                ),
              )
            else
              const Text(
                'No insights available.',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}

enum MoodScoreChartType { day, week, month }

class MoodScoreChartData {
  final MoodScoreChartType type;
  final int value;
  MoodScoreChartData({required this.type, required this.value});

  //要求出最近的7天
  static List<MoodScoreChartData> createDaySamples() {
    return [
      MoodScoreChartData(type: MoodScoreChartType.day, value: 81),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 85),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 76),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 82),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 80),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 85),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 83),
    ];
  }

  //要求出最近的4周
  static List<MoodScoreChartData> createWeekSamples() {
    return [
      MoodScoreChartData(type: MoodScoreChartType.day, value: 78),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 82),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 79),
      MoodScoreChartData(type: MoodScoreChartType.day, value: 85),
    ];
  }

  // 只要最近的5个月
  static List<MoodScoreChartData> createMonthSamples() {
    return [
      MoodScoreChartData(type: MoodScoreChartType.month, value: 70),
      MoodScoreChartData(type: MoodScoreChartType.month, value: 78),
      MoodScoreChartData(type: MoodScoreChartType.month, value: 80),
      MoodScoreChartData(type: MoodScoreChartType.month, value: 82),
      MoodScoreChartData(type: MoodScoreChartType.month, value: 85),
    ];
  }
}

class MoodScoreChart extends StatelessWidget {
  final MoodScoreChartType type;
  final List<MoodScoreChartData> dayData;
  final List<MoodScoreChartData> weekData;
  final List<MoodScoreChartData> monthData;

  const MoodScoreChart({
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
            minY: 0, // 设置最小值为 0
            maxY: 100, // 设置最大值为 100
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, // 确保左侧标题显示
                  interval: 25, // 设置刻度间隔为 25
                  reservedSize: 40, // 增加刻度区域的宽度
                  getTitlesWidget: (value, meta) {
                    if (value == 0 ||
                        value == 25 ||
                        value == 50 ||
                        value == 75 ||
                        value == 100) {
                      return Text(
                        value.toInt().toString(),
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
  SideTitles _buildBottomTitles(MoodScoreChartType type) {
    switch (type) {
      case MoodScoreChartType.day:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatDayTitle(value.toInt(), dayData.length),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case MoodScoreChartType.week:
        // 暂时留空
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
      case MoodScoreChartType.month:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatMonthTitle(value.toInt(), monthData.length),
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
  List<LineChartBarData> _buildLineBarsData(MoodScoreChartType type) {
    switch (type) {
      case MoodScoreChartType.day:
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
      case MoodScoreChartType.week:
        // 暂时留空
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
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case MoodScoreChartType.month:
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
            color: Colors.purple,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
    }
  }

  /// 格式化月份标题
  String _formatMonthTitle(int widgetIndexValue, int monthsCount) {
    // 获取当前月份
    DateTime dateTime = DataManager().moodScoreInsights.dateTime;
    final int currentMonth = dateTime.month;

    // 计算从当前月份开始的正序排列
    int startMonth = (currentMonth - monthsCount) % 12; // 计算起始月份索引
    if (startMonth < 0) startMonth += 12; // 确保索引为正数
    int targetMonth = (startMonth + widgetIndexValue) % 12; // 计算目标月份索引
    return Utils.monthNames[targetMonth];
  }

  String _formatDayTitle(int widgetIndexValue, int dayCount) {
    // 获取当前月份
    DateTime dateTime = DataManager().moodScoreInsights.dateTime;
    final int currentWeekDay = dateTime.weekday;

    // 计算从当前月份开始的正序排列
    int startWeekDay = (currentWeekDay - dayCount) % 7; // 计算起始月份索引
    if (startWeekDay < 0) startWeekDay += 7; // 确保索引为正数
    int targetWeekDay = (startWeekDay + widgetIndexValue) % 7; // 计算目标月份索引
    return Utils.weekDayNames[targetWeekDay];
  }

  String _formatWeekTitle(int widgetIndexValue) {
    List<String> weekNames = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    return weekNames[widgetIndexValue];
  }
}
