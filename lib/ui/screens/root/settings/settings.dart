import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/ui/components/brand_card/brand_card.dart';
import 'package:sputnik/ui/helpers/phone_services/open_url/open_url.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/root/settings/about.dart';
import 'package:sputnik/ui/screens/root/settings/appearance.dart';
import 'package:sputnik/ui/screens/root/settings/language.dart';
import 'package:sputnik/ui/screens/root/settings/modules.dart';
import 'package:sputnik/ui/screens/root/settings/privacy/privacy.dart';
import 'package:sputnik/utils/help_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'notifications.dart';
import 'security.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    final bool canPop = canPopHelper(context);
    final divider = Divider(height: 0.5, indent: 16, endIndent: 0, color: theme.colorTheme.seconadaryGray3);

    List<Widget> listItems = [
      // BrandCard(
      //   icon: CupertinoIcons.lock_fill,
      //   text: AppLocalizations.of(context)?.security ?? '',
      //   color: theme.colorTheme.scaffoldBackground,
      //   onPress: () => Navigator.of(context).push(materialRoute(SecurityPage())),
      // ),
      BrandCard(
        icon: CupertinoIcons.rectangle_grid_2x2_fill,
        text: AppLocalizations.of(context)?.modules ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(ModulesPage())),
      ),
      BrandCard(
        icon: CupertinoIcons.bell_fill,
        text: AppLocalizations.of(context)?.notifications ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(NotificationsPage())),
      ),
      BrandCard(
        icon: CupertinoIcons.text_aligncenter,
        text: AppLocalizations.of(context)?.privacy ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(PrivacyPage())),
      ),
      BrandCard(
        icon: CupertinoIcons.text_aligncenter,
        text: AppLocalizations.of(context)?.language ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(LanguagePage())),
      ),
      BrandCard(
        icon: CupertinoIcons.text_aligncenter,
        text: AppLocalizations.of(context)?.appearance ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(AppearancePage())),
      ),
      BrandCard(
        icon: CupertinoIcons.text_aligncenter,
        text: AppLocalizations.of(context)?.about ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => Navigator.of(context).push(materialRoute(AboutPage())),
      ),
      BrandCard(
        icon: CupertinoIcons.square_arrow_right_fill,
        text: AppLocalizations.of(context)?.exit ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () => showLoadingDialog(context),
      ),
      divider
    ];
    return ListView.separated(
      itemCount: listItems.length,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      separatorBuilder: (context, index) => index < listItems.length - 2 ? divider : SizedBox.shrink(),
      itemBuilder: (context, index) => listItems[index],
    );
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => LoadingDialog(context),
    );
  }

// ignore: non_constant_identifier_names
  CupertinoAlertDialog LoadingDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)?.exit ?? ''),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(AppLocalizations.of(context)?.yes ?? ''),
          onPressed: () {
            Box usernameBox = Hive.box(BNames.username);
            usernameBox.clear();
            context.read<AuthenticationCubit>().logout();
            context.read<AppSettingsCubit>().update(isModuleWalletOn: false);
          },
        ),
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context)?.no ?? ''),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}
