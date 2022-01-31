import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';

class InterfacePage extends StatelessWidget {
  const InterfacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var settingCubit = context.watch<AppSettingsCubit>();
    var isDarkModeOn = settingCubit.state.isDarkModeOn ?? true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Внешний вид'),
        leading: BrandBackButton(),
      ),
      body: ListView(
        children: [
          TransparentCard(
            color: theme.colorTheme.scaffoldBackground,
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Row(
                children: [
                  Text('Dark theme', style: context.watch<BrandTheme>().h2),
                  Spacer(),
                  Switch(
                    activeColor: BrandColors.blue2,
                    activeTrackColor: BrandColors.blue1,
                    onChanged: (_) {
                      settingCubit.update(isDarkModeOn: !isDarkModeOn);
                    },
                    value: isDarkModeOn,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
