import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/config/theme.dart';
import 'package:sputnik/logic/api/ethree.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/services/socket_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:socket_io/socket_io.dart';

import 'config/bloc_config.dart';
import 'config/bloc_observer.dart';
import 'config/get_it_config.dart';

import 'home_page.dart';
import 'logic/locators/navigation.dart';

var apiDefaultLog = true;
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const baseUrl = "https://api.sputnik-1.com";
const getstreamKey = 'ccfqavf3cr8a';
// const getstreamKey = 'kp2rb6b76fp4';
//const getstreamKey = 'jx6h7dmndqz5';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  getItSetup();

  WidgetsFlutterBinding.ensureInitialized();
  initEthree();
  Bloc.observer = SimpleBlocObserver();
  await HiveConfig.init();
  await NotificationService().init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  getIt.registerSingleton<SocketService>(SocketService());

  ///
  // Dart server
  // var io = new Server();
  // var nsp = io.of('/token');// /some
  // nsp.on('connection', (client) {
  //   print('io server:  nsp.on  connection:  /token');
  //   client.on('msg', (data) {
  //     print('io server:  nsp.on  connection:  data from /tonen => $data');
  //     client.emit('fromServer', "ok 2");
  //   });
  // });
  // io.on('connection', (client) {
  //   print('io server:  io.on  connection:  default namespace');
  //   client.on('msg', (data) {
  //     print('io server:  io.on  connection:  client.on:  data from default => $data');
  //     client.emit('fromServer', "ok");
  //   });
  // });
  // io.listen(3000);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dcf291f407ee4be89e3808f9b6cc4594@o649171.ingest.sentry.io/5933461';
    },
    appRunner: () => runApp(
      BlocAndProviderConfig(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  late StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    client = getIt.get<ChatService>().client;
    NotificationService.listenOnForeground();
    //var settingsCubit = context.watch<AppSettingsCubit>();
    var settingsCubit = context.watch<AppSettingsCubit>();
    //var isDarkModeOn = settingsCubit.state.isDarkModeOn ?? true;
    //var isModuleWalletOn = settingsCubit.state.isModuleWalletOn;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, //isDarkModeOn
        //? SystemUiOverlayStyle.light
        //: SystemUiOverlayStyle.dark, // Manually changnig appbar color
        child: MaterialApp(
            navigatorKey: getIt.get<NavigationService>().navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [routeObserver],
            title: 'Sputnik',
            themeMode: ThemeMode.system,
            theme: brandThemeLight,
            darkTheme: brandThemeDark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settingsCubit.locale != null
                ? Locale(settingsCubit.locale!)
                : null,
            home: HomePage(),
            builder: (context, child) {
              checkDarkMode(settingsCubit);
              return StreamChatCore(
                  client: client,
                  child: child!,
                  onBackgroundEventReceived: (e) =>
                      NotificationService.onBackgroundEventReceived(
                          e, client.state.currentUser?.id));
            }));
  }

  void checkDarkMode(AppSettingsCubit settings) {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    if (settings.isDarkModeOn == (brightness == Brightness.dark)) {
      return;
    }
    settings.updateDarkModeState(brightness == Brightness.dark);
  }
}
