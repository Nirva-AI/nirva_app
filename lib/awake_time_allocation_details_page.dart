import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';

class AwakeTimeAllocationDetailsPage extends StatefulWidget {
  const AwakeTimeAllocationDetailsPage({super.key});

  @override
  State<AwakeTimeAllocationDetailsPage> createState() =>
      _AwakeTimeAllocationDetailsPageState();
}

class _AwakeTimeAllocationDetailsPageState
    extends State<AwakeTimeAllocationDetailsPage> {
  String? selectedActionType;

  @override
  Widget build(BuildContext context) {
    final double settingHeight = 300;
    final double unitWidth = 50; // 每个数据点的宽度

    return Scaffold(
      appBar: AppBar(
        title: const Text('Awake Time Allocation'),
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
                // 传递选中的情绪类型
                selectedActionType: selectedActionType,
                lineColor: Colors.blue,
                settingHeight: settingHeight,
                unitWidth: unitWidth,
              ),
            ),
            // 添加一个标题
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Action Types',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // 添加清除选择按钮
                  if (selectedActionType != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedActionType = null; // 清除选择
                        });
                      },
                      child: const Text('Clear Selection'),
                    ),
                ],
              ),
            ),
            // 添加情绪类型列表
            Expanded(
              child: ListView.builder(
                itemCount: AwakeTimeAllocation.activityNames.length,
                itemBuilder: (context, index) {
                  String actionType = AwakeTimeAllocation.activityNames[index];

                  Color actionColor = Color(
                    AwakeTimeAllocation(name: actionType, minutes: 0).color,
                  );

                  // 检查当前项是否被选中
                  bool isSelected = selectedActionType == actionType;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // 如果被选中添加背景色 - 修复withOpacity弃用警告
                        color:
                            isSelected
                                ? Colors.blue.withAlpha(26)
                                : null, // 26约等于0.1的透明度
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          // 添加颜色指示器
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: actionColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 情绪类型名称
                          Expanded(
                            child: Text(
                              actionType,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          // View按钮
                          ElevatedButton(
                            onPressed: () {
                              // 记录选择的情绪类型并刷新页面
                              setState(() {
                                selectedActionType = actionType;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              // 如果被选中则使用不同的样式
                              backgroundColor: isSelected ? Colors.blue : null,
                              foregroundColor: isSelected ? Colors.white : null,
                            ),
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlidingLineChart extends StatefulWidget {
  final Color lineColor;
  final double settingHeight;
  final double unitWidth;
  // 添加选中的情绪类型参数
  final String? selectedActionType;

  const SlidingLineChart({
    super.key,
    required this.settingHeight,
    required this.unitWidth,
    this.lineColor = Colors.blue,
    this.selectedActionType, // 添加这个参数接收选中的情绪类型
  });

  @override
  State<SlidingLineChart> createState() => _SlidingLineChartState();
}

class _SlidingLineChartState extends State<SlidingLineChart> {
  late ScrollController _scrollController;
  late List<Dashboard> _chartData;

  double get chartWidth {
    return AppRuntimeContext().dashboards.length * widget.unitWidth;
  }

  @override
  void initState() {
    super.initState();
    _chartData = AppRuntimeContext().dashboards;
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
    final minY = Dashboard.awakeTimeAllocationMinY;
    final maxY = Dashboard.awakeTimeAllocationMaxY;
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
                  child:
                      widget.selectedActionType == null
                          ? const Center(
                            child: Text(
                              'Please select a action type to view data',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                          : LineChart(
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
                                    color: Colors.grey.withAlpha(77),
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
                                      if (index < 0 ||
                                          index >= _chartData.length) {
                                        return const SizedBox.shrink();
                                      }

                                      final date = _chartData[index].dateTime;
                                      final isToday = _isToday(date);

                                      String weekday = DateFormat(
                                        'E',
                                      ).format(date);
                                      String dayMonth = DateFormat(
                                        'd/M',
                                      ).format(date);

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isToday
                                                  ? Colors.blue.withAlpha(51)
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              weekday,
                                              style: TextStyle(
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
    return Dashboard.awakeTimeAllocationYAxisLabels
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

  // 创建固定的Y轴刻度 - 修改为基于选中的情绪类型
  List<LineChartBarData> _getLineChartBars() {
    // 如果没有选中情绪类型，返回空列表
    if (widget.selectedActionType == null) {
      return [];
    }

    List<LineChartBarData> result = [];
    List<FlSpot> currentSegment = [];

    for (int i = 0; i < _chartData.length; i++) {
      // 使用所选的情绪类型获取比例值
      final awakeTimeAllocationMinutes = _chartData[i]
          .getAwakeTimeAllocationMinutes(widget.selectedActionType!);

      if (awakeTimeAllocationMinutes != null) {
        final awakeTimeAllocationHours = awakeTimeAllocationMinutes / 60.0;
        // 有数据的点，添加到当前线段
        currentSegment.add(FlSpot(i.toDouble(), awakeTimeAllocationHours));
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
    // 如果有选中的情绪类型，使用对应的颜色
    Color lineColor =
        widget.selectedActionType != null
            ? Color(
              AwakeTimeAllocation(
                name: widget.selectedActionType!,
                minutes: 0,
              ).color,
            )
            : widget.lineColor;

    return LineChartBarData(
      spots: List.from(spots),
      isCurved: true,
      barWidth: 3,
      color: lineColor,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          int originalIndex = spot.x.toInt();
          final date = _chartData[originalIndex].dateTime;
          final isToday = _isToday(date);

          return FlDotCirclePainter(
            radius: isToday ? 5 : 4,
            color: lineColor,
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
