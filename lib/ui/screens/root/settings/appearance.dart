import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_card/brand_card.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/root/settings/security.dart';
import 'package:sputnik/utils/help_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'chat_background.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    final bool canPop = canPopHelper(context);
    final divider = Divider(height: 0.5,
        indent: 16,
        endIndent: 0,
        color: theme.colorTheme.seconadaryGray3);

    List<Widget> listItems = [
      BrandCard(
        icon: CupertinoIcons.lock_fill,
        text: AppLocalizations.of(context)?.chatBackground ?? '',
        color: theme.colorTheme.scaffoldBackground,
        onPress: () =>
            Navigator.of(context).push(materialRoute(ChatBackgroundPage())),
      ),
      divider
    ];
    return Scaffold(
       appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.appearance ?? ''),
          leading: BrandBackButton(),
      ),
      body:ListView.separated(
      itemCount: listItems.length,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      separatorBuilder: (context, index) =>
      index < listItems.length - 2
          ? divider
          : SizedBox.shrink(),
      itemBuilder: (context, index) => listItems[index],
    ),
    );
  }
}