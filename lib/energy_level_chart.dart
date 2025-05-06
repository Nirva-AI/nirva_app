import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 用于绘制图表

class EnergyData {
  final DateTime dateTime; // 标准时间格式
  final double energyLevel; // 能量值，例如 1.0

  EnergyData({required this.dateTime, required this.energyLevel});

  // 动态生成时间字符串，仅输出时间部分
  String get time =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

final List<EnergyData> energyDataList = [
  EnergyData(dateTime: DateTime(2025, 5, 6, 10, 0), energyLevel: 1.0),
  EnergyData(dateTime: DateTime(2025, 5, 6, 10, 30), energyLevel: 2.0),
  EnergyData(dateTime: DateTime(2025, 5, 6, 11, 30), energyLevel: 1.5),
  EnergyData(dateTime: DateTime(2025, 5, 6, 13, 0), energyLevel: 2.8),
  EnergyData(dateTime: DateTime(2025, 5, 6, 13, 30), energyLevel: 2.0),
  EnergyData(dateTime: DateTime(2025, 5, 6, 14, 30), energyLevel: 3.0),
  EnergyData(dateTime: DateTime(2025, 5, 6, 15, 10), energyLevel: 1.5),
  EnergyData(dateTime: DateTime(2025, 5, 6, 16, 30), energyLevel: 2.5),
  EnergyData(dateTime: DateTime(2025, 5, 6, 18, 30), energyLevel: 3.2),
  EnergyData(dateTime: DateTime(2025, 5, 6, 19, 0), energyLevel: 2.8),
];

class EnergyLevelChart extends StatelessWidget {
  const EnergyLevelChart({super.key});

  // 生成图表数据点
  List<FlSpot> generateSpots(List<EnergyData> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      EnergyData energy = entry.value;
      return FlSpot(index.toDouble(), energy.energyLevel);
    }).toList();
  }

  // 生成底部标题
  Widget generateBottomTitle(
    double value,
    TitleMeta meta,
    List<EnergyData> data,
  ) {
    int index = value.toInt();
    if (index >= 0 && index < data.length) {
      return Text(
        data[index].time, // 调用动态生成的时间字符串
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final spots = generateSpots(energyDataList);

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
                  minY: 0,
                  maxY: 4,
                  minX: 0,
                  maxX: (energyDataList.length - 1).toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine:
                        (value) => FlLine(
                          color: Colors.grey.withAlpha(51),
                          strokeWidth: 1,
                        ),
                    getDrawingVerticalLine:
                        (value) => FlLine(
                          color: Colors.grey.withAlpha(51),
                          strokeWidth: 1,
                        ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
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
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget:
                            (value, meta) => generateBottomTitle(
                              value,
                              meta,
                              energyDataList,
                            ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withAlpha(128),
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
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
