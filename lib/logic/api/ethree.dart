import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:virgil_e3kit/virgil_e3kit.dart';

const String identity = "identity";

Future<String> tokenCallback() async {
  var host = Uri.parse('http://localhost:8080/jwt');

  //android emulator has different routing
  if (Platform.isAndroid) {
    host = Uri.parse('http://10.0.2.2:8080/jwt');
  }

  var response = await http.post(host, body: '{"identity": identity}');
  final resp = jsonDecode(response.body);

  print("RESP: $resp");
  return resp["jwt"];
}

void initEthree() async {
  try {
//    final ethree = await Ethree.init(identity, tokenCallback);
//    await ethree.register();
    print("DONE");
  } on PlatformException {
    //process error
  }
}
