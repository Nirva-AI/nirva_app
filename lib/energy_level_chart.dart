import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 用于绘制图表

class EnergyLevelChart extends StatelessWidget {
  const EnergyLevelChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy Level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0, // 设置 Y 轴的最小值
                  maxY: 4, // 设置 Y 轴的最大值
                  minX: 0, // 设置 X 轴的最小值
                  maxX: 9, // 设置 X 轴的最大值（对应 9 个时间点）
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine:
                        (value) => FlLine(
                          color: Colors.grey.withAlpha(
                            51,
                          ), // 替换 withOpacity(0.2)
                          strokeWidth: 1,
                        ),
                    getDrawingVerticalLine:
                        (value) => FlLine(
                          color: Colors.grey.withAlpha(
                            51,
                          ), // 替换 withOpacity(0.2)
                          strokeWidth: 1,
                        ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, // 保留左侧的自定义标签
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // 根据刻度值映射标签
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Low-',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 1:
                              return const Text(
                                'Low',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 2:
                              return const Text(
                                'Neutral',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 3:
                              return const Text(
                                'High',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 4:
                              return const Text(
                                'High+',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            default:
                              return const SizedBox.shrink(); // 对未定义的值返回空
                          }
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, // 显示底部的时间序列
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // 根据 X 值映射时间标签
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                '10:00',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 1:
                              return const Text(
                                '10:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 2:
                              return const Text(
                                '11:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 3:
                              return const Text(
                                '13:00',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 4:
                              return const Text(
                                '13:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 5:
                              return const Text(
                                '14:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 6:
                              return const Text(
                                '15:10',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 7:
                              return const Text(
                                '16:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 8:
                              return const Text(
                                '18:30',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            case 9:
                              return const Text(
                                '19:00',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // 隐藏顶部的数字刻度
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // 隐藏右侧的数字刻度
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withAlpha(128), // 替换 withOpacity(0.5)
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1), // 对应 10:00
                        FlSpot(1, 2), // 对应 10:30
                        FlSpot(2, 1.5), // 对应 11:30
                        FlSpot(3, 2.8), // 对应 13:00
                        FlSpot(4, 2), // 对应 13:30
                        FlSpot(5, 3), // 对应 14:30
                        FlSpot(6, 1.5), // 对应 15:10
                        FlSpot(7, 2.5), // 对应 16:30
                        FlSpot(8, 3.2), // 对应 18:30
                        FlSpot(9, 2.8), // 对应 19:00
                      ],
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.purple,
                                  strokeWidth: 0,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
