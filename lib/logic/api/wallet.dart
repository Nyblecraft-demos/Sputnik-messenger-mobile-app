import 'dart:io';

import 'package:either_option/either_option.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';

import 'api.dart';

const ouroBalanceUrl = '/coins/ouro';
const sputBalanceUrl = '/coins/sput';
const transactions = '/transactions';
const pin = '/pin';
const validate = '/pin/validate';

class WalletApi extends SputnikPublicApi {
  Box userBox = Hive.box(BNames.authModel);

  String get token {
    AuthModel authModel = userBox.get(BNames.authModel);
    return authModel.token;
  }

  Future<Either<Exception, num>> getBalance(CryptoToken crypto) async {
    var client = await getClient();

    var res = await client.get(
        crypto == CryptoToken.OURO ? ouroBalanceUrl : sputBalanceUrl,
        options: Options(headers: {'Authorization': token}));
    client.close();

    if (res.statusCode == HttpStatus.ok) {
      return Right(res.data['data']['balance']);
    } else if (res.statusCode == HttpStatus.badRequest) {
      return Left(Exception('wrong phone'));
    }

    throw 'wrong code';
  }

  Future<Response> sendTokens(String address, num amount, CryptoToken crypto) async {
    debugPrint('WalletApi:  send tokens:  adress = $address  ammount = $amount crypto = ${crypto.toString()}');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.post(
      transactions,
      data: {
        "sendTxDto": {
          "to": address,
          "amount": amount,
          "coinName": crypto == CryptoToken.OURO ? 'ouro' : 'sput'
        }
      },
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('WalletApi:  send tokens:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('WalletApi:  send tokens:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('WalletApi:  send tokens:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('WalletApi:  send tokens:  unauthorized!');
    }

    /*
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('WalletApi:  send tokens:  ok:  data = ${data}');
      return Right(data);
    } else if (res.statusCode == HttpStatus.badRequest) {
      return Left(Exception('something wrong'));
    } else if (res.statusCode == HttpStatus.unauthorized) {
      return Left(Exception('unauthorized'));
    }
    throw 'wrong code';
     */
    return res;
  }

  Future<Response> setPinCode(int pinCode) async {
    debugPrint('WalletApi:  set pin:  pincode = $pinCode');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.put(
      pin,
      data: {"pin": pinCode},
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('WalletApi:  set pincode:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('WalletApi:  set pincode:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('WalletApi:  set pincode:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('WalletApi:  set pincode:  unauthorized!');
    }
    return res;
  }

  Future<Response> validatePinCode(int pinCode) async {
    debugPrint('WalletApi:  validate pin:  pincode = $pinCode');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.post(
      validate,
      data: {
        "pin": pinCode,
      },
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('WalletApi:  set pincode:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('WalletApi:  validate pincode:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('WalletApi:  validate pincode:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('WalletApi:  validate pincode:  unauthorized!');
    }
    return res;
  }

  Future<Response> checkPinCodeExist() async {
    debugPrint('WalletApi:  check if pin exist');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.get(
      pin,
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('WalletApi:  check if pin exist:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('WalletApi:  check if pin exist:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('WalletApi:  check if pin exist:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('WalletApi:  check if pin exist:  unauthorized!');
    }
    return res;
  }
}
