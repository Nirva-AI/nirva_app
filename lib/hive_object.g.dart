// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesAdapter extends TypeAdapter<Favorites> {
  @override
  final int typeId = 1;

  @override
  Favorites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorites(
      favoriteIds: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Favorites obj) {
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
      other is FavoritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserTokenAdapter extends TypeAdapter<UserToken> {
  @override
  final int typeId = 2;

  @override
  UserToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserToken(
      access_token: fields[0] as String,
      token_type: fields[1] as String,
      refresh_token: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserToken obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.access_token)
      ..writeByte(1)
      ..write(obj.token_type)
      ..writeByte(2)
      ..write(obj.refresh_token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveChatMessageAdapter extends TypeAdapter<HiveChatMessage> {
  @override
  final int typeId = 3;

  @override
  HiveChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChatMessage(
      id: fields[0] as String,
      role: fields[1] as int,
      content: fields[2] as String,
      time_stamp: fields[3] as String,
      tags: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveChatMessage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.time_stamp)
      ..writeByte(4)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatHistoryAdapter extends TypeAdapter<ChatHistory> {
  @override
  final int typeId = 4;

  @override
  ChatHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistory(
      messages: (fields[0] as List).cast<HiveChatMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalFileMetaAdapter extends TypeAdapter<JournalFileMeta> {
  @override
  final int typeId = 5;

  @override
  JournalFileMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalFileMeta(
      fileName: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JournalFileMeta obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.fileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalFileMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalFileIndexAdapter extends TypeAdapter<JournalFileIndex> {
  @override
  final int typeId = 6;

  @override
  JournalFileIndex read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalFileIndex(
      files: (fields[0] as List?)?.cast<JournalFileMeta>(),
    );
  }

  @override
  void write(BinaryWriter writer, JournalFileIndex obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalFileIndexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalFileStorageAdapter extends TypeAdapter<JournalFileStorage> {
  @override
  final int typeId = 7;

  @override
  JournalFileStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalFileStorage(
      fileName: fields[0] as String,
      content: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JournalFileStorage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalFileStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveTasksAdapter extends TypeAdapter<HiveTasks> {
  @override
  final int typeId = 8;

  @override
  HiveTasks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTasks(
      taskJsonList: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveTasks obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.taskJsonList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTasksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveNotesAdapter extends TypeAdapter<HiveNotes> {
  @override
  final int typeId = 9;

  @override
  HiveNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNotes(
      noteJsonList: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveNotes obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.noteJsonList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UpdateDataTaskAdapter extends TypeAdapter<UpdateDataTask> {
  @override
  final int typeId = 10;

  @override
  UpdateDataTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateDataTask(
      id: fields[0] as String,
      status: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateDataTask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateDataTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UpdateDataTaskListAdapter extends TypeAdapter<UpdateDataTaskList> {
  @override
  final int typeId = 11;

  @override
  UpdateDataTaskList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateDataTaskList(
      tasks: (fields[0] as List).cast<UpdateDataTask>(),
    );
  }

  @override
  void write(BinaryWriter writer, UpdateDataTaskList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateDataTaskListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
