import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/mood_details_page.dart';

class MoodScoreCard extends StatelessWidget {
  final MoodScore data;

  const MoodScoreCard({super.key, required this.data});

  // 根据变化值获取颜色
  Color _getChangeColor(double change) {
    return change >= 0 ? Colors.green : Colors.red;
  }

  // 写一个函数 根据change 返回一个string. 可以使用.toStringAsFixed(1),的方法，注意如果是正数要加上+号
  String _formatChange(double change) {
    return change >= 0
        ? '+${change.toStringAsFixed(1)}'
        : change.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final Color changeColor = _getChangeColor(data.change);
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mood Score', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    data.value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        changeColor == Colors.green
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: changeColor,
                        size: 16,
                      ),
                      Text(
                        _formatChange(data.change),
                        style: TextStyle(color: changeColor),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoodDetailsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
