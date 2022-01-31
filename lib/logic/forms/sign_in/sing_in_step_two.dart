import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cubit_form/cubit_form.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/sign_in/sign_in_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';

class SignInStepTwoForm extends FormCubit {
  SignInStepTwoForm(this.signInCubit) {
    codeNumber = FieldCubit(
      initalValue: '',
      validations: [
        RequiredStringValidation('required'),
        PhoneStringValidation(6, '6 didget code')
      ],
    );

    subscription = signInCubit.stream.listen(signInCubitListener);
    super.addFields([codeNumber]);
  }

  late StreamSubscription<SignInState> subscription;

  Future<void> close() async {
    subscription.cancel();
    super.close();
  }

  @override
  FutureOr<void> onSubmit() async {
    signInCubit.sendCode(codeNumber.state.value);
  }

  late SignInCubit signInCubit;

  void signInCubitListener(SignInState signInState) {
    if (signInState is WrongCode) {
      codeNumber.setError(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.wrongCode ?? '');
      codeNumber.showError();
      emit(state.copyWith(isErrorShown: true, isFormValid: false));
    }
  }

  late FieldCubit<String> codeNumber;
}
