import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/chat_history_provider.dart';
import 'package:nirva_app/api_models.dart';
import 'package:intl/intl.dart';

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
  bool _showLoadMore = true;
  int _previousMessageCount = 0;

  // Mock chat messages
  final List<ChatMessage> _mockMessages = [
    ChatMessage(
      id: '1',
      role: MessageRole.ai,
      content: 'Good morning! 🌅 How are you feeling today? I noticed you had a late night yesterday.',
      time_stamp: DateTime.now().subtract(const Duration(days: 3, hours: 9)).toIso8601String(),
    ),
    ChatMessage(
      id: '2',
      role: MessageRole.human,
      content: 'Morning! Actually feeling pretty good despite the late night. That meditation session you suggested really helped me unwind.',
      time_stamp: DateTime.now().subtract(const Duration(days: 3, hours: 8, minutes: 45)).toIso8601String(),
    ),
    ChatMessage(
      id: '3',
      role: MessageRole.ai,
      content: 'I\'m so glad it helped! Sometimes we just need to slow down and breathe. What\'s on your agenda today?',
      time_stamp: DateTime.now().subtract(const Duration(days: 3, hours: 8, minutes: 30)).toIso8601String(),
    ),
    ChatMessage(
      id: '4',
      role: MessageRole.human,
      content: '📸 Photo message',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 14)).toIso8601String(),
    ),
    ChatMessage(
      id: '5',
      role: MessageRole.human,
      content: 'Just had the most amazing lunch! 🍜 This ramen place downtown is incredible. You have to try it sometime.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 13, minutes: 55)).toIso8601String(),
    ),
    ChatMessage(
      id: '6',
      role: MessageRole.ai,
      content: 'That looks absolutely delicious! I\'m so jealous. What kind of ramen did you get? The broth looks rich and flavorful.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 13, minutes: 40)).toIso8601String(),
    ),
    ChatMessage(
      id: '7',
      role: MessageRole.human,
      content: 'Tonkotsu with extra chashu! It was perfect comfort food. I was thinking about what you said yesterday about treating myself better.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 13, minutes: 25)).toIso8601String(),
    ),
    ChatMessage(
      id: '8',
      role: MessageRole.ai,
      content: 'That\'s exactly what I mean! You deserve to enjoy the little moments. How did it make you feel?',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 13, minutes: 10)).toIso8601String(),
    ),
    ChatMessage(
      id: '9',
      role: MessageRole.human,
      content: 'Really grateful and present. I actually put my phone away and just savored every bite. It\'s been a while since I did that.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 12, minutes: 55)).toIso8601String(),
    ),
    ChatMessage(
      id: '10',
      role: MessageRole.ai,
      content: 'That\'s beautiful! Mindful eating is such a powerful practice. I\'m proud of you for being so intentional about it.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 12, minutes: 40)).toIso8601String(),
    ),
    ChatMessage(
      id: '11',
      role: MessageRole.human,
      content: 'Thanks! It felt really good. I\'ve been thinking about our conversation about boundaries too. I said no to that extra project at work.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 12, minutes: 25)).toIso8601String(),
    ),
    ChatMessage(
      id: '12',
      role: MessageRole.ai,
      content: 'That\'s a huge step! How did it feel to prioritize yourself? I know that wasn\'t easy for you.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 12, minutes: 10)).toIso8601String(),
    ),
    ChatMessage(
      id: '13',
      role: MessageRole.human,
      content: 'Scary at first, but really empowering. My boss was actually understanding about it. I think I\'ve been overthinking these situations.',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 11, minutes: 55)).toIso8601String(),
    ),
    ChatMessage(
      id: '14',
      role: MessageRole.ai,
      content: 'You absolutely have been! It\'s amazing how our fears often don\'t match reality. This is such great progress. 🌟',
      time_stamp: DateTime.now().subtract(const Duration(days: 2, hours: 11, minutes: 40)).toIso8601String(),
    ),
    ChatMessage(
      id: '15',
      role: MessageRole.human,
      content: 'I finished that book you recommended last night. The ending was unexpected but perfect.',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)).toIso8601String(),
    ),
    ChatMessage(
      id: '16',
      role: MessageRole.ai,
      content: 'Right?! I was shocked too. What did you think of the main character\'s decision?',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 7, minutes: 45)).toIso8601String(),
    ),
    ChatMessage(
      id: '17',
      role: MessageRole.human,
      content: 'I think she made the right choice, even though it was hard. Sometimes you have to put yourself first, just like we talked about.',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 7, minutes: 30)).toIso8601String(),
    ),
    ChatMessage(
      id: '18',
      role: MessageRole.ai,
      content: 'Exactly! That\'s what I loved about it. It felt so real and relatable. The author really captured that internal struggle.',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 7, minutes: 15)).toIso8601String(),
    ),
    ChatMessage(
      id: '19',
      role: MessageRole.human,
      content: 'I\'ve been journaling about it too. It\'s helping me process some of my own decisions lately.',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 7)).toIso8601String(),
    ),
    ChatMessage(
      id: '20',
      role: MessageRole.ai,
      content: 'That\'s wonderful! Journaling is such a powerful tool for self-reflection. I\'d love to hear your thoughts if you want to share.',
      time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 6, minutes: 45)).toIso8601String(),
    ),
    ChatMessage(
      id: '21',
      role: MessageRole.human,
      content: 'Maybe later. Right now I should focus on this project deadline. It\'s stressing me out a bit.',
      time_stamp: DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    ),
    ChatMessage(
      id: '22',
      role: MessageRole.ai,
      content: 'You\'ve got this! Remember to take breaks and breathe. Want to grab coffee later?',
      time_stamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 55)).toIso8601String(),
    ),
    ChatMessage(
      id: '23',
      role: MessageRole.human,
      content: 'That sounds perfect. I\'ll text you when I\'m done.',
      time_stamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)).toIso8601String(),
    ),
    ChatMessage(
      id: '24',
      role: MessageRole.human,
      content: '🎤 Audio message (0:03)',
      time_stamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)).toIso8601String(),
    ),
    ChatMessage(
      id: '25',
      role: MessageRole.ai,
      content: 'Haha, I can hear how excited you are about finishing that project! We should definitely celebrate together.',
      time_stamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)).toIso8601String(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with mock data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
      chatProvider.setupChatHistory(_mockMessages);
      // Scroll to bottom after initializing chat history with multiple frames
      _scrollToBottomWithDelay();
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
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
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
          '0:03',
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

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    // Add more mock messages
    final moreMessages = [
      ChatMessage(
        id: '16',
        role: MessageRole.human,
        content: 'How did you know I needed to talk about this?',
        time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)).toIso8601String(),
      ),
      ChatMessage(
        id: '17',
        role: MessageRole.ai,
        content: 'I noticed from your recent journal entries that you\'ve been mentioning work stress more frequently. I wanted to check in and see how you\'re doing.',
        time_stamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 55)).toIso8601String(),
      ),
    ];

    if (mounted) {
      final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
      chatProvider.addChatMessages(moreMessages);

      setState(() {
        _isLoadingMore = false;
        _showLoadMore = false; // Hide after loading more
      });
    }
  }

  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.human,
      content: message,
      time_stamp: DateTime.now().toIso8601String(),
    );

    chatProvider.addMessage(userMessage);
    _textController.clear();

    // Simulate Nirva response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final response = ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          role: MessageRole.ai,
          content: 'Thanks for sharing that with me. I\'m here to listen and support you. Is there anything specific you\'d like to explore together?',
          time_stamp: DateTime.now().toIso8601String(),
        );
        chatProvider.addMessage(response);
      }
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // Simulate recording
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
          });
          // Add audio message
          final chatProvider = Provider.of<ChatHistoryProvider>(context, listen: false);
          final audioMessage = ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: MessageRole.human,
            content: '🎤 Audio message (0:03)',
            time_stamp: DateTime.now().toIso8601String(),
          );
          chatProvider.addMessage(audioMessage);
        }
      });
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
                    DateFormat('HH:mm').format(DateTime.parse(message.time_stamp)),
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
              child: const Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
              // Call Nirva functionality
            },
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
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
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    itemCount: chatProvider.chatHistory.length + (_showLoadMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && _showLoadMore) {
                        return _buildLoadMoreButton();
                      }
                      
                      final messageIndex = _showLoadMore ? index - 1 : index;
                      final message = chatProvider.chatHistory[messageIndex];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 24),
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
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
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
                onPressed: _sendMessage,
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }
} 