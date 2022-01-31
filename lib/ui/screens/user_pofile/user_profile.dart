import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/ouro/ouro.dart';
import 'package:sputnik/ui/screens/user_pofile/edit_user_profile.dart';
import 'package:sputnik/utils/time_helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sputnik/logic/model/user_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.user,
    this.allowToEdit = false,
  }) : super(key: key);

  final User user;
  final bool allowToEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF3F5F8),
        body: CustomScrollView(
          slivers: <Widget>[
            profileAppBar(context),
            SliverList(
                delegate: SliverChildListDelegate.fixed(
                    [InformationList(context), Divider])),
          ],
        ));
  }

  Widget profileAppBar(BuildContext context) => SliverAppBar(
        leading: BrandBackButton(),
        actions: allowToEdit
            ? [
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .push(materialRoute(EditUserProfile())),
                  child: Text(
                    AppLocalizations.of(context)?.change ?? '',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
              ]
            : null,
        expandedHeight: 256,
        floating: true,
        pinned: true,
        //snap: true,
        //elevation: 50,
        backgroundColor: BrandColors.primary,
        flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BrandAvatarCircle(
                    user: user,
                    size: 88,
                    circleColor: BrandColors.blue1,
                    backgroundColor: BrandColors.primary,
                    showStatus: true,
                  ),
                  SizedBox(height: 12),
                  Text(
                    user.getShortName(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(user.online ?
                    (AppLocalizations.of(context)?.online ?? '') :
                    '${AppLocalizations.of(context)?.lastVisit} ${timeAgo(user.lastActive)}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.5)),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleButton(
                        icon: Icon(BrandIcons.ouro,
                            color: user.wallet != null
                                ? Color(0xFF5F5CE4)
                                : Colors.black45,
                            size: 20),
                        isActive: user.wallet != null,
                        onTap: () => user.wallet != null
                            ? Navigator.of(context).push(
                                materialRoute(
                                    OuroPage(walletAddress: user.wallet!)),
                              )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _CircleButton(
          {required Widget icon,
          required bool isActive,
          double circleSize = 40.0,
          Color backgroundColor = Colors.white,
          required VoidCallback onTap}) =>
      GestureDetector(
        onTap: isActive ? onTap : null,
        child: Container(
          width: circleSize,
          height: circleSize,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
          child: icon,
        ),
      );

  Widget InformationList(BuildContext context) {
    final items = <Widget>[
      InfoRow(
          title: AppLocalizations.of(context)?.phone ?? '',
          subtitle: user.phoneNumberFormatted == null
              ? (AppLocalizations.of(context)?.privateInfo ?? '')
              : user.phoneNumber.toString()),
      InfoRow(
        title: AppLocalizations.of(context)?.wallet ?? '',
        subtitle: user.wallet == null
            ? (AppLocalizations.of(context)?.privateInfo ?? '')
            : user.wallet.toString(),
        //TODO: вылетает апка при показе snackbar
        // actionButton: _CircleButton(
        //     icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill,
        //         color: BrandColors.primary,//user.wallet != null ? BrandColors.primary : CupertinoColors.secondarySystemFill,
        //         size: 18
        //     ),
        //     //isActive: user.wallet != null,
        //     circleSize: 40,
        //     backgroundColor: CupertinoColors.systemGrey6,
        //     onTap: () async {
        //       await Clipboard.setData(ClipboardData(text: user.wallet));
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //           backgroundColor: BrandColors.primary,
        //           content: Text('Адрес кошелька скопирован', textAlign: TextAlign.center),
        //         )
        //       );
        //     }
        // ),
      ),
      InfoRow(
          title: AppLocalizations.of(context)?.biography ?? '',
          subtitle: user.bio == null ? '' : user.bio.toString())
    ];
    return Container(
      color: Colors.white,
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 24),
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => Divider,
          itemCount: items.length),
    );
  }

  Widget get Divider =>
      Container(height: 0.5, color: Color(0xFF3C3C43).withOpacity(0.36));
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    Key? key,
    required this.title,
    required this.subtitle,
    this.actionButton,
    this.showArrow = false,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool showArrow;
  final Widget? actionButton;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: CupertinoColors.label)),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: BrandColors.primary),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Spacer(),
              if (actionButton != null) actionButton!,
              if (showArrow)
                Icon(CupertinoIcons.chevron_right,
                    color: BrandColors.grey3, size: 15),
              SizedBox(width: 12),
            ],
          ),
        ),
      );
}
