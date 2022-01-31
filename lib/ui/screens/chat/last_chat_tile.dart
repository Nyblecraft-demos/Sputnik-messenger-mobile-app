part of 'last_chat.dart';

class LastChatTile extends StatefulWidget {
  const LastChatTile(
    this.channel, {
      required this.opponentUser,
      Key? key,
  }) : super(key: key);

  final Channel channel;
  final User opponentUser;

  @override
  _LastChatTileState createState() => _LastChatTileState();
}

class _LastChatTileState extends State<LastChatTile> {

  late int? unreadMessages;
  late StreamSubscription<Event> eventSubscription;
  late bool opponentUnread;

  @override
  void initState() {
    _listenUnreadMessages();
    opponentUnread = _checkOpponentUnread();
    super.initState();
  }

  @override
  void dispose() {
    // eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    //final opponentUser = getOpponentUser(channel);
    var hasLastMessage = widget.channel.state?.lastMessage != null;
    unreadMessages = widget.channel.state?.unreadCount;
    // MessageStatus? lastMessageStatus;

    // if (hasLastMessage) {
    //   lastMessageStatus = getLastMessageStatus(channel, channel.state!.lastMessage!);
    // }

    //debugPrint('LastChatTile:  oponent = $opponentUser  hasLastMessage = $hasLastMessage  lastMessageStatus = $lastMessageStatus');

    return GestureDetector(
      child: Card(
        //color: theme.colorTheme.bubleBackground,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        elevation: 0,
        child: DismissibleItem(
          onDismissed: (_) async {
            await widget.channel.hide();
          },
          //TODO: remove ''
          key: Key(widget.channel.id ?? ''),
          child: GestureDetector(
            onTap: () {
              debugPrint('tap chat with ${widget.opponentUser.displayName}');
              NotificationService.opponentID = widget.opponentUser.id;
              Navigator.of(context).push(materialRoute(
                StreamChannel(
                  channel: widget.channel,
                  child: ChatPage(widget.opponentUser),
                ),
              )).then((value) {
                if (value != opponentUnread) {
                  setState(() {
                    opponentUnread = value;
                  });
                }
              });
            },
            child: Container(
              height: 68,
              color: theme.colorTheme.scaffoldBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(materialRoute(
                        UserProfile(user: widget.opponentUser)
                    )),
                    child: BrandAvatarCircle(
                      user: widget.opponentUser,
                      size: 48,
                      showStatus: true,
                    ),
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _name(theme, widget.opponentUser),
                            if (hasLastMessage)
                              TimeStatus(
                                unreadMessages: unreadMessages ?? 0,
                                dateTime: widget.channel.lastMessageAt!,
                                color: theme.colorTheme.hintText,
                                opponentUnread: opponentUnread,
                              ),
                          ],
                        ),
                        SizedBox(height: 3.5),
                        Text(
                          _getMessageText(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: theme.colorTheme.hintText,
                            fontStyle: hasLastMessage
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMessageText() {
    if (widget.channel.state?.lastMessage != null) {
      return (widget.channel.state?.lastMessage?.deletedAt == null) ? (widget.channel.state?.lastMessage?.text ?? '') : (AppLocalizations.of(context)?.messegeDeleted ?? '');
    } else {
      return (AppLocalizations.of(context)?.noMessages ?? '');
    }
  }

  Widget _name(BrandTheme theme, User? opponentUser) {
    return opponentUser != null ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                opponentUser.getShortName(),
                style: theme.h3,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
        SizedBox(width: 4),
        Icon(BrandIcons.ouro, color: BrandColors.primary, size: 16),
      ],
    ) : Container();
  }

  void _listenUnreadMessages() {
    eventSubscription = widget.channel.on().where((Event event) => event.totalUnreadCount != null).listen((Event event) {
      if (event.totalUnreadCount == 0) {
        setState(() {
          unreadMessages = event.totalUnreadCount ?? 0;
        });
      }
    });
  }

  bool _checkOpponentUnread() {
    var opponentUnreadMessages = widget.channel.state?.read
        .firstWhere((r) => r.user == widget.opponentUser)
        .unreadMessages;
    if (opponentUnreadMessages != null && opponentUnreadMessages == 0) {
      return false;
    } else {
      return true;
    }
  }
}
