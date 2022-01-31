import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';

class BrandDivider extends StatelessWidget {
  const BrandDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = context.watch<AppSettingsCubit>().state.isDarkModeOn ?? true;

    return Container(
      color: isDark ? BrandColors.grey1 : BrandColors.grey3,
      height: 1,
      width: double.infinity,
    );
  }
}
