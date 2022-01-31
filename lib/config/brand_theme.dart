import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/utils/named_font_weight.dart';
export 'package:provider/provider.dart';

class BrandTheme {
  BrandTheme({
    required bool isDarkModeOn
  })
      : colorTheme = isDarkModeOn ? BrandColors.darkThemeColors : BrandColors.lightThemeColors
  {
    body = TextStyles.body.copyWith(color: colorTheme.defaultText);
    highlightedText = TextStyles.body.copyWith(color: colorTheme.highlightedText);
    fieldLabel = TextStyles.fieldLabel.copyWith(color: colorTheme.defaultText);
    h1 = TextStyles.h1.copyWith(color: colorTheme.highlightedText);
    h2 = TextStyles.h2.copyWith(color: colorTheme.highlightedText);
    h3 = TextStyles.h3.copyWith(color: colorTheme.highlightedText);
    small = TextStyles.small.copyWith(color: colorTheme.defaultText);
    textField1 = TextStyles.textField.copyWith(color: colorTheme.textField);
    textField2 = TextStyles.textField2.copyWith(color: colorTheme.textField);
    bigNumbers = TextStyles.bigNumbers.copyWith(color: colorTheme.textField);
    bigbigNumbers = TextStyles.bigbigNumbers.copyWith(color: colorTheme.textField);
    tabButton = TextStyles.tabButton.copyWith(color: colorTheme.tabBarTextColor);
    light = TextStyles.light.copyWith(color: colorTheme.textField);
  }

  final BrandColorTheme colorTheme;

  late TextStyle body;
  late TextStyle highlightedText;
  late TextStyle h1;
  late TextStyle h2;
  late TextStyle h3;
  late TextStyle textField1;
  late TextStyle textField2;
  late TextStyle bigNumbers;
  late TextStyle bigbigNumbers;

  late TextStyle tabButton;
  late TextStyle fieldLabel;

  late TextStyle small;
  late TextStyle light;
}

class TextStyles {
  static const h1 = TextStyle(fontSize: 18, fontWeight: NamedWeight.demiBold);
  static const h2 = TextStyle(fontSize: 15, fontWeight: NamedWeight.medium);
  static const h3 = TextStyle(fontSize: 15, fontWeight: NamedWeight.demiBold);
  static const body = TextStyle(fontSize: 15, letterSpacing: 0.5);
  static const textField = TextStyle(fontSize: 13, color: BrandColors.white);
  static const bigNumbers = TextStyle(fontSize: 24, color: BrandColors.white);
  static const bigbigNumbers = TextStyle(fontSize: 36, fontWeight: NamedWeight.demiBold, color: BrandColors.white);

  static const fieldLabel = TextStyle(fontSize: 13, color: BrandColors.white);

  static const textField2 = TextStyle(fontSize: 18, color: BrandColors.white);
  static const tabButton = TextStyle(fontSize: 14, color: BrandColors.white);

  static const small = TextStyle(fontSize: 13);
  static const light = TextStyle(fontSize: 15, fontWeight: NamedWeight.light);
  static const appBar = h1;
}

final paddingV24H0 = EdgeInsets.symmetric(horizontal: 24);
final paddingV20H0 = EdgeInsets.symmetric(horizontal: 20);
final paddingV10H0 = EdgeInsets.symmetric(horizontal: 10);
final paddingV27H30 = EdgeInsets.symmetric(vertical: 27, horizontal: 30);
