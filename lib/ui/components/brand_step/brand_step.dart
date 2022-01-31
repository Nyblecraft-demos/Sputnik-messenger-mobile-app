import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_theme.dart';

class BrandStep extends StatelessWidget {
  const BrandStep({
    Key? key,
    required this.text,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  final String text;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var widget = Container(
      height: 29,
      width: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorTheme.stepButton,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: isActive ? CupertinoColors.label : CupertinoColors.tertiaryLabel, width: 1),
      ),
      child: Text(
        text,
        style: isActive
            ? theme.textField1.copyWith(color: CupertinoColors.label)
            : theme.textField1.copyWith(color: CupertinoColors.tertiaryLabel),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    } else {
      return widget;
    }
  }
}
