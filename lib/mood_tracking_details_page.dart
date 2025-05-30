import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';
import 'package:nirva_app/data.dart';

enum MoodTrackingChartTab { day, week, month }

class MoodTrackingDetailsPage extends StatefulWidget {
  const MoodTrackingDetailsPage({super.key});

  @override
  State<MoodTrackingDetailsPage> createState() =>
      _MoodTrackingDetailsPageState();
}

class _MoodTrackingDetailsPageState extends State<MoodTrackingDetailsPage> {
  MoodTrackingChartTab _selectedType = MoodTrackingChartTab.day; // 默认选中类型

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
                        _buildTab('Day', MoodTrackingChartTab.day),
                        _buildTab('Week', MoodTrackingChartTab.week),
                        _buildTab('Month', MoodTrackingChartTab.month),
                      ],
                    ),
                    const SizedBox(height: 16 * 2),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: MoodTrackingChart(
                        type: _selectedType,
                        //dataManager: widget.dataManager,
                      ),
                    ),

                    // 添加间距
                    const SizedBox(height: 16),

                    // 添加图例
                    _buildLegend(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              AppRuntimeContext().data.currentDashboard.moodTracking.insights,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建按钮
  Widget _buildTab(String title, MoodTrackingChartTab type) {
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
                .moodTracking
                .moodTrackingMap
                .values
                .map((data) {
                  return Row(
                    mainAxisSize: MainAxisSize.min, // 设置为最小宽度
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(data.moodTracking.color),
                          shape: BoxShape.circle, // 使用圆形表示情绪类型
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.moodTracking.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                })
                .toList(),
      ),
    );
  }
}

class MoodTrackingChart extends StatelessWidget {
  static const double minY = 0; // 最小值
  static const double maxY = 100; // 最大值
  static const double interval = 25; // 刻度间隔
  static const dayCount = 7;
  static const monthCount = 5;
  final MoodTrackingChartTab type;

  const MoodTrackingChart({super.key, required this.type});

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
  SideTitles _buildBottomTitles(MoodTrackingChartTab type) {
    switch (type) {
      case MoodTrackingChartTab.day:
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
      case MoodTrackingChartTab.week:
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
      case MoodTrackingChartTab.month:
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
  List<LineChartBarData> _buildLineBarsData(MoodTrackingChartTab type) {
    List<LineChartBarData> ret = [];

    final moodTrackingMap =
        AppRuntimeContext().data.currentDashboard.moodTracking.moodTrackingMap;

    switch (type) {
      case MoodTrackingChartTab.day:
        for (var data in moodTrackingMap.values) {
          ret.add(_buildLineBarData(data.day, Color(data.moodTracking.color)));
        }
        break;

      case MoodTrackingChartTab.week:
        for (var data in moodTrackingMap.values) {
          ret.add(_buildLineBarData(data.week, Color(data.moodTracking.color)));
        }

        break;

      case MoodTrackingChartTab.month:
        for (var data in moodTrackingMap.values) {
          ret.add(
            _buildLineBarData(data.month, Color(data.moodTracking.color)),
          );
        }
        break;
    }
    return ret;
  }
}
