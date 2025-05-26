import 'package:hive/hive.dart';

part 'hive_data.g.dart';

@HiveType(typeId: 0)
class HiveTest extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  HiveTest(this.id, this.name);
}
