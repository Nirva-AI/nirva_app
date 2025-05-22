import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

class EnergyLevelDetailsPage extends StatefulWidget {
  const EnergyLevelDetailsPage({super.key});

  @override
  State<EnergyLevelDetailsPage> createState() => _EnergyLevelDetailsPageState();
}

class _EnergyLevelDetailsPageState extends State<EnergyLevelDetailsPage> {
  EnergyLevelChartType _selectedType = EnergyLevelChartType.day; // 默认选中类型

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 包裹 TabBar、Energy Level 和折线图的 Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TabBar 模拟
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab('Day', EnergyLevelChartType.day),
                        _buildTab('Week', EnergyLevelChartType.week),
                        _buildTab('Month', EnergyLevelChartType.month),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Energy Level
                    Center(
                      child: Text(
                        _parseEnergyLevelString(_selectedType),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: EnergyLevelChart(
                        type: _selectedType,
                        dayData: EnergyLevelChartData.createDaySamples(),
                        weekData: EnergyLevelChartData.createWeekSamples(),
                        monthData: EnergyLevelChartData.createMonthSamples(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              DataManager().energyLevelDashboard.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  String _parseEnergyLevelString(EnergyLevelChartType type) {
    if (type == EnergyLevelChartType.day) {
      return "8.3";
    } else if (type == EnergyLevelChartType.week) {
      return "8.1";
    } else if (type == EnergyLevelChartType.month) {
      return "8.0";
    }
    return "0.0"; // 默认值
  }

  /// 构建按钮
  Widget _buildTab(String title, EnergyLevelChartType type) {
    final bool isSelected = _selectedType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedType = type; // 更新选中的类型
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 提取 Insights 卡片部分为独立函数
  Widget _buildInsightsCard(List<String> insights) {
    // 如果insights为空，提供一些默认值
    final List<String> displayInsights =
        insights.isNotEmpty
            ? insights
            : [
              // 'Your energy levels peak in the late morning and early afternoon.',
              // 'Social interactions appear to boost your energy significantly.',
              // 'Consider scheduling important tasks during your high-energy periods.',
            ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...displayInsights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(insight, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum EnergyLevelChartType { day, week, month }

class EnergyLevelChartData {
  final EnergyLevelChartType type;
  final double value;
  EnergyLevelChartData({required this.type, required this.value});

  // 生成最近的7天数据
  static List<EnergyLevelChartData> createDaySamples() {
    return [
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 7.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 6.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 8.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 7.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 7.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 6.0),
      EnergyLevelChartData(type: EnergyLevelChartType.day, value: 8.3),
    ];
  }

  // 生成最近的4周数据
  static List<EnergyLevelChartData> createWeekSamples() {
    return [
      EnergyLevelChartData(type: EnergyLevelChartType.week, value: 6.8),
      EnergyLevelChartData(type: EnergyLevelChartType.week, value: 7.2),
      EnergyLevelChartData(type: EnergyLevelChartType.week, value: 7.5),
      EnergyLevelChartData(type: EnergyLevelChartType.week, value: 7.9),
    ];
  }

  // 生成最近的5个月数据
  static List<EnergyLevelChartData> createMonthSamples() {
    return [
      EnergyLevelChartData(type: EnergyLevelChartType.month, value: 6.2),
      EnergyLevelChartData(type: EnergyLevelChartType.month, value: 6.7),
      EnergyLevelChartData(type: EnergyLevelChartType.month, value: 7.3),
      EnergyLevelChartData(type: EnergyLevelChartType.month, value: 7.8),
      EnergyLevelChartData(type: EnergyLevelChartType.month, value: 8.1),
    ];
  }
}

class EnergyLevelChart extends StatelessWidget {
  final EnergyLevelChartType type;
  final List<EnergyLevelChartData> dayData;
  final List<EnergyLevelChartData> weekData;
  final List<EnergyLevelChartData> monthData;

  final double _minY = 0; // 最小值
  final double _maxY = 10; // 最大值
  final double _interval = 2; // 刻度间隔

  List<double> get yAxisValues {
    return List.generate(
      ((_maxY - _minY) / _interval).toInt() + 1,
      (index) => _minY + index * _interval,
    );
  }

  String _convertYValueToString(double value) {
    if (yAxisValues.contains(value)) {
      return value.toInt().toString();
    }
    return '';
  }

  const EnergyLevelChart({
    super.key,
    required this.type,
    required this.dayData,
    required this.weekData,
    required this.monthData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // 确保图表居中
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 1.0,
        child: LineChart(
          LineChartData(
            minY: _minY,
            maxY: _maxY,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _interval,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    var valueToString = _convertYValueToString(value);
                    if (valueToString.isNotEmpty) {
                      return Text(
                        valueToString,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(sideTitles: _buildBottomTitles(type)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: _buildLineBarsData(type),
          ),
        ),
      ),
    );
  }

  /// 构建底部标题的逻辑
  SideTitles _buildBottomTitles(EnergyLevelChartType type) {
    switch (type) {
      case EnergyLevelChartType.day:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatDayTitle(
                  value.toInt(),
                  DataManager().energyLevelDashboard.dateTime.weekday,
                  dayData.length,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case EnergyLevelChartType.week:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatWeekTitle(value.toInt()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      case EnergyLevelChartType.month:
        return SideTitles(
          showTitles: true,
          reservedSize: 32, // 为底部标题预留空间
          interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
              child: Text(
                _formatMonthTitle(
                  value.toInt(),
                  DataManager().energyLevelDashboard.dateTime.month,
                  monthData.length,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
    }
  }

  /// 构建 lineBarsData 的逻辑
  List<LineChartBarData> _buildLineBarsData(EnergyLevelChartType type) {
    switch (type) {
      case EnergyLevelChartType.day:
        return [
          LineChartBarData(
            spots:
                dayData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case EnergyLevelChartType.week:
        return [
          LineChartBarData(
            spots:
                weekData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
      case EnergyLevelChartType.month:
        return [
          LineChartBarData(
            spots:
                monthData
                    .asMap()
                    .entries
                    .map(
                      (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ];
    }
  }

  /// 格式化月份标题
  String _formatMonthTitle(
    int widgetIndexValue,
    int currentMonth,
    int monthsCount,
  ) {
    int startMonth = (currentMonth - monthsCount) % 12;
    if (startMonth <= 0) startMonth += 12;
    int targetMonth = (startMonth + widgetIndexValue) % 12;
    if (targetMonth == 0) targetMonth = 12;
    return Utils.monthNames[targetMonth - 1];
  }

  // 格式化每天的标题
  String _formatDayTitle(
    int widgetIndexValue,
    int currentWeekDay,
    int dayCount,
  ) {
    // 计算从当前月份开始的正序排列
    int startWeekDay = (currentWeekDay - dayCount) % 7;
    if (startWeekDay <= 0) startWeekDay += 7;
    int targetWeekDay = (startWeekDay + widgetIndexValue) % 7;
    if (targetWeekDay == 0) targetWeekDay = 7;
    return Utils.weekDayNames[targetWeekDay - 1];
  }

  /// 显示最近的4个周
  String _formatWeekTitle(int widgetIndexValue) {
    List<String> weekNames = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    return weekNames[widgetIndexValue];
  }
}
