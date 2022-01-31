import 'package:flutter/material.dart';

SnackBar snackBar({required String text, required int durationMS, required bool error}) {
  return SnackBar(
    content: Text(text),
    backgroundColor: error ? Colors.red : null,
    duration: Duration(milliseconds: durationMS),
  );
}