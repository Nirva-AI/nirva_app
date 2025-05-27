import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

enum MoodScoreChartType { day, week, month }

// 数据管理器
class MoodScoreChartDataManager {
  final double minY = 40; // 最小值
  final double maxY = 100; // 最大值
  final double interval = 20; // 刻度间隔

  final List<double> day;
  final List<double> week;
  final List<double> month;

  MoodScoreChartDataManager({
    required this.day,
    required this.week,
    required this.month,
  }) {
    assert(day.length == 7, 'Day data should have 7 values');
    assert(week.length == 4, 'Week data should have 4 values');
    assert(month.length == 5, 'Month data should have 5 values');
  }

  List<double> get yAxisValues {
    return List.generate(
      ((maxY - minY) / interval).toInt() + 1,
      (index) => minY + index * interval,
    );
  }

  String convertYValueToString(double value) {
    if (yAxisValues.contains(value)) {
      return value.toInt().toString();
    }
    return '';
  }

  double getScore(MoodScoreChartType type) {
    // 解析分数的逻辑
    if (type == MoodScoreChartType.day) {
      return 83; // 示例分数
    } else if (type == MoodScoreChartType.week) {
      return 85; // 示例分数
    } else if (type == MoodScoreChartType.month) {
      return 85; // 示例分数
    }
    return 0; // 默认值
  }
}

class MoodScoreDetailsPage extends StatefulWidget {
  MoodScoreDetailsPage({super.key});

  final MoodScoreChartDataManager dataManager = MoodScoreChartDataManager(
    day: [81, 85, 76, 82, 80, 85, 83],
    week: [78, 82, 79, 85],
    month: [70, 78, 80, 82, 85],
  );

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
                    Center(
                      child: Text(
                        widget.dataManager
                            .getScore(_selectedType)
                            .toInt()
                            .toString(),
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
                        dataManager: widget.dataManager,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              DataManager().moodScoreDashboard.insights,
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

class MoodScoreChart extends StatelessWidget {
  final MoodScoreChartType type;
  final MoodScoreChartDataManager dataManager;

  const MoodScoreChart({
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
            minY: dataManager.minY, // 修改最小值为 40
            maxY: dataManager.maxY, // 最大值保持为 100
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, // 确保左侧标题显示
                  interval: dataManager.interval, // 设置刻度间隔为 20
                  reservedSize: 40, // 增加刻度区域的宽度
                  getTitlesWidget: (value, meta) {
                    var valueToString = dataManager.convertYValueToString(
                      value,
                    );
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
                Utils.formatDayTitleForDashboardChart(
                  value.toInt(),
                  DataManager().currentDashboard.dateTime.weekday,
                  dataManager.day.length,
                ),
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
                Utils.formateWeekTitleForDashboardChart(value.toInt()),
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
                Utils.formatMonthTitleForDashboardChart(
                  value.toInt(),
                  DataManager().currentDashboard.dateTime.month,
                  dataManager.month.length,
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
  List<LineChartBarData> _buildLineBarsData(MoodScoreChartType type) {
    switch (type) {
      case MoodScoreChartType.day:
        return [
          LineChartBarData(
            spots:
                dataManager.day
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.toDouble()),
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
        return [
          LineChartBarData(
            spots:
                dataManager.week
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.toDouble()),
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
                dataManager.month
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          FlSpot(entry.key.toDouble(), entry.value.toDouble()),
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
}
