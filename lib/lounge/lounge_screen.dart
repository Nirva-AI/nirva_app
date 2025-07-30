import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class LoungeScreen extends StatefulWidget {
  const LoungeScreen({super.key});

  @override
  State<LoungeScreen> createState() => _LoungeScreenState();
}

class _LoungeScreenState extends State<LoungeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Reflection', 'Mood', 'Nature', 'Sleep'];
  final PageController _slideshowController = PageController(
    viewportFraction: 0.65,
    initialPage: 1,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _slideshowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFfaf9f5),
        ),
        child: Stack(
          children: [
            // Background image with fade-out effect - pushed up and trimmed
            Positioned(
              top: -100, // Push up and trim top area
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home_bg.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Gradient overlay for fade-out effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      const Color(0xFFfaf9f5).withOpacity(0.3),
                      const Color(0xFFfaf9f5).withOpacity(0.7),
                      const Color(0xFFfaf9f5),
                    ],
                    stops: const [0.0, 0.4, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),
            // Greeting text on top left
            Positioned(
              top: 90, 
              left: 20,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evening light finds you',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.1,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Claire',
                      style: GoogleFonts.pacifico(
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFe7bf57),
                        height: 1.1,
                        letterSpacing: 3.0,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Top right notification button with frosted glass effect
            Positioned(
              top: 100,
              right: 20,
              child: _buildFrostedGlassButton(
                width: 44,
                height: 44,
                child: Icon(Icons.notifications_outlined,
                  color: Colors.white.withOpacity(0.6),
                  size: 24,
                ),
                onTap: () {
                  // Handle notification tap
                },
              ),
            ),
            // Category buttons with horizontal scroll
            Positioned(
              top: 380,
              left: 0,
              right: 0,
              child: _buildCategoryButtons(),
            ),
            // Slideshow component
            Positioned(
              top: 450,
              left: 0,
              right: 0,
              child: _buildSlideshow(),
            ),
            // For You section
            Positioned(
              top: 750,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildForYouSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrostedGlassButton({
    required double width,
    required double height,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(height / 2),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: EdgeInsets.only(right: index < _categories.length - 1 ? 12 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Material(
                    color: Colors.transparent,
                                          child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.black87 : Colors.white,
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlideshow() {
    final List<Map<String, String>> slideshowData = [
      {
        'title': 'Evening Meditation',
        'subtitle': '15 Minute Guided Session',
        'background': 'assets/lounge_slideshow_bg_1.png',
        'picker_pic': 'assets/picker_pic_2.png',
      },
      {
        'title': 'Heart-to-heart',
        'subtitle': 'Want to share more about your frustration after date night?',
        'background': 'assets/lounge_slideshow_bg_2.png',
        'picker_pic': 'assets/picker_pic_2.png',
      },
      {
        'title': 'Today, in Moments',
        'subtitle': 'A gentle reflection on where your energy went.',
        'background': 'assets/lounge_slideshow_bg_3.png',
        'picker_pic': 'assets/picker_pic_3.png',
      },
      {
        'title': 'Mindful Walking',
        'subtitle': 'Outdoor Mindfulness Practice',
        'background': 'assets/lounge_slideshow_bg_4.png',
        'picker_pic': 'assets/picker_pic_4.png',
      },
    ];

    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: _slideshowController,
        itemCount: slideshowData.length,
        padEnds: true,
        pageSnapping: true,
        itemBuilder: (context, index) {
          final data = slideshowData[index];
          return AnimatedBuilder(
            animation: _slideshowController,
            builder: (context, child) {
              double value = 1.0;
              if (_slideshowController.position.haveDimensions && _slideshowController.page != null) {
                value = _slideshowController.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
              } else {
                // Handle initial state - use the same scaling logic as scrolling
                double distance = (index - _slideshowController.initialPage).abs().toDouble();
                value = (1 - (distance * 0.2)).clamp(0.0, 1.0);
              }
              
              return Center(
                child: SizedBox(
                  height: 220 * value + 70,
                  child: Transform.scale(
                    scale: 0.85 + (value * 0.15),
                    child: _buildSlideshowCard(
                      title: data['title']!,
                      subtitle: data['subtitle']!,
                      backgroundImage: data['background']!,
                      pickerPic: data['picker_pic']!,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSlideshowCard({
    required String title,
    required String subtitle,
    required String backgroundImage,
    required String pickerPic,
  }) {
    return Container(
      width: 260, // Adjusted width for better spacing with new viewport fraction
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFf0ebd8),
            const Color(0xFFe5dfc7),
            const Color(0xFFd4ccb0),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background illustration in bottom left
            Positioned(
              bottom: -15,
              left: -15,
              child: Container(
                width: 160,
                height: 160,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    const Color(0xFFd4ccb0).withOpacity(0.3),
                    BlendMode.multiply,
                  ),
                  child: Image.asset(
                    pickerPic,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Text content positioned at top
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title and subtitle
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom right icons positioned absolutely
            Positioned(
              bottom: 24,
              right: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Star icon
                  Icon(Icons.star_border,
                    color: Colors.black54,
                    size: 24,
                  ),
                  SizedBox(height: 16),
                  // Headphones icon
                  Icon(Icons.headphones,
                    color: Colors.black54,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForYouSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Text(
        'For You',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// Simple placeholder ArticlePage
class ArticlePage extends StatelessWidget {
  final String title;
  const ArticlePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'This is the article: $title',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}