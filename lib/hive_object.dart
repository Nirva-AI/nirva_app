// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';
part 'hive_object.g.dart';

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class Favorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  Favorites({required this.favoriteIds});
}

// 本机存储UserToken
@HiveType(typeId: 2)
class UserToken extends HiveObject {
  @HiveField(0)
  String access_token;

  @HiveField(1)
  String token_type;

  @HiveField(2)
  String refresh_token; // 新增字段

  UserToken({
    required this.access_token,
    required this.token_type,
    required this.refresh_token,
  });
}
