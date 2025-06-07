import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
//import 'package:nirva_app/data.dart';
import 'package:nirva_app/energy_level_details_page.dart'; // 导入新页面
import 'package:nirva_app/utils.dart';

class EnergyLabel {
  static const lowMinus = EnergyLabel(label: '', measurementValue: 0.0);
  static const low = EnergyLabel(label: 'Low', measurementValue: 1.0);
  static const neutral = EnergyLabel(label: 'Neutral', measurementValue: 2.0);
  static const high = EnergyLabel(label: 'High', measurementValue: 3.0);
  static const highPlus = EnergyLabel(label: '', measurementValue: 4.0);
  static const double energyLabelTitlesInterval = 1;

  final String label;
  final double measurementValue;

  const EnergyLabel({required this.label, required this.measurementValue});
}

class EnergyLevel {
  final DateTime dateTime;
  final double energyLevel;

  EnergyLevel({required this.dateTime, required this.energyLevel});

  double get measuredEnergy {
    final clampedEnergyLevel = energyLevel.clamp(1.0, 10.0);
    final normalizedEnergyLevel =
        (clampedEnergyLevel - 1.0) / 9.0; // 将1-10映射到0-1
    final mappedEnergyLevel =
        normalizedEnergyLevel *
        EnergyLabel.highPlus.measurementValue; // 将0-1映射到0-4
    return mappedEnergyLevel;
  }
}

class EnergyLevelCard extends StatelessWidget {
  const EnergyLevelCard({super.key});

  List<EnergyLevel> get energyLevels {
    List<EnergyLevel> ret = [];
    final events = AppRuntimeContext().data.currentJournalFile.events;
    final currentJournalDate = AppRuntimeContext().data.currentJournalDate;
    for (var event in events) {
      try {
        final parseTimeRange = Utils.parseTimeRange(
          currentJournalDate,
          event.time_range,
        );

        ret.add(
          EnergyLevel(
            dateTime: parseTimeRange.item2,
            energyLevel: event.energy_level.toDouble(),
          ),
        );
      } catch (e) {
        // 如果时间格式不正确，跳过这个事件
        continue;
      }
    }
    return ret;
  }

  List<FlSpot> _generateSpots(List<EnergyLevel> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      EnergyLevel energy = entry.value;
      return FlSpot(index.toDouble(), energy.measuredEnergy);
    }).toList();
  }

  Widget _generateBottomTitle(
    double value,
    TitleMeta meta,
    List<EnergyLevel> data,
  ) {
    int index = value.toInt();
    if (index >= 0 && index < data.length) {
      return Text(
        //data[index].time,
        _timeToString(data[index].dateTime),
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
    }
    return const SizedBox.shrink();
  }

  String _timeToString(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _formatEnergyLevelString(double value) {
    if (value <= EnergyLabel.lowMinus.measurementValue) {
      return EnergyLabel.lowMinus.label;
    }
    if (value <= EnergyLabel.low.measurementValue) {
      return EnergyLabel.low.label;
    }
    if (value <= EnergyLabel.neutral.measurementValue) {
      return EnergyLabel.neutral.label;
    }
    if (value <= EnergyLabel.high.measurementValue) {
      return EnergyLabel.high.label;
    }
    return EnergyLabel.highPlus.label;
  }

  @override
  Widget build(BuildContext context) {
    // List<EnergyLevel> energyLevels =
    //     AppRuntimeContext().data.currentJournal.energyLevels;
    final spots = _generateSpots(energyLevels);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 修改部分：将标题和按钮放在同一行
            Row(
              children: [
                const Text(
                  'Energy Level',
                  style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(), // 添加Spacer将按钮推到最右侧
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnergyLevelDetailsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: EnergyLabel.lowMinus.measurementValue,
                  maxY: EnergyLabel.highPlus.measurementValue,
                  minX: 0,
                  maxX: (energyLevels.length - 1).toDouble(),
                  // gridData: FlGridData(
                  //   show: true,
                  //   drawVerticalLine: true,
                  //   horizontalInterval: 1,
                  //   verticalInterval: 1,
                  //   getDrawingHorizontalLine:
                  //       (value) => FlLine(
                  //         color: Colors.grey.withAlpha(51),
                  //         strokeWidth: 1,
                  //       ),
                  //   getDrawingVerticalLine:
                  //       (value) => FlLine(
                  //         color: Colors.grey.withAlpha(51),
                  //         strokeWidth: 1,
                  //       ),
                  // ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: EnergyLabel.energyLabelTitlesInterval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatEnergyLevelString(value),
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
                            (value, meta) =>
                                _generateBottomTitle(value, meta, energyLevels),
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
