import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

class GoalReflectionCard extends StatelessWidget {
  final Reflection data;

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
                  _showTopOverlay(context, data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 封装的 _showTopOverlay 函数
  void _showTopOverlay(BuildContext context, Reflection data) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight, // 设置为 AppBar 的高度
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
            ),
          ),
    );

    // 显示 Overlay
    overlay.insert(overlayEntry);

    // 自动移除 Overlay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
