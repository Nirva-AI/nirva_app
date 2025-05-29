// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
import 'package:freezed_annotation/freezed_annotation.dart';
part 'api.freezed.dart';
part 'api.g.dart';

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

@freezed
class Token with _$Token {
  const factory Token({
    required String access_token,
    required String token_type,
    required String refresh_token, // 新增字段
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Token).toJson();
}

//聊天请求
@freezed
class ChatActionRequest with _$ChatActionRequest {
  const factory ChatActionRequest({
    required String user_name,
    required String content,
  }) = _ChatActionRequest;

  factory ChatActionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatActionRequestFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ChatActionRequest).toJson();
}

@freezed
class ChatActionResponse with _$ChatActionResponse {
  const factory ChatActionResponse({
    required int error,
    required String message,
  }) = _ChatActionResponse;

  factory ChatActionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatActionResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ChatActionResponse).toJson();
}
