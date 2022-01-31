import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/sign_in/sign_in_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';

class SignInStepOneForm extends FormCubit {
  SignInStepOneForm(this.signInCubit) {
    phoneNumber = FieldCubit(
      initalValue: '',
      validations: [
        RequiredStringValidation(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.requiredField ?? ''),
        ValidationModel(
          (p) {
            var phoneLengh = p.replaceAll(new RegExp(r"\D"), "").length;
            return phoneLengh < 10 || phoneLengh > 23;
          },
          AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.wrongPhone ?? '',
        )
      ],
    );

    subscription = signInCubit.stream.listen(signInCubitListener);
    super.addFields([phoneNumber]);
  }

  late StreamSubscription<SignInState> subscription;

  Future<void> close() async {
    subscription.cancel();
    super.close();
  }

  void signInCubitListener(SignInState signInState) {
    if (signInState is SignInError) {
      phoneNumber.setError(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.wrongPhone ?? '');
      phoneNumber.showError();
      emit(state.copyWith(isErrorShown: true, isFormValid: false));
    }
  }

  @override
  FutureOr<void> onSubmit() async {
    var phoneString =
        phoneNumber.state.value.replaceAll(RegExp(r'[+()-\W]'), '');
    debugPrint('SignInStepOneForm:  send phone = +$phoneString');
    signInCubit.sendPhone('+$phoneString');
  }

  late final SignInCubit signInCubit;

  late FieldCubit<String> phoneNumber;
  late VoidCallback onSave;
}
