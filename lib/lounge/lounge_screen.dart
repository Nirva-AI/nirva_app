import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoungeScreen extends StatefulWidget {
  const LoungeScreen({super.key});

  @override
  State<LoungeScreen> createState() => _LoungeScreenState();
}

class _LoungeScreenState extends State<LoungeScreen> {
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
                        fontSize: 52,
                        fontWeight: FontWeight.w500, // Medium weight - between light and bold
                        color: Colors.white.withOpacity(0.85),
                        height: 1.1,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
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
            // Menu/Todo button on top right
            Positioned(
              top: 90,
              right: 20,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 