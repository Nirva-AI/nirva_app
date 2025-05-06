import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

class GoalReflectionCard extends StatelessWidget {
  final SelfReflection data;

  const GoalReflectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...data.items.map(
                  (item) => Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.checklist, color: Colors.purple),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    _getSnackBar(context, data), // 调用封装的函数
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 封装的 _getSnackBar 函数
  SnackBar _getSnackBar(BuildContext context, SelfReflection data) {
    return SnackBar(
      behavior: SnackBarBehavior.fixed, // 固定在屏幕底部
      backgroundColor: Colors.white, // 背景颜色
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // 圆角
      ),
      content: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Added to todo list',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${data.title}" and ${data.items.length} tasks have been added to your todo list.',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // 关闭当前 SnackBar
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
      duration: const Duration(seconds: 2), // 显示时间
    );
  }
}
