part of 'sign_in_cubit.dart';

abstract class SignInState {
  const SignInState();
}

class SignInProgress extends SignInState {}

class SignStepOne extends SignInState {}

class SignStepTwo extends SignInState {}

class SignPinCode extends SignInState {}

class SignInError extends SignInState {
  SignInError(this.exception);
  final Exception exception;
}

class WrongCode extends SignInState {}
