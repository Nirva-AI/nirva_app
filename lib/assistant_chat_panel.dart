import 'package:flutter/material.dart';
import 'package:nirva_app/chat_manager.dart';
import 'package:nirva_app/message.dart';

class AssistantChatPanel extends StatelessWidget {
  final ValueNotifier<List<BaseMessage>> chatMessages;
  final TextEditingController textController;
  //final Function(String) onSend;
  final ScrollController _scrollController = ScrollController();

  AssistantChatPanel({
    super.key,
    required this.chatMessages,
    required this.textController,
    //required this.onSend,
  });

  String _getContent(BaseMessage message) {
    if (message.role == ChatRole.user) {
      return 'You: ${message.content}';
    } else if (message.role == ChatRole.ai) {
      return 'Nirva: ${message.content}';
    }
    return 'Illegal: ${message.content}';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40), // 占位，保持对称
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // 关闭软键盘
                    Navigator.pop(context); // 关闭当前界面
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<List<BaseMessage>>(
                valueListenable: chatMessages,
                builder: (context, chatMessagesValue, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom(); // 每次消息更新后滚动到底部
                  });
                  return ListView.builder(
                    controller: _scrollController, // 绑定 ScrollController
                    itemCount: chatMessagesValue.length,
                    itemBuilder: (context, index) {
                      final message = chatMessagesValue[index];
                      final isUser = message.role == ChatRole.user;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Align(
                          alignment:
                              isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              _getContent(message),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: '输入内容...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        final message = textController.text.trim();
                        if (message.isNotEmpty) {
                          //(message);
                          ChatManager().addUserMessage(message);
                          ChatManager().addAIMessage('回复: $message');
                          textController.clear();
                          _scrollToBottom(); // 发送消息后滚动到底部
                        }
                      },
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
}
