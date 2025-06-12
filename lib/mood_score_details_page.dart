import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class MoodScoreDetailsPage extends StatefulWidget {
  const MoodScoreDetailsPage({super.key});

  @override
  State<MoodScoreDetailsPage> createState() => _MoodScoreDetailsPageState();
}

class _MoodScoreDetailsPageState extends State<MoodScoreDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final double settingHeight = 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Score'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // 使用默认的AppBar背景色
      ),
      // 使用白色背景
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: settingHeight,
              child: SlidingLineChart(
                // 更改线条颜色为蓝色以适应浅色主题
                lineColor: Colors.blue,
                settingHeight: settingHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 滑动图表数据结构保持不变
class SlidingChartData {
  static final random = Random();
  static const double minY = 0;
  static const double maxY = 12;
  static List<double> yAxisLabels = [2.0, 4.0, 6.0, 8.0, 10.0];
  static const double unitWidth = 50.0;

  /// 生成的图表数据
  final DateTime date;
  final double? value;

  SlidingChartData({required this.date, this.value});

  static int daysToShow(DateTime startDate) {
    final lastYearSameDate = DateTime(
      startDate.year - 1,
      startDate.month,
      startDate.day,
    );
    final daysBetween = startDate.difference(lastYearSameDate).inDays;
    return daysBetween;
  }

  static List<SlidingChartData> generate(DateTime startDate) {
    final lastYearSameDate = DateTime(
      startDate.year - 1,
      startDate.month,
      startDate.day,
    );

    final daysBetween = startDate.difference(lastYearSameDate).inDays;
    final List<SlidingChartData> data = [];
    for (int i = 0; i <= daysBetween; i++) {
      final date = lastYearSameDate.add(Duration(days: i));
      data.add(SlidingChartData(date: date, value: genRandomValue(date)));
    }

    return data;
  }

  static double? genRandomValue(DateTime date) {
    if (random.nextDouble() < 0.1) {
      return null;
    }

    // 返回4～10之间的值
    double value = 4 + random.nextDouble() * 6;
    return value;
  }
}

class SlidingLineChart extends StatefulWidget {
  final Color lineColor;
  final double settingHeight;

  const SlidingLineChart({
    super.key,
    required this.settingHeight,
    this.lineColor = Colors.blue, // 默认颜色改为蓝色
  });

  @override
  State<SlidingLineChart> createState() => _SlidingLineChartState();
}

class _SlidingLineChartState extends State<SlidingLineChart> {
  late ScrollController _scrollController;
  late List<SlidingChartData> _chartData;

  double get chartWidth {
    return SlidingChartData.daysToShow(DateTime.now()) *
        SlidingChartData.unitWidth;
  }

  @override
  void initState() {
    super.initState();
    _chartData = SlidingChartData.generate(DateTime.now());
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minY = SlidingChartData.minY;
    final maxY = SlidingChartData.maxY;
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Container(
                  width: chartWidth,
                  height: widget.settingHeight,
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    bottom: 16,
                    right: 16,
                  ),
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: _chartData.length.toDouble() - 1,
                      minY: minY,
                      maxY: maxY,
                      lineTouchData: LineTouchData(enabled: false),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 2,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            // 修改网格线为浅灰色，使用withAlpha替代withOpacity
                            color: Colors.grey.withAlpha(77), // 约等于0.3的透明度
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= _chartData.length) {
                                return const SizedBox.shrink();
                              }

                              final date = _chartData[index].date;
                              final isToday = _isToday(date);

                              String weekday = DateFormat('E').format(date);
                              String dayMonth = DateFormat('d/M').format(date);

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  // 修改今日高亮背景为浅蓝色
                                  color:
                                      isToday
                                          ? Colors.blue.withAlpha(
                                            51,
                                          ) // 约等于0.2的透明度
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      weekday,
                                      style: TextStyle(
                                        // 修改文字颜色为黑色
                                        color:
                                            isToday
                                                ? Colors.blue.shade800
                                                : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      dayMonth,
                                      style: TextStyle(
                                        // 修改日期颜色为灰色
                                        color:
                                            isToday
                                                ? Colors.blue.shade600
                                                : Colors.grey.shade700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: _getLineChartBars(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              height: widget.settingHeight,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    bottom: 16.0 + 45.0,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerHeight = constraints.maxHeight;
                      final offsize = 17.0 / 2;
                      return Stack(
                        children: _buildAllYAxisLabels(
                          minY: minY,
                          maxY: maxY,
                          containerHeight: containerHeight,
                          offset: offsize,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Y轴标签修改
  Widget _buildYAxisLabel({
    required double value,
    required double minY,
    required double maxY,
    required double containerHeight,
    required double offset,
    required String text,
  }) {
    return Positioned(
      top: _calculateYPosition(value, minY, maxY, containerHeight) - offset,
      child: Text(
        text,
        // 修改Y轴标签为深灰色
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  List<Widget> _buildAllYAxisLabels({
    required double minY,
    required double maxY,
    required double containerHeight,
    required double offset,
  }) {
    // 可以根据需要自动计算间隔
    return SlidingChartData.yAxisLabels
        .map(
          (value) => _buildYAxisLabel(
            value: value,
            minY: minY,
            maxY: maxY,
            containerHeight: containerHeight,
            offset: offset,
            text: '${value.toInt()}',
          ),
        )
        .toList();
  }

  // 创建固定的Y轴刻度
  List<LineChartBarData> _getLineChartBars() {
    List<LineChartBarData> result = [];
    List<FlSpot> currentSegment = [];

    for (int i = 0; i < _chartData.length; i++) {
      if (_chartData[i].value != null) {
        // 有数据的点，添加到当前线段
        currentSegment.add(FlSpot(i.toDouble(), _chartData[i].value!));
      } else if (currentSegment.isNotEmpty) {
        // 遇到空值且当前线段不为空，结束当前线段
        result.add(_createLineChartBarData(currentSegment));
        currentSegment = [];
      }
    }

    // 添加最后一段线段(如果有)
    if (currentSegment.isNotEmpty) {
      result.add(_createLineChartBarData(currentSegment));
    }

    return result;
  }

  LineChartBarData _createLineChartBarData(List<FlSpot> spots) {
    return LineChartBarData(
      spots: List.from(spots),
      isCurved: true,
      barWidth: 3,
      color: widget.lineColor,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          int originalIndex = spot.x.toInt();
          final date = _chartData[originalIndex].date;
          final isToday = _isToday(date);

          return FlDotCirclePainter(
            radius: isToday ? 5 : 4,
            // 修改点的颜色为蓝色，配合线条颜色
            color: widget.lineColor,
            strokeColor: isToday ? Colors.blue.shade800 : Colors.transparent,
            strokeWidth: 2,
          );
        },
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // 计算刻度值在Y轴上的位置
  double _calculateYPosition(
    double value,
    double minY,
    double maxY,
    double containerHeight,
  ) {
    final double heightRatio = 1.0 - (value - minY) / (maxY - minY);
    return containerHeight * heightRatio;
  }
}
