import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    //var settingCubit = context.watch<AppSettingsCubit>();
    //var isModuleWalletOn = settingCubit.state.isModuleWalletOn ?? true;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.security ?? ''),
          leading: BrandBackButton(),
        ),
        body: Center(
          child: Text(
              AppLocalizations.of(context)?.comingSoon ?? '',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.colorTheme.grayText)
          ),
        )
    );
  }
}
