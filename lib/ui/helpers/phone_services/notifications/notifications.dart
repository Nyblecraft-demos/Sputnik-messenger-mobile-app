import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/push_notifications.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/chat/chat.dart';
import 'package:sputnik/utils/get_stream_helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class NotificationService {
  static bool chatList = false;
  static String opponentID = '';
  static final NotificationService _notificationService = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "channel_id";
  static const channel_name = "channel_name";

  Future<void> init() async {

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    final channel = getIt.get<ChatService>().client.channel("messaging", id: payload);
    final opponentUser = getOpponentUser(channel);
    if (opponentUser != null) {
      NotificationService.opponentID = opponentUser.id;
      getIt.get<NavigationService>().navigator?.push(materialRoute(
        StreamChannel(channel: channel, child: ChatPage(opponentUser)),
      ));
    }
  }

  void showNotification({String? title, String? body, String? payload}) async {
    await flutterLocalNotificationsPlugin.show(
        123,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              channel_id,
              channel_name,
              'Входящее сообщение',
              importance: Importance.high),
          iOS: IOSNotificationDetails(),
        ),
        payload: payload
    );
  }

  static void onBackgroundEventReceived(Event event, String? currentUserId) {
    if (![EventType.messageNew, EventType.notificationMessageNew,].contains(event.type) ||
        event.user?.id == currentUserId) {
      return;
    }
    if (event.message == null) return;
    if (PushNotificationService.isNotificationsOn == false) return;
    final user = event.user?.id ?? "";
    NotificationService().showNotification(
        title: event.message?.user?.name,
        body: event.message?.text,
        payload: '${event.channelId}   $user');
  }

  static void listenOnForeground() {
    final client = getIt.get<ChatService>().client;
    client
        .on(EventType.messageNew, EventType.notificationMessageNew,)
        .listen((event) {
          if (PushNotificationService.isNotificationsOn == false) return;
      if (event.message?.user?.id == client.state.currentUser?.id) return;
      if (chatList && opponentID.isEmpty) return;
      if (event.message?.user?.id == opponentID) return;
      NotificationService().showNotification(title: event.message?.user?.name,
          body: event.message?.text,
          payload: event.channelId);
    });
  }

}