import 'package:flutter/material.dart';

class MoodTrendCard extends StatefulWidget {
  const MoodTrendCard({super.key});

  @override
  State<MoodTrendCard> createState() => _MoodTrendCardState();
}

class _MoodTrendCardState extends State<MoodTrendCard> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf0ebd8),
            Color(0xFFece6d2),
            Color(0xFFe8e2cc),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Container with Period Switcher
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Background pattern with diagonal stripes for entire container
                Positioned.fill(
                  child: CustomPaint(
                    painter: DiagonalStripesPainter(),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Mood Trend Chart
                      SizedBox(
                        height: 200,
                        child: _buildMoodTrendChart(),
                      ),
                      const SizedBox(height: 16),
                      // Time Period Switcher
                      _buildPeriodSwitcher(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Description
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildMoodTrendChart() {
    return Center(
      child: Container(
        width: 320,
        height: 200,
        child: Stack(
          children: [
                            // Calm - much larger circle, using Focused's color (C8D4B8)
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: _buildMoodBubble(
                    'Calm',
                    const Color(0xFFC8D4B8), // Focused's color (Movement color)
                    140.0, // Much larger size
                  ),
                ),
                
                // Joyful - large circle, using new color #fdd78c
                Positioned(
                  left: 45,
                  bottom: 40,
                  child: _buildMoodBubble(
                    'Joyful',
                    const Color(0xFFfdd78c), // New color
                    90.0, // Large size
                  ),
                ),
                
                // Stressed - medium circle, using new color #616a7f
                Positioned(
                  left: 107,
                  bottom: 10,
                  child: _buildMoodBubble(
                    'Stressed',
                    const Color(0xFF616a7f), // New color
                    70.0, // Medium size
                    fontSize: 12,
                    textColor: const Color(0xFFfaf9f5), // Custom text color
                  ),
                ),
                
                // Focused - smaller circle, using Stressed's color (B8C4D4)
                Positioned(
                  left: 123,
                  top: 42,
                  child: _buildMoodBubble(
                    'Focused',
                    const Color(0xFFB8C4D4), // Stressed's color (Breathing color)
                    60.0, // Smaller size
                    fontSize: 11,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodBubble(String mood, Color color, double size, {double fontSize = 14, Color? textColor}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          mood,
          style: TextStyle(
            color: textColor ?? Colors.grey.shade600,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mood Track',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your emotional landscape shows varied states this week.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Detail button
        GestureDetector(
          onTap: () {
            // TODO: Navigate to mood trend detail page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mood trend detail page coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward_outlined,
              color: Color(0xFF0E3C26),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSwitcher() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFe7bf57).withOpacity(0.1)
      ..strokeWidth = 2;

    const spacing = 8.0;
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