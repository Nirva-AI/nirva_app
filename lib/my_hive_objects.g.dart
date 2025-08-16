// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_hive_objects.dart';

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

class ChatMessageStorageAdapter extends TypeAdapter<ChatMessageStorage> {
  @override
  final int typeId = 3;

  @override
  ChatMessageStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageStorage(
      id: fields[0] as String,
      role: fields[1] as int,
      content: fields[2] as String,
      time_stamp: fields[3] as String,
      tags: (fields[4] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageStorage obj) {
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
      other is ChatMessageStorageAdapter &&
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
      messages: (fields[0] as List).cast<ChatMessageStorage>(),
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

class TasksStorageAdapter extends TypeAdapter<TasksStorage> {
  @override
  final int typeId = 8;

  @override
  TasksStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasksStorage(
      taskJsonList: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TasksStorage obj) {
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
      other is TasksStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotesStorageAdapter extends TypeAdapter<NotesStorage> {
  @override
  final int typeId = 9;

  @override
  NotesStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesStorage(
      noteJsonList: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotesStorage obj) {
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
      other is NotesStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UploadAndTranscribeTaskStorageAdapter
    extends TypeAdapter<UploadAndTranscribeTaskStorage> {
  @override
  final int typeId = 10;

  @override
  UploadAndTranscribeTaskStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UploadAndTranscribeTaskStorage(
      taskId: fields[0] as String,
      userId: fields[1] as String,
      assetFileNames: (fields[2] as List).cast<String>(),
      pickedFileNames: (fields[3] as List).cast<String>(),
      creationTimeIso: fields[4] as String,
      uploadedFileNames: (fields[5] as List).cast<String>(),
      isUploaded: fields[6] as bool,
      isTranscribed: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UploadAndTranscribeTaskStorage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.assetFileNames)
      ..writeByte(3)
      ..write(obj.pickedFileNames)
      ..writeByte(4)
      ..write(obj.creationTimeIso)
      ..writeByte(5)
      ..write(obj.uploadedFileNames)
      ..writeByte(6)
      ..write(obj.isUploaded)
      ..writeByte(7)
      ..write(obj.isTranscribed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadAndTranscribeTaskStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnalyzeTaskStorageAdapter extends TypeAdapter<AnalyzeTaskStorage> {
  @override
  final int typeId = 11;

  @override
  AnalyzeTaskStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyzeTaskStorage(
      content: fields[0] as String,
      transcribeFileNameData: fields[1] as String,
      fileName: fields[2] as String,
      dateKey: fields[3] as String,
      statusValue: fields[4] as int,
      errorMessage: fields[5] as String?,
      uploadResponseMessage: fields[6] as String?,
      analyzeTaskId: fields[7] as String?,
      journalFileResultJson: fields[8] as String?,
      id: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyzeTaskStorage obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.transcribeFileNameData)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.dateKey)
      ..writeByte(4)
      ..write(obj.statusValue)
      ..writeByte(5)
      ..write(obj.errorMessage)
      ..writeByte(6)
      ..write(obj.uploadResponseMessage)
      ..writeByte(7)
      ..write(obj.analyzeTaskId)
      ..writeByte(8)
      ..write(obj.journalFileResultJson)
      ..writeByte(9)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzeTaskStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UpdateDataTaskStorageAdapter extends TypeAdapter<UpdateDataTaskStorage> {
  @override
  final int typeId = 12;

  @override
  UpdateDataTaskStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateDataTaskStorage(
      userId: fields[0] as String,
      assetFileNames: (fields[1] as List).cast<String>(),
      pickedFileNames: (fields[2] as List).cast<String>(),
      creationTimeIso: fields[3] as String,
      statusValue: fields[4] as int,
      errorMessage: fields[5] as String?,
      transcriptFilePath: fields[6] as String?,
      uploadAndTranscribeTaskStorage:
          fields[7] as UploadAndTranscribeTaskStorage?,
      analyzeTaskStorage: fields[8] as AnalyzeTaskStorage?,
      id: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateDataTaskStorage obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.assetFileNames)
      ..writeByte(2)
      ..write(obj.pickedFileNames)
      ..writeByte(3)
      ..write(obj.creationTimeIso)
      ..writeByte(4)
      ..write(obj.statusValue)
      ..writeByte(5)
      ..write(obj.errorMessage)
      ..writeByte(6)
      ..write(obj.transcriptFilePath)
      ..writeByte(7)
      ..write(obj.uploadAndTranscribeTaskStorage)
      ..writeByte(8)
      ..write(obj.analyzeTaskStorage)
      ..writeByte(9)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateDataTaskStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CloudAsrResultStorageAdapter extends TypeAdapter<CloudAsrResultStorage> {
  @override
  final int typeId = 13;

  @override
  CloudAsrResultStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudAsrResultStorage(
      id: fields[0] as String,
      segmentPath: fields[1] as String,
      startTimeIso: fields[2] as String,
      endTimeIso: fields[3] as String,
      durationMs: fields[4] as int,
      transcription: fields[5] as String?,
      confidence: fields[6] as double?,
      language: fields[7] as String?,
      isFinal: fields[8] as bool,
      processingTimeIso: fields[9] as String,
      audioFilePath: fields[10] as String?,
      audioDataSize: fields[11] as int,
      userId: fields[12] as String,
      sessionId: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CloudAsrResultStorage obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.segmentPath)
      ..writeByte(2)
      ..write(obj.startTimeIso)
      ..writeByte(3)
      ..write(obj.endTimeIso)
      ..writeByte(4)
      ..write(obj.durationMs)
      ..writeByte(5)
      ..write(obj.transcription)
      ..writeByte(6)
      ..write(obj.confidence)
      ..writeByte(7)
      ..write(obj.language)
      ..writeByte(8)
      ..write(obj.isFinal)
      ..writeByte(9)
      ..write(obj.processingTimeIso)
      ..writeByte(10)
      ..write(obj.audioFilePath)
      ..writeByte(11)
      ..write(obj.audioDataSize)
      ..writeByte(12)
      ..write(obj.userId)
      ..writeByte(13)
      ..write(obj.sessionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudAsrResultStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CloudAsrSessionStorageAdapter
    extends TypeAdapter<CloudAsrSessionStorage> {
  @override
  final int typeId = 14;

  @override
  CloudAsrSessionStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudAsrSessionStorage(
      sessionId: fields[0] as String,
      userId: fields[1] as String,
      startTimeIso: fields[2] as String,
      endTimeIso: fields[3] as String?,
      resultIds: (fields[4] as List).cast<String>(),
      isActive: fields[5] as bool,
      deviceInfo: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CloudAsrSessionStorage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.startTimeIso)
      ..writeByte(3)
      ..write(obj.endTimeIso)
      ..writeByte(4)
      ..write(obj.resultIds)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.deviceInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudAsrSessionStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
