import 'package:sputnik/logic/model/status.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

extension UserExtension on User {
  String get surname => (extraData['surname'] as String?) ?? '';

  String? get email => (extraData['email'] as String?) ?? '';

  String get nickname => (extraData['nickname'] as String?) ?? '';

  String? get avatar => extraData['avatar'] as String?;
  String? get wallet => extraData['wallet'] as String?;
  String? get phoneNumber => extraData['phone'] as String?;
  String? get phoneNumberFormatted => phoneNumber != null
      ? FlutterLibphonenumber().formatNumberSync(phoneNumber!)
      : null;

  String? get bio => extraData['bio'] as String?;

  User setAvatar(String? url) => copyWith(
        extraData: {...this.extraData}..['avatar'] = url,
      );

  User setName(String name) => copyWith(
        extraData: {...this.extraData}
          ..['name'] = name
          ..['firstname'] = name,
      );

  User setNickname(String name) => copyWith(
        extraData: {...this.extraData}..['nickname'] = name,
      );

  User setEmail(String name) => copyWith(
        extraData: {...this.extraData}..['email'] = name,
      );

  User setSurname(String name) => copyWith(
        extraData: {...this.extraData}..['surname'] = name,
      );

  User setWallet(String address) => copyWith(
        extraData: {...this.extraData}..['wallet'] = address,
      );

  User setPhoneNumber(String phone) => copyWith(
        extraData: {...this.extraData}..['phone'] = phone,
      );

  User setBio(String bio) => copyWith(
        extraData: {...this.extraData}..['bio'] = bio,
      );

  bool get isRegistrationCompleted {
//    print("ExtraData: ${extraData['phone']}");
//    print("ExtraData: ${extraData['name']}");
    return extraData['phone'] != null && extraData['name'] != null;
  }

  Status? get status => extraData['status'] == null
      ? null
      : Status.fromJson(extraData['status'] as Map<String, dynamic>);

  User setStatus(Status? status) =>
      copyWith(extraData: {...this.extraData}..['status'] = status?.toJson());

  String get displayName {
    if (extraData.containsKey('name')) {
      final name = extraData['name']! as String;
      String fullName = '';
      if (name.isNotEmpty) {
        fullName = name;
      }
      if (extraData.containsKey('surname')) {
        final surname = extraData['surname']! as String;
        if (surname.isNotEmpty) {
          fullName += ' $surname';
        }
      }
      if (fullName.isNotEmpty) return fullName;
    }
    return phoneNumberFormatted ?? id;
  }

  String getShortName() {
    if (extraData['name'] != null) {
      if (extraData['name'] as String == "") {
        if (extraData['nickname'] != null) {
          if (extraData['nickname'] as String == "") {
            return extraData['phone'] as String;
          }
        }
        return extraData['nickname'] as String;
      }
      return extraData['name'] as String == id
          ? extraData['phone'] as String
          : extraData['name'] as String;
    } else {
      if (extraData['nickname'] != null) {
        if (extraData['nickname'] as String == "") {
          return extraData['phone'] as String;
        }
      } else {
        return (extraData['phone'] != null) ? extraData['phone'] as String : id;
      }
    }
    return id;
  }
}
