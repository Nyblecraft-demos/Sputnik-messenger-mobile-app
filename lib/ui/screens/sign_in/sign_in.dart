import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/cubits/sign_in/sign_in_cubit.dart';
import 'package:sputnik/logic/forms/sign_in/sign_in_step_one.dart';
import 'package:sputnik/logic/forms/sign_in/sing_in_step_two.dart';
import 'package:sputnik/ui/components/brand_alert.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/components/brand_inputs/brand_inputs.dart';
import 'package:sputnik/ui/components/brand_step/brand_step.dart';
import 'package:sputnik/ui/helpers/phone_services/open_url/open_url.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/screens/root/root.dart';

part 'step_one.dart';
part 'step_two.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authCubit = context.watch<AuthenticationCubit>();

    return BlocProvider(
      create: (_) => SignInCubit(authenticationCubit: authCubit),
      child: Builder(
        builder: (context) {
          return BlocListener<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state is SignStepTwo) {
                setState(() {
                  pageIndex = 1;
                });
              } else if (state is SignStepOne) {
                setState(() {
                  pageIndex = 0;
                });
              }
            },
            child: Scaffold(
              body: [
                _PageOne(),
                _PageTwo(),
              ][pageIndex],
            ),
          );
        },
      ),
    );
  }
}
