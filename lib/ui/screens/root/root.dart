import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:either_option/either_option.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/home_page.dart';
import 'package:sputnik/logic/api/awards.dart';
import 'package:sputnik/logic/api/modules.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/logic/locators/user_time_reward.dart';
import 'package:sputnik/ui/components/brand_alert.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/push_notifications.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/chat/chats.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';
import 'package:sputnik/ui/screens/user_pofile/edit_user_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'contacts/contacts.dart';
import 'settings/settings.dart';

enum MenuPage { chats, contacts, wallet, settings }

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  var _androidAppRetain = MethodChannel("android_app_retain");
  MenuPage currentMenuPage = MenuPage.chats;
  SolidController _controller = SolidController();
  ChatService chatService = getIt.get<ChatService>();
  bool isOpened = false;
  PanelController _scrollController = PanelController();
  List<MenuPage> navigationStack = getIt.get<NavigationService>().navigationStack;


  @override
  Widget build(BuildContext context) => BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is NotAuthenticated || state is LoggedOut) {
              Navigator.of(context).pushReplacement(
                materialRoute(
                  HomePage(),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/title_logo.png', alignment: Alignment.center, width: 35,)
              ),
              title: Text(AppLocalizations.of(context)?.appTitle ?? ''),
            ),
            body: SlidingUpPanel(
              controller: _scrollController,
              color: Colors.transparent,
              minHeight: MediaQuery.of(context).padding.bottom + 40,
              maxHeight: MediaQuery.of(context).padding.bottom + 390,
              boxShadow: [],
              collapsed: _BottomAppBarBody(),
              backdropEnabled: true,
              panel: _ExpandedMenuBody(),
              body: Stack(
                children: [
                  _Body(),
                  if (isOpened)
                    Container(
                      color: Colors.black.withOpacity(
                        0.5,
                      ),
                    ),
                ],
              ),
              onPanelOpened: () {
                setState(() {
                  isOpened = true;
                });
              },
              onPanelClosed: () {
                setState(() {
                  isOpened = false;
                });
              },
            ),

//          Stack(
//            children: [
//              _Body(),
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: _BottomAppBarBody(),
//              ),
//            ],
//          ),
//          bottomNavigationBar: Menu,
          ),
  );

  Widget get Menu => SolidBottomSheet(
        headerBar: _BottomAppBarBody(),
        body: _ExpandedMenuBody(),
        controller: _controller,
        maxHeight: 390,
        draggableBody: true,
        toggleVisibilityOnTap: true,
      );

  Widget _BottomAppBarBody1() => ClipPath(
        clipper: MenuBarClipper(width: 52, height: 26),
        child: Container(
          height: MediaQuery.of(context).padding.bottom + 40,
//          color: Color(0xFF1D1D1D),
          color: Colors.black,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  'assets/images/4rectangles.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _ExpandedMenuBody() => Column(
        children: [
          _BottomAppBarBody(),
          Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              //height: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(builder: (context, state) {
                    final user = (state as WithUser).user;
                    debugPrint('root:  user info = $user  phone = ${user.phoneNumber}  formatted = ${user.phoneNumberFormatted}');
                    return Column(
                      children: [
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(width: 64, height: 64,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(32),
                            //       gradient: LinearGradient(
                            //         begin: Alignment.centerLeft,
                            //         end: Alignment.centerRight,
                            //         colors: [Color(0xFF271E26), Color(0xFF592354)],
                            //       )
                            //   ),
                            //   child: SizedBox(width: 24, height: 24,
                            //     child: Image.asset('assets/images/zap-on.png', fit: BoxFit.cover, color: Color(0xFF4A4A4A)),
                            //   ),
                            // ),
                            BrandAvatarCircle(
                              user: user,
                              size: 88,
                              backgroundColor: Color(0xFF1D1D1D),
                              showStatus: false,
                            ),
                            // Container(width: 64, height: 64,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(32),
                            //       gradient: LinearGradient(
                            //         begin: Alignment.centerLeft,
                            //         end: Alignment.centerRight,
                            //         colors: [Color(0xFF303C5A), Color(0xFF202226)],
                            //       )
                            //   ),
                            //   child: SizedBox(width: 24, height: 24,
                            //     child: Image.asset('assets/images/zap-on.png', fit: BoxFit.cover, color: Color(0xFF4A4A4A)),
                            //   ),
                            // ),
                            // Container(width: 64, height: 64,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(32),
                            //       gradient: LinearGradient(
                            //         begin: Alignment.centerLeft,
                            //         end: Alignment.centerRight,
                            //         colors: [Color(0xFF271E26), Color(0xFF592354)],
                            //       )
                            //   ),
                            //   child: SizedBox(width: 24, height: 24,
                            //     child: Image.asset('assets/images/zap-on.png', fit: BoxFit.cover, color: Color(0xFF4A4A4A)),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
//                    context.watch<AuthenticationCubit>().chatService.client,
                              user.getShortName(),
//                              getIt.get<ChatService>().currentUser.phoneNumber ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              width: 13,
                              height: 13,
                              child: Image.asset(
                                'assets/images/name_icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          '',
//                          user.phoneNumberFormatted ??
//                            '',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(materialRoute(EditUserProfile())),
                          child: Text(
                            AppLocalizations.of(context)?.editProfile ?? '',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF6B95FF)),
                          ),
                        ),
                        SizedBox(height: 20),
                        _SpendingTimeAward(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Container(height: 1, color: Colors.white.withOpacity(0.2)),
                        ),
                        _HorizontalScrollMenuItemsView(
                          children: [
                            MenuItem(
                              icon: CupertinoIcons.bubble_left_bubble_right_fill,
                              title: AppLocalizations.of(context)?.chats ?? '',
                              onTap: () => select(menuPage: MenuPage.chats),
                              isSelected: currentMenuPage == MenuPage.chats,
                            ),
                            MenuItem(
                              icon: CupertinoIcons.person_2_fill,
                              title: AppLocalizations.of(context)?.contacts ?? '',
                              onTap: () => select(menuPage: MenuPage.contacts),
                              isSelected: currentMenuPage == MenuPage.contacts,
                            ),
                            MenuItem(
                              icon: CupertinoIcons.briefcase_fill,
                              title: AppLocalizations.of(context)?.wallet ?? '',
                              onTap: () => select(menuPage: MenuPage.wallet),
                              isSelected: currentMenuPage == MenuPage.wallet,
                            ),
                            MenuItem(
                              icon: CupertinoIcons.gear_solid,
                              title: AppLocalizations.of(context)?.settings ?? '',
                              onTap: () => select(menuPage: MenuPage.settings),
                              isSelected: currentMenuPage == MenuPage.settings,
                            )
                          ],
                        )
                      ],
                    );
                  }),
                  SizedBox(height: 19),
                ],
              )),
        ],
      );

  Widget _BottomAppBarBody() => ClipPath(
        clipper: MenuBarClipper(width: 52, height: 26),
        child: Container(
          height: MediaQuery.of(context).padding.bottom + 40,
//          color: Color(0xFF1D1D1D),
          color: Colors.black,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 16,
                height: 16,
                child: Image.asset(
                  'assets/images/4rectangles.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _SpendingTimeAward() => SpendingTimeAndRewardWidget();

  Widget _Body() {
    switch (currentMenuPage) {
      case MenuPage.chats:
        return ChatsPage();
      case MenuPage.contacts:
        return ContactsPage();
      case MenuPage.wallet:
        return OuroWalletPage();
      case MenuPage.settings:
        return SettingsPage();
    }
  }

  void select({required MenuPage menuPage}) {
    navigationStack.add(menuPage);
    setState(() {
      currentMenuPage = menuPage;
      debugPrint('root:  current menu page = $currentMenuPage');
      NotificationService.chatList = currentMenuPage == MenuPage.chats ? true : false;
      isOpened = false;
    });
    _scrollController.close();
  }

  void _navigationBack() {
    navigationStack.removeLast();
    final page = navigationStack.last;
    setState(() {
      currentMenuPage = page;
      debugPrint('root:  navigate back to menu page = $currentMenuPage');
      NotificationService.chatList = currentMenuPage == MenuPage.chats ? true : false;
    });
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    _getModules();
    final pushNotificationService = PushNotificationService(FirebaseMessaging.instance);
    pushNotificationService.initialise();
    PushNotificationService.isNotificationsOn = true;
    navigationStack.add(MenuPage.chats);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return _sendToBackground();
  }

  bool _sendToBackground() {
    if (Platform.isAndroid) {
      if (Navigator.of(context).canPop()) {
        return false;
      } else {
        if (navigationStack.length > 1) {
          _navigationBack();
          return true;
        } else {
          _androidAppRetain.invokeMethod("sendToBackground");
          return true;
        }
      }
    } else {
      return false;
    }
  }

  void _getModules() async {
    var res = await ModulesApi().getModules();
    final bool isWalletOn = res.data['data']['wallet']['enabled'];
    final settings = context.read<AppSettingsCubit>();
    if (settings.isModuleWalletOn != isWalletOn) {
      settings.update(isModuleWalletOn: isWalletOn);
    }
  }

}

class SpendingTimeAndRewardWidget extends StatelessWidget {
  SpendingTimeAndRewardWidget({Key? key}) : super(key: key);
  final userReward = getIt.get<UserRewardInterval>();

  @override
  Widget build(BuildContext context) => FutureBuilder<SpendingTimeReward>(
        future: userReward.getFata(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            debugPrint('future build:  reward widget:  spending time = ${snapshot.data?.toJson()}');
            return _SpendingTimeAndRewardWidget(data: snapshot.data!);
          }
          return SizedBox.shrink();
        },
      );
}

class _SpendingTimeAndRewardWidget extends StatefulWidget {
  _SpendingTimeAndRewardWidget({required this.data});

  SpendingTimeReward data;

  @override
  __SpendingTimeAndRewardWidgetState createState() => __SpendingTimeAndRewardWidgetState();
}

class __SpendingTimeAndRewardWidgetState extends State<_SpendingTimeAndRewardWidget> {
  String _spendingTimeString = '';
  String _rewardString = '';
  String _earnedString = '';
  Timer? timer;
  late String rewardFormat;
  late String earnedFormat;

  @override
  void initState() {
    _start();
    timer = Timer.periodic(Duration(seconds: 1), (t) => _update());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _start() {
    rewardFormat = _checkFormat(widget.data.totalReward);
    earnedFormat = _checkFormat(widget.data.totalEarned);
    _updateValues(rewardFormat: rewardFormat, earnedFormat: earnedFormat);
  }

  void _update() {
    rewardFormat = _checkFormat(widget.data.totalReward);
    earnedFormat = _checkFormat(widget.data.totalEarned);
    setState(() {
      _updateValues(rewardFormat: rewardFormat, earnedFormat: earnedFormat);
    });
  }

  String _checkFormat(num) {
    if (num < 1000) return 'N';
    if (num > 999 && num < 1000000) return 'K';
    if (num > 999999 && num < 1000000000) return 'M';
    if (num > 999999999) return 'B';
    return 'N';
  }

  void _updateValues({required String rewardFormat, required String earnedFormat}) {
    _spendingTimeString = widget.data.activeString();
    _rewardString = rewardFormat == 'N' ? widget.data.rewardString(): widget.data.formattedRewardKMB(rewardFormat);
    _earnedString = earnedFormat == 'N' ? widget.data.formattedEarned : widget.data.formattedEarnedKMB(earnedFormat);
  }

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<AppSettingsCubit>();
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xFFB5B0FF).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: rewardFormat == 'N' ? 2 : 1,
                      child: FittedBox(
                        child: Text(
                          _spendingTimeString,
                          style: TextStyle(fontSize: rewardFormat == 'N' ? 10 : 13,
                              fontWeight: FontWeight.w400, color: Colors.white),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: rewardFormat == 'N' ? 2 : 1,
                      child: FittedBox(
                        child: Text(
                                  (_earnedString + '  ($_rewardString) Ouro'),
                                  style: TextStyle(fontSize: rewardFormat == 'N' ? 10 : 13, fontWeight: FontWeight.w400, color: Color(0xFF73CA72)),
                                  maxLines: 1,
                                ),
                      ),
                    ),
                  ],
                ))),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () => _withdrawAlert(settings.isModuleWalletOn),
          child: Container(
              width: 44,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFB5B0FF).withOpacity(0.16),
                  //? Color(0xFF6B95FF)
                  //: ,
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Icon(
                  CupertinoIcons.arrow_right, size: 20, color: Colors.white)),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () =>
              BrandAlert.showInfo(
              context: context,
              content: _infoContent,
              title: AppLocalizations.of(context)?.rewardForUse ?? '',
              subtitle: (AppLocalizations.of(context)?.ouroInfo ?? '') + ' ${widget.data.currentEarnRate} ouro.',
              mainButtonTitle: 'Ok',
              mainButtonAction: () {
                Navigator.pop(context);
              }),
          child: Container(
              width: 44,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFB5B0FF).withOpacity(0.16),
                  //? Color(0xFF6B95FF)
                  //: ,
                  borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Icon(CupertinoIcons.info, size: 20, color: Colors.white)),
        ),
      ],
    );
  }

  Widget get _infoContent{
    final textStyleNormal = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal);
    final textStyleBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('\n' + (AppLocalizations.of(context)?.ouroFormat ?? '') + '\n', style: textStyleNormal, textAlign: TextAlign.center),
        Text((AppLocalizations.of(context)?.abbreviation ?? '') + '\n', style: textStyleNormal, textAlign: TextAlign.center),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text((AppLocalizations.of(context)?.ouroEarned ?? ''), style: textStyleNormal,),
            Text('${widget.data.formattedEarned}', style: textStyleBold,)
          ],),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text((AppLocalizations.of(context)?.ouroReady ?? ''), style: textStyleNormal,),
            Text('${widget.data.formattedReward}', style: textStyleBold,)
          ],),
      ],
    );
  }

  Future<void> _withdrawAlert(bool? isModuleWalletOn) async {
    (widget.data.totalReward > widget.data.minWithDrawAmount && isModuleWalletOn == true)
        ? BrandAlert.setStateAlert(
        context: context,
        title: AppLocalizations.of(context)?.rewardForUse ?? '',
        subtitle: AppLocalizations.of(context)?.withdrawToWallet ?? '',
        secondaryButtonTitle: AppLocalizations.of(context)?.no ?? '',
        secondaryButtonAction: () => Navigator.pop(context),
        mainButtonTitle: AppLocalizations.of(context)?.yes ?? '',
        mainButtonAction: () async {
          var res = await widget.data.withdrawAllReward();
          _updateData(res);
          Navigator.pop(context);
          BrandAlert.sendRequest = false;
          res.isRight ?
          BrandAlert.show(
              context: context,
              title: AppLocalizations.of(context)?.rewardForUse ?? '',
              subtitle: AppLocalizations.of(context)?.withdrawSuccess ?? '',
              secondaryButtonTitle: null,
              secondaryButtonAction: null,
              mainButtonTitle: 'Ok',
              mainButtonAction: () {
                Navigator.pop(context);
              }) :
          BrandAlert.show(
              context: context,
              title: AppLocalizations.of(context)?.rewardForUse ?? '',
              subtitle: AppLocalizations.of(context)?.withdrawError2 ?? '',
              secondaryButtonTitle: null,
              secondaryButtonAction: null,
              mainButtonTitle: 'Ok',
              mainButtonAction: () {
                Navigator.pop(context);
              });
        })
        : BrandAlert.show(
        context: context,
        title: AppLocalizations.of(context)?.rewardForUse ?? '',
        subtitle: AppLocalizations.of(context)?.withdrawError1 ?? '',
        secondaryButtonTitle: null,
        secondaryButtonAction: null,
        mainButtonTitle: 'Ok',
        mainButtonAction: () {
          Navigator.pop(context);
        });
  }

  void _updateData(Either<Exception, SpendingTimeReward> data) {
    data.fold(
            (exception) {return;},
            (data) {
              widget.data = data;
              final userReward = getIt.get<UserRewardInterval>();
              userReward.spendingTimeRewardData = data;
            });
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({
    this.height = 64,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final double height;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(color: isSelected ? Color(0xFF6B95FF) : Color(0xFF2B2B2B), borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                //height: 32,
                child: Center(
                  child: Icon(icon, size: 24, color: isSelected ? Colors.white : Color(0xFF6B95FF)),
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: isSelected ? Colors.white : Color(0xFF9A9A9A)),
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      );
}

class _HorizontalScrollMenuItemsView extends StatelessWidget {
  const _HorizontalScrollMenuItemsView({
    Key? key,
    this.minElementWidth = 64,
    this.spacing = 8,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;
  final double minElementWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    var settingCubit = context.watch<AppSettingsCubit>();
    var isModuleWalletOn = settingCubit.state.isModuleWalletOn ?? false;
    if (!isModuleWalletOn) {
      children.removeWhere((element) => (element as MenuItem).title == AppLocalizations.of(context)?.wallet);
    }
        //debugPrint('horizontal menu:  width = ${MediaQuery.of(context).size.width}  constraints = ${constraints.maxWidth}');
    double itemWidth = max(minElementWidth, ((constraints.maxWidth - spacing * (children.length - 1)) / children.length));
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
            //physics: const BouncingScrollPhysics(),
        child: Row(children: List<Widget>.generate(children.length * 2 - 1, (n) => n % 2 == 0 ? SizedBox(width: itemWidth, child: children[n ~/ 2]) : SizedBox(width: spacing))));
      });
}

class MenuBarClipper extends CustomClipper<Path> {
  MenuBarClipper({
    required this.width,
    required this.height,
    this.topRadius = 16,
    this.bottomRadius = 12,
  });

  final double height;
  final double width;
  final double topRadius;
  final double bottomRadius;

  @override
  Path getClip(Size size) {
    Path path = new Path()
      ..moveTo(0.0, height)
      ..lineTo((size.width - width) / 2 - bottomRadius, height)
      ..arcToPoint(Offset((size.width - width) / 2, height - bottomRadius), radius: Radius.circular(bottomRadius), clockwise: false)
      ..arcToPoint(Offset((size.width - width) / 2 + topRadius, 0), radius: Radius.circular(topRadius))
      ..lineTo(size.width / 2, 0) //
      ..lineTo((size.width + width) / 2 - topRadius, 0)
      ..arcToPoint(Offset((size.width + width) / 2, height - bottomRadius), radius: Radius.circular(topRadius))
      ..arcToPoint(Offset((size.width + width) / 2 + bottomRadius, height), radius: Radius.circular(bottomRadius), clockwise: false) //
      ..lineTo((size.width + width) / 2, height) //
      ..lineTo(size.width, height)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
