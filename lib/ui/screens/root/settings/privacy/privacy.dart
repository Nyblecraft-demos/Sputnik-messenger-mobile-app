import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_card/brand_card.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/root/settings/privacy/blocked_users.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();
    var isFlaggedMessagesOn = settingCubit.state.isFlaggedMessagesOn ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.privacy ?? ''),
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
                  Expanded(
                    child: Text(
                        AppLocalizations.of(context)?.showReportedMessages ?? '',
                        style: context.watch<BrandTheme>().h2,
                        maxLines: 2,),
                  ),
                  SizedBox(width: 20,),
                  CupertinoSwitch(
                      activeColor: BrandColors.primary,
                      value: isFlaggedMessagesOn,
                      onChanged: (newValue) => switchFlaggedMessages(newValue, settingCubit, context)
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
          BrandCard(
            icon: CupertinoIcons.text_aligncenter,
            text: AppLocalizations.of(context)?.blackList ?? '',
            color: theme.colorTheme.scaffoldBackground,
            onPress: () => Navigator.of(context).push(materialRoute(BlockedUsersPagePage())),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
        ],
      ),
    );
  }

  void switchFlaggedMessages(bool newValue, AppSettingsCubit settings, BuildContext context) {
    switch (newValue) {
      case false:
        settings.update(isFlaggedMessagesOn: false);
        break;
      case true:
        settings.update(isFlaggedMessagesOn: true);
        break;
    }
  }
}
