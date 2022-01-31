import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';
import 'package:sputnik/ui/helpers/phone_services/open_url/open_url.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var textStyle = context.watch<BrandTheme>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.about ?? ''),
        leading: BrandBackButton(),
      ),
      body: ListView(
        children: [
          TransparentCard(
            color: theme.colorTheme.scaffoldBackground,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                  children: [Text(
                        AppLocalizations.of(context)?.privacyPolicy ?? '',
                        style: textStyle.h2),
                    Spacer(),
                    _icon
              ]
                ),
                onTap: () => openUrl(AppLocalizations.of(context)?.localeName == 'ru'
                              ? 'https://sputnik-1.com/ru/privacy/'
                               : 'https://sputnik-1.com/privacy/'),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
          TransparentCard(
            color: theme.colorTheme.scaffoldBackground,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                    children: [Text(
                        AppLocalizations.of(context)?.termsOfUse ?? '',
                        style: textStyle.h2),
                      Spacer(),
                      _icon
                    ]
                ),
                onTap: () => openUrl(AppLocalizations.of(context)?.localeName == 'ru'
                    ? 'https://sputnik-1.com/ru/conditions/'
                    : 'https://sputnik-1.com/conditions/'),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
          TransparentCard(
            color: theme.colorTheme.scaffoldBackground,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Row(
                    children: [Text(
                        AppLocalizations.of(context)?.webSite ?? '',
                        style: textStyle.h2),
                      Spacer(),
                      _icon
                    ]
                ),
                onTap: () => openUrl(AppLocalizations.of(context)?.localeName == 'ru'
                    ? 'https://sputnik-1.com/ru/'
                    : 'https://sputnik-1.com'),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20), child: Container(height: 0.5, color: theme.colorTheme.seconadaryGray3)),
    TransparentCard(
    color: theme.colorTheme.scaffoldBackground,
    child: Padding(
    padding: EdgeInsets.only(left: 20, right: 12),
    child: Row(
      children: [
        _versionBuilder(textStyle),
      ],
    )
    )
    )
        ],
      ),
    );
  }
  
  Widget get _icon {
    return Icon(CupertinoIcons.chevron_right,
      color: BrandColors.grey3,
      size: 15,);
  }

  Widget _versionBuilder(BrandTheme textStyle) {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          if( snapshot.connectionState == ConnectionState.waiting) {
            return  Text(
              '${AppLocalizations.of(context)?.version ?? ''} ...',
              style: textStyle.h2
            );
          } else {
            if (snapshot.hasError) {
              return Text(
                '${AppLocalizations.of(context)?.version ?? ''} unknown',
                style: textStyle.h2,
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                '${AppLocalizations.of(context)?.version ?? ''} ${snapshot.data?.version.toString()}',
                style: textStyle.h2,
              ),
                Text(
                  '${AppLocalizations.of(context)?.build ?? ''} ${snapshot.data?.buildNumber}',
                  style: textStyle.small
                ),
          ],
            );
          }

        }

    );
  }
}
