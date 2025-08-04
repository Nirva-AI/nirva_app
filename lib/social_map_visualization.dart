import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'dart:math';

class SocialMapVisualization extends StatefulWidget {
  final String selectedPeriod;
  final String? selectedPerson;
  final Function(String?) onPersonSelected;
  final double height;

  const SocialMapVisualization({
    super.key,
    required this.selectedPeriod,
    required this.selectedPerson,
    required this.onPersonSelected,
    this.height = 200.0,
  });

  @override
  State<SocialMapVisualization> createState() => _SocialMapVisualizationState();
}

class _SocialMapVisualizationState extends State<SocialMapVisualization> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JournalFilesProvider>(
      builder: (context, journalProvider, child) {
        final socialMap = journalProvider.buildSocialMap();
        final socialEntities = socialMap.values.toList();
        
        if (socialEntities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'No social interactions recorded',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Filter entities based on selected period
        List<SocialEntity> filteredEntities;
        if (widget.selectedPeriod == 'Day') {
          // For day view, only show 'trent' and 'ashley'
          filteredEntities = socialEntities.where((entity) => 
            entity.name.toLowerCase() == 'trent' || 
            entity.name.toLowerCase() == 'ashley'
          ).toList();
          
          // If filtered entities are empty, show empty state
          if (filteredEntities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No social interactions for today',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Sort filtered entities by hours for day view
          filteredEntities.sort((a, b) => b.hours.compareTo(a.hours));
        } else {
          // For week and month views, use all entities (top 6)
          socialEntities.sort((a, b) => b.hours.compareTo(a.hours));
          filteredEntities = socialEntities.take(6).toList();
        }
        
        // Calculate size range for nodes
        final maxHours = filteredEntities.isNotEmpty ? filteredEntities.first.hours : 1.0;
        final minHours = filteredEntities.isNotEmpty ? filteredEntities.last.hours : 1.0;
        final sizeRange = maxHours - minHours;
        
        if (widget.selectedPeriod == 'Day') {
          return _buildDayView(filteredEntities, sizeRange, minHours);
        } else {
          return _buildWeekMonthView(filteredEntities, sizeRange, minHours);
        }
      },
    );
  }

  Widget _buildDayView(List<SocialEntity> entities, double sizeRange, double minHours) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = widget.height;
        final centerX = chartWidth / 2;
        final centerY = chartHeight / 2;
        final youNodeSize = 60.0;
        
        return Stack(
          children: [
            // Draw connection lines
            CustomPaint(
              size: Size(chartWidth, chartHeight),
              painter: DayViewPainter(
                entities: entities,
                centerX: centerX,
                centerY: centerY,
                youNodeSize: youNodeSize,
              ),
            ),
            // Draw YOU node in center
            Positioned(
              left: centerX - youNodeSize / 2,
              top: centerY - youNodeSize / 2,
              child: Container(
                width: youNodeSize,
                height: youNodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFfdd78c), // Golden yellow color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'YOU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Draw other people nodes
            ...entities.asMap().entries.map((entry) {
              final index = entry.key;
              final entity = entry.value;
              final isSelected = widget.selectedPerson == entity.name;
              
              // Calculate node size based on hours (40-80 range for day view)
              final nodeSize = 40.0 + (entity.hours / 10.0) * 40.0;
              
              // Position around the center in a circle
              final angle = (index * 2 * 3.14159) / entities.length;
              final radius = 80.0;
              final x = centerX + radius * cos(angle);
              final y = centerY + radius * sin(angle);
              
              return Positioned(
                left: x - nodeSize / 2,
                top: y - nodeSize / 2,
                child: GestureDetector(
                  onTap: () {
                    widget.onPersonSelected(isSelected ? null : entity.name);
                  },
                  child: Container(
                    width: nodeSize,
                    height: nodeSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC8D4B8), // Light green
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name
                        Text(
                          entity.name,
                          style: TextStyle(
                            fontSize: nodeSize * 0.25,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0E3C26),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Hours
                        Text(
                          '${entity.hours.toStringAsFixed(1)}h',
                          style: TextStyle(
                            fontSize: nodeSize * 0.2,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildWeekMonthView(List<SocialEntity> entities, double sizeRange, double minHours) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = widget.height;
        final centerX = chartWidth / 2;
        final centerY = chartHeight / 2;
        final youNodeSize = 60.0;
        
        return Stack(
          children: [
            // Draw connection lines
            CustomPaint(
              size: Size(chartWidth, chartHeight),
              painter: DayViewPainter(
                entities: entities,
                centerX: centerX,
                centerY: centerY,
                youNodeSize: youNodeSize,
              ),
            ),
            // Draw YOU node in center
            Positioned(
              left: centerX - youNodeSize / 2,
              top: centerY - youNodeSize / 2,
              child: Container(
                width: youNodeSize,
                height: youNodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFfdd78c), // Golden yellow color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'YOU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Draw other people nodes
            ...entities.asMap().entries.map((entry) {
              final index = entry.key;
              final entity = entry.value;
              final isSelected = widget.selectedPerson == entity.name;
              
              // Calculate node size based on hours (30-60 range for week/month view)
              double normalizedSize;
              if (sizeRange > 0.1) { // Use a small threshold to avoid division by very small numbers
                normalizedSize = 30.0 + ((entity.hours - minHours) / sizeRange) * 30.0;
              } else if (entities.length == 1) {
                // If only one entity, use a medium size
                normalizedSize = 45.0;
              } else {
                // If multiple entities but similar hours, scale based on absolute hours
                final maxHoursInView = entities.first.hours;
                normalizedSize = 30.0 + (entity.hours / maxHoursInView) * 30.0;
              }
              final nodeSize = normalizedSize;
              
              // Position around the center in a circle
              final angle = (index * 2 * 3.14159) / entities.length;
              final radius = 80.0; // Reduced radius for better visibility
              final x = centerX + radius * cos(angle);
              final y = centerY + radius * sin(angle);
              
              return Positioned(
                left: x - nodeSize / 2,
                top: y - nodeSize / 2,
                child: GestureDetector(
                  onTap: () {
                    widget.onPersonSelected(isSelected ? null : entity.name);
                  },
                  child: Container(
                    width: nodeSize,
                    height: nodeSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC8D4B8), // Light green
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name
                        Text(
                          entity.name,
                          style: TextStyle(
                            fontSize: nodeSize * 0.25,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0E3C26),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Hours
                        Text(
                          '${entity.hours.toStringAsFixed(1)}h',
                          style: TextStyle(
                            fontSize: nodeSize * 0.2,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class DayViewPainter extends CustomPainter {
  final List<SocialEntity> entities;
  final double centerX;
  final double centerY;
  final double youNodeSize;

  DayViewPainter({
    required this.entities,
    required this.centerX,
    required this.centerY,
    required this.youNodeSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entities.isEmpty) return;

    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw lines from YOU to each person
    final radius = 80.0; // Reduced radius for better visibility
    for (int i = 0; i < entities.length; i++) {
      final angle = (i * 2 * pi) / entities.length;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      
      // Draw line from center to person
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(x, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 20.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 