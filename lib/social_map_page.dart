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

    // 关系详情数据
    final List<Map<String, dynamic>> relationshipData = [
      {
        'name': 'Michael',
        'hours': 8.5,
        'description':
            'Long-time friend who brings perspective and shared history. Conversations are effortless and restorative.',
        'tips': [
          'Schedule Regular Check-ins: Make time for your monthly calls even when busy.',
          'Share Your Growth: Keep them updated on your personal development.',
          'Plan That Trip: Follow through on your discussed travel plans.',
        ],
      },
      {
        'name': 'Sarah',
        'hours': 6.8,
        'description':
            'Creative collaborator who inspires new ideas. Time flies during conversations about art and projects.',
        'tips': [
          'Schedule Making Sessions: Set aside time for collaborative creation.',
          'Share Inspirations: Continue exchanging creative resources.',
          'Celebrate Wins: Acknowledge each other\'s creative successes.',
        ],
      },
      {
        'name': 'Trent',
        'hours': 5.5,
        'description':
            'Highly engaging, intellectually stimulating conversations. Covered a wide range of topics (work, philosophy, film, society).',
        'tips': [
          'Continue intellectual exchanges on various topics.',
          'Plan regular coffee meetups for deeper discussions.',
          'Share book and film recommendations.',
        ],
      },
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

            // Relationship Details 卡片
            RelationshipDetailsCard(relationshipData: relationshipData),
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

class RelationshipDetailsCard extends StatelessWidget {
  final List<Map<String, dynamic>> relationshipData;

  const RelationshipDetailsCard({super.key, required this.relationshipData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            const Text(
              'Relationship Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 关系详情卡片列表
            ...relationshipData.map(
              (relationship) => _buildRelationshipCard(relationship),
            ),
            //.toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipCard(Map<String, dynamic> relationship) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 名字和小时
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    relationship['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${relationship['hours']} hours',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 描述
              Text(
                relationship['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // 关系提示标题
              const Text(
                'RELATIONSHIP TIPS:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // 提示列表
              ...relationship['tips']
                  .map<Widget>(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}



/*

*/