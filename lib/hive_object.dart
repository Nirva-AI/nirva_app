import 'package:hive/hive.dart';
part 'hive_object.g.dart';

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class DiaryFavorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  DiaryFavorites({required this.favoriteIds});
}
