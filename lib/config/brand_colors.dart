import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class BrandColors {
  static const Color black1 = Colors.black;
  static const Color black2 = Color(0xFF141B23);
  static const Color black3 = Color(0xFF19202A);

  static const Color blue1 = Color(0xFF3676ea);
  static const Color blue2 = Color(0xFF4d86fa);
  static const Color blue3 = Color(0xFF6563FF);

  static const Color white = Colors.white;

  static const Color grey1 = Color(0xFF293039);
  static const Color grey2 = Color(0xFF8C8C8C);
  static const Color grey3 = Color(0xFFCBCDCE);
  static const Color grey4 = Color(0xFFEFF1F3);

  static const Color red = Color(0xFFEC2A2A);

  static const Color primary = Color(0xFF3E589A);

  /// Light
  static const Color lightPrimaryBlue = Color(0xFF3E589A);
  static const Color lightSecondaryBlue = Color(0xFFF3F5F8);
  static const Color lightPrimaryBlack = Colors.black;
  static const Color lightPrimaryWhite = Colors.white;
  static const Color lightSecondaryRed = Color(0xFFE34848);
  static const Color lightPrimaryBlue2 = Color(0xFF6B95FF);
  static const Color lightSecondaryBlue2 = Color(0xFFE9EFFF);
  static const Color lightPrimaryPink = Color(0xFFFF6BA9);
  static const Color lightSecondaryPink = Color(0xFFFFE9F2);
  static const Color lightPrimaryOrange = Color(0xFFFFAE4F);
  static const Color lightSecondaryOrange = Color(0xFFFFF3E5);
  static const Color lightPrimaryGreen = Color(0xFF45AB20);
  static const Color lightSecondaryGreen = Color(0xFFE3F2DE);
  static const Color lightPrimaryGreenCall = Color(0xFF73CA72);
  static const Color lightSecondaryBlue3 = Color(0xFF9BB3D4);
  static const Color lightSecondaryBlue4 = Color(0xFFE0E5EC);
  static const Color lightSecondaryGray1 = Color(0xFF1D1D1D);
  static const Color lightSecondaryGray2 = Color(0xFF797979);
  static const Color lightSecondaryGray3 = Color(0xFFC6C6C6);
  static const Color lightSecondaryGray4 = Color(0xFFE7E7E7);

  /// Dark
  static const Color darkPrimaryBlue = Color(0xFF6B95FF);
  static const Color darkSecondaryBlue = Color(0xFF313E5D);
  static const Color darkPrimaryBlack = Color(0xFFFFF0FF);
  static const Color darkPrimaryWhite = Color(0xFF181818);
  static const Color darkSecondaryRed = Color(0xFFCF6679);
  static const Color darkPrimaryBlue2 = Color(0xFF6B95FF);
  static const Color darkSecondaryBlue2 = Color(0xFF293146);
  static const Color darkPrimaryPink = Color(0xFFCE3877);
  static const Color darkSecondaryPink = Color(0xFF3B242E);
  static const Color darkPrimaryOrange = Color(0xFFFFAE4F);
  static const Color darkSecondaryOrange = Color(0xFF3B2E20);
  static const Color darkPrimaryGreen = Color(0xFF73CA72);
  static const Color darkSecondaryGreen = Color(0xFF1E3516);
  static const Color darkPrimaryGreenCall = Color(0xFF73CA72);
  static const Color darkSecondaryBlue3 = Color(0xFF9BAACE);
  static const Color darkSecondaryBlue4 = Color(0xFF4B5B82);
  static const Color darkSecondaryGray1 = Color(0xFF3E589A);
  static const Color darkSecondaryGray2 = Color(0xFF8B8B8B);
  static const Color darkSecondaryGray3 = Color(0xFF696469);
  static const Color darkSecondaryGray4 = Color(0xFF6179B1);


  /// Dark theme:
  static final darkThemeColors = BrandColorTheme(
    scaffoldBackground: darkPrimaryWhite,
    highlightedText: darkPrimaryBlack,
    defaultText: darkSecondaryGray2,
    textField: darkPrimaryBlack,
    backgroundColor1: darkSecondaryGray4,
    appBarAlternetiveBackground: darkPrimaryBlue,
    bubleBackground: darkSecondaryGray1,
    inputBackgroundColor: darkSecondaryGray2,
    seconadaryGray3: darkSecondaryGray3,
    grayText: darkPrimaryBlack,
    buttonsColorEnable: lightSecondaryGray2,
    buttonsColorDisable: lightSecondaryGray2,
    textButtonsColorEnable: darkPrimaryBlack,
    textButtonsColorDisable: lightSecondaryGray3,
    editProfileBackground: darkSecondaryGray4,
    hintText: lightSecondaryGray4,
    opponentChat: lightPrimaryBlue,
    mineChat: darkPrimaryBlue,
    stepButton: lightSecondaryGray3,
    chatSettingsBackground: lightSecondaryGray2,
    dateChatBackground: darkSecondaryGray3,
    transCardBackground: darkSecondaryGray3,
    transCardText: lightSecondaryGray4,
    aboutBackground: darkSecondaryGray1
  );

  /// Light theme:
  static final lightThemeColors = BrandColorTheme(
    scaffoldBackground: lightPrimaryWhite,
    highlightedText: lightPrimaryBlack,
    defaultText: lightSecondaryGray2,
    textField: lightPrimaryBlack,
    backgroundColor1: lightSecondaryGray4,
    appBarAlternetiveBackground: lightPrimaryBlue,
    bubleBackground: lightSecondaryGray1,
    inputBackgroundColor: lightPrimaryWhite,
    seconadaryGray3: lightSecondaryGray3,
    grayText: lightSecondaryGray3,
    buttonsColorEnable: lightSecondaryGray4,
    buttonsColorDisable: lightSecondaryGray2,
    textButtonsColorEnable: lightPrimaryBlack,
    textButtonsColorDisable: lightSecondaryGray3,
    editProfileBackground: lightSecondaryGray4,
    hintText: lightSecondaryGray2,
    opponentChat: lightSecondaryBlue,
    mineChat: lightPrimaryBlue,
    stepButton: lightPrimaryWhite,
    chatSettingsBackground: lightSecondaryGray4,
    dateChatBackground: lightSecondaryGray3,
    transCardBackground: lightSecondaryGray3,
    transCardText: lightPrimaryBlack,
    aboutBackground: lightSecondaryBlue3
  );

  /*
  static final darkThemeColors = BrandColorTheme(
    scaffoldBackground: black2,
    highlightedText: white,
    defaultText: grey2,
    textField: white,
    backgroundColor1: grey1,
    appBarAlternetiveBackground: black3,
    bubleBackground: grey1,
    inputBackgroundColor: Colors.green,
  );

  /// Light theme:
  static final lightThemeColors = BrandColorTheme(
    scaffoldBackground: grey4,
    highlightedText: black1,
    defaultText: grey2,
    textField: black1,
    backgroundColor1: grey3,
    appBarAlternetiveBackground: white,
    bubleBackground: white,
    inputBackgroundColor: Colors.red,
  );
   */
}

