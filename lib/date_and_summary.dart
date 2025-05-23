import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

class DateAndSummary extends StatelessWidget {
  const DateAndSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final fullDateTime = Utils.fullDiaryDateTime(
      DataManager().currentJournal.dateTime,
    );
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '''$fullDateTime Reflections''',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(DataManager().currentJournal.summary),
        ],
      ),
    );
  }
}
