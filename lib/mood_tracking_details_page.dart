import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';
import 'dart:math';
import 'package:nirva_app/data.dart';

enum MoodTrackingChartType { day, week, month }

class MoodTrackingChartDataGroup {
  final MoodTracking moodTracking;
  final List<double> day;
  final List<double> week;
  final List<double> month;

  static final random = Random();

  MoodTrackingChartDataGroup({
    required this.moodTracking,
    required this.day,
    required this.week,
    required this.month,
  });

  Color get lineBarColor {
    return Color(moodTracking.color);
  }

  String get label {
    return moodTracking.name;
  }

  static createGroup(MoodTracking moodTracking) {
    return MoodTrackingChartDataGroup(
      moodTracking: moodTracking,
      day: MoodTrackingChartDataGroup.createDaySamples(),
      week: MoodTrackingChartDataGroup.createWeekSamples(),
      month: MoodTrackingChartDataGroup.createMonthSamples(),
    );
  }

  static double randomValue() {
    //用math.Random() , 随机返回一个0～100之间的值
    final random = Random();
    return random.nextDouble() * 100;
  }

  // 生成最近的7天数据
  static List<double> createDaySamples() {
    return List.generate(7, (index) => randomValue());
  }

  // 生成最近的4周数据
  static List<double> createWeekSamples() {
    return List.generate(4, (index) => randomValue());
  }

  // 生成最近的5个月数据
  static List<double> createMonthSamples() {
    return List.generate(5, (index) => randomValue());
  }
}

class MoodTrackingChartDataManager {
  final double minY = 0; // 最小值
  final double maxY = 100; // 最大值
  final double interval = 25; // 刻度间隔
  final dayCount = 7;
  final monthCount = 5;
  Map<String, MoodTrackingChartDataGroup> groups = {};

  MoodTrackingChartDataManager({required this.groups});

  List<double> get yAxisValues {
    return List.generate(
      ((maxY - minY) / interval).toInt() + 1,
      (index) => minY + index * interval,
    );
  }

  void addGroup(String label, MoodTrackingChartDataGroup dataGroup) {
    groups[label] = dataGroup;
  }
}

class MoodTrackingDetailsPage extends StatefulWidget {
  MoodTrackingDetailsPage({super.key});

  final MoodTrackingChartDataManager dataManager = MoodTrackingChartDataManager(
    groups: {},
  );

  @override
  State<MoodTrackingDetailsPage> createState() =>
      _MoodTrackingDetailsPageState();
}

class _MoodTrackingDetailsPageState extends State<MoodTrackingDetailsPage> {
  MoodTrackingChartType _selectedType = MoodTrackingChartType.day; // 默认选中类型

  MoodTrackingChartDataManager _initializeDataManager() {
    if (widget.dataManager.groups.isNotEmpty) {
      return widget.dataManager;
    }
    List<MoodTracking> moodTrackings =
        DataManager().currentJournal.moodTrackings;

    for (var moodTracking in moodTrackings) {
      widget.dataManager.addGroup(
        moodTracking.name,
        MoodTrackingChartDataGroup.createGroup(moodTracking),
      );
    }
    return widget.dataManager;
  }

  @override
  Widget build(BuildContext context) {
    _initializeDataManager();

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
                        dataManager: widget.dataManager,
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

class MoodTrackingChart extends StatelessWidget {
  final MoodTrackingChartType type;
  final MoodTrackingChartDataManager dataManager;

  const MoodTrackingChart({
    super.key,
    required this.type,
    required this.dataManager,
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
            minY: dataManager.minY,
            maxY: dataManager.maxY,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: dataManager.interval,
                  //reservedSize: 40,
                  getTitlesWidget: (value, meta) {
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
                Utils.formatDayTitleForDashboardChart(
                  value.toInt(),
                  DataManager().moodTrackingDashboard.dateTime.weekday,
                  dataManager.dayCount,
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
                Utils.formateWeekTitleForDashboardChart(value.toInt()),
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
                Utils.formatMonthTitleForDashboardChart(
                  value.toInt(),
                  DataManager().moodTrackingDashboard.dateTime.month,
                  dataManager.monthCount,
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

  LineChartBarData _buildLineBarData(List<double> data, Color color) {
    return LineChartBarData(
      spots:
          data
              .asMap()
              .entries
              .map(
                (entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()),
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

  /// 构建 lineBarsData 的逻辑
  List<LineChartBarData> _buildLineBarsData(MoodTrackingChartType type) {
    List<LineChartBarData> ret = [];

    switch (type) {
      case MoodTrackingChartType.day:
        for (var dataGroup in dataManager.groups.values) {
          ret.add(_buildLineBarData(dataGroup.day, dataGroup.lineBarColor));
        }
        break;

      case MoodTrackingChartType.week:
        for (var dataGroup in dataManager.groups.values) {
          ret.add(_buildLineBarData(dataGroup.week, dataGroup.lineBarColor));
        }

        break;

      case MoodTrackingChartType.month:
        for (var dataGroup in dataManager.groups.values) {
          ret.add(_buildLineBarData(dataGroup.month, dataGroup.lineBarColor));
        }
        break;
    }
    return ret;
  }
}
