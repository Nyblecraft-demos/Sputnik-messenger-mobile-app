import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool canPopHelper(BuildContext context) {
  final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
  return parentRoute?.canPop ?? false;
}

  void callPhone(phoneNumber) async =>
      phoneNumber != null && await canLaunch('tel:$phoneNumber')
          ? await launch('tel:$phoneNumber')
          : throw 'Could not launch $phoneNumber';