import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';

class BrandEditButton extends StatelessWidget {
  const BrandEditButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.watch<AppSettingsCubit>();
    var isDarkModeOn = settingsCubit.state.isDarkModeOn ?? true;
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: isDarkModeOn ? Colors.white : BrandColors.blue1,
      ),
      onPressed: onPressed,
    );
  }
}
