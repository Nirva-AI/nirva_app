import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/data_manager.dart';

class TodayHighlightsDetailsPage extends StatelessWidget {
  final highlightGroups = DataManager().highlightGroups;

  TodayHighlightsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Highlights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TabBar 模拟
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab('Weekly', true),
                _buildTab('Monthly', false),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: highlightGroups.length,
              itemBuilder: (context, index) {
                final group = highlightGroups[index];
                return _buildHighlightGroup(group);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget _buildHighlightGroup(HighlightGroup group) {
    return ExpansionTile(
      title: Text(
        '${_formatDate(group.beginTime)} - ${_formatDate(group.endTime)}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      children:
          group.highlights.map((highlight) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    highlight.category.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(highlight.content, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
