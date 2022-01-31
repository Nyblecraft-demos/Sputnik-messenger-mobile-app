import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/api/awards.dart';
import 'package:sputnik/ui/components/brand_card_transaction/brand_card_transaction.dart';
import 'package:sputnik/ui/components/loader/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    return FutureBuilder(
        future: UserReward().withdrawHistory(),
        builder: (BuildContext context, AsyncSnapshot<List<TransactionsData>?> snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return BrandCardTransaction(theme: brandTheme, data: snapshot.data![index]);
                      }),
                ),
                SizedBox(height: 130,)
          ],
            );
          }
          if (snapshot.hasData && snapshot.data!.length == 0) {
            return Center(
                child: Text(
                    AppLocalizations.of(context)?.noTransaction ?? '',
                    style: TextStyles.h3.copyWith(
                        color: CupertinoColors.secondaryLabel,
                        height: 1)
                )
            );
          }
          return Loader(text: AppLocalizations.of(context)?.loading ?? '');
    });
  }
}
