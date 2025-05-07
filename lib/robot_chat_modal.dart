import 'package:flutter/material.dart';

// 写一个枚举类，表示消息的角色，目前只有AI 和用户和非法。
enum ChatRole { user, ai, illegal }

// 基础消息类
class BaseMessage {
  final ChatRole role;
  final String content;

  BaseMessage({required this.role, required this.content});
}

// AI 消息类
class AIMessage extends BaseMessage {
  AIMessage({required super.content}) : super(role: ChatRole.ai);
}

// 用户消息类
class UserMessage extends BaseMessage {
  UserMessage({required super.content}) : super(role: ChatRole.user);
}

class ChatMessageManager {
  // 单例实例
  static final ChatMessageManager _instance = ChatMessageManager._internal();

  // 私有构造函数
  ChatMessageManager._internal();

  // 获取单例实例
  factory ChatMessageManager() => _instance;

  // 存储对话记录
  final ValueNotifier<List<BaseMessage>> _chatMessages = ValueNotifier([]);

  // 添加消息
  void _addMessage(BaseMessage message) {
    _chatMessages.value = [..._chatMessages.value, message];
  }

  // 添加AI消息
  void addAIMessage(String content) {
    _addMessage(AIMessage(content: content));
  }

  // 添加用户消息
  void addUserMessage(String content) {
    _addMessage(UserMessage(content: content));
  }

  // 删除消息（根据索引）
  void removeMessage(int index) {
    if (index >= 0 && index < _chatMessages.value.length) {
      final updatedMessages = List<BaseMessage>.from(_chatMessages.value);
      updatedMessages.removeAt(index);
      _chatMessages.value = updatedMessages;
    }
  }

  // 获取所有消息
  ValueNotifier<List<BaseMessage>> getMessages() {
    return _chatMessages;
  }
}

class RobotChatModal extends StatelessWidget {
  final ValueNotifier<List<BaseMessage>> chatMessages;
  final TextEditingController textController;
  final Function(String) onSend;

  const RobotChatModal({
    super.key,
    required this.chatMessages,
    required this.textController,
    required this.onSend,
  });

  //
  String _getContent(BaseMessage message) {
    if (message.role == ChatRole.user) {
      return 'You: ${message.content}';
    } else if (message.role == ChatRole.ai) {
      return 'Nirva: ${message.content}';
    } else {
      return 'Illegal: ${message.content}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<List<BaseMessage>>(
              valueListenable: chatMessages,
              builder: (context, chatMessagesValue, _) {
                return ListView.builder(
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
                            color: isUser ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            //message.content,
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
                        onSend(message);
                        textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
