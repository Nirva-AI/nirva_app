import 'package:flutter/material.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/journals_page.dart';
import 'dart:math';

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
              
              // New Recap Section
              _buildRecapSection(context),
              
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
          pattern: ExplorePattern.journalDots,
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
                      pattern: ExplorePattern.stars,
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
                      pattern: ExplorePattern.diamonds,
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
    ExplorePattern? pattern,
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
                // Background pattern
                if (pattern != null)
                  Positioned.fill(
                    child: _buildPattern(pattern, backgroundColor),
                  ),
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
          : Stack(
              children: [
                // Background pattern for smaller cards
                if (pattern != null)
                  Positioned.fill(
                    child: _buildPattern(pattern, backgroundColor),
                  ),
                // Content
                Column(
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
        pattern: ExplorePattern.lines,
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
        pattern: ExplorePattern.triangles,
      ),
      ExploreItem(
        title: 'Movement',
        subtitle: '8 routines',
        color: const Color(0xFFC8D4B8),
        pattern: ExplorePattern.hexagons,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
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
      case ExplorePattern.lines:
        return CustomPaint(
          painter: LinesPatternPainter(baseColor),
        );
      case ExplorePattern.triangles:
        return CustomPaint(
          painter: TrianglesPatternPainter(baseColor),
        );
      case ExplorePattern.hexagons:
        return CustomPaint(
          painter: HexagonsPatternPainter(baseColor),
        );
      case ExplorePattern.squares:
        return CustomPaint(
          painter: SquaresPatternPainter(baseColor),
        );
      case ExplorePattern.stars:
        return CustomPaint(
          painter: StarsPatternPainter(baseColor),
        );
      case ExplorePattern.diamonds:
        return CustomPaint(
          painter: DiamondsPatternPainter(baseColor),
        );
      case ExplorePattern.journalDots:
        return CustomPaint(
          painter: JournalDotsPatternPainter(baseColor),
        );
    }
  }

  Widget _buildRecapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Recap',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 20),
        
        // Highlights Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFe7bf57).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // First Highlight
              _buildHighlightItem(
                icon: Icons.edit_note,
                title: 'Nirva wrote today for you',
                description: 'Today was a day of deep conversations and cultural experiences. Your emotions fluctuated between relaxation, joy, and slight anxiety throughout the day.',
                color: const Color(0xFFD4C4A8).withOpacity(0.4),
                footerText: 'Read full story',
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              
              const SizedBox(height: 20),
              
              // Second Highlight
              _buildHighlightItem(
                icon: Icons.favorite_outline,
                title: 'Friendship Joy',
                description: 'I noticed that your chat with Ashley today made you very happy. This kind of deep friendship connection is very precious to you.',
                color: const Color(0xFFdad5fd).withOpacity(0.4),
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              
              const SizedBox(height: 20),
              
              // Third Highlight
              _buildHighlightItem(
                icon: Icons.self_improvement,
                title: 'Creative Breakthrough',
                description: 'Your afternoon brainstorming session led to a breakthrough idea. I could see how your mind worked through the challenge with renewed energy and clarity.',
                color: const Color(0xFFC8D4B8).withOpacity(0.4),
                footerText: 'Explore insights',
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              
              const SizedBox(height: 20),
              
              // Fourth Highlight
              _buildHighlightItem(
                icon: Icons.trending_up,
                title: 'Weekly Growth',
                description: 'This week, you\'ve consistently shown up for your morning routine. I\'ve noticed how this small daily commitment is building your confidence and setting a positive tone for each day.',
                color: const Color(0xFFfdd78c).withOpacity(0.4),
                footerText: 'Read full story',
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              
              const SizedBox(height: 20),
              
              // Fifth Highlight
              _buildHighlightItem(
                icon: Icons.celebration,
                title: 'Monthly Milestone',
                description: 'You\'ve completed your first full month of daily journaling! This consistent practice has helped you process emotions better and gain deeper insights into your patterns and growth.',
                color: const Color(0xFFB8C4D4).withOpacity(0.4),
                footerText: 'View progress',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    String footerText = 'Chat with Nirva',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with background
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0E3C26).withOpacity(0.7),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E3C26),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // Footer tappable text
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // TODO: Handle tap for each highlight type
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  footerText,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFe7bf57),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFe7bf57),
                    decorationThickness: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_outward_outlined,
                  size: 16,
                  color: const Color(0xFFe7bf57),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

enum ExplorePattern { circles, dots, waves, lines, triangles, hexagons, squares, stars, diamonds, journalDots }

// Custom painters for background patterns
class CirclesPatternPainter extends CustomPainter {
  final Color color;
  
  CirclesPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final center = Offset(size.width / 2.0, size.height / 2.0);
    final radius = size.width * 0.3;
    
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center, radius - (i * 20.0), paint);
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
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 30.0) % size.width;
      final y = ((i * 25.0) % size.height);
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
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    for (double x = 0; x < size.width; x += 20.0) {
              path.quadraticBezierTo(
          x + 10.0,
          size.height * 0.7 + (x % 40 == 0 ? -20.0 : 20.0),
          x + 20.0,
        size.height * 0.7,
      );
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SquaresPatternPainter extends CustomPainter {
  final Color color;
  
  SquaresPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw squares in a grid pattern
    final squareSize = 25.0;
    final spacing = 35.0;
    
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 2; col++) {
        final left = col * spacing + 10.0;
        final top = row * spacing + 10.0;
        
        final rect = Rect.fromLTWH(left, top, squareSize, squareSize);
        canvas.drawRect(rect, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarsPatternPainter extends CustomPainter {
  final Color color;
  
  StarsPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw simple star shapes (5-pointed stars)
    final starSize = 20.0;
    final positions = [
      Offset(30.0, 30.0),
      Offset(size.width - 30.0, 30.0),
      Offset(30.0, size.height - 30.0),
      Offset(size.width - 30.0, size.height - 30.0),
      Offset(size.width / 2.0, size.height / 2.0),
    ];
    
    for (final position in positions) {
      _drawStar(canvas, position, starSize, paint);
    }
  }
  
  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
    for (int i = 0; i < 10; i++) {
      final angle = i * pi / 5.0;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiamondsPatternPainter extends CustomPainter {
  final Color color;
  
  DiamondsPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw diamonds in a grid pattern
    final diamondSize = 20.0;
    final spacing = 40.0;
    
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final centerX = col * spacing + spacing / 2.0;
        final centerY = row * spacing + spacing / 2.0;
        
        final path = Path();
        path.moveTo(centerX, centerY - diamondSize);
        path.lineTo(centerX + diamondSize, centerY);
        path.lineTo(centerX, centerY + diamondSize);
        path.lineTo(centerX - diamondSize, centerY);
        path.close();
        
        canvas.drawPath(path, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JournalDotsPatternPainter extends CustomPainter {
  final Color color;
  
  JournalDotsPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    // Draw asymmetrical dots in the top area - expanded coverage
    final dotPositions = [
      Offset(20.0, 30.0),
      Offset(35.0, 20.0),
      Offset(50.0, 35.0),
      Offset(65.0, 25.0),
      Offset(80.0, 40.0),
      Offset(95.0, 30.0),
      Offset(110.0, 45.0),
      Offset(125.0, 35.0),
      Offset(140.0, 50.0),
      Offset(155.0, 40.0),
      Offset(170.0, 55.0),
      Offset(185.0, 45.0),
      Offset(200.0, 60.0),
      Offset(215.0, 50.0),
      Offset(230.0, 65.0),
      Offset(245.0, 55.0),
      Offset(260.0, 70.0),
      Offset(275.0, 60.0),
      Offset(290.0, 75.0),
      Offset(305.0, 65.0),
    ];
    
    for (final position in dotPositions) {
      canvas.drawCircle(position, 3.0, paint);
    }
    
    // Draw a subtle line representing journaling/writing
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final linePath = Path();
    linePath.moveTo(30.0, size.height * 0.6);
    linePath.quadraticBezierTo(
      size.width * 0.3, 
      size.height * 0.5, 
      size.width * 0.7, 
      size.height * 0.6
    );
    linePath.quadraticBezierTo(
      size.width * 0.8, 
      size.height * 0.7, 
      size.width - 30.0, 
      size.height * 0.65
    );
    
    canvas.drawPath(linePath, linePaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LinesPatternPainter extends CustomPainter {
  final Color color;
  
  LinesPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw diagonal lines that stay within bounds
    for (int i = 0; i < 6; i++) {
      final startX = (i * size.width / 6.0);
      final startY = 0.0;
      final endX = startX + (size.width / 6.0);
      final endY = size.height;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrianglesPatternPainter extends CustomPainter {
  final Color color;
  
  TrianglesPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw triangles in a grid pattern
            for (int row = 0; row < 4; row++) {
          for (int col = 0; col < 3; col++) {
            final centerX = (col * size.width / 3.0) + (size.width / 6.0);
            final centerY = (row * size.height / 4.0) + (size.height / 8.0);
        final triangleSize = 15.0;
        
        final path = Path();
        path.moveTo(centerX, centerY - triangleSize);
        path.lineTo(centerX - triangleSize, centerY + triangleSize);
        path.lineTo(centerX + triangleSize, centerY + triangleSize);
        path.close();
        
        canvas.drawPath(path, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonsPatternPainter extends CustomPainter {
  final Color color;
  
  HexagonsPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw hexagons in a honeycomb pattern
    final hexagonSize = 20.0;
    final hexagonWidth = hexagonSize * 2;
    final hexagonHeight = hexagonSize * 1.732; // sqrt(3) * size
    
            for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            final centerX = (col * hexagonWidth * 0.75) + (hexagonWidth / 2.0);
            final centerY = (row * hexagonHeight) + (hexagonHeight / 2.0);
        
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60.0) * (3.14159 / 180.0); // Convert to radians
          final x = centerX + hexagonSize * cos(angle);
          final y = centerY + hexagonSize * sin(angle);
          
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 