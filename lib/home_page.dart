import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/ui/screens/root/root.dart';
import 'package:sputnik/ui/screens/sign_in/sign_in.dart';
import 'package:sputnik/ui/screens/splash/splash.dart';
import 'logic/cubits/authentication/authentication_cubit.dart';
import 'logic/model/auth_model.dart';

import 'logic/services/socket_service.dart';

class HomePage extends StatelessWidget{
//
  HomePage({Key? key}) : super(key: key);

  final Box userBox = Hive.box(BNames.authModel);

  String get token {
    AuthModel authModel = userBox.get(BNames.authModel);
    return authModel.token;
  }




  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          SocketService socketService = GetIt.instance.get<SocketService>();
          WidgetsBinding.instance!.addObserver(socketService.eventHandler);          
          socketService.startSocket();
          return RootPage();
        } else if (state is Registration) {
          return RootPage(); //ProfileForm();
        } else if (state is NotAuthenticated) {
          return SignIn();
        }
        return SplashScreen();
      },
    );
  }
}
