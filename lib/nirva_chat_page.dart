import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
import 'package:nirva_app/providers/call_provider.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/nirva_call_screen.dart';
import 'package:intl/intl.dart';
import 'package:nirva_app/mini_call_bar.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;
  
  DottedLinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NirvaChatPage extends StatefulWidget {
  const NirvaChatPage({super.key});

  @override
  State<NirvaChatPage> createState() => _NirvaChatPageState();
}

class _NirvaChatPageState extends State<NirvaChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  bool _isLoadingMore = false;
  bool _showLoadMore = false; // Changed to false - will be determined by actual history
  bool _isWaitingForResponse = false; // Track if we're waiting for AI response
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    // Load existing chat history from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
      // Chat history is already loaded from Hive by the provider
      // Just scroll to bottom if there are messages
      if (chatProvider.chatHistory.isNotEmpty) {
        _scrollToBottomWithDelay();
      }
      // Check if we should show "load more" based on message count
      setState(() {
        _showLoadMore = chatProvider.chatHistory.length >= 20; // Show if we have many messages
      });
    });
  }

  void _scrollToBottomWithDelay() {
    // Use multiple post frame callbacks to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottomImmediate();
        });
      });
    });
  }

  void _scrollToBottomImmediate() {
    // Use a small delay for immediate scroll to ensure content is laid out
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _scrollToBottom() {
    // Delay to ensure layout is complete, especially for long messages
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildAudioMessageContent(ChatMessage message) {
    return Row(
      children: [
        // Play button
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF0E3C26),
            shape: BoxShape.circle,
          ),
                        child: const Icon(
                Icons.play_arrow_outlined,
                color: Colors.white,
                size: 16,
              ),
        ),
        const SizedBox(width: 16),
        // Audio waveform - expanded with more bars
        Expanded(
          child: Row(
            children: [
              _buildAudioWaveformBar(0.3),
              _buildAudioWaveformBar(0.7),
              _buildAudioWaveformBar(0.5),
              _buildAudioWaveformBar(0.9),
              _buildAudioWaveformBar(0.4),
              _buildAudioWaveformBar(0.6),
              _buildAudioWaveformBar(0.8),
              _buildAudioWaveformBar(0.3),
              _buildAudioWaveformBar(0.5),
              _buildAudioWaveformBar(0.7),
              _buildAudioWaveformBar(0.4),
              _buildAudioWaveformBar(0.8),
              _buildAudioWaveformBar(0.6),
              _buildAudioWaveformBar(0.9),
              _buildAudioWaveformBar(0.3),
              _buildAudioWaveformBar(0.7),
              _buildAudioWaveformBar(0.5),
              _buildAudioWaveformBar(0.8),
              _buildAudioWaveformBar(0.4),
              _buildAudioWaveformBar(0.6),
              _buildAudioWaveformBar(0.7),
              _buildAudioWaveformBar(0.5),
              _buildAudioWaveformBar(0.8),
              _buildAudioWaveformBar(0.3),
              _buildAudioWaveformBar(0.6),
              _buildAudioWaveformBar(0.9),
              _buildAudioWaveformBar(0.4),
              _buildAudioWaveformBar(0.7),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Duration text
        Text(
          '0:23',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAudioWaveformBar(double height) {
    return Container(
      width: 3,
      height: 20 * height,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3C26),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPhotoMessageContent(ChatMessage message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/chat_sample_photo.jpg',
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image is not found
          return Container(
            width: 200,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFf4e4b3), // Light yellow
                  Color(0xFFe7bf57), // Golden yellow
                  Color(0xFFd4a574), // Warm brown
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                                          Icon(
                          Icons.restaurant_outlined,
                          color: Color(0xFF0E3C26),
                          size: 40,
                        ),
                  SizedBox(height: 8),
                  Text(
                    'Stir-fried Noodles',
                    style: TextStyle(
                      color: Color(0xFF0E3C26),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFFf0efea),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Nirva is typing...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);
    
    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM d').format(date);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              painter: DottedLinePainter(color: Colors.grey.shade300),
              child: Container(height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dateText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: DottedLinePainter(color: Colors.grey.shade300),
              child: Container(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }



  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading delay for UX
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real implementation, you would:
    // 1. Load older messages from local storage (Hive)
    // 2. Or fetch message history from the server if implemented
    // For now, we just work with what's in the ChatHistoryProvider
    
    if (mounted) {
      final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
      
      // Check if we have enough messages to warrant "load more"
      // In the future, this could paginate through older messages
      final totalMessages = chatProvider.chatHistory.length;
      
      setState(() {
        _isLoadingMore = false;
        // Hide load more if we don't have many messages
        _showLoadMore = totalMessages > 50; // Only show if we have lots of messages
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    // Clear text field immediately for better UX
    _textController.clear();
    
    // NirvaAPI.chat now adds the user message immediately before sending request
    // So user sees their message right away
    
    // Scroll to show the new message
    _scrollToBottom();

    // Show that we're waiting for a response (but don't block sending)
    setState(() {
      _isWaitingForResponse = true;
    });

    // Send to server asynchronously without blocking UI
    try {
      // Call the API - it will add user message immediately, then wait for response
      final response = await NirvaAPI.chat(message, context);
      
      if (response == null) {
        // Show error if response is null
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get response from Nirva'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // AI response has been added by NirvaAPI, just scroll
        _scrollToBottom();
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWaitingForResponse = false;
        });
      }
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // TODO: Implement actual audio recording
      // 1. Start recording audio
      // 2. Save audio file locally
      // 3. Upload to S3 if needed
      // 4. Transcribe audio to text
      // 5. Send transcribed text via NirvaAPI.chat()
      
      // For now, just simulate with a delayed stop
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
          });
          // TODO: Once audio is transcribed, send it as a regular message
          // For now, show a placeholder message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audio recording feature coming soon!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    } else {
      // Stop recording
      // TODO: Stop audio recording and process the audio
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFfaf9f5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_outlined, color: Color(0xFF0E3C26)),
              title: const Text('Photo or Video'),
              onTap: () {
                Navigator.pop(context);
                // Handle photo/video selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file_outlined, color: Color(0xFF0E3C26)),
              title: const Text('Document'),
              onTap: () {
                Navigator.pop(context);
                // Handle document selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined, color: Color(0xFF0E3C26)),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                // Handle location sharing
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == MessageRole.human;
    final isSpecialNirva = message.content.contains('*') && message.role == MessageRole.ai;
    final isAudioMessage = message.content.contains('🎤') || message.content.contains('Audio message');
    final isPhotoMessage = message.content.contains('📸') || message.content.contains('Photo message');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSpecialNirva
                    ? const Color(0xFFe7bf57).withOpacity(0.1)
                    : isUser
                        ? Colors.white
                        : const Color(0xFFf4e4b3), // Lighter yellow for Nirva's messages
                borderRadius: BorderRadius.circular(20),
                border: isSpecialNirva
                    ? Border.all(color: const Color(0xFFe7bf57), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSpecialNirva) ...[
                    Row(
                      children: [
                        const                         Icon(
                          Icons.star_outlined,
                          color: Color(0xFFe7bf57),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Nirva Special',
                          style: TextStyle(
                            color: const Color(0xFFe7bf57),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (isAudioMessage) ...[
                    _buildAudioMessageContent(message),
                  ] else if (isPhotoMessage) ...[
                    _buildPhotoMessageContent(message),
                  ] else ...[
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? const Color(0xFF0E3C26) : const Color(0xFF0E3C26),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(DateTime.parse(message.time_stamp).toLocal()),
                    style: TextStyle(
                      color: isUser ? Colors.grey.shade600 : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to match the background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFfaf9f5),
        systemNavigationBarColor: Color(0xFFfaf9f5),
      ),
    );
    
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf9f5),
        surfaceTintColor: const Color(0xFFfaf9f5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Color(0xFF0E3C26)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFe7bf57),
              child: const Icon(
                Icons.water_drop_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nirva',
                  style: TextStyle(
                    color: Color(0xFF0E3C26),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: Color(0xFF0E3C26)),
            onPressed: () {
              // Show search functionality
            },
            padding: const EdgeInsets.all(4),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: Color(0xFF0E3C26)),
            onPressed: () {
              final callProvider = Provider.of<CallProvider>(context, listen: false);
              callProvider.startCall();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NirvaCallScreen(),
                ),
              );
            },
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Consumer<ChatHistoryProvider>(
                    builder: (context, chatProvider, child) {
                      // Auto-scroll to bottom when new messages are added
                      if (chatProvider.chatHistory.length > _previousMessageCount && _previousMessageCount > 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottomImmediate();
                        });
                      }
                      _previousMessageCount = chatProvider.chatHistory.length;
                      
                      // Build list with date dividers
                      final List<Widget> items = [];
                      
                      if (_showLoadMore) {
                        items.add(_buildLoadMoreButton());
                      }
                      
                      DateTime? lastMessageDate;
                      
                      for (int i = 0; i < chatProvider.chatHistory.length; i++) {
                        final message = chatProvider.chatHistory[i];
                        final messageDate = DateTime.parse(message.time_stamp).toLocal();
                        final currentMessageDate = DateTime(messageDate.year, messageDate.month, messageDate.day);
                        
                        // Add date divider if this is a new day, but not if it's the first message
                        if (lastMessageDate == null || currentMessageDate.isAfter(lastMessageDate)) {
                          // Don't show divider if this is the first message in the loaded list
                          // or if there's a "Load more" button above it
                          if (i > 0 && !(_showLoadMore && items.length == 1)) {
                            items.add(_buildDateDivider(messageDate));
                          }
                          lastMessageDate = currentMessageDate;
                        }
                        
                        items.add(_buildMessageBubble(message));
                      }
                      
                      // Add a loading indicator at the bottom if waiting for response
                      if (_isWaitingForResponse) {
                        items.add(_buildLoadingIndicator());
                      }
                      
                      return GestureDetector(
                        onTap: () {
                          // Dismiss keyboard when tapping in chat area
                          FocusScope.of(context).unfocus();
                        },
                        onVerticalDragStart: (_) {
                          // Dismiss keyboard when starting to scroll/drag
                          FocusScope.of(context).unfocus();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return items[index];
                          },
                        ),
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
            // Mini call bar
            const MiniCallBar(hasBottomNavigation: false),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Center(
        child: TextButton(
          onPressed: _isLoadingMore ? null : _loadMoreMessages,
          child: _isLoadingMore
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0E3C26)),
                  ),
                )
              : const Text(
                  'Load more...',
                  style: TextStyle(
                    color: Color(0xFF0E3C26),
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    // Check if keyboard is visible
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 24, isKeyboardVisible ? 12 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
                      IconButton(
              icon: const Icon(Icons.attach_file_outlined, color: Color(0xFF0E3C26)),
              onPressed: _showAttachmentOptions,
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFfaf9f5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      // Never disable - user can send multiple messages
                      decoration: InputDecoration(
                        hintText: _isWaitingForResponse ? 'Waiting for Nirva...' : 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onTap: () {
                        // Auto-scroll to bottom when focusing the input
                        _scrollToBottom();
                      },
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                                      IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic_none_outlined,
                        color: _isRecording ? Colors.red : const Color(0xFF0E3C26),
                      ),
                      onPressed: _toggleRecording,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
                      Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF0E3C26),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_outlined, color: Colors.white, size: 18),
                onPressed: _sendMessage, // Never disabled - user can send anytime
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

} 