import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/utils/named_font_weight.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DismissibleItem extends StatelessWidget {
  const DismissibleItem({
    Key? key,
    this.onDismissed,
    required this.child,
  }) : super(key: key);

  final ValueSetter? onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      resizeDuration: Duration(milliseconds: 200),
      movementDuration: Duration(milliseconds: 100),
      background: background(context),
      child: child,
    );
  }

  Widget background(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        //borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(CupertinoIcons.trash, color: Colors.white),
          SizedBox(height: 4),
          Text(
              AppLocalizations.of(context)?.delete ?? '',
              style: TextStyles.small.copyWith(color: Colors.white, fontWeight: NamedWeight.demiBold))
        ],
      ),
    );
  }
}