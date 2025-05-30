import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';
import 'package:nirva_app/data.dart';

enum AwakeTimeChartTab { day, week, month }

class AwakeTimeAllocationDetailsPage extends StatefulWidget {
  const AwakeTimeAllocationDetailsPage({super.key});

  @override
  State<AwakeTimeAllocationDetailsPage> createState() =>
      _AwakeTimeAllocationDetailsPageState();
}

class _AwakeTimeAllocationDetailsPageState
    extends State<AwakeTimeAllocationDetailsPage> {
  AwakeTimeChartTab _selectedType = AwakeTimeChartTab.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awake Time Allocation'),
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
            // 包裹 TabBar 和折线图的 Card
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
                        _buildTab('Day', AwakeTimeChartTab.day),
                        _buildTab('Week', AwakeTimeChartTab.week),
                        _buildTab('Month', AwakeTimeChartTab.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: AwakeTimeChart(
                        type: _selectedType,
                        //dataManager: widget.dataManager,
                      ),
                    ),

                    const SizedBox(height: 16),
                    // 图例说明
                    _buildLegend(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              AppRuntimeContext()
                  .data
                  .currentDashboard
                  .awakeTimeAllocation
                  .insights,
            ),
          ],
        ),
      ),
    );
  }

  // 构建图例
  Widget _buildLegend() {
    return Center(
      // 添加Center容器使整体居中
      child: Wrap(
        alignment: WrapAlignment.center, // 设置Wrap的内部对齐方式为居中
        spacing: 16,
        runSpacing: 8,
        children:
            AppRuntimeContext()
                .data
                .currentDashboard
                .awakeTimeAllocation
                .awakeTimeAllocationMap
                .values
                .map((data) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(data.awakeTimeAllocation.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.awakeTimeAllocation.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                })
                .toList(),
      ),
    );
  }

  /// 构建按钮
  Widget _buildTab(String title, AwakeTimeChartTab type) {
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

class AwakeTimeChart extends StatelessWidget {
  static const double minY = 0; // 最小值
  static const double maxY = 10; // 最大值，假设清醒时间最多10小时
  static const double interval = 2; // 刻度间隔
  static const dayCount = 7;
  static const monthCount = 5;

  final AwakeTimeChartTab type;

  const AwakeTimeChart({super.key, required this.type});

  List<double> get yAxisValues {
    return List.generate(
      ((maxY - minY) / interval).toInt() + 1,
      (index) => minY + index * interval,
    );
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
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval,
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
  SideTitles _buildBottomTitles(AwakeTimeChartTab type) {
    switch (type) {
      case AwakeTimeChartTab.day:
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
                  dayCount,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case AwakeTimeChartTab.week:
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
      case AwakeTimeChartTab.month:
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
                  monthCount,
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
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
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
  List<LineChartBarData> _buildLineBarsData(AwakeTimeChartTab type) {
    List<LineChartBarData> ret = [];

    final awakeTimeAllocationMap =
        AppRuntimeContext()
            .data
            .currentDashboard
            .awakeTimeAllocation
            .awakeTimeAllocationMap;

    switch (type) {
      case AwakeTimeChartTab.day:
        for (var dataGroup in awakeTimeAllocationMap.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.day,
              Color(dataGroup.awakeTimeAllocation.color),
            ),
          );
        }
        break;

      case AwakeTimeChartTab.week:
        for (var dataGroup in awakeTimeAllocationMap.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.week,
              Color(dataGroup.awakeTimeAllocation.color),
            ),
          );
        }
        break;

      case AwakeTimeChartTab.month:
        for (var dataGroup in awakeTimeAllocationMap.values) {
          ret.add(
            _buildLineBarData(
              dataGroup.month,
              Color(dataGroup.awakeTimeAllocation.color),
            ),
          );
        }
        break;
    }
    return ret;
  }
}
