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
              
              // Smart Diary Component
              _buildExperienceCard(
                context: context,
                title: 'Journals',
                subtitle: 'Record and reflect on your daily experiences',
                icon: Icons.auto_stories_outlined,
                color: const Color(0xFFe7bf57),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JournalsPage(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Memories Component
              _buildExperienceCard(
                context: context,
                title: 'Memories',
                subtitle: 'Revisit your past moments and insights',
                icon: Icons.photo_library_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  // TODO: Navigate to Memories page when created
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Memories feature coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Reflections Component
              _buildExperienceCard(
                context: context,
                title: 'Reflections',
                subtitle: 'Deep dive into guided self-reflection',
                icon: Icons.psychology_outlined,
                color: const Color(0xFF10B981),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReflectionsPage(),
                    ),
                  );
                },
              ),
              
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
        color: const Color(0xFFC8B8D4),
        pattern: ExplorePattern.none,
      ),
      ExploreItem(
        title: 'Emotions 101',
        subtitle: '10 videos',
        color: const Color(0xFFD4C8B8),
        pattern: ExplorePattern.waves,
      ),
      ExploreItem(
        title: 'Best Self',
        subtitle: '12 exercises',
        color: const Color(0xFFD0B8D4),
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