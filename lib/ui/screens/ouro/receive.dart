//part of 'ouro.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletReceiveTab extends StatelessWidget {
  const WalletReceiveTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    var walletAddress = (context.watch<AuthenticationCubit>().state as WithUser).user.wallet;
    final addressHidden = AppLocalizations.of(context)?.addressHidden ?? '';
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WalletBalance(),
            SizedBox(height: 24),
            Text(
                AppLocalizations.of(context)?.myAddress ?? '',
                style: brandTheme.fieldLabel),
            SizedBox(height: 12),
            Text(walletAddress != null ? walletAddress.isEmpty ? addressHidden : walletAddress : addressHidden, style: brandTheme.textField1),
            SizedBox(height: 24),
            BrandButton.blue(
              text: AppLocalizations.of(context)?.copyAddress ?? '',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: walletAddress));
                final snackBar = SnackBar(
                  backgroundColor: BrandColors.primary,
                  content: Text(AppLocalizations.of(context)?.walletAddressCopied ?? '', textAlign: TextAlign.center),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}
