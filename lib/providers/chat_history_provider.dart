import 'package:flutter/foundation.dart';
import 'package:nirva_app/api_models.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:logger/logger.dart';

class ChatHistoryProvider extends ChangeNotifier {
  List<ChatMessage> _chatHistory = [];

  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  /// 设置聊天历史（用于初始化数据）
  void setupChatHistory(List<ChatMessage> messages) {
    _chatHistory = messages;
    notifyListeners();
  }

  /// 添加单条聊天消息
  void addMessage(ChatMessage message) {
    _chatHistory.add(message);
    notifyListeners();
  }

  /// 添加多条聊天消息到历史记录（保持与原 RuntimeData 兼容）
  void addChatMessages(List<ChatMessage> conversation) {
    _chatHistory.addAll(conversation);
    notifyListeners();
  }

  /// 在指定位置插入消息
  void insertMessage(int index, ChatMessage message) {
    if (index >= 0 && index <= _chatHistory.length) {
      _chatHistory.insert(index, message);
      notifyListeners();
    }
  }

  /// 移除指定消息
  void removeMessage(ChatMessage message) {
    if (_chatHistory.remove(message)) {
      notifyListeners();
    }
  }

  /// 根据索引移除消息
  void removeMessageAt(int index) {
    if (index >= 0 && index < _chatHistory.length) {
      _chatHistory.removeAt(index);
      notifyListeners();
    }
  }

  /// 更新指定位置的消息
  void updateMessage(int index, ChatMessage newMessage) {
    if (index >= 0 && index < _chatHistory.length) {
      _chatHistory[index] = newMessage;
      notifyListeners();
    }
  }

  /// 清空聊天历史
  void clearChatHistory() {
    _chatHistory.clear();
    notifyListeners();
  }

  /// 获取最后N条消息
  List<ChatMessage> getRecentMessages(int count) {
    if (count >= _chatHistory.length) {
      return chatHistory;
    }
    return _chatHistory.sublist(_chatHistory.length - count);
  }

  /// 获取用户消息数量
  int get userMessageCount {
    return _chatHistory.where((msg) => msg.role == MessageRole.human).length;
  }

  /// 获取助手消息数量
  int get assistantMessageCount {
    return _chatHistory.where((msg) => msg.role == MessageRole.ai).length;
  }

  /// 获取总消息数量
  int get messageCount => _chatHistory.length;

  /// 检查聊天历史是否为空
  bool get isEmpty => _chatHistory.isEmpty;

  /// 检查聊天历史是否不为空
  bool get isNotEmpty => _chatHistory.isNotEmpty;

  /// 根据内容搜索消息（本地搜索）
  List<ChatMessage> searchMessagesLocal(String query) {
    if (query.isEmpty) return chatHistory;
    return _chatHistory
        .where(
          (message) =>
              message.content.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// 获取最后一条消息
  ChatMessage? get lastMessage {
    return _chatHistory.isNotEmpty ? _chatHistory.last : null;
  }

  /// 获取最后一条用户消息
  ChatMessage? get lastUserMessage {
    for (int i = _chatHistory.length - 1; i >= 0; i--) {
      if (_chatHistory[i].role == MessageRole.human) {
        return _chatHistory[i];
      }
    }
    return null;
  }

  /// 获取最后一条助手消息
  ChatMessage? get lastAssistantMessage {
    for (int i = _chatHistory.length - 1; i >= 0; i--) {
      if (_chatHistory[i].role == MessageRole.ai) {
        return _chatHistory[i];
      }
    }
    return null;
  }

  /// Clear all chat history data (used on logout)
  void clearData() {
    _chatHistory = [];
    notifyListeners();
  }

  /// 从服务器同步对话历史记录
  Future<bool> syncFromServer({int limit = 50, int offset = 0}) async {
    try {
      Logger().i('Syncing conversation history from server...');
      
      final response = await NirvaAPI.getConversationHistory(
        limit: limit,
        offset: offset,
      );

      if (response == null) {
        Logger().e('Failed to sync conversation history from server');
        return false;
      }

      final messages = response['messages'] as List<dynamic>?;
      if (messages == null) {
        Logger().w('No messages in server response');
        return true; // Empty is valid
      }

      // Convert server response to ChatMessage objects
      final serverMessages = messages
          .map((messageJson) => ChatMessage.fromJson(messageJson as Map<String, dynamic>))
          .toList();

      // Replace local history with server data if offset is 0
      // Otherwise append for pagination
      if (offset == 0) {
        _chatHistory = serverMessages;
        Logger().i('Replaced local chat history with ${serverMessages.length} messages from server');
      } else {
        // Insert at beginning for pagination (older messages)
        _chatHistory.insertAll(0, serverMessages);
        Logger().i('Added ${serverMessages.length} older messages from server');
      }

      // Save to local storage
      HiveHelper.saveChatHistory(_chatHistory);
      notifyListeners();

      Logger().i('Successfully synced conversation history');
      return true;
    } catch (e) {
      Logger().e('Error syncing conversation history: $e');
      return false;
    }
  }

  /// 搜索对话消息
  Future<List<ChatMessage>?> searchMessages(String query) async {
    try {
      if (query.trim().isEmpty) {
        return chatHistory; // Return all messages for empty query
      }

      Logger().i('Searching conversation for: $query');
      
      final response = await NirvaAPI.searchConversation(query: query);
      if (response == null) {
        Logger().e('Failed to search conversation');
        return null;
      }

      final messages = response['messages'] as List<dynamic>?;
      if (messages == null) {
        return [];
      }

      return messages
          .map((messageJson) => ChatMessage.fromJson(messageJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Logger().e('Error searching conversation: $e');
      return null;
    }
  }

  /// 获取对话统计信息
  Future<Map<String, dynamic>?> getConversationStats() async {
    try {
      return await NirvaAPI.getConversationStats();
    } catch (e) {
      Logger().e('Error getting conversation stats: $e');
      return null;
    }
  }
}
