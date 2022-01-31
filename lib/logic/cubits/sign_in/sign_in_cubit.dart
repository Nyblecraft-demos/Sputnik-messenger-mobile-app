import 'package:bloc/bloc.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/api/phone_verification.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:sputnik/ui/screens/pin_code/pin_code.dart';

part 'sign_in_state.dart';
part 'sign_in_repository.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.authenticationCubit}) : super(SignStepOne()) {
    repository = SignInRepository(
      onLogin: (AuthModel authDto) => authenticationCubit.login(authDto),
      onWrongCode: () => emit(WrongCode()),
      onOtherError: (Exception e) => emit(SignInError(e)),
    );
  }

  final AuthenticationCubit authenticationCubit;

  SignInRepository? repository;

  void sendPhone(String phone) async {
    emit(SignInProgress());
    debugPrint('SignInCubit:  send phone = $phone');
    var res = await repository?.requestCode(phone);
    debugPrint('SignInCubit:  res = $res');
    var newState = res?.fold(
      (e) => SignInError(e),
      (bool) => SignStepTwo(),
    );
    if (newState != null)
      emit(newState);
  }

  Future<void> sendCode(String code) async {
    //var data = code.replaceAll(RegExp('-'), '');
    emit(SignInProgress());
    var res = await repository?.sendCode(code);
    var newState = res?.fold(
          (e) => WrongCode(),
          (auth) {
            repository?.onLogin(auth);
            return SignPinCode();
          },
    );
    if (newState != null) {
      emit(newState);
    }
  }

  void resetPhone() {
    emit(SignInProgress());
    emit(SignStepOne());
  }
}
