import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/api/modules.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/pin_code/pin_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();
    var isModuleWalletOn = settingCubit.state.isModuleWalletOn ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.modules ?? ''),
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
                      AppLocalizations.of(context)?.wallet ?? '',
                      style: context.watch<BrandTheme>().h2),
                  Spacer(),
                  CupertinoSwitch(
                      activeColor: BrandColors.primary,
                      value: isModuleWalletOn,
                      onChanged: (newValue) => switchWallet(newValue, settingCubit, context)
                  ),
                  // Switch(
                  //   activeColor: BrandColors.blue2,
                  //   activeTrackColor: BrandColors.blue1,
                  //   onChanged: (_) => settingCubit.update(isModuleWalletOn: !isModuleWalletOn),
                  //   value: isModuleWalletOn,
                  // ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
        ],
      ),
    );
  }

  void switchWallet(bool newValue, AppSettingsCubit settings, BuildContext context) async {
    switch (newValue) {
      case false:
        await ModulesApi().deactivateWalletModule();
        settings.update(isModuleWalletOn: false);
        break;
      case true:
        Navigator.of(context).push(materialRoute(PinCodePage()));
    }
  }
}
