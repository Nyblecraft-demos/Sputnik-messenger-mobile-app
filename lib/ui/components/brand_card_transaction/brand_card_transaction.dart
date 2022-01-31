import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/api/awards.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/helpers/phone_services/open_url/open_url.dart';

class BrandCardTransaction extends StatelessWidget {
  const BrandCardTransaction({
    Key? key,
    required this.theme,
    required this.data,
  }) : super(key: key);

  final BrandTheme theme;
  final TransactionsData data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: theme.colorTheme.transCardBackground),
        child: Column(children: [
          Row(
            children: [
              _dataText(AppLocalizations.of(context)?.transID ?? ''),
              Spacer(),
              _dataText(data.slug, true),
            ],
          ),
          Row(
            children: [
              _dataText(AppLocalizations.of(context)?.transAmount ?? ''),
              Spacer(),
              _dataText(data.amount.toString(), true),
            ],
          ),
          Row(
            children: [
              _dataText(AppLocalizations.of(context)?.transDate ?? ''),
              Spacer(),
              _dataText(DateFormat('dd/MM/yyyy – HH:mm').format(data.date), true),
            ],
          ),
          Row(
            children: [
              _dataText(AppLocalizations.of(context)?.transStatus ?? ''),
              Spacer(),
              _dataText(data.status, true),
            ],
          ),
          SizedBox(height: 10,),
          BrandButton.blue(text: (AppLocalizations.of(context)?.transDetail ?? ''), height: 35, onPressed: data.explorerUrl == null ? null : () => openUrl(data.explorerUrl!))
        ]));
  }

  Widget _dataText(String text, [bool bold = false]) {
    return Text(
      text,
      style: TextStyle(
          color: theme.colorTheme.transCardText,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
