import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';

class BrandBackButton extends StatelessWidget {
  const BrandBackButton({Key? key, this.backFunc}) : super(key: key);

  final Function? backFunc;

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.watch<AppSettingsCubit>();
    var isDarkModeOn = settingsCubit.state.isDarkModeOn ?? true;
    return IconButton(
      icon: Icon(
        CupertinoIcons.chevron_left,
        color: isDarkModeOn ? Colors.white : BrandColors.blue1,
      ),
      onPressed: () {
        NotificationService.opponentID = '';
        if (backFunc == null) {
          Navigator.of(context).pop();
        } else {
          backFunc!();
        }
      }

    );
  }
}
