import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
class Status {
  Status({
    @required this.imageUrl,
    @required this.createdAt,
  });

  final String? imageUrl;
  final DateTime? createdAt;

  static Status fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  Map<String, dynamic> toJson() => _$StatusToJson(this);
}
