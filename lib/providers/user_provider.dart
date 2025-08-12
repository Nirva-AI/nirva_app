import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';

class UserProvider extends ChangeNotifier {
  // 用户信息
  User _user;

  // 构造函数，接收用户参数
  UserProvider({
    required String id,
    required String username,
    required String password,
    required String displayName,
  }) : _user = User(
         id: id,
         username: username,
         password: password,
         displayName: displayName,
       );

  // 获取用户
  User get user => _user;
  
  // 获取用户ID
  String get id => _user.id;

  // 清空用户信息（如果需要的话）
  void clearUser() {
    _user = const User(id: "", username: "", password: "", displayName: "");
    notifyListeners();
  }
}
