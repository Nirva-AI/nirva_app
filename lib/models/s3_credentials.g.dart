// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's3_credentials.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class S3CredentialsAdapter extends TypeAdapter<S3Credentials> {
  @override
  final int typeId = 20;

  @override
  S3Credentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return S3Credentials(
      accessKeyId: fields[0] as String,
      secretAccessKey: fields[1] as String,
      sessionToken: fields[2] as String,
      expiration: fields[3] as String,
      bucket: fields[4] as String,
      prefix: fields[5] as String,
      region: fields[6] as String,
      durationSeconds: fields[7] as int,
      fetchedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, S3Credentials obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.accessKeyId)
      ..writeByte(1)
      ..write(obj.secretAccessKey)
      ..writeByte(2)
      ..write(obj.sessionToken)
      ..writeByte(3)
      ..write(obj.expiration)
      ..writeByte(4)
      ..write(obj.bucket)
      ..writeByte(5)
      ..write(obj.prefix)
      ..writeByte(6)
      ..write(obj.region)
      ..writeByte(7)
      ..write(obj.durationSeconds)
      ..writeByte(8)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is S3CredentialsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
