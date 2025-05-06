import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';

class EnergyLevelChart extends StatelessWidget {
  const EnergyLevelChart({super.key});

  //
  List<FlSpot> _generateSpots(List<EnergyData> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      EnergyData energy = entry.value;
      return FlSpot(index.toDouble(), energy.energyLevel);
    }).toList();
  }

  //
  Widget _generateBottomTitle(
    double value,
    TitleMeta meta,
    List<EnergyData> data,
  ) {
    int index = value.toInt();
    if (index >= 0 && index < data.length) {
      return Text(
        data[index].time,
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    List<EnergyData> energyRecords =
        DataManager().activePersonalData.energyRecords;
    final spots = _generateSpots(energyRecords);

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
                  minY: EnergyLabel.lowMinus.measurementValue,
                  maxY: EnergyLabel.highPlus.measurementValue,
                  minX: 0,
                  maxX: (energyRecords.length - 1).toDouble(),
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
                          final energyData = EnergyData(
                            dateTime: DateTime.now(),
                            energyLevel: value,
                          );
                          final label = energyData.energyLabelString;

                          return Text(
                            label,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget:
                            (value, meta) => _generateBottomTitle(
                              value,
                              meta,
                              energyRecords,
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
