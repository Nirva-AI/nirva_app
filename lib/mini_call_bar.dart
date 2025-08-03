import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/call_provider.dart';
import 'package:nirva_app/nirva_call_screen.dart';
import 'package:nirva_app/nirva_chat_page.dart';

class MiniCallBar extends StatelessWidget {
  final bool hasBottomNavigation;
  
  const MiniCallBar({
    super.key,
    this.hasBottomNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        if (!callProvider.isInCall) {
          return const SizedBox.shrink();
        }
        
        return Positioned(
          bottom: hasBottomNavigation ? 8 : 100, // Same position as if footer exists (8px from footer, which is 80px from bottom)
          left: 16,
          right: 16,
          child: _buildCallBar(context, callProvider),
        );
      },
    );
  }

  Widget _buildCallBar(BuildContext context, CallProvider callProvider) {
    String formatDuration(int seconds) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

          return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Reduce width to 85% of screen width
          height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
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
            // Left side: Call info (Nirva name and time)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
                children: [
                  const Text(
                    'Nirva',
                    style: TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatDuration(callProvider.callDuration),
                    style: const TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Center: Nirva profile (hidden when footer is visible)
            if (!hasBottomNavigation)
              Expanded(
                flex: 1,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to chat screen - Flutter will handle if already on chat screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NirvaChatPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFe7bf57),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.water_drop_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            
            // Right side: Control buttons
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center align the buttons
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf5f5f5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.open_in_full_outlined,
                        color: Color(0xFF0E3C26),
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NirvaCallScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        callProvider.endCall();
                        callProvider.resetCall();
                      },
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
} 