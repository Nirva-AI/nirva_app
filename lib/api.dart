// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
import 'package:freezed_annotation/freezed_annotation.dart';
part 'api.freezed.dart';
part 'api.g.dart';

//api端点配置
@freezed
class APIEndpointConfiguration with _$APIEndpointConfiguration {
  const factory APIEndpointConfiguration({
    required String LOGIN_URL,
    required String LOGOUT_URL,
    required String CHAT_ACTION_URL,
  }) = _APIEndpointConfiguration;

  factory APIEndpointConfiguration.fromJson(Map<String, dynamic> json) =>
      _$APIEndpointConfigurationFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _APIEndpointConfiguration).toJson();
}

@freezed
class APIEndpointConfigurationResponse with _$APIEndpointConfigurationResponse {
  const factory APIEndpointConfigurationResponse({
    required APIEndpointConfiguration api_endpoints,
    required int error,
    required String message,
  }) = _APIEndpointConfigurationResponse;

  factory APIEndpointConfigurationResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$APIEndpointConfigurationResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      (this as _APIEndpointConfigurationResponse).toJson();
}

//登录请求
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({required String user_name}) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _LoginRequest).toJson();
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required int error, required String message}) =
      _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _LoginResponse).toJson();
}

//登出请求
@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({required String user_name}) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _LogoutRequest).toJson();
}

@freezed
class LogoutResponse with _$LogoutResponse {
  const factory LogoutResponse({required int error, required String message}) =
      _LogoutResponse;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _LogoutResponse).toJson();
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
