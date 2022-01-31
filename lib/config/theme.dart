import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';

import 'brand_theme.dart';

var brandThemeLight = ThemeData(
  primaryColor: BrandColors.lightPrimaryBlue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: BrandColors.lightPrimaryWhite,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: BrandColors.lightPrimaryBlue,
    iconTheme: IconThemeData(color: BrandColors.blue1),
    elevation: 0
  ),
  primaryTextTheme: TextTheme(
    bodyText1: TextStyles.body.copyWith(
      color: BrandColors.lightPrimaryBlack,
    ),
    headline6: TextStyles.appBar,
  ),
);

var brandThemeDark = ThemeData(
  primaryColor: BrandColors.darkPrimaryBlue,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: BrandColors.darkPrimaryWhite,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: BrandColors.darkPrimaryBlue,
      iconTheme: IconThemeData(color: BrandColors.blue1),
      elevation: 0
  ),
  primaryTextTheme: TextTheme(
    bodyText1: TextStyles.body.copyWith(
      color: BrandColors.darkPrimaryBlack,
    ),
    headline6: TextStyles.appBar,
    ),
);

// var darkTheme = ThemeData(
//   primaryColor: BrandColors.blue1,
//   brightness: Brightness.light,
//   scaffoldBackgroundColor: BrandColors.darkThemeColors.scaffoldBackground,
//   appBarTheme: ligtTheme.appBarTheme.copyWith(
//     brightness: Brightness.dark,
//     color: BrandColors.primary,
//     iconTheme: IconThemeData(color: BrandColors.blue1),
//     elevation: 0,
//   ),
//   primaryTextTheme: TextTheme(
//     bodyText1: TextStyles.body.copyWith(
//       color: BrandColors.black1,
//     ),
//     headline6: TextStyles.appBar.copyWith(
//       color: BrandColors.white,
//     ),
//   ),
// );

/*
var ligtTheme = ThemeData(
  primaryColor: BrandColors.blue1,
  brightness: Brightness.light,
  scaffoldBackgroundColor: BrandColors.lightThemeColors.scaffoldBackground,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: BrandColors.lightThemeColors.scaffoldBackground,
    iconTheme: IconThemeData(color: BrandColors.blue1),
  ),
  primaryTextTheme: TextTheme(
    bodyText1: TextStyles.body.copyWith(
      color: BrandColors.black1,
    ),
    headline6: TextStyles.appBar.copyWith(
      color: BrandColors.black1,
    ),
  ),
);

var darkTheme = ligtTheme.copyWith(
  primaryColor: BrandColors.blue1,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: BrandColors.darkThemeColors.scaffoldBackground,
  appBarTheme: ligtTheme.appBarTheme.copyWith(
    brightness: Brightness.dark,
    color: BrandColors.darkThemeColors.scaffoldBackground,
  ),
  primaryTextTheme: TextTheme(
    bodyText1: TextStyles.body.copyWith(
      color: BrandColors.white,
    ),
    headline6: TextStyles.appBar.copyWith(
      color: BrandColors.white,
    ),
  ),
);
 */


final phoneFilter = {"_": RegExp(r'[0-9]')};
final codeFilter = {"#": RegExp(r'[0-9]')};
