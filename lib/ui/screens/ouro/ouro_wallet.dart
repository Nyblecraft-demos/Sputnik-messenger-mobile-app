import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/balance/balance_cubit.dart';
import 'package:sputnik/logic/forms/send_form/send_form.dart';
import 'package:sputnik/ui/components/base_tabbar.dart';
import 'package:sputnik/ui/helpers/unfocus/unfocus.dart';
import 'package:sputnik/ui/screens/ouro/receive.dart';
import 'package:sputnik/ui/screens/ouro/sent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/screens/ouro/transactions.dart';

class OuroWalletPage extends StatefulWidget {
  const OuroWalletPage({
    Key? key,
    this.walletAddress
  }) : super(key: key);

  final String? walletAddress;

  @override
  _OuroWalletPageState createState() => _OuroWalletPageState();
}

class _OuroWalletPageState extends State<OuroWalletPage>
    with SingleTickerProviderStateMixin {
  int _currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    List<TabItem> tabsContent = [
      TabItem(
        tab: BaseTab(text: AppLocalizations.of(context)?.send ?? ''),
        page: WalletSentTab(walletAddress: widget.walletAddress),
      ),
      TabItem(
        tab: BaseTab(text: AppLocalizations.of(context)?.receive ?? ''),
        page: WalletReceiveTab(),
      ),
      TabItem(
        tab: BaseTab(text: AppLocalizations.of(context)?.transactions ?? ''),
        page: Transactions(),
      ),
    ];

    return DefaultTabController(
      initialIndex: _currentPosition,
      length: tabsContent.length,
      child: UnfocusOnTap(
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 1,
            bottom: BaseTabBar(
                tabs: tabsContent.map((e) => e.tab).toList(),
                onTap: (index) {
                  setState(() {
                    _currentPosition = index;
                  });
                }
            ),
          ),
          body: TabBarView(
            children: tabsContent.map((e) => e.page).toList(),
          ),
        ),
      ),
    );
  }
}

class WalletBalance extends StatefulWidget {
  const WalletBalance({this.callBack, Key? key}) : super(key: key);

  final Function(CryptoToken crypto)? callBack;

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {

  late CryptoToken crypto;
  var balanceCubit = BalanceCubit();

  @override
  void initState() {
    crypto = CryptoToken.OURO;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: BlocProvider(
          lazy: false,
          create: (_) => balanceCubit..check(crypto),
          child: Builder(builder: (context) {
            var balanceCubit = context.watch<BalanceCubit>();

            if (balanceCubit.state is! BalanceLoaded) {
              return Center(
                child: SizedBox(
                  height: 48,
                  child: Center(
                      child: Text(AppLocalizations.of(context)?.loadingBalance ?? '',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: CupertinoColors.secondaryLabel
                        ),
                        textAlign: TextAlign.center,
                      ),
                  )
                ),
              );
            }

            return Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                          onChanged: (newVal) {
                            balanceCubit.reloadBalance(newVal as CryptoToken);
                            if (widget.callBack != null) {
                              widget.callBack!(newVal);
                            }
                            setState(() {
                              crypto = newVal;
                            });
                          },
                        value: crypto,
                          items: [
                            DropdownMenuItem(
                              child: Row(children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/images/ouro.png',
                                      fit: BoxFit.fill,
                                    ),
                                    // child: Image.asset('assets/images/mock.png'),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Text('OURO')
                              ],),
                        value: CryptoToken.OURO,
                      ),
                        DropdownMenuItem(
                          child: Row(children: [
                            Container(
                              height: 30,
                              width: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/sput.png',
                                  fit: BoxFit.fill,
                                ),
                                // child: Image.asset('assets/images/mock.png'),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Text('SPUT')
                          ],),
                          value: CryptoToken.SPUT,
                        ),

                      ]),
                    ),
                    SizedBox(width: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                (balanceCubit.state as BalanceLoaded).balance.toString(),
                                style: brandTheme.bigbigNumbers,
                              maxLines: 1,
                            ),
                          ),
                        ],
                  ),
                    ),
                  ]
                ),
            );
          }),
        )
    );
  }
}

enum CryptoToken {
  OURO, SPUT
}
