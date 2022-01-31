import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class PushNotificationService {
  static bool? isNotificationsOn = getIt.get<NavigationService>().navigatorKey.currentContext?.watch<AppSettingsCubit>().isNotificationsOn;
  final FirebaseMessaging _fcm;
  static final storage = FlutterSecureStorage();

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }
    _getToken();
    _listenOnTokenRefresh();
  }

  void _getToken() async {
    String? token = await _fcm.getToken();
    if (token == null) {
      return;
    }
    debugPrint("FirebaseMessaging token: $token");
    final client = getIt.get<ChatService>().client;
    String? deviceToken = await storage.read(key: BNames.fcmToken);
    debugPrint("SecureStorage token: $token");
    if (deviceToken == null) {
      storage.write(key: BNames.fcmToken, value: token);
      if (isNotificationsOn == true) {
        client.addDevice(token, PushProvider.firebase);
      }
    }
    if (deviceToken != null && deviceToken != token) {
      client.removeDevice(deviceToken);
      storage.write(key: BNames.fcmToken, value: token);
      if (isNotificationsOn == true) {
        client.addDevice(token, PushProvider.firebase);
      }
    }
  }

  void _listenOnTokenRefresh() {
    _fcm.onTokenRefresh.listen((token) async {
      String? deviceToken = await storage.read(key: BNames.fcmToken);
      final client = getIt.get<ChatService>().client;
      if (deviceToken != null && deviceToken != token) {
        client.removeDevice(deviceToken);
        storage.write(key: BNames.fcmToken, value: token);
        if (isNotificationsOn == true){
          client.addDevice(token, PushProvider.firebase);
        }
      }
    });
  }
}
