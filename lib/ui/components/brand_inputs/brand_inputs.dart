import 'dart:async';
import 'dart:math';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/forms/sign_in/phone_input_formatter/phone_input_formatter.dart';


part 'big_input.dart';
part 'input_with_label.dart';
part 'address.dart';
part 'count.dart';

class BrandInputs {
  static Widget big({
    Key? key,
    required FieldCubit<String> fieldCubit,
    required String mask,
    String? hintText,
  }) =>
      BigInput(
        key: key,
        fieldCubit: fieldCubit,
        mask: mask,
        hintText: hintText,
        textAlign: TextAlign.center,
      );

  static Widget address({
    Key? key,
    required FieldCubit<String> fieldCubit,
    String? hintText,
  }) =>
      _Address(
        key: key,
        fieldCubit: fieldCubit,
        hintText: hintText,
      );
  static Widget count({
    Key? key,
    required FieldCubit<num> fieldCubit,
  }) =>
      _Count(
        key: key,
        fieldCubit: fieldCubit,
      );
  static Widget withLabel(
          {Key? key,
          required FieldCubit<String> fieldCubit,
          required String label,
          double? height,
          BrandTheme? theme,
          int? lines,
          TextInputFormatter? formatter}) =>
      InputWithLabel(
        key: key,
        fieldCubit: fieldCubit,
        label: label,
        height: height,
        theme: theme,
        lines: lines,
        formatter: formatter
      );
}
