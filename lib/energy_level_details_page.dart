import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

enum EnergyLevelChartType { day, week, month }

// 数据管理器
class EnergyLevelChartDataManager {
  final double minY = 0; // 最小值
  final double maxY = 10; // 最大值
  final double interval = 2; // 刻度间隔

  final List<double> day;
  final List<double> week;
  final List<double> month;

  EnergyLevelChartDataManager({
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

  double getScore(EnergyLevelChartType type) {
    // 解析分数的逻辑
    if (type == EnergyLevelChartType.day) {
      return 8.3;
    } else if (type == EnergyLevelChartType.week) {
      return 8.1;
    } else if (type == EnergyLevelChartType.month) {
      return 8.0;
    }
    return 0.0; // 默认值
  }
}

class EnergyLevelDetailsPage extends StatefulWidget {
  EnergyLevelDetailsPage({super.key});

  final EnergyLevelChartDataManager dataManager = EnergyLevelChartDataManager(
    day: [7.0, 6.0, 8.0, 7.0, 7.0, 6.0, 8.3],
    week: [6.8, 7.2, 7.5, 7.9],
    month: [6.2, 6.7, 7.3, 7.8, 8.1],
  );

  @override
  State<EnergyLevelDetailsPage> createState() => _EnergyLevelDetailsPageState();
}

class _EnergyLevelDetailsPageState extends State<EnergyLevelDetailsPage> {
  EnergyLevelChartType _selectedType = EnergyLevelChartType.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Level'),
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
            // 包裹 TabBar、Energy Level 和折线图的 Card
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
                        _buildTab('Day', EnergyLevelChartType.day),
                        _buildTab('Week', EnergyLevelChartType.week),
                        _buildTab('Month', EnergyLevelChartType.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Energy Level
                    Center(
                      child: Text(
                        widget.dataManager.getScore(_selectedType).toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: EnergyLevelChart(
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
              DataManager().energyLevelDashboard.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  /// 构建按钮
  Widget _buildTab(String title, EnergyLevelChartType type) {
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

class EnergyLevelChart extends StatelessWidget {
  final EnergyLevelChartType type;
  final EnergyLevelChartDataManager dataManager;

  const EnergyLevelChart({
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
                  reservedSize: 40,
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
  SideTitles _buildBottomTitles(EnergyLevelChartType type) {
    switch (type) {
      case EnergyLevelChartType.day:
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
                  DataManager().energyLevelDashboard.dateTime.weekday,
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
      case EnergyLevelChartType.week:
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
      case EnergyLevelChartType.month:
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
                  DataManager().energyLevelDashboard.dateTime.month,
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
  List<LineChartBarData> _buildLineBarsData(EnergyLevelChartType type) {
    // 选择颜色和数据
    Color lineColor;
    List<double> data;

    switch (type) {
      case EnergyLevelChartType.day:
        lineColor = Colors.purple;
        data = dataManager.day;
        break;
      case EnergyLevelChartType.week:
        lineColor = Colors.blue;
        data = dataManager.week;
        break;
      case EnergyLevelChartType.month:
        lineColor = Colors.green;
        data = dataManager.month;
        break;
    }

    return [
      LineChartBarData(
        spots:
            data
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
        isCurved: true,
        color: lineColor,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: true),
      ),
    ];
  }
}
