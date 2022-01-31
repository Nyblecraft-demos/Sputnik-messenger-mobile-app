import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';

class BrandChatBackground extends StatelessWidget {
  BrandChatBackground({
    Key? key,
    required this.selectedBackground,
    required this.background,
    required this.onPressed,
  }) : super(key: key);

  final String? selectedBackground;
  final String background;
  late final BrandTheme theme;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    theme = context.watch<BrandTheme>();
    return GestureDetector(
      onTap: () => onPressed(background),
      child: Container(
        decoration: BoxDecoration(
          color: background.contains('png') ? null : _color,
          image: background.contains('png') ? _backgroundImage : null,
        ),
        child: circle(),
      ),
    );
  }

  Widget circle() {
    if (selectedBackground != null && selectedBackground == background) {
      return Align(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: BrandColors.lightSecondaryGray4,
            shape: BoxShape.circle,
          ),
          child: Icon(CupertinoIcons.check_mark,
              color: theme.colorTheme.appBarAlternetiveBackground),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Color? get _color {
    if (background == 'light') { return BrandColors.lightPrimaryWhite; }
    if (background == 'dark') { return BrandColors.darkPrimaryWhite; }
  }

  DecorationImage get _backgroundImage {
    return DecorationImage (
        image: AssetImage('assets/chat_backgrounds/$background'),
        fit: BoxFit.cover
    );
  }
}

