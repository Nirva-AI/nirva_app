import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';

enum EnergyLevelChartTab { day, week, month }

class EnergyLevelDetailsPage extends StatefulWidget {
  const EnergyLevelDetailsPage({super.key});

  @override
  State<EnergyLevelDetailsPage> createState() => _EnergyLevelDetailsPageState();
}

class _EnergyLevelDetailsPageState extends State<EnergyLevelDetailsPage> {
  EnergyLevelChartTab _selectedType = EnergyLevelChartTab.day; // 默认选中类型

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
                        _buildTab('Day', EnergyLevelChartTab.day),
                        _buildTab('Week', EnergyLevelChartTab.week),
                        _buildTab('Month', EnergyLevelChartTab.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Energy Level
                    Center(
                      child: Text(
                        _getScore(
                          _selectedType,
                          AppRuntimeContext()
                              .data
                              .currentDashboard
                              .energyLevel
                              .scores,
                        ).toString(),
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
                      child: EnergyLevelChart(type: _selectedType),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              AppRuntimeContext().data.currentDashboard.energyLevel.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  double _getScore(EnergyLevelChartTab type, List<double> scores) {
    if (scores.length != 3) {
      return 0; // 如果分数列表长度不正确，返回 0
    }
    return switch (type) {
      EnergyLevelChartTab.day => scores[0],
      EnergyLevelChartTab.week => scores[1],
      EnergyLevelChartTab.month => scores[2],
    };
  }

  /// 构建按钮
  Widget _buildTab(String title, EnergyLevelChartTab type) {
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
  static const double _minY = 0; // 最小值
  static const double _maxY = 10; // 最大值
  static const double _interval = 2; // 刻度间隔

  final EnergyLevelChartTab type;

  const EnergyLevelChart({super.key, required this.type});

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
  SideTitles _buildBottomTitles(EnergyLevelChartTab type) {
    switch (type) {
      case EnergyLevelChartTab.day:
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
                  AppRuntimeContext().data.currentDashboard.dateTime.weekday,
                  AppRuntimeContext()
                      .data
                      .currentDashboard
                      .energyLevel
                      .day
                      .length,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case EnergyLevelChartTab.week:
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
      case EnergyLevelChartTab.month:
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
                  AppRuntimeContext().data.currentDashboard.dateTime.month,
                  AppRuntimeContext()
                      .data
                      .currentDashboard
                      .energyLevel
                      .month
                      .length,
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
  List<LineChartBarData> _buildLineBarsData(EnergyLevelChartTab type) {
    // 选择颜色和数据
    Color lineColor;
    List<double> data;

    switch (type) {
      case EnergyLevelChartTab.day:
        lineColor = Colors.purple;
        data = AppRuntimeContext().data.currentDashboard.energyLevel.day;
        break;
      case EnergyLevelChartTab.week:
        lineColor = Colors.blue;
        data = AppRuntimeContext().data.currentDashboard.energyLevel.week;
        break;
      case EnergyLevelChartTab.month:
        lineColor = Colors.green;
        data = AppRuntimeContext().data.currentDashboard.energyLevel.month;
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
