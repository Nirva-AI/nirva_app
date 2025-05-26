import 'package:hive/hive.dart';
part 'hive_data.g.dart';

// 测试的类
@HiveType(typeId: 0)
class HiveTest extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  HiveTest(this.id, this.name);
}

// 本机存储的日记收藏列表
@HiveType(typeId: 1)
class DiaryFavorites extends HiveObject {
  @HiveField(0)
  List<String> favoriteIds;

  DiaryFavorites({required this.favoriteIds});
}
