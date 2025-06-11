import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _chartData = List.from(widget.initialData);
    _scrollController = ScrollController();

    // 计算图表宽度，每天分配一个固定宽度
    _chartWidth = widget.daysToShow * 60.0; // 每天60逻辑像素宽度

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
    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent + 20) {
      // 加载更多历史数据
      setState(() {
        final oldestDate = _chartData.first.date;
        List<SlidingChartData> moreData = [];

        // 添加更多历史数据
        for (int i = 1; i <= 7; i++) {
          final newDate = oldestDate.subtract(Duration(days: i));

          // 在实际应用中，这里应该从真实数据源获取数据
          // 这里仅为演示创建随机数据
          moreData.add(
            SlidingChartData(
              date: newDate,
              value: 4 + (DateTime.now().millisecond % 5),
            ),
          );
        }

        _chartData.insertAll(0, moreData.reversed.toList());
        _chartWidth += 7 * 60.0; // 为新添加的7天增加宽度
      });

      // 使用微任务确保在状态更新后调整滚动位置
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.pixels + 7 * 60.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
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
                    showTitles: true,
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
                    reservedSize: 45, // 从32增加到45
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= _chartData.length) {
                        return const SizedBox.shrink();
                      }

                      final date = _chartData[index].date;
                      final isToday = _isToday(date);

                      // 获取星期几的简写
                      String weekday = DateFormat('E').format(date);

                      // 添加简单的小图标（可以根据需求进一步定制）
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
                            Icon(
                              Icons.label,
                              color: isToday ? Colors.black : Colors.white,
                              size: 16,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              weekday,
                              style: TextStyle(
                                color: isToday ? Colors.black : Colors.white,
                                fontSize: 12,
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
  List<SlidingChartData> _generateTestData() {
    final now = DateTime.now();
    final List<SlidingChartData> data = [];

    // 生成包含今天在内的过去14天数据
    for (int i = 13; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      // 生成一些模拟的睡眠数据 (6-10小时范围内的随机值)
      final sleepHours = 6.0 + (date.day % 5) + (date.day % 2 == 0 ? 0.5 : 0.0);

      data.add(SlidingChartData(date: date, value: sleepHours));
    }

    return data;
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
                initialData: _generateTestData(),
                lineColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
