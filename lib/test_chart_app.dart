import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SlidingLineChart extends StatefulWidget {
  final List<SlidingChartData> initialData;
  final int daysToShow; // 初始显示的天数
  final double minY;
  final double maxY;
  final Color lineColor;

  const SlidingLineChart({
    super.key,
    required this.initialData,
    this.daysToShow = 14, // 默认显示两周数据
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
  late double _chartWidth;

  static const double _defaultChartWidth = 45.0; // 每天的默认宽度

  @override
  void initState() {
    super.initState();
    _chartData = List.from(widget.initialData);
    _scrollController = ScrollController();

    // 计算图表宽度，每天分配一个固定宽度
    _chartWidth = widget.daysToShow * _defaultChartWidth; // 每天60逻辑像素宽度

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

  // 当滚动到左侧边缘时加载更多历史数据
  void _onScrollUpdate() {
    // 当滚动接近左侧边缘时加载更多数据（距离左侧边缘20像素内）
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 20) {
      // 加载更多历史数据
      setState(() {
        final oldestDate = _chartData.first.date;
        List<SlidingChartData> moreData =
            SlidingChartData.generateSlidingChartSamples(oldestDate, 7);
        _chartData.insertAll(0, moreData.toList());
        _chartWidth += 7 * _defaultChartWidth; // 为新添加的7天增加宽度
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _onScrollUpdate();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: _chartWidth,
          height: 300,
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: _chartData.length.toDouble() - 1,
              minY: widget.minY,
              maxY: widget.maxY,
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
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value % 2 == 0) {
                        return Text(
                          '${value.toInt()}h',
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

                      // 可以选择每几个数据点显示一个标签
                      // if (index % 2 != 0) {
                      //   // 仅显示偶数索引的标签
                      //   return const SizedBox.shrink();
                      // }

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
                          color: isToday ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Text(
                              weekday,
                              style: TextStyle(
                                color: isToday ? Colors.black : Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              dayMonth,
                              style: TextStyle(
                                color: isToday ? Colors.black : Colors.white70,
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
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(),
                  isCurved: true,
                  barWidth: 2,
                  color: widget.lineColor,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      // 找出这个点对应的日期
                      final date = _chartData[index].date;
                      final isToday = _isToday(date);

                      return FlDotCirclePainter(
                        radius: isToday ? 8 : 4,
                        color: Colors.white,
                        strokeColor:
                            isToday ? Colors.white : Colors.transparent,
                        strokeWidth: 2,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    // 透明度方案二 (如果上面的方案不适用)
                    color: Color.fromARGB(
                      (0.2 * 255).toInt(), // alpha (透明度)
                      255,
                      255,
                      255, // RGB
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    return _chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class SlidingChartData {
  final DateTime date;
  final double value;

  SlidingChartData({required this.date, required this.value});

  // 生成测试数据
  static List<SlidingChartData> generateSlidingChartSamples(
    DateTime startDate,
    int days,
  ) {
    final now = startDate;
    final List<SlidingChartData> data = [];

    // 生成包含今天在内的过去14天数据
    for (int i = days; i > 0; i--) {
      final date = now.subtract(Duration(days: i));

      // 生成一些模拟的睡眠数据 (6-10小时范围内的随机值)
      final sleepHours = 6.0 + (date.day % 5) + (date.day % 2 == 0 ? 0.5 : 0.0);

      data.add(SlidingChartData(date: date, value: sleepHours));
    }

    return data;
  }
}

class TestChartApp extends StatelessWidget {
  const TestChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试图表',
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
    final now = DateTime.now();
    final todayData = SlidingChartData(
      date: now,
      value: 7.5, // 假设今天的睡眠时间为7.5小时
    );
    final last7daysData = SlidingChartData.generateSlidingChartSamples(now, 7);
    return last7daysData + [todayData];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠时间图表'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '睡眠时间趋势',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '过去两周的睡眠数据',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
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
