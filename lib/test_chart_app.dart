import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SlidingChartData {
  static final random = Random();
  final DateTime date;
  final double? value; // 修改为可空类型

  SlidingChartData({required this.date, this.value});

  static int daysToShow(DateTime startDate) {
    // 计算去年同月同日的日期
    final lastYearSameDate = DateTime(
      startDate.year - 1,
      startDate.month,
      startDate.day,
    );

    // 计算从去年同日到今天的天数
    final daysBetween = startDate.difference(lastYearSameDate).inDays;
    return daysBetween;
  }

  // 生成数据的大列表
  static List<SlidingChartData> generate(DateTime startDate) {
    // 计算去年同月同日的日期
    final lastYearSameDate = DateTime(
      startDate.year - 1,
      startDate.month,
      startDate.day,
    );

    // 计算从去年同日到今天的天数
    final daysBetween = startDate.difference(lastYearSameDate).inDays;

    final List<SlidingChartData> data = [];

    // 从去年同日开始，生成每一天的数据
    for (int i = 0; i <= daysBetween; i++) {
      final date = lastYearSameDate.add(Duration(days: i));
      data.add(SlidingChartData(date: date, value: genRandomValue(date)));
    }

    return data;
  }

  static double? genRandomValue(DateTime date) {
    if (random.nextDouble() < 0.1) {
      return null; // 模拟数据缺失
    }
    return (6 + (date.day % 5) + (date.day % 2 == 0 ? 0.5 : 0.0));
  }
}

class SlidingLineChart extends StatefulWidget {
  final List<SlidingChartData> initialData;
  final double minY;
  final double maxY;
  final Color lineColor;

  const SlidingLineChart({
    super.key,
    required this.initialData,
    this.minY = 0,
    this.maxY = 12, // 假设最大值为12小时
    this.lineColor = Colors.white,
  });

  @override
  State<SlidingLineChart> createState() => _SlidingLineChartState();
}

class _SlidingLineChartState extends State<SlidingLineChart> {
  late ScrollController _scrollController;
  late List<SlidingChartData> _chartData;
  static const double _defaultChartWidth = 50.0; // 每天的默认宽度

  double get chartWidth {
    return SlidingChartData.daysToShow(DateTime.now()) *
        _defaultChartWidth; // 每天60逻辑像素宽度
  }

  @override
  void initState() {
    super.initState();
    _chartData = List.from(widget.initialData);
    _scrollController = ScrollController();
    // 在初始化后滚动到最右侧（最新数据）
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
    return Stack(
      children: [
        // 使用Row来分配空间
        Row(
          children: [
            // 左侧滚动区域
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
                      minY: widget.minY,
                      maxY: widget.maxY,
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
                        // 启用右侧刻度并设置显示逻辑
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              // 只显示0,2,4,6,8,10,12这些刻度值
                              if (value % 2 == 0 && value >= 0 && value <= 12) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
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
                      lineBarsData:
                          _getLineChartBars(), // 正确位置在这里，作为LineChartData的直接属性
                    ),
                  ),
                ),
              ),
            ),
            //右侧预留固定宽度区域
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
                        children: [
                          // 刻度值 10
                          Positioned(
                            top:
                                _calculateYPosition(
                                  10,
                                  widget.minY,
                                  widget.maxY,
                                  containerHeight,
                                ) -
                                offsize,
                            child: const Text(
                              '10h',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // 刻度值 8
                          Positioned(
                            top:
                                _calculateYPosition(
                                  8,
                                  widget.minY,
                                  widget.maxY,
                                  containerHeight,
                                ) -
                                offsize,
                            child: const Text(
                              '8h',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // 刻度值 6
                          Positioned(
                            top:
                                _calculateYPosition(
                                  6,
                                  widget.minY,
                                  widget.maxY,
                                  containerHeight,
                                ) -
                                offsize,
                            child: const Text(
                              '6h',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // 刻度值 4
                          Positioned(
                            top:
                                _calculateYPosition(
                                  4,
                                  widget.minY,
                                  widget.maxY,
                                  containerHeight,
                                ) -
                                offsize,
                            child: const Text(
                              '4h',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // 刻度值 2
                          Positioned(
                            top:
                                _calculateYPosition(
                                  2,
                                  widget.minY,
                                  widget.maxY,
                                  containerHeight,
                                ) -
                                offsize,
                            child: const Text(
                              '2h',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                      //);
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
    // 反转Y轴映射(因为Flutter绘制坐标是从上到下)
    final double heightRatio = 1.0 - (value - minY) / (maxY - minY);
    // 计算位置
    return containerHeight * heightRatio; // 减去17是为了调整文本位置，使其居中
  }
}

class TestChartApp extends StatelessWidget {
  const TestChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: '测试图表',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black, // 深色背景
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
  // 生成测试数据
  List<SlidingChartData> _initTestData() {
    final samples = SlidingChartData.generate(DateTime.now());
    return samples;
  }

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
              child: SlidingLineChart(
                initialData: _initTestData(),
                lineColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
