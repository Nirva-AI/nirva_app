// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryFavoritesAdapter extends TypeAdapter<DiaryFavorites> {
  @override
  final int typeId = 1;

  @override
  DiaryFavorites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryFavorites(
      favoriteIds: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DiaryFavorites obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.favoriteIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryFavoritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
