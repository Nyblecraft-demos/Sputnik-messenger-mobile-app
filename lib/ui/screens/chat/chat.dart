import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/bottom_chat_bar/bottom_chat_bar.dart';
import 'package:sputnik/ui/components/brand_alert.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/loader/loader.dart';
import 'package:sputnik/ui/components/message/message.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/user_pofile/user_profile.dart';
import 'package:sputnik/utils/time_helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sputnik/logic/model/user_extension.dart';
import 'package:sputnik/ui/screens/chat/three_dots_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

part 'appbar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.opponentUser, {Key? key}) : super(key: key);

  final User opponentUser;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ItemScrollController _scrollController;
  final MessageListController _messageListController = MessageListController();
  late DateTime _lastRead;
  bool opponentUnread = false;
  Message? replyMessage;
  late BrandTheme theme;
  late List<Message> listMessages;


  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
    WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    debugPrint('chat:  initState');
  }

  late StreamChannelState streamChannel;
  late StreamSubscription<Event> readEvent;

  void _afterLayout(_) async {
    streamChannel = StreamChannel.of(context);
    channel = streamChannel.channel
      // ..watch()
      // ..show()
      ..markRead();
    _lastRead = channel.state?.read
            .firstWhere((r) => r.user == widget.opponentUser)
            .lastRead ??
        DateTime.now();
    _listenUnreadMessages();
    setState(() {
      _isReady = true;
    });
  }

  late Channel channel;

  bool _isReady = false;

  @override
  void dispose() {
    channel.markRead();
    readEvent.cancel();
    super.dispose();
    debugPrint('chat:  dispose');
  }

  bool? get _upToDate => streamChannel.channel.state?.isUpToDate;

  void _updateList() {
    _scrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );

    channel.markRead();
  }

  void _listenUnreadMessages() {
    readEvent = channel
        .on()
        .where((Event event) => event.type == 'message.read')
        .listen((Event event) {
      _checkUnread();
      if ((channel.state?.read
                  .firstWhere((r) => r.user == widget.opponentUser)
                  .lastRead ??
              DateTime.now())
          .isAfter(_lastRead)) {
        setState(() {
          _lastRead = channel.state?.read
                  .firstWhere((r) => r.user == widget.opponentUser)
                  .lastRead ??
              DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = context.watch<BrandTheme>();
    var settingsCubit = context.read<AppSettingsCubit>();
    //final currentUser = getIt.get<ChatService>().currentUser;
    debugPrint(
        'chat:  build:  isReady = $_isReady  wallet = ${widget.opponentUser.wallet} opponent = $widget.opponentUser');
    if (!_isReady || widget.opponentUser == null) {
      return Container();
    }
    return Scaffold(
        appBar: ChatAppBar(user: widget.opponentUser, channel: channel, backFunc: _backCallBack),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: _color(settingsCubit.background),
                    image: _backgroundImage(settingsCubit.background)),
                child: MessageListCore(
                    messageListController: _messageListController,
                    emptyBuilder: (context) => Center(
                          child: Text(
                              AppLocalizations.of(context)?.noMessages ?? '',
                              style: TextStyles.h3.copyWith(
                                  color: CupertinoColors.secondaryLabel,
                                  height: 1)),
                        ),
                    errorBuilder: (context, e) => Container(
                          child: Text(e.toString()),
                        ),
                    loadingBuilder: (_) => Loader(
                        text: AppLocalizations.of(context)?.loading ?? ''),
                    messageListBuilder: (context, List<Message> messages) {
                      listMessages = messages;
                      List<DateTime> dates = [];
                      DateTime lastDate = messages.first.createdAt.toLocal();
                      for (int a = 0; a < messages.length; a++) {
                        final message =
                            messages.reversed.toList()[a].createdAt.toLocal();
                        final dateMessage = message;
                        if (message.year == lastDate.year &&
                            message.month == lastDate.month &&
                            message.day == lastDate.day) {
                          dates.add(DateTime.now());
                        } else {
                          dates.add(dateMessage);
                          lastDate = dateMessage;
                        }
                      }

                      NotificationService.opponentID = widget.opponentUser.id;
                      return LazyLoadScrollView(
                        onStartOfPage: () async {
                          if (_upToDate != null && !_upToDate!) {
                            return _paginateData(
                              streamChannel,
                              QueryDirection.bottom,
                            );
                          }
                        },
                        onEndOfPage: () async {
                          return _paginateData(
                            streamChannel,
                            QueryDirection.top,
                          );
                        },
                        child: ScrollablePositionedList.separated(
                          reverse: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            itemScrollController: _scrollController,
                            itemCount: messages.length,
                            separatorBuilder: (context, index) {
                              var sameType = false;
                              if (index < messages.length) {
                                if (messages[index].user?.id ==
                                    messages[index + 1].user?.id) {
                                  sameType = true;
                                }
                              }
                              return SizedBox(height: sameType ? 6 : 20);
                            },
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final date = dates.reversed.toList()[index];

                              return Column(
                                children: [
                                  message.createdAt.toLocal() == date
                                      ? Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: theme
                                            .colorTheme.dateChatBackground,
                                        borderRadius:
                                        BorderRadius.circular(16)),
                                    child: Text(
                                      DateFormat.MMMMd()
                                          .format(date)
                                          .toString(),
                                      style: TextStyle(
                                          color: theme
                                              .colorTheme.highlightedText),
                                    ),
                                  )
                                      : Container(),
                                  MessageWidget(
                                    key: Key(message.id),
                                    message: message,
                                    lastRead: _lastRead,
                                    theme: theme,
                                    replyCallBack: _replyCallBack,
                                    tapReplyCallBack: _tapReplyCallBack,

                                  ),
                                ],
                              );
                            },
                            )
                      );
                    }),
              ),
            ),
            replyMessage != null ? _replyMessage : Container(),
            BottomChatBar(
              onSend: _sendMessage,
              channel: channel,
              showAttachment: _checkBlocked() ? false : true,
            ),
          ],
        ));
  }




  // ListView.separated(
  // reverse: true,
  // physics: const AlwaysScrollableScrollPhysics(),
  // padding: const EdgeInsets.symmetric(
  // vertical: 20, horizontal: 10),
  // controller: _scrollController,
  // itemCount: messages.length,
  // separatorBuilder: (context, index) {
  // var sameType = false;
  // if (index < messages.length) {
  // if (messages[index].user?.id ==
  // messages[index + 1].user?.id) {
  // sameType = true;
  // }
  // }
  // return SizedBox(height: sameType ? 6 : 20);
  // },
  // itemBuilder: (context, index) {
  // final message = messages[index];
  // final date = dates.reversed.toList()[index];
  //
  // return Column(
  // children: [
  // message.createdAt.toLocal() == date
  // ? Container(
  // padding: EdgeInsets.all(5),
  // decoration: BoxDecoration(
  // color: theme
  //     .colorTheme.dateChatBackground,
  // borderRadius:
  // BorderRadius.circular(16)),
  // child: Text(
  // DateFormat.MMMMd()
  //     .format(date)
  //     .toString(),
  // style: TextStyle(
  // color: theme
  //     .colorTheme.highlightedText),
  // ),
  // )
  //     : Container(),
  // MessageWidget(
  // key: Key(message.id),
  // message: message,
  // lastRead: _lastRead,
  // theme: theme,
  // replyCallBack: _replyCallBack,
  // tapReplyCallBack: _tapReplyCallBack,
  //
  // ),
  // ],
  // );
  // },
  // ),










  void _replyCallBack(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  /// TODO: remove !
  Future<void> _paginateData(
      StreamChannelState channel, QueryDirection direction) {
    return _messageListController.paginateData!(direction: direction);
  }

  Future<void> _sendMessage(String text) async {
    if (_checkBlocked()) {
      _showError();
    } else {
      await channel.sendMessage(
        Message(text: text, quotedMessageId: replyMessage?.id),
      );
      _updateList();
      setState(() {
        replyMessage = null;
      });
    }
  }

  bool _checkBlocked() {
    var user = getIt.get<ChatService>().currentUser;
    if (user.extraData['channelsBanned'] is List) {
      var bannedList = user.extraData['channelsBanned'] as List<dynamic>?;
      if (bannedList != null) {
        if (bannedList.contains(channel.id)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _showError() {
    BrandAlert.showInfo(
        context: context,
        title: AppLocalizations.of(context)?.blackList ?? '',
        subtitle: AppLocalizations.of(context)?.blacklisted ?? '',
        mainButtonTitle: 'Ok',
        mainButtonAction: () => Navigator.of(context).pop(),
        content: null);
  }

  DecorationImage? _backgroundImage(String? background) {
    if (background != null && background.contains('png')) {
      return DecorationImage(
          image: AssetImage('assets/chat_backgrounds/$background'),
          fit: BoxFit.cover);
    }
  }

  Color? _color(String? background) {
    if (background == 'light') {
      return BrandColors.lightPrimaryWhite;
    }
    if (background == 'dark') {
      return BrandColors.darkPrimaryWhite;
    }
  }

  void _backCallBack() {
    Navigator.pop(context, opponentUnread);
  }

  void _checkUnread() {
    opponentUnread = !(_lastRead.isAfter(channel.lastMessageAt ?? DateTime.now()));
  }

  Widget get _replyMessage {
    return Container(
      padding: EdgeInsets.all(10),
        height: 60,
        color: theme.colorTheme.appBarAlternetiveBackground,
        child: Row(
          children: [
            Icon(CupertinoIcons.reply, size: 20, color: Colors.white),
            SizedBox(width: 10,),
            Container(width: 1, color: Colors.white ,),
            SizedBox(width: 10,),
            _replyAttachments,
            SizedBox(width: 10,),
            Expanded(
              child: Text(replyMessage?.text ?? '',
                style: TextStyle(color: Colors.white,),
                maxLines: 2,
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                setState(() {
                  replyMessage = null;
                });
              },
              child: Icon(CupertinoIcons.clear, size: 20, color: Colors.white),
            )
          ],
        ),);
  }

  Widget get _replyAttachments {
    if (replyMessage?.attachments.isEmpty == true) {
      return Container();
    } else {
      Attachment? element = replyMessage?.attachments[0];
      if (element == null) { return Container(); }
      if (element.assetUrl != null && element.assetUrl?.isNotEmpty == true) {
        return Icon(Icons.insert_drive_file_rounded, color: BrandColors.primary,);
      }
      if (element.imageUrl != null && element.imageUrl?.isNotEmpty == true) {
        return CachedNetworkImage(
          imageUrl: element.imageUrl!,
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container(),
          fit: BoxFit.fitWidth,
        );
      }
      return Container();
    }
  }
  void _tapReplyCallBack(Message message) {
    var targetMessage = listMessages.firstWhere((element) => element.id == message.id);
      var index = listMessages.indexOf(targetMessage);
      debugPrint("$index");
      if (index < 0) { return; }
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
  }
}
