import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sputnik/main.dart';

abstract class ApiMap {
  FutureOr<Dio> getClient();

  FutureOr<BaseOptions> get options;

  ValidateStatus? validateStatus;

  void close(Dio client) {
    client.close();
    validateStatus = null;
  }
}

abstract class SputnikApi extends ApiMap {
  Future<Dio> getClient() async {
    var dio = Dio(await options);
    if (apiDefaultLog) {
      dio.interceptors
          .add(PrettyDioLogger(requestHeader: true, requestBody: true));
    }

    return dio;
  }
}

abstract class SputnikPublicApi extends SputnikApi {
  BaseOptions get options {
    var options = BaseOptions(baseUrl: baseUrl);
    if (validateStatus != null) {
      options.validateStatus = validateStatus!;
    }
    return options;
  }

  ValidateStatus? validateStatus;
}
