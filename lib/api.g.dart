// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$APIEndpointConfigurationImpl _$$APIEndpointConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$APIEndpointConfigurationImpl(
  LOGIN_URL: json['LOGIN_URL'] as String,
  LOGOUT_URL: json['LOGOUT_URL'] as String,
  CHAT_ACTION_URL: json['CHAT_ACTION_URL'] as String,
);

Map<String, dynamic> _$$APIEndpointConfigurationImplToJson(
  _$APIEndpointConfigurationImpl instance,
) => <String, dynamic>{
  'LOGIN_URL': instance.LOGIN_URL,
  'LOGOUT_URL': instance.LOGOUT_URL,
  'CHAT_ACTION_URL': instance.CHAT_ACTION_URL,
};

_$APIEndpointConfigurationResponseImpl
_$$APIEndpointConfigurationResponseImplFromJson(Map<String, dynamic> json) =>
    _$APIEndpointConfigurationResponseImpl(
      api_endpoints: APIEndpointConfiguration.fromJson(
        json['api_endpoints'] as Map<String, dynamic>,
      ),
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$APIEndpointConfigurationResponseImplToJson(
  _$APIEndpointConfigurationResponseImpl instance,
) => <String, dynamic>{
  'api_endpoints': instance.api_endpoints,
  'error': instance.error,
  'message': instance.message,
};

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(user_name: json['user_name'] as String);

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'user_name': instance.user_name};

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{'error': instance.error, 'message': instance.message};

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(user_name: json['user_name'] as String);

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{'user_name': instance.user_name};

_$LogoutResponseImpl _$$LogoutResponseImplFromJson(Map<String, dynamic> json) =>
    _$LogoutResponseImpl(
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$LogoutResponseImplToJson(
  _$LogoutResponseImpl instance,
) => <String, dynamic>{'error': instance.error, 'message': instance.message};

_$ChatActionRequestImpl _$$ChatActionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ChatActionRequestImpl(
  user_name: json['user_name'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$$ChatActionRequestImplToJson(
  _$ChatActionRequestImpl instance,
) => <String, dynamic>{
  'user_name': instance.user_name,
  'content': instance.content,
};

_$ChatActionResponseImpl _$$ChatActionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ChatActionResponseImpl(
  error: (json['error'] as num).toInt(),
  message: json['message'] as String,
);

Map<String, dynamic> _$$ChatActionResponseImplToJson(
  _$ChatActionResponseImpl instance,
) => <String, dynamic>{'error': instance.error, 'message': instance.message};
