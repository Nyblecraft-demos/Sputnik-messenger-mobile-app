import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

part 'auth_dependent_state.dart';

abstract class AuthDependentCubit<T extends AuthDependentState> extends Cubit<T> {
  AuthDependentCubit(
    AuthenticationCubit authCubit,
    AuthDependentState initState,
  ) : super(initState as T) {
    authCubitSubscription = authCubit.stream.listen(checkAuthStatus);
    checkAuthStatus(authCubit.state);
  }

  void checkAuthStatus(AuthenticationState state) {
    if (state is Authenticated) {
      load(state.user);
    } else if (state is LoggedOut) {
      clear();
    }
  }

  StreamSubscription? authCubitSubscription;

  void load(User user);
  void clear();

  @override
  Future<void> close() {
    authCubitSubscription?.cancel();
    return super.close();
  }
}
