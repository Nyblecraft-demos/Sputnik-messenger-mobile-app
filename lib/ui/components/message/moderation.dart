import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/components/brand_alert.dart';

Set<String> flaggedMessages = {};

Widget flaggedMessage(String id, bool isFlaggedMessagesOn) {
  if (isFlaggedMessagesOn) {
    return Container();
  }
  return flaggedMessages.contains(id)
      ? Container()
      : Positioned(
    top: 0,
    bottom: 0,
    right: 0,
    left: 0,
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Widget returnedWidget = flaggedMessages.contains(id)
            ? Container()
            : GestureDetector(
          onTap: () => _showAlert(
              getIt.get<NavigationService>().navigatorKey.currentContext!,
              id, setState),
          child: Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                  decoration:
                  BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Icon(CupertinoIcons.exclamationmark,
                      size: 20, color: Colors.white)),
            ),
          ),
        );
        return returnedWidget;
      },
    ),
  );
}

void _showAlert(BuildContext context, String id, StateSetter setState) {
  BrandAlert.show(
      context: context,
      title: AppLocalizations.of(context)?.messageReportTitle ?? '',
      subtitle: AppLocalizations.of(context)?.showReportMessage ?? '',
      secondaryButtonTitle: AppLocalizations.of(context)?.cancel,
      secondaryButtonAction: () => Navigator.of(context).pop(),
      mainButtonTitle: "Ok",
      mainButtonAction: () {
        _updateReportMessages(id, setState);
        Navigator.of(context).pop();
      });
}

void _updateReportMessages(String id, StateSetter setState) {
  flaggedMessages.add(id);
  setState(() {});
}
