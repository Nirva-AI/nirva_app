import 'package:flutter/material.dart';

class SocialMapPage extends StatelessWidget {
  const SocialMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例数据
    final List<Map<String, dynamic>> socialData = [
      {'name': 'Michael', 'hours': 8.5, 'impact': 'Positive'},
      {'name': 'Sarah', 'hours': 6.8, 'impact': 'Positive'},
      {'name': 'Trent', 'hours': 5.5, 'impact': 'Positive'},
      {'name': 'Emma', 'hours': 4.2, 'impact': 'Neutral'},
      {'name': 'Raj', 'hours': 3.7, 'impact': 'Positive'},
      {'name': 'Ashley', 'hours': 3.0, 'impact': 'Positive'},
      {'name': 'Jason', 'hours': 2.1, 'impact': 'Negative'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Holistic Social Map')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Social Interactions 卡片
            SocialInteractionsCard(socialData: socialData),

            const SizedBox(height: 16),

            // 这里可以添加其他内容
          ],
        ),
      ),
    );
  }
}

class SocialInteractionsCard extends StatelessWidget {
  final List<Map<String, dynamic>> socialData;

  const SocialInteractionsCard({super.key, required this.socialData});

  @override
  Widget build(BuildContext context) {
    // 计算总时间
    double totalHours = 0;
    for (var person in socialData) {
      totalHours += person['hours'] as double;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 500, // 设置固定高度
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            const Text(
              'Social Interactions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 总时间
            Text(
              'Total time spent with others: ${totalHours.toStringAsFixed(1)} hours',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // 表头
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Energy Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // 数据行 - 可滚动列表
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: socialData.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final person = socialData[index];

                  // 根据impact选择颜色
                  Color impactColor;
                  if (person['impact'] == 'Positive') {
                    impactColor = Colors.green;
                  } else if (person['impact'] == 'Neutral') {
                    impactColor = Colors.amber;
                  } else {
                    impactColor = Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            person['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(person['hours'].toString()),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: impactColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(person['impact']),
                            ],
                          ),
                        ),
                      ],
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
