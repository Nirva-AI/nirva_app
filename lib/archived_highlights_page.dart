import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';

enum ArchivedHighlightsType { weekly, monthly }

class ArchivedHighlightsPage extends StatefulWidget {
  const ArchivedHighlightsPage({super.key});

  @override
  State<ArchivedHighlightsPage> createState() => _ArchivedHighlightsPageState();
}

class _ArchivedHighlightsPageState extends State<ArchivedHighlightsPage> {
  ArchivedHighlightsType _selectedType = ArchivedHighlightsType.weekly;

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
                _buildTab(
                  'Weekly',
                  _selectedType == ArchivedHighlightsType.weekly,
                  () => _onTabSelected(ArchivedHighlightsType.weekly),
                ),
                _buildTab(
                  'Monthly',
                  _selectedType == ArchivedHighlightsType.monthly,
                  () => _onTabSelected(ArchivedHighlightsType.monthly),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.builder(
              key: UniqueKey(),
              itemCount: selectedArchivedHighlights.length,
              itemBuilder: (context, index) {
                return _buildArchivedHighlights(
                  selectedArchivedHighlights[index],
                  _selectedType,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onTabSelected(ArchivedHighlightsType type) {
    setState(() {
      _selectedType = type;
    });
  }

  List<ArchivedHighlights> get selectedArchivedHighlights {
    return _selectedType == ArchivedHighlightsType.weekly
        ? AppRuntimeContext().data.weeklyArchivedHighlights
        : AppRuntimeContext().data.monthlyArchivedHighlights;
  }

  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  //
  String _parseTitle(
    ArchivedHighlights archivedHighlights,
    ArchivedHighlightsType selectedType,
  ) {
    String parseTitle = '';
    if (selectedType == ArchivedHighlightsType.weekly) {
      parseTitle =
          '${Utils.fullDiaryDateTime(archivedHighlights.beginTime)} - ${Utils.fullDiaryDateTime(archivedHighlights.endTime)}';
    } else if (selectedType == ArchivedHighlightsType.monthly) {
      parseTitle =
          '${Utils.fullMonthNames[archivedHighlights.endTime.month - 1]} ${archivedHighlights.endTime.year}';
    }
    return parseTitle;
  }

  Widget _buildArchivedHighlights(
    ArchivedHighlights archivedHighlights,
    ArchivedHighlightsType selectedType,
  ) {
    return ExpansionTile(
      title: Text(
        _parseTitle(archivedHighlights, selectedType),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      childrenPadding: EdgeInsets.zero, // 添加此行确保无额外内边距
      children:
          archivedHighlights.highlights.map((highlight) {
            return Container(
              // 使用Container替代Padding以确保一致性
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              width: double.infinity, // 确保宽度一致
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
}
