import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/foundation.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/logic/model/user_extension.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileFormCubit extends FormCubit {
  ProfileFormCubit({
    required this.authCubit,
  }) {
    var user = (authCubit.state as WithUser).user;

    avatar = FieldCubit(
      initalValue: user.avatar,
      validations: [],
    );

    name = FieldCubit(
      initalValue: user.name == user.id ? '' : user.name,
      validations: [
        MaxLengthValidation(25, AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.exceededFieldLength ?? ''),
      ],
    );

    surname = FieldCubit(
      initalValue: user.surname,
      validations: [
        //MaxLengthValidation(25, 'Превышенна длина поля: макс 25 символов'),
      ],
    );

    email = FieldCubit(
      initalValue: user.email ?? '',
      validations: [
        EmailStringValidation(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.wrongEmail ?? ''),
      ],
    );

    nickname = FieldCubit(
      initalValue: user.nickname,
      validations: [
        MaxLengthValidation(25, AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.exceededFieldLength ?? ''),
      ],
    );

    bio = FieldCubit(
      initalValue: user.bio ?? "",
      validations: [],
    );

    super.addFields([name, surname, avatar, nickname, bio]);
  }

  //final bool editMode;

  @override
  Future<bool> asyncValidation() async {
    ChatService chatService = getIt.get<ChatService>();
    debugPrint(
        'ProfileFormCubit:  asyncValidation:  nickname = ${nickname.state.value}  initial = ${nickname.state.initialValue}  avatar = ${avatar.state.value}');
    if (nickname.initalValue != nickname.state.value) {
      var resp = await chatService.client
          .queryUsers(filter: Filter.equal('nickname', nickname.state.value));

      if (resp.users.isEmpty) {
        return true;
      } else {
        nickname.setError(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.nicknameTaken ?? '');
        return false;
      }
    }
    return true;
  }

  @override
  FutureOr<void> onSubmit() async {
    var authCubitState = authCubit.state as WithUser;
    ChatService chatService = getIt.get<ChatService>();
    debugPrint(
        'profile:  onSubmit:  name = ${name.state.value}  initial = ${name.state.initialValue}  avatar = ${avatar.state.value}');

    var newUser = authCubitState.user
        .setPhoneNumber(chatService.currentUser.phoneNumber ?? "")
        .setWallet(chatService.currentUser.wallet ?? "")
        .setName(name.state.value)
        .setSurname(surname.state.value)
        //.setEmail(email.state.value)
        .setNickname(nickname.state.value)
        .setAvatar(avatar.state.value)
        .setBio(bio.state.value);

    authCubit.update(user: newUser);
  }

  @override
  void trySubmit() async {
    super.trySubmit();
    onSubmit();
    debugPrint(
        'profile:  trySubmit:  state.isFormDataValid = ${state.isFormDataValid}  errors = ${fields.map((e) => e.state.error)}');
  }

  final AuthenticationCubit authCubit;

  late FieldCubit<String> name;
  late FieldCubit<String> surname;
  late FieldCubit<String> email;
  late FieldCubit<String> nickname;
  late FieldCubit<String?> avatar;
  late FieldCubit<String> bio;
}