class BrandColorTheme {
  BrandColorTheme({
    required this.scaffoldBackground,
    required this.highlightedText,
    required this.defaultText,
    required this.textField,
    required this.backgroundColor1,
    required this.appBarAlternetiveBackground,
    required this.bubleBackground,
    required this.inputBackgroundColor,
    required this.seconadaryGray3,
    required this.grayText,
    required this.buttonsColorEnable,
    required this.buttonsColorDisable,
    required this.textButtonsColorEnable,
    required this.textButtonsColorDisable,
    required this.editProfileBackground,
    required this.hintText,
    required this.opponentChat,
    required this.mineChat,
    required this.stepButton,
    required this.chatSettingsBackground,
    required this.dateChatBackground,
    required this.transCardBackground,
    required this.transCardText,
    required this.aboutBackground,
  });

  final Color scaffoldBackground;
  final Color highlightedText;
  final Color defaultText;
  final Color textField;
  final Color backgroundColor1;
  final Color appBarAlternetiveBackground;
  final Color tabBarTextColor = BrandColors.grey2;
  final Color seconadaryGray3;

  final Color bubleBackground;
  final Color inputBackgroundColor;
  final Color grayText;
  final Color buttonsColorEnable;
  final Color buttonsColorDisable;
  final Color textButtonsColorEnable;
  final Color textButtonsColorDisable;
  final Color editProfileBackground;
  final Color hintText;
  final Color opponentChat;
  final Color mineChat;
  final Color stepButton;
  final Color chatSettingsBackground;
  final Color dateChatBackground;
  final Color transCardBackground;
  final Color transCardText;
  final Color aboutBackground;
}
