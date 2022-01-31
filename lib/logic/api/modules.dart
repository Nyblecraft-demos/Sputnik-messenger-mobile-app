import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:dio/dio.dart';

import 'api.dart';

const modules = '/settings/modules';
const walletModule = '/settings/modules/wallet';

class ModulesApi extends SputnikPublicApi {
  Box userBox = Hive.box(BNames.authModel);

  String get token {
    AuthModel authModel = userBox.get(BNames.authModel);
    return authModel.token;
  }

  Future<Response> getModules() async {
    debugPrint('ModulesApi:  get modules');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.get(
      modules,
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('ModulesApi:  get modules:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('ModulesApi:  get modules:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('ModulesApi:  get modules:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('ModulesApi:  get modules:  unauthorized!');
    }
    return res;
  }

  Future<Response> activateWalletModule(bool isOn) async {
    debugPrint('ModulesApi:  activate wallet module');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.put(
      walletModule,
      data: {
            "enabled": isOn
      },
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('ModulesApi:  activate wallet module:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('ModulesApi:  activate wallet module:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('ModulesApi:  activate wallet module:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('ModulesApi:  activate wallet module:  unauthorized!');
    }
    return res;
  }

  Future<Response> deactivateWalletModule() async {
    debugPrint('ModulesApi:  deactivate wallet module');
    validateStatus = (status) {
      return status == HttpStatus.ok ||
          status == HttpStatus.unauthorized ||
          status == HttpStatus.badRequest;
    };
    var client = await getClient();
    var res = await client.delete(
      walletModule,
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    debugPrint('ModulesApi:  deactivate wallet module:  status code = ${res.statusCode}  res = $res');
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data["data"]["response"];
      debugPrint('ModulesApi:  deactivate wallet module:  ok:  data = $data');
    } else if (res.statusCode == HttpStatus.badRequest) {
      debugPrint('ModulesApi:  deactivate wallet module:  something wrong!');
    } else if (res.statusCode == HttpStatus.unauthorized) {
      debugPrint('ModulesApi:  deactivate wallet module:  unauthorized!');
    }
    return res;
  }

}