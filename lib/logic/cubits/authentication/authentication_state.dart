part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

abstract class WithUser extends AuthenticationState {
  final User user;

  WithUser({required this.user, required this.authModel});

  final AuthModel authModel;

  @override
  List<Object> get props => [user];
}

class Registration extends WithUser {
  Registration(User user, AuthModel authModel)
      : super(user: user, authModel: authModel);
}

class Authenticated extends WithUser {
  Authenticated(User user, AuthModel authModel)
      : super(user: user, authModel: authModel);

  @override
  List<Object> get props => [user, user.extraData, authModel];
}

class NotAuthenticated extends AuthenticationState {}

class LoggedOut extends NotAuthenticated {}
