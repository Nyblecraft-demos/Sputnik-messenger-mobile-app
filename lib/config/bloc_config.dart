import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';

import 'package:sputnik/logic/cubits/contacts/contacts_cubit.dart';

class BlocAndProviderConfig extends StatelessWidget {
  const BlocAndProviderConfig({Key? key, required this.child})
      : super(key: key);

  final Widget child; /*!*/

  @override
  Widget build(BuildContext context) {
    var platformBrightness =
        SchedulerBinding.instance!.window.platformBrightness;
    var isDark = platformBrightness == Brightness.dark;
    var authenticationCubit = AuthenticationCubit();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppSettingsCubit(
            isDarkModeOn: isDark,
            isModuleWalletOn: false,
          )..load(),
        ),
        BlocProvider(create: (_) => authenticationCubit..silentLogin()),
        BlocProvider(
          create: (_) => ContactsCubit(authenticationCubit),
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<AppSettingsCubit, AppSettingsState>(
          bloc: context.watch<AppSettingsCubit>(),
          builder: (_, state) {
            return ProxyProvider0(
              update: (_, __) =>
                  BrandTheme(isDarkModeOn: state.isDarkModeOn ?? true),
              child: child,
            );
          },
        );
      }),
    );
  }
}
