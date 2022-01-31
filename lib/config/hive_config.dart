import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sputnik/logic/model/auth_model.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthModelAdapter());

    await Hive.openBox(BNames.appSettings);
    await Hive.openBox(BNames.authModel);
    await Hive.openBox<List<String>>(BNames.contactBook);
    await Hive.openBox(BNames.appConfig);
    await Hive.openBox(BNames.username);
  }
}

class BNames {
  static String appConfig = 'appConfig';
  static String isDarkModeOn = 'isDarkModeOn';
  static String contactBook = 'contactBook';

  static String appSettings = 'appSettings';

  static String key = 'key';

  static String authModel = 'authDto';

  static String token = 'token';
  static String list = 'list';

  static String isModuleWalletOn = 'isModuleWalletOn';
  static String isNotificationsOn = 'isNotificationsOn';
  static String isFlaggedMessagesOn = 'isFlaggedMessagesOn';
  static String locale = 'locale';
  static String background = 'background';
  static String fcmToken = 'fcm_token';
  static String username = 'username';
}
