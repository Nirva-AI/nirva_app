import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';
import 'dart:math';
import 'package:nirva_app/data.dart';

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
    List<MoodTracking> moodTrackings =
        DataManager().currentJournal.moodTrackings;

    Map<String, MoodTrackingChartDataGroup> dataMap = {};
    for (var moodTracking in moodTrackings) {
      dataMap[moodTracking.name] = MoodTrackingChartDataGroup.createGroupSample(
        moodTracking,
      );
    }

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

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: MoodTrackingChart(
                        type: _selectedType,
                        moodChartDataGroups: dataMap, // 这里可以传入实际的数据
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
    final List<String> displayInsights = insights.isNotEmpty ? insights : [];

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

  MoodTrackingChartData({required this.type, required this.value});

  static double randomValue() {
    //用math.Random() , 随机返回一个0～100之间的值
    final random = Random();
    return random.nextDouble() * 100;
  }

  // 生成最近的7天数据
  static List<MoodTrackingChartData> createDaySamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.day,
        value: randomValue(),
      ),
    ];
  }

  // 生成最近的4周数据
  static List<MoodTrackingChartData> createWeekSamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.week,
        value: randomValue(),
      ),
    ];
  }

  // 生成最近的5个月数据
  static List<MoodTrackingChartData> createMonthSamples() {
    return [
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: randomValue(),
      ),
      MoodTrackingChartData(
        type: MoodTrackingChartType.month,
        value: randomValue(),
      ),
    ];
  }
}

class MoodTrackingChartDataGroup {
  final String label;
  final List<MoodTrackingChartData> dayData;
  final List<MoodTrackingChartData> weekData;
  final List<MoodTrackingChartData> monthData;

  MoodTrackingChartDataGroup({
    required this.label,
    required this.dayData,
    required this.weekData,
    required this.monthData,
  });

  static createGroupSample(MoodTracking moodTracking) {
    return MoodTrackingChartDataGroup(
      label: moodTracking.name,
      dayData: MoodTrackingChartData.createDaySamples(),
      weekData: MoodTrackingChartData.createWeekSamples(),
      monthData: MoodTrackingChartData.createMonthSamples(),
    );
  }
}

class MoodTrackingChart extends StatelessWidget {
  final MoodTrackingChartType type;

  final Map<String, MoodTrackingChartDataGroup> moodChartDataGroups;

  final double _minY = 0; // 最小值
  final double _maxY = 100; // 最大值
  final double _interval = 25; // 刻度间隔

  List<double> get yAxisValues {
    return List.generate(
      ((_maxY - _minY) / _interval).toInt() + 1,
      (index) => _minY + index * _interval,
    );
  }

  String _convertYValueToString(double value) {
    // if (yAxisValues.contains(value)) {
    //   return value.toInt().toString();
    // }
    return '';
  }

  const MoodTrackingChart({
    super.key,
    required this.type,
    required this.moodChartDataGroups,
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
                  //reservedSize: 40,
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
    //获得dataMap第一个元素的dayData、weekData、monthData
    List<MoodTrackingChartData> dayData1 =
        moodChartDataGroups.values.first.dayData;
    List<MoodTrackingChartData> monthData1 =
        moodChartDataGroups.values.first.monthData;

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
                _formatDayTitle(
                  value.toInt(),
                  DataManager().moodTrackingDashboard.dateTime.weekday,
                  dayData1.length,
                ),
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
                _formatMonthTitle(
                  value.toInt(),
                  DataManager().moodTrackingDashboard.dateTime.month,
                  monthData1.length,
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

  LineChartBarData _buildLineBarData(
    List<MoodTrackingChartData> data,
    Color color,
  ) {
    return LineChartBarData(
      spots:
          data
              .asMap()
              .entries
              .map(
                (entry) =>
                    FlSpot(entry.key.toDouble(), entry.value.value.toDouble()),
              )
              .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(show: true),
    );
  }

  //
  Color _getLineBarColor(String label) {
    return Color(
      DataManager().currentJournal.moodTrackings
          .firstWhere((moodTracking) => moodTracking.name == label)
          .color,
    );
  }

  /// 构建 lineBarsData 的逻辑
  List<LineChartBarData> _buildLineBarsData(MoodTrackingChartType type) {
    List<LineChartBarData> ret = [];

    switch (type) {
      case MoodTrackingChartType.day:
        for (var dataGroup in moodChartDataGroups.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.dayData,
              _getLineBarColor(dataGroup.label),
            ),
          );
        }
        break;

      case MoodTrackingChartType.week:
        for (var dataGroup in moodChartDataGroups.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.weekData,
              _getLineBarColor(dataGroup.label),
            ),
          );
        }

        break;

      case MoodTrackingChartType.month:
        for (var dataGroup in moodChartDataGroups.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.monthData,
              _getLineBarColor(dataGroup.label),
            ),
          );
        }
        break;
    }
    return ret;
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
    return Utils.shortMonthNames[targetMonth - 1];
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
