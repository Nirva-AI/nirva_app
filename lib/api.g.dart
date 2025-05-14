// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$URLConfigurationResponseImpl _$$URLConfigurationResponseImplFromJson(
  Map<String, dynamic> json,
) => _$URLConfigurationResponseImpl(
  api_version: json['api_version'] as String,
  endpoints: Map<String, String>.from(json['endpoints'] as Map),
  deprecated: json['deprecated'] as bool,
  notice: json['notice'] as String,
);

Map<String, dynamic> _$$URLConfigurationResponseImplToJson(
  _$URLConfigurationResponseImpl instance,
) => <String, dynamic>{
  'api_version': instance.api_version,
  'endpoints': instance.endpoints,
  'deprecated': instance.deprecated,
  'notice': instance.notice,
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
