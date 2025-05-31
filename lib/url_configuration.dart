// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'dart:convert';
import 'package:nirva_app/api_models.dart';
import 'package:logger/logger.dart';

class URLConfiguration {
  URLConfigurationResponse _urlConfig = URLConfigurationResponse(
    api_version: '',
    endpoints: {},
    deprecated: false,
    notice: '',
  );

  setup(URLConfigurationResponse urlConfig) {
    _urlConfig = urlConfig;
    Logger().d(
      '_url_configuration_response=\n${jsonEncode(_urlConfig.toJson())}',
    );
  }

  String get loginUrl {
    return _urlConfig.endpoints['login'] ?? '';
  }

  String get logoutUrl {
    return _urlConfig.endpoints['logout'] ?? '';
  }

  String get chatActionUrl {
    return _urlConfig.endpoints['chat'] ?? '';
  }

  String get refreshUrl {
    return _urlConfig.endpoints['refresh'] ?? '';
  }
}
