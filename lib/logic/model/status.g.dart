// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) {
  return Status(
    imageUrl: json['imageUrl'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String).toLocal(),
  );
}

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toUtc().toIso8601String(),
    };
