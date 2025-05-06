import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

// ReflectionCard Widget
class ReflectionCard extends StatelessWidget {
  final SelfReflection data;

  const ReflectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
