import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.capitalizeFirst(),
      selection: newValue.selection,
    );
  }
}

extension TextEditingValueExtension on TextEditingValue {
  String capitalizeFirst() {
    if (text.isEmpty) return this.text;
    return "${this.text[0].toUpperCase()}${this.text.substring(1)}";
  }
}