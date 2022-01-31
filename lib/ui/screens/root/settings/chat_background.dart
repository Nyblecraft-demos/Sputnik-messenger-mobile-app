import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_chat_background/brand_chat_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBackgroundPage extends StatelessWidget {
  ChatBackgroundPage({Key? key}) : super(key: key);

  final List<String> backgroundImages = [
    'light',
    'dark',
    'background8.png',
    'background10.png',
    'background15.png',
    'background49.png'
  ];

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.chatBackground ?? ''),
          leading: BrandBackButton(),
        ),
        body: Container(
          color: theme.colorTheme.chatSettingsBackground,
          child: GridView.count(
            padding: EdgeInsets.symmetric(vertical: 10),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.5,
            children: List.generate(
              backgroundImages.length,
              (index) {
                return BrandChatBackground(
                    selectedBackground: settingCubit.background,
                    background: backgroundImages[index],
                    onPressed: (background) {
                      print(background);
                      settingCubit.update(background: background);
                    });
              },
            ),
          ),
        ));
  }
}