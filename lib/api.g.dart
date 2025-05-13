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
