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
  final ScrollController _slideshowController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the 2nd card after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_slideshowController.hasClients) {
        _slideshowController.animateTo(
          256, // 240 (card width) + 16 (margin) to reach 2nd card
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
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
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            const Color(0xFFe7bf57).withOpacity(0.9),
                            Colors.white.withOpacity(0.85),
                          ],
                          stops: const [0.0, 0.95],
                        ).createShader(bounds);
                      },
                      child: Text(
                        'Claire',
                        style: GoogleFonts.pacifico(
                          fontSize: 48,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
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
              top: 470,
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
        'title': 'Morning Meditation',
        'subtitle': '15 Minute Guided Session',
        'background': 'assets/lounge_slideshow_bg_1.png',
      },
      {
        'title': 'Relaxing Meditation',
        'subtitle': '30 Audio and Video Series',
        'background': 'assets/lounge_slideshow_bg_2.png',
      },
      {
        'title': 'Deep Breathing',
        'subtitle': 'Stress Relief Techniques',
        'background': 'assets/lounge_slideshow_bg_3.png',
      },
      {
        'title': 'Mindful Walking',
        'subtitle': 'Outdoor Mindfulness Practice',
        'background': 'assets/lounge_slideshow_bg_4.png',
      },
    ];

        return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _slideshowController,
        itemCount: slideshowData.length,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final data = slideshowData[index];
          return Container(
            width: 240,
            margin: EdgeInsets.only(right: 16),
            child: _buildSlideshowCard(
              title: data['title']!,
              subtitle: data['subtitle']!,
              backgroundImage: data['background']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlideshowCard({
    required String title,
    required String subtitle,
    required String backgroundImage,
  }) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            // Background image with reduced saturation and blur
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix([
                      0.6, 0.0, 0.0, 0.0, 0.0,
                      0.0, 0.6, 0.0, 0.0, 0.0,
                      0.0, 0.0, 0.6, 0.0, 0.0,
                      0.0, 0.0, 0.0, 1.0, 0.0,
                    ]),
                    child: Image.asset(
                      backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Gradient overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Title and subtitle at the top
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Spacer to push icons to bottom
                  Spacer(),
                  // Bottom row with icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bottom left - empty star icon
                      Icon(Icons.star_border,
                        color: Colors.white,
                        size: 24,
                      ),
                      // Bottom right - another icon (using headphones as per design)
                      Icon(Icons.headphones,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
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