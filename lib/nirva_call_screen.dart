import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/call_provider.dart';
import 'dart:async';
import 'dart:math' as math;

class NirvaCallScreen extends StatefulWidget {
  final bool isIncoming;
  
  const NirvaCallScreen({
    super.key,
    this.isIncoming = false,
  });

  @override
  State<NirvaCallScreen> createState() => _NirvaCallScreenState();
}

class _NirvaCallScreenState extends State<NirvaCallScreen>
    with TickerProviderStateMixin {
  bool _isTalkingAnimationActive = false;
  
  late AnimationController _ringingController;
  late AnimationController _pulseController;
  late AnimationController _minimizeController;
  late AnimationController _talkingController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _minimizeAnimation;
  late Animation<double> _talkingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCall();
  }

  void _initializeAnimations() {
    // Ringing animation for dots
    _ringingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Pulse animation for avatar
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Minimize animation
    _minimizeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _minimizeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _minimizeController,
      curve: Curves.easeInOut,
    ));

    // Talking animation for connected state
    _talkingController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _talkingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _talkingController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _ringingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    // Don't start talking animation yet - it will be started after delay
  }

  void _startCall() {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    // Simulate Nirva picking up after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        callProvider.connectCall();
        _ringingController.stop();
        _pulseController.stop();
        // Start talking animation after 3 more seconds
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTalkingAnimationActive = true;
            });
            _talkingController.repeat();
          }
        });
      }
    });
  }

  void _endCall() {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.endCall();
    _ringingController.stop();
    _pulseController.stop();
    _talkingController.stop();
    setState(() {
      _isTalkingAnimationActive = false;
    });
    
    // Navigate back after a short delay
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _toggleMinimize() {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.toggleMinimize();
    
    if (callProvider.isMinimized) {
      _minimizeController.forward();
      Navigator.of(context).pop();
    } else {
      _minimizeController.reverse();
    }
  }

  void _toggleMute() {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.toggleMute();
  }

  void _toggleSpeaker() {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    callProvider.toggleSpeaker();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ringingController.dispose();
    _pulseController.dispose();
    _minimizeController.dispose();
    _talkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        if (callProvider.isMinimized) {
          return _buildFloatingCallBar();
        }
        
        return _buildFullScreenCall();
      },
    );
  }

  Widget _buildFullScreenCall() {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFf4e4b3),
              Color(0xFFfaf9f5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with minimize button
              _buildTopSection(),
              
              // Main content
              Expanded(
                child: Consumer<CallProvider>(
                  builder: (context, callProvider, child) {
                    return callProvider.callState == CallState.ringing
                        ? _buildRingingContent()
                        : _buildConnectedContent();
                  },
                ),
              ),
              
              // Bottom controls
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF0E3C26),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 48), // Balance the layout
            ],
          ),
        );
      },
    );
  }

  Widget _buildRingingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated avatar with enhanced pulse effect
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFe7bf57),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFe7bf57).withOpacity(0.3 * _pulseAnimation.value),
                      blurRadius: 20 * _pulseAnimation.value,
                      spreadRadius: 5 * _pulseAnimation.value,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: Colors.white,
                    size: 72,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 150),
        
        // Ringing dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _ringingController,
              builder: (context, child) {
                final delay = index * 0.2;
                final animationValue = (_ringingController.value + delay) % 1.0;
                final opacity = (animationValue * 2).clamp(0.0, 1.0);
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E3C26).withOpacity(opacity),
                    shape: BoxShape.circle,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildConnectedContent() {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Connected avatar with talking animation
            AnimatedBuilder(
              animation: _isTalkingAnimationActive ? _talkingAnimation : const AlwaysStoppedAnimation(0.0),
              builder: (context, child) {
                // Create complex, somewhat random glow patterns with bounds checking
                final baseGlow = (0.4 + (0.6 * _talkingAnimation.value)).clamp(0.0, 1.0);
                final pulseGlow = (0.3 + (0.5 * (0.5 + 0.5 * math.sin(_talkingAnimation.value * 12 * math.pi)))).clamp(0.0, 1.0);
                final randomGlow = (0.2 + (0.4 * (0.3 + 0.7 * math.sin(_talkingAnimation.value * 20 * math.pi)))).clamp(0.0, 1.0);
                
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFe7bf57),
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Inner glow
                      BoxShadow(
                        color: const Color(0xFFe7bf57).withOpacity(baseGlow.clamp(0.0, 1.0)),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      // Outer pulse glow
                      BoxShadow(
                        color: const Color(0xFFe7bf57).withOpacity((pulseGlow * 0.8).clamp(0.0, 1.0)),
                        blurRadius: (50 + (30 * pulseGlow)).clamp(0.0, 100.0),
                        spreadRadius: (15 + (10 * pulseGlow)).clamp(0.0, 50.0),
                      ),
                      // Random accent glow
                      BoxShadow(
                        color: const Color(0xFFe7bf57).withOpacity((randomGlow * 0.7).clamp(0.0, 1.0)),
                        blurRadius: (70 + (40 * randomGlow)).clamp(0.0, 150.0),
                        spreadRadius: (25 + (15 * randomGlow)).clamp(0.0, 80.0),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 80),
            
            const Text(
              'Nirva',
              style: TextStyle(
                color: Color(0xFF0E3C26),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              _formatDuration(callProvider.callDuration),
              style: const TextStyle(
                color: Color(0xFF0E3C26),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mute button
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: callProvider.isMuted ? const Color(0xFFe7bf57) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    callProvider.isMuted ? Icons.mic_off : Icons.mic,
                    color: callProvider.isMuted ? Colors.white : const Color(0xFF0E3C26),
                    size: 28,
                  ),
                  onPressed: _toggleMute,
                ),
              ),
              
              // Speaker button
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: callProvider.isSpeakerOn ? const Color(0xFFe7bf57) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    callProvider.isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    color: callProvider.isSpeakerOn ? Colors.white : const Color(0xFF0E3C26),
                    size: 28,
                  ),
                  onPressed: _toggleSpeaker,
                ),
              ),
              
              // End call button
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: _endCall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildFloatingCallBar() {
    return Consumer<CallProvider>(
      builder: (context, callProvider, child) {
        return AnimatedBuilder(
          animation: _minimizeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_minimizeAnimation.value * 0.1),
              child: Opacity(
                opacity: 1.0 - _minimizeAnimation.value,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                      // Avatar
                      Container(
                        margin: const EdgeInsets.all(12),
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFe7bf57),
                          shape: BoxShape.circle,
                        ),
                                    child: const Center(
              child: Icon(
                Icons.water_drop_outlined,
                color: Colors.white,
                size: 36,
              ),
            ),
                      ),
                      
                      // Call info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              _formatDuration(callProvider.callDuration),
                              style: const TextStyle(
                                color: Color(0xFF0E3C26),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Controls
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              callProvider.isMuted ? Icons.mic_off : Icons.mic,
                              color: callProvider.isMuted ? const Color(0xFFe7bf57) : const Color(0xFF0E3C26),
                            ),
                            onPressed: _toggleMute,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.red,
                            ),
                            onPressed: _endCall,
                          ),
                                                  IconButton(
                          icon: const Icon(
                            Icons.open_in_full_outlined,
                            color: Color(0xFF0E3C26),
                          ),
                          onPressed: _toggleMinimize,
                        ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
} 