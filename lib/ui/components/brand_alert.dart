import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sputnik/config/brand_colors.dart';

class BrandAlert {
  static AlertStyle get style => AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      descStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400),
      animationDuration: Duration(milliseconds: 250),
      alertBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      constraints: BoxConstraints.expand(width: 300),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center);

  static TextStyle get buttonTextStyle =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  static DialogButton mainButton(
          {required String title, required Function()? onPressed}) =>
      DialogButton(
          child:
              Text(title, style: buttonTextStyle.copyWith(color: Colors.white)),
          color: BrandColors.primary,
          radius: BorderRadius.circular(12.0),
          onPressed: onPressed);

  static DialogButton loadingMainButton() =>
      DialogButton(
          child: CircularProgressIndicator(),
          color: BrandColors.primary,
          radius: BorderRadius.circular(12.0),
          onPressed: () {});

  static DialogButton secondaryButton(
          {required String? title, required Function()? onPressed}) =>
      DialogButton(
          child: Text(title ?? '',
              style: buttonTextStyle.copyWith(color: Colors.black)),
          color: Colors.white,
          border: Border.fromBorderSide(
              BorderSide(color: Color(0xFF3E589A), width: 1)),
          radius: BorderRadius.circular(12.0),
          onPressed: onPressed);

  static DialogButton secondaryButtonInactive(
      {required String? title}) =>
      DialogButton(
          child: Text(title ?? '',
              style: buttonTextStyle.copyWith(color: Colors.black)),
          color: Colors.blueGrey,
          border: Border.fromBorderSide(
              BorderSide(color: Color(0xFF3E589A), width: 1)),
          radius: BorderRadius.circular(12.0),
          onPressed: (){});

  static bool sendRequest = false;

  static void setStateAlert({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String? secondaryButtonTitle,
    required Function()? secondaryButtonAction,
    required String mainButtonTitle,
    required Function()? mainButtonAction,
  }) => Alert(
      context: context,
      style: style,
      //type: AlertType.info,
      title: title,
      desc: subtitle + '\n\n',
      content: StatefulBuilder(builder: (context, setState) {
        return Row(
          children: [
            Expanded(child: secondaryButton(title: secondaryButtonTitle, onPressed: secondaryButtonAction)),
            Expanded(child: sendRequest ? loadingMainButton() : mainButton(title: mainButtonTitle, onPressed: () {
              setState(() {
                sendRequest = true;
              });
              if (mainButtonAction != null) {
                mainButtonAction();
              }
            }))
          ],
        );
      }),
    buttons: []
    ).show();

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String? secondaryButtonTitle,
    required Function()? secondaryButtonAction,
    required String mainButtonTitle,
    required Function()? mainButtonAction,
  }) =>
      Alert(
        context: context,
        style: style,
        //type: AlertType.info,
        title: title,
        desc: subtitle,
        buttons: secondaryButtonTitle != null
            ? [
                secondaryButton(
                    title: secondaryButtonTitle,
                    onPressed: secondaryButtonAction),
                mainButton(
                  title: mainButtonTitle,
                  onPressed: mainButtonAction, //() => Navigator.pop(context)
                )
              ]
            : [
                mainButton(
                  title: mainButtonTitle,
                  onPressed: mainButtonAction, //() => Navigator.pop(context)
                )
              ],
      ).show();

  static void showInfo({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String mainButtonTitle,
    required Function()? mainButtonAction,
    required Widget? content,
  }) =>
      Alert(
        context: context,
        style: style,
        content: content ?? SizedBox(),
        title: title,
        desc: subtitle,
        buttons:[
        mainButton(
          title: mainButtonTitle,
          onPressed: mainButtonAction,)
        ]
  ).show();
}
