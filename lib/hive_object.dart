// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';
part 'hive_object.g.dart';

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class DiaryFavorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  DiaryFavorites({required this.favoriteIds});
}

// @freezed
// class Token with _$Token {
//   const factory Token({
//     required String access_token,
//     required String token_type,
//     required String refresh_token, // 新增字段
//   }) = _Token;

//   factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
//   @override
//   Map<String, dynamic> toJson() => (this as _Token).toJson();
// }

// 本机存储Token
@HiveType(typeId: 2)
class Token extends HiveObject {
  @HiveField(0)
  String access_token;

  @HiveField(1)
  String token_type;

  @HiveField(2)
  String refresh_token; // 新增字段

  Token({
    required this.access_token,
    required this.token_type,
    required this.refresh_token,
  });
}
