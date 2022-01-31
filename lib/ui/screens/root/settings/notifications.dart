import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/push_notifications.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();
    var isNotificationsOn = settingCubit.state.isNotificationsOn ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.notifications ?? ''),
        leading: BrandBackButton(),
      ),
      body: ListView(
        children: [
          TransparentCard(
            color: theme.colorTheme.scaffoldBackground,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 12),
              child: Row(
                children: [
                  Text(
                      AppLocalizations.of(context)?.notifications ?? '',
                      style: context.watch<BrandTheme>().h2),
                  Spacer(),
                  CupertinoSwitch(
                      activeColor: BrandColors.primary,
                      value: isNotificationsOn,
                      onChanged: (newValue) => switchNotifications(newValue, settingCubit, context)
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
        ],
      ),
    );
  }

  void switchNotifications(bool newValue, AppSettingsCubit settings, BuildContext context) {
    switch (newValue) {
      case false:
        settings.update(isNotificationsOn: false);
        turnNotifications(false);
        break;
      case true:
        settings.update(isNotificationsOn: true);
        turnNotifications(true);
        break;
    }
  }

  void turnNotifications(bool on) async {
    final client = getIt.get<ChatService>().client;
    PushNotificationService.isNotificationsOn = on;
    String? deviceToken = await PushNotificationService.storage.read(key: BNames.fcmToken);
    if (on && deviceToken != null) {
      client.addDevice(deviceToken, PushProvider.firebase);
    }
    if (!on && deviceToken != null) {
      client.removeDevice(deviceToken);
    }
  }
}
