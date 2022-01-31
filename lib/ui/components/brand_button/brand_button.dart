import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/utils/named_font_weight.dart';

class BrandButton {
  static Widget flat({
    required String text,
    VoidCallback? onPressed,
    TextStyle? textStyle,
  }) =>
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(27, 9, 27, 8),
          primary: BrandColors.primary,
        ),
        child: Text(
          text,
          style: textStyle ?? TextStyle(color: BrandColors.primary, fontSize: 13, fontWeight: FontWeight.w400),
        ),
        onPressed: onPressed,
      );

  static Widget secondary({
    required String text,
    VoidCallback? onPressed,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor
  }) {
    var isDisabled = onPressed == null;

    return Material(
      clipBehavior: Clip.hardEdge,
      color: isDisabled ? CupertinoColors.quaternarySystemFill : backgroundColor,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onPressed,
        onDoubleTap: null,
        child: Container(
          width: double.infinity,
          height: 40,
          //padding: EdgeInsets.symmetric(vertical: 27),
          alignment: Alignment.center,
          child: Text(text, style: textStyle ?? TextStyle(
              color: isDisabled ? CupertinoColors.secondaryLabel : textColor,
              fontSize: 12
          ),),
        ),
      ),
    );
  }

  static Widget blue({
    required String text,
    VoidCallback? onPressed,
    bool isCapitalized = false,
    bool progressIndicator = false,
    double height = 52
  }) =>
      _BrandRisedButton(
        onPressed: onPressed,
        height: height,
        child: progressIndicator ? CircularProgressIndicator() : Text(
          isCapitalized ? text.toUpperCase() : text,
          style: TextStyle(
            fontWeight: NamedWeight.demiBold,
            color: Colors.white,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      );
}

class _BrandRisedButton extends StatelessWidget {
  const _BrandRisedButton({
    Key? key,
    required this.child,
    this.onPressed,
    required this.height
  }) : super(key: key);

  final Widget child;
  final void Function()? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var isDisabled = onPressed == null;
    return Material(
      clipBehavior: Clip.hardEdge,
      color: isDisabled ? BrandColors.grey2 : theme.colorTheme.appBarAlternetiveBackground,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: height,
          //padding: EdgeInsets.symmetric(vertical: 27),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
