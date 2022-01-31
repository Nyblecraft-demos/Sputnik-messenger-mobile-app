import 'dart:io';

import 'package:either_option/either_option.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
// import 'package:virgil_e3kit/virgil_e3kit.dart';

import 'api.dart';
import 'ethree.dart';

const codeUrl = '/auth/code';
const loginUrl = '/auth/login';

class PhoneVerification extends SputnikPublicApi {
  Future<Either<Exception, bool>> requestCode(String phoneNumber) async {
    validateStatus = (status) {
      return status == HttpStatus.created || status == HttpStatus.badRequest;
    };

    var client = await getClient();

    var res = await client.post(codeUrl, data: {"phone": phoneNumber});
    client.close();
    //debugPrint('PhoneVerification:  requestCode:  res = $res');
    if (res.statusCode == HttpStatus.created) {
      return Right(true);
    } else if (res.statusCode == HttpStatus.badRequest) {
      return Left(Exception('wrong phone'));
    }

    throw 'wrong code';
  }

  Future<Either<Exception, AuthModel>> requestToken(String phoneNumber, String code) async {
    validateStatus = (status) {
      return status == HttpStatus.ok || status == HttpStatus.created || status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.post(
      loginUrl,
      data: {
        "phone": phoneNumber,
        "code": code,
        "isAgreedPrivacy": true,
        "isAgreedConditions": true
      },
    );
    client.close();
    debugPrint('PhoneVerification:  requestToken:  res = $res');
    if (res.statusCode == HttpStatus.created || res.statusCode == HttpStatus.ok) {
      debugPrint('PhoneVerification:  user data = ${res.data["user"]}');
      return Right(
        AuthModel(
          token: res.data["user"]["token"],
          address: res.data["user"]["address"] ?? '',
          phoneNumber: phoneNumber,
//           virgilToken: res.data["user"]["virgilToken"],
        ),
      );
    } else if (res.statusCode == HttpStatus.badRequest) {
      return Left(Exception('code'));
    }
    throw 'wrong code';
  }

//   void initEthree() async {
//     try {
//       final ethree = await Ethree.init(identity, tokenCallback);
// //      await ethree?.register();
//     } on PlatformException {
//       //process error
//     }
//   }
}
