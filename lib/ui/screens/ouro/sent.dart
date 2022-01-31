import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/balance/balance_cubit.dart';
import 'package:sputnik/logic/forms/send_form/send_form.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/components/brand_inputs/brand_inputs.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';
import 'package:sputnik/utils/help_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletSentTab extends StatefulWidget {
  const WalletSentTab({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  final String? walletAddress;

  @override
  State<WalletSentTab> createState() => _WalletSentTabState();
}

class _WalletSentTabState extends State<WalletSentTab> {
  CryptoToken crypto = CryptoToken.OURO;
  late SendOuroCubit form;

  void _cryptoCallBack(CryptoToken newVal) {
    form.crypto.setValue(newVal);
  }

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    final bool canPop = canPopHelper(context);
    return SingleChildScrollView(
      child: BlocProvider(
        create: (_) => BalanceCubit()..check(crypto),
        child: Builder(builder: (context) {
          var balanceCubit = context.watch<BalanceCubit>();
          return BlocProvider(
            create: (_) => SendOuroCubit(widget.walletAddress, balanceCubit),
            child: Builder(
              builder: (context) {
                form = context.watch<SendOuroCubit>();
                return BlocListener<SendOuroCubit, FormCubitState>(
                  bloc: form,
                  listener: (context, state) {
                    if (state.isSubmitted) {
                      if (canPop) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WalletBalance(callBack: _cryptoCallBack),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)?.recipient ?? '',
                          style: brandTheme.fieldLabel,
                        ),
                        SizedBox(height: 12),
                        BrandInputs.address(
                          fieldCubit: form.recipientWallet,
                          hintText: AppLocalizations.of(context)?.addressOfRecipient ?? '',
                        ),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)?.transferAmount ?? '',
                          style: brandTheme.fieldLabel,
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: BrandInputs.count(fieldCubit: form.amount),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: 50,
                                child: Text(form.crypto.state.value == CryptoToken.OURO ? 'OURO' : 'SPUT',
                                    style: brandTheme.highlightedText.copyWith(fontSize: 14)
                                ),
                              ),
                            ),
                          ],
                        ),
                        //BrandDivider(),
                        BlocBuilder<FieldCubit, FieldCubitState>(
                          bloc: form.amount,
                          builder: (_, state) {
                            if (state.isErrorShown && state.error != null) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 30, top: 10),
                                child: Text(state.error ?? '',
                                  style: brandTheme.textField1.copyWith(color: BrandColors.red),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(height: 24),
                        BlocBuilder<FieldCubit, FieldCubitState>(
                            bloc: form.amount,
                            builder: (_, state) =>
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.value > 0
                                        ? Text('${AppLocalizations.of(context)?.amountToDebited ?? ''}: ${state.value + 0.025} OURO',
                                          style: brandTheme.highlightedText.copyWith(fontSize: 12),
                                        )
                                        : SizedBox.shrink(),
                                    SizedBox(height: 36),
                                    BrandButton.blue(text: AppLocalizations.of(context)?.send ?? '',
                                      onPressed: state.value > 0 ? form.trySubmit : null,
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
