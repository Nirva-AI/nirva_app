import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_runtime_context.dart';

class SocialMapPage extends StatelessWidget {
  const SocialMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取 DataManager 中的社交数据
    // final socialEntities =
    //     AppRuntimeContext().data.globalSocialMap.socialEntities;

    return Scaffold(
      appBar: AppBar(title: const Text('Holistic Social Map')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Social Interactions 卡片
            SocialInteractionsCard(),

            const SizedBox(height: 24),

            // Relationship Details 标题
            const Text(
              'Relationship Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Relationship Details 内容
            RelationshipDetailsCard(),
          ],
        ),
      ),
    );
  }
}

class SocialInteractionsCard extends StatelessWidget {
  const SocialInteractionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 计算总时间
    final totalHours = AppRuntimeContext().data.getTotalSocialHours();
    // 获取全局社交实体映射
    final Map<String, SocialEntity2> globalSocialMap =
        AppRuntimeContext().data.genGlobalSocialEntitiesMap();

    // 将globalSocialMap中的value全部取出来，存成一个List
    final List<SocialEntity2> socialEntities = globalSocialMap.values.toList();

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
                itemCount: socialEntities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final entity = socialEntities[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            entity.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(entity.hours.toStringAsFixed(1)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(entity.color),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(entity.impact),
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
  //final List<SocialEntity> socialEntities;

  const RelationshipDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, SocialEntity2> globalSocialMap =
        AppRuntimeContext().data.genGlobalSocialEntitiesMap();
    final List<SocialEntity2> socialEntities = globalSocialMap.values.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 关系详情卡片列表
        ...socialEntities.map((entity) => _buildRelationshipCard(entity)),
      ],
    );
  }

  Widget _buildRelationshipCard(SocialEntity2 entity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
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
                    entity.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${entity.hours} hours',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(entity.color), // 使用实体的颜色
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 描述
              Text(entity.discription, style: const TextStyle(fontSize: 16)),
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
              ...entity.interactionDynamics.map<Widget>(
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
                        child: Text(tip, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              //.toList(),
            ],
          ),
        ),
      ),
    );
  }
}
