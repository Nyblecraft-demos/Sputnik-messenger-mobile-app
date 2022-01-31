import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sputnik/logic/model/user_extension.dart';

export 'package:sputnik/logic/model/user_extension.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  ChatService chatService = getIt.get<ChatService>();
  Box userBox = Hive.box(BNames.authModel);
  Box usernameBox = Hive.box(BNames.username);

  void silentLogin() async {
    AuthModel? authModel = userBox.get(BNames.authModel);
    debugPrint('silent login:  authModel = $authModel');

    if (authModel == null) {
      emit(NotAuthenticated());
    } else {
      await login(authModel);
    }
  }

  Future login(AuthModel authModel) async {
    String? username = usernameBox.get(BNames.username);
    var event = await chatService.client.connectUser(
      User(id: authModel.id, name: username),
      authModel.token,
    );
//    print(event.);
    debugPrint(
      'AuthenticationCubit:  login:  authModel phone = ${authModel.phoneNumber}   event phone = ${event.phoneNumber}  event = $event',
    );
//    if (!event.isRegistrationCompleted) {
    if (authModel.phoneNumber != null || authModel.phoneNumber.isNotEmpty) {
      userBox.put(BNames.authModel, authModel);
//      print("PH" + authModel.phoneNumber);
      User newUser;
      if (event.extraData['firstname'] != null && event.name == event.id) {
        newUser = event.setWallet(authModel.address).setPhoneNumber(authModel.phoneNumber).setName(event.extraData['firstname'] as String);
      } else {
        newUser = event.setWallet(authModel.address).setPhoneNumber(authModel.phoneNumber);
      }
      await chatService.client.updateUser(newUser);
      emit(Authenticated(newUser, authModel));
    } else {
      registrationStart(event, authModel);
    }
  }

  Future<void> logout() async {
    emit(AuthenticationInProgress());

    await chatService.client.disconnectUser(flushChatPersistence: true); //.disconnect(clearUser: true);
    userBox.clear();
    emit(LoggedOut());
  }

  void update({required User user}) async {
    debugPrint('AuthenticationCubit:  update:  user = $user  phone = ${user.phoneNumber}');
    usernameBox.put(BNames.username, user.name);
    var res = await chatService.client.updateUser(user);
    var data = res.users[user.id];
    debugPrint('AuthenticationCubit:  update:  response = $data  phone = ${user.phoneNumber}');
    if (data != null) {
      emit(Authenticated(data, (state as WithUser).authModel));
    }
  }

  void registrationStart(User user, AuthModel authModel) async {
    var newUser = user.setWallet(authModel.address).setPhoneNumber(authModel.phoneNumber);
    await chatService.client.updateUser(newUser);
    debugPrint('AuthenticationCubit:  registration start:  \nauthModel = $authModel  \nnewUser = $newUser');
    userBox.put(BNames.authModel, authModel);

    emit(Registration(newUser, authModel));
  }
}
