import 'package:flutter/material.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/journals_page.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Experience',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 32),
              
              // New AI Assistant Component
              _buildAIAssistantSection(context),
              
              const SizedBox(height: 32),
              
              const SizedBox(height: 40),
              
              // Explore Section Title
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 20),
              
              // Explore Grid
              _buildExploreGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIAssistantSection(BuildContext context) {
    return Row(
      children: [
        // Large purple card on the left (40% width) - Journals
        Expanded(
          flex: 4,
          child: _buildAIAssistantCard(
            context: context,
            title: 'Journals',
            subtitle: 'Record and reflect on your daily experiences',
            description: '',
            icon: Icons.auto_stories_outlined,
            backgroundColor: const Color(0xFFdad5fd), // New purple color
            textColor: const Color(0xFF0E3C26), // Dark green
            titleFontSize: 22,
            titleFontWeight: FontWeight.w700,
            addTitleSpacing: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JournalsPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Two smaller cards on the right (60% width)
        Expanded(
          flex: 6,
          child: SizedBox(
            height: 320, // Increased height for all buttons
            child: Column(
              children: [
                // Yellow card for "Memories"
                Expanded(
                  child: Container(
                    width: double.infinity, // Force full width
                    child: _buildAIAssistantCard(
                      context: context,
                      title: 'Memories',
                      subtitle: 'Past moments and insights',
                      description: '',
                      icon: Icons.photo_library_outlined,
                      backgroundColor: const Color(0xFFfdd78c).withOpacity(0.4), // Even lighter Joyful color
                      textColor: const Color(0xFF0E3C26), // Dark green
                      titleFontSize: 18,
                      titleFontWeight: FontWeight.w600,
                      addTitleSpacing: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Memories feature coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Dark card for "Reflections"
                Expanded(
                  child: Container(
                    width: double.infinity, // Force full width
                    child: _buildAIAssistantCard(
                      context: context,
                      title: 'Reflections',
                      subtitle: 'Guided self-reflection',
                      description: '',
                      icon: Icons.psychology_outlined,
                      backgroundColor: const Color(0xFF616a7f).withOpacity(0.2), // Even lighter Stressed color
                      textColor: const Color(0xFF0E3C26), // Dark green
                      titleFontSize: 18,
                      titleFontWeight: FontWeight.w500,
                      addTitleSpacing: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReflectionsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIAssistantCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    bool addTitleSpacing = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: subtitle.isNotEmpty ? 320 : null, // Increased height for main card
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: subtitle.isNotEmpty 
          ? Stack(
              children: [
                // Icon positioned at top
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(icon, color: const Color(0xFF0E3C26).withOpacity(0.7), size: 20),
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                // Text content aligned to bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize ?? 22,
                          fontWeight: titleFontWeight ?? FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (addTitleSpacing) ...[
                        const SizedBox(height: 16),
                      ],
                                    // Subtitle - different styling for main card vs right cards
              Text(
                subtitle,
                style: description.isEmpty 
                  ? TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600, // Grey color for right card subtitles
                    )
                  : TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor, // Dark green for main card subtitle (Cooper)
                    ),
              ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        // Description
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600, // Grey color for description
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(icon, color: const Color(0xFF0E3C26).withOpacity(0.7), size: 20),
                    onPressed: onTap,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 8),
                // Just title for smaller cards
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize ?? 16,
                    fontWeight: titleFontWeight ?? FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildExperienceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 28),
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
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0E3C26).withOpacity(0.4),
              size: 36,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E3C26),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreGrid(BuildContext context) {
    final List<ExploreItem> exploreItems = [
      ExploreItem(
        title: 'Sound Patterns',
        subtitle: '4 experiences',
        color: const Color(0xFFD4C4A8),
        pattern: ExplorePattern.circles,
      ),
      ExploreItem(
        title: 'Breathing',
        subtitle: '5 practices',
        color: const Color(0xFFB8C4D4),
        pattern: ExplorePattern.dots,
      ),
      ExploreItem(
        title: 'Quotes',
        subtitle: '128 affirmations',
        color: const Color(0xFFdad5fd), // Same as Journals button
        pattern: ExplorePattern.none,
      ),
      ExploreItem(
        title: 'Emotions 101',
        subtitle: '10 videos',
        color: const Color(0xFFfdd78c).withOpacity(0.4), // Same as Memories button
        pattern: ExplorePattern.waves,
      ),
      ExploreItem(
        title: 'Best Self',
        subtitle: '12 exercises',
        color: const Color(0xFF616a7f).withOpacity(0.2), // Same as Reflections button
        pattern: ExplorePattern.none,
      ),
      ExploreItem(
        title: 'Movement',
        subtitle: '8 routines',
        color: const Color(0xFFC8D4B8),
        pattern: ExplorePattern.waves,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: exploreItems.length,
      itemBuilder: (context, index) {
        return _buildExploreCard(context, exploreItems[index]);
      },
    );
  }

  Widget _buildExploreCard(BuildContext context, ExploreItem item) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to specific explore content
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Background pattern
            if (item.pattern != ExplorePattern.none)
              Positioned.fill(
                child: _buildPattern(item.pattern, item.color),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E3C26),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPattern(ExplorePattern pattern, Color baseColor) {
    switch (pattern) {
      case ExplorePattern.circles:
        return CustomPaint(
          painter: CirclesPatternPainter(baseColor),
        );
      case ExplorePattern.dots:
        return CustomPaint(
          painter: DotsPatternPainter(baseColor),
        );
      case ExplorePattern.waves:
        return CustomPaint(
          painter: WavesPatternPainter(baseColor),
        );
      case ExplorePattern.none:
        return const SizedBox.shrink();
    }
  }
}

// Data class for explore items
class ExploreItem {
  final String title;
  final String subtitle;
  final Color color;
  final ExplorePattern pattern;

  ExploreItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.pattern,
  });
}

enum ExplorePattern { circles, dots, waves, none }

// Custom painters for background patterns
class CirclesPatternPainter extends CustomPainter {
  final Color color;
  
  CirclesPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;
    
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center, radius - (i * 20), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DotsPatternPainter extends CustomPainter {
  final Color color;
  
  DotsPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 30) % size.width;
      final y = ((i * 25) % size.height);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WavesPatternPainter extends CustomPainter {
  final Color color;
  
  WavesPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    for (double x = 0; x < size.width; x += 20) {
      path.quadraticBezierTo(
        x + 10,
        size.height * 0.7 + (x % 40 == 0 ? -20 : 20),
        x + 20,
        size.height * 0.7,
      );
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 