import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future openUrl(String url) async {
  if (await canLaunch(url)) {
    debugPrint('open url: $url}');
    await launch(url);
  } else {
    debugPrint('can not open url: $url}');
  }
}