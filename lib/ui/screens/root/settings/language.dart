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

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();
    if (settingCubit.locale == null) {
      settingCubit.update(locale: AppLocalizations.of(context)?.localeName);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.language ?? ''),
        leading: BrandBackButton(),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => _selectLocale("en", settingCubit),
            child: TransparentCard(
              color: theme.colorTheme.scaffoldBackground,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 12),
                child: Row(
                  children: [Column(
                    children: [
                      SizedBox(height: 20),
                      Text("English")
                    ],
                  ),
                  Spacer(),
                  _checkMark(settingCubit.locale == 'en', theme)
                  ]
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
          GestureDetector(
            onTap: () => _selectLocale("ru", settingCubit),
            child: TransparentCard(
              color: theme.colorTheme.scaffoldBackground,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 12),
                child: Row(
                  children: [Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text("Russian"),
                      SizedBox(height: 10),
                      Text("Русский")
                    ],
                  ),
                  Spacer(),
                  _checkMark(settingCubit.locale == 'ru', theme)
                  ]
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
        ],
      ),
    );
  }

  void _selectLocale(String locale, AppSettingsCubit settings) {
    settings.update(locale: locale);
  }

  Widget _checkMark(bool currentLocale, BrandTheme theme) {
    if (currentLocale) {
      return Icon(
          CupertinoIcons.check_mark,
          color: theme.colorTheme.appBarAlternetiveBackground);
    }
    return SizedBox.shrink();
  }
}
