// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';
import 'package:nirva_app/api_models.dart';
part 'hive_object.g.dart';

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class Favorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  Favorites({required this.favoriteIds});
}

// 本机存储UserToken
@HiveType(typeId: 2)
class UserToken extends HiveObject {
  @HiveField(0)
  String access_token;

  @HiveField(1)
  String token_type;

  @HiveField(2)
  String refresh_token; // 新增字段

  UserToken({
    required this.access_token,
    required this.token_type,
    required this.refresh_token,
  });
}

// ChatMessage 在 Hive 中的存储模型
@HiveType(typeId: 3)
class HiveChatMessage {
  @HiveField(0)
  String id;

  @HiveField(1)
  int role;

  @HiveField(2)
  String content;

  @HiveField(3)
  String time_stamp;

  @HiveField(4)
  List<String>? tags;

  HiveChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.time_stamp,
    this.tags,
  });

  // 转换为 API 模型中的 ChatMessage
  ChatMessage toChatMessage() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      time_stamp: time_stamp,
      tags: tags,
    );
  }

  // 从 API 模型的 ChatMessage 创建 Hive 模型
  static HiveChatMessage fromChatMessage(ChatMessage message) {
    return HiveChatMessage(
      id: message.id,
      role: message.role,
      content: message.content,
      time_stamp: message.time_stamp,
      tags: message.tags,
    );
  }
}

// 存储聊天历史的容器
//如果聊天历史较大，可能需要考虑分页加载或按会话存储的优化策略!!!!!!!!
@HiveType(typeId: 4)
class ChatHistory extends HiveObject {
  @HiveField(0)
  List<HiveChatMessage> messages;

  ChatHistory({required this.messages});
}
