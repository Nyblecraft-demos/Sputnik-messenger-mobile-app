import 'dart:async';
import 'dart:io';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/foundation.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/api/wallet.dart';
import 'package:sputnik/logic/cubits/balance/balance_cubit.dart';
export 'package:cubit_form/cubit_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';

class SendOuroCubit extends FormCubit {
  SendOuroCubit(String? walletAddress, BalanceCubit balanceCubit) {
    recipientWallet = FieldCubit(
      initalValue: walletAddress ?? '',
      validations: [
        RequiredStringValidation(AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.requiredField ?? ''),
      ],
    );

    amount = FieldCubit(
      initalValue: 0,
      validations: [
        ValidationModel(
          (v) => v == 0,
          AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.requiredField ?? '',
        ),
        ValidationModel(
          (v) => v > (balanceCubit.state as BalanceLoaded).balance,
          AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.noEnoughFunds ?? '',
        )
      ],
    );

    crypto = FieldCubit(initalValue: CryptoToken.OURO,);

    super.addFields([recipientWallet, amount, crypto]);
  }

  @override
  FutureOr<void> onSubmit() async {
    await WalletApi()
        .sendTokens(
      recipientWallet.state.value,
      amount.state.value,
      crypto.state.value
    )
        .then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          break;
      }
    });

    for (var f in fields) {
      if (f is FieldCubit<CryptoToken>) {
        continue;
      } else {
        debugPrint('SendOuroCubit:  reset field = $f');
        f.reset();
      }
    }
  }

  late FieldCubit<String> recipientWallet;
  late FieldCubit<num> amount;
  late FieldCubit<CryptoToken> crypto;
}
