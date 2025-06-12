import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SlidingChartData {
  static final random = Random();
  static const double minY = 0;
  static const double maxY = 12;
  static List<double> yAxisLabels = [2.0, 4.0, 6.0, 8.0, 10.0];
  static const double unitWidth = 50.0;

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
    return (6 + (date.day % 5) + (date.day % 2 == 0 ? 0.5 : 0.0));
  }
}

class SlidingLineChart extends StatefulWidget {
  final Color lineColor;

  const SlidingLineChart({super.key, this.lineColor = Colors.white});

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
                  height: 300,
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
                            color: Color.fromRGBO(255, 255, 255, 0.2),
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
                            interval: 1, // 确保每个数据点之间有固定间隔
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= _chartData.length) {
                                return const SizedBox.shrink();
                              }

                              final date = _chartData[index].date;
                              final isToday = _isToday(date);

                              // 获取星期几的简写
                              String weekday = DateFormat('E').format(date);
                              // 添加日期信息，更清晰地识别不同日期
                              String dayMonth = DateFormat('d/M').format(date);

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isToday
                                          ? Colors.white
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      weekday,
                                      style: TextStyle(
                                        color:
                                            isToday
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      dayMonth,
                                      style: TextStyle(
                                        color:
                                            isToday
                                                ? Colors.black
                                                : Colors.white70,
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
              height: 300,
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

  // 封装创建Y轴刻度标签的方法
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
        style: const TextStyle(color: Colors.white70, fontSize: 12),
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
            text: '${value.toInt()}h',
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
      spots: List.from(spots), // 创建副本避免引用问题
      isCurved: true,
      barWidth: 3,
      color: widget.lineColor,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          // 找到对应原始数据的索引
          int originalIndex = spot.x.toInt();
          final date = _chartData[originalIndex].date;
          final isToday = _isToday(date);

          return FlDotCirclePainter(
            radius: isToday ? 4 : 4,
            color: Colors.white,
            strokeColor: isToday ? Colors.white : Colors.transparent,
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

class TestChartApp extends StatelessWidget {
  const TestChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TestChartPage(),
    );
  }
}

class TestChartPage extends StatefulWidget {
  const TestChartPage({super.key});

  @override
  State<TestChartPage> createState() => _TestChartPageState();
}

class _TestChartPageState extends State<TestChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliding Chart'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: SlidingLineChart(lineColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
