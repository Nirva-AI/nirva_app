// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
import 'package:freezed_annotation/freezed_annotation.dart';
part 'api.freezed.dart';
part 'api.g.dart';

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
