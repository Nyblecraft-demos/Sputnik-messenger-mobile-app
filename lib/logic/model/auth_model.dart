import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 1)
class AuthModel {
  AuthModel({
    required this.token,
    required this.address,
    required this.phoneNumber,
//     required this.virgilToken,
  }) {
    var decodedToken = JwtDecoder.decode(token);
    _userId = decodedToken['user_id'];
  }

  @HiveField(0)
  final String token;

  @HiveField(1)
  final String address;

  @HiveField(2)
  late String _userId;

  @HiveField(3)
  final String phoneNumber;

  // @HiveField(4)
  // final String virgilToken;

  String get id => _userId;
}
