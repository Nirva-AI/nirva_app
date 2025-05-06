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
                        showTitles: false, // 隐藏底部的数字刻度
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
                        FlSpot(0, 0), // 修改为从 0 开始
                        FlSpot(1, 1),
                        FlSpot(2, 0.5),
                        FlSpot(3, 2.8),
                        FlSpot(4, 2),
                        FlSpot(5, 3),
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
