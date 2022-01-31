import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';

class ChatFormCubit extends FormCubit {
  ChatFormCubit(this.saveText) {
    message = FieldCubit(
      initalValue: '',
      validations: [
        RequiredStringValidation('Обязательное поле'),
      ],
    );

    super.addFields([message]);
  }

  @override
  FutureOr<void> onSubmit() async {
    saveText(message.state.value);
    for (var f in fields) {
      f.reset();
    }
  }

  final ValueChanged<String> saveText;

  late FieldCubit<String> message;
}
