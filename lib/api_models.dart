// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
import 'package:freezed_annotation/freezed_annotation.dart';
part 'api_models.freezed.dart';
part 'api_models.g.dart';

// url配置
@freezed
class URLConfigurationResponse with _$URLConfigurationResponse {
  const factory URLConfigurationResponse({
    required String api_version,
    required Map<String, String> endpoints,
    required bool deprecated,
    required String notice,
  }) = _URLConfigurationResponse;

  factory URLConfigurationResponse.fromJson(Map<String, dynamic> json) =>
      _$URLConfigurationResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _URLConfigurationResponse).toJson();
}

class MessageRole {
  static const int system = 0; // 0
  static const int human = 1; // 1
  static const int ai = 2; // 2
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required int role,
    required String content,
    required String time_stamp,
    List<String>? tags, // 可选参数
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ChatMessage).toJson();
}

@freezed
class ChatActionRequest with _$ChatActionRequest {
  const factory ChatActionRequest({
    required ChatMessage human_message,
    required List<ChatMessage> chat_history, // 可选参数
  }) = _ChatActionRequest;

  factory ChatActionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatActionRequestFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ChatActionRequest).toJson();
}

@freezed
class ChatActionResponse with _$ChatActionResponse {
  const factory ChatActionResponse({required ChatMessage ai_message}) =
      _ChatActionResponse;

  factory ChatActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatActionResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ChatActionResponse).toJson();
}
