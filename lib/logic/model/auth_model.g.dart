// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthModelAdapter extends TypeAdapter<AuthModel> {
  @override
  final int typeId = 1;

  @override
  AuthModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthModel(
      token: fields[0] as String,
      address: fields[1] as String,
      phoneNumber: fields[3] as String,
      // virgilToken: fields[4] as String,
    ).._userId = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, AuthModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj._userId)
      ..writeByte(3)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
