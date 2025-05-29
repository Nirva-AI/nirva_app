// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$URLConfigurationResponseImpl _$$URLConfigurationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$URLConfigurationResponseImpl(
      api_version: json['api_version'] as String,
      endpoints: Map<String, String>.from(json['endpoints'] as Map),
      deprecated: json['deprecated'] as bool,
      notice: json['notice'] as String,
    );

Map<String, dynamic> _$$URLConfigurationResponseImplToJson(
        _$URLConfigurationResponseImpl instance) =>
    <String, dynamic>{
      'api_version': instance.api_version,
      'endpoints': instance.endpoints,
      'deprecated': instance.deprecated,
      'notice': instance.notice,
    };

_$TokenImpl _$$TokenImplFromJson(Map<String, dynamic> json) => _$TokenImpl(
      access_token: json['access_token'] as String,
      token_type: json['token_type'] as String,
      refresh_token: json['refresh_token'] as String,
    );

Map<String, dynamic> _$$TokenImplToJson(_$TokenImpl instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'token_type': instance.token_type,
      'refresh_token': instance.refresh_token,
    };

_$ChatActionRequestImpl _$$ChatActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatActionRequestImpl(
      user_name: json['user_name'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$ChatActionRequestImplToJson(
        _$ChatActionRequestImpl instance) =>
    <String, dynamic>{
      'user_name': instance.user_name,
      'content': instance.content,
    };

_$ChatActionResponseImpl _$$ChatActionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatActionResponseImpl(
      error: (json['error'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$ChatActionResponseImplToJson(
        _$ChatActionResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
    };
