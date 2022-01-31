part of 'chat.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  ChatAppBar({
    Key? key,
    required this.user,
    required this.channel,
    this.backFunc
  }) : super(key: key);

  final User user;
  final Channel channel;
  final Function? backFunc;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  int popCount = 0;

  var bannedChannels = [];
  var needUpdate = true;
  late User user;
  bool userBlocked = false;

  @override
  void initState() {
    user = widget.user;
    _checkBannedChannels(user);
    super.initState();
  }

  void _checkBannedChannels(User user) async {
    if (needUpdate) {
      user = await _updateUser() ?? widget.user;
    }
    if (user.extraData['channelsBanned'] != null) {
      if (user.extraData['channelsBanned'] is List) {
        bannedChannels = user.extraData['channelsBanned'] as List<dynamic>;
      } else {
        bannedChannels = [];
      }
    } else {
      bannedChannels = [];
    }
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return Material(
      color: theme.colorTheme.appBarAlternetiveBackground,
      elevation: 0,
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: EdgeInsets.only(left: 4),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 36,
            child: Row(
              children: [
                BrandBackButton(backFunc: widget.backFunc),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .push(materialRoute(UserProfile(user: widget.user))),
                  child: BrandAvatarCircle(
                    user: widget.user,
                    size: 36,
                    showStatus: true,
                    backgroundColor:
                        theme.colorTheme.appBarAlternetiveBackground,
                    circleColor: BrandColors.blue1,
                  ),
                ),

                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      materialRoute(
                        UserProfile(
                          user: widget.user,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.getShortName(),
                          style:
                              theme.h1.copyWith(color: Colors.white, height: 1),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        Spacer(),
                        Text(
                          widget.user.online ?
                          (AppLocalizations.of(context)?.online ?? '') :
                          '${AppLocalizations.of(context)?.wasOnline} ${timeAgo(widget.user.lastActive)}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.5)),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
                MyPopupMenuButton(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      CupertinoIcons.ellipsis,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  color: Color(0xFF3E589A),
                  offset: Offset(0, 36),
                  itemBuilder: (context) => [
                    MyPopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                        title: Text(
                          AppLocalizations.of(context)?.openProfile ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            materialRoute(
                              UserProfile(
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MyPopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          Icons.block,
                          color: Colors.white,
                        ),
                        title: Text(
                          userBlocked ? AppLocalizations.of(context)?.unBlockUser ?? '' : AppLocalizations.of(context)?.blockUser ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          userBlocked ? _unBlockUser() : _blockUser();
                        },
                      ),
                    ),
                    MyPopupMenuItem(
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          AppLocalizations.of(context)?.deleteChat ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          BrandAlert.show(
                              context: context,
                              title: AppLocalizations.of(context)?.deleteChat ?? '',
                              subtitle: AppLocalizations.of(context)?.deleteChatError ?? '',
                              secondaryButtonTitle: AppLocalizations.of(context)?.no ?? '',
                              secondaryButtonAction: () => Navigator.pop(context),
                              mainButtonTitle: AppLocalizations.of(context)?.yes ?? '',
                              mainButtonAction: () async {
                                await widget.channel.hide(clearHistory: true);
                                Navigator.of(context).popUntil((_) => popCount++ >= 3);
                              });
                        },
                      ),
                    ),
                  ],
                ),

                /*            RotatedBox(
                  quarterTurns: 1,
                  child: _button(
                    icon: CupertinoIcons.ellipsis,
                    size: 24,
                    onTap: () {},
                  ),
                ),
*/
                SizedBox(width: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(
      {required IconData icon,
      bool isActive = true,
      required VoidCallback onTap,
      required double size}) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 38,
        width: 38,
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.384),
          size: size,
        ),
      ),
    );
  }

  void _blockUser() async {
    final currentUser = getIt.get<ChatService>().currentUser;
    final client = getIt.get<ChatService>().client;
    List channelsBanned;
    if (widget.user.extraData['channelsBanned'] != null) {
      final list = bannedChannels.toSet();
      list.add(widget.channel.id ?? '');
      channelsBanned = list.toList();
    } else {
      channelsBanned = [widget.channel.id ?? ''];
    }
    await widget.channel.banUser(widget.user.id, {
      'banned_by_id': currentUser.id,
      'reason': 'User_${currentUser.id} banned you in channel_${widget.channel.id}',
    });
    var updatedUser = widget.user.copyWith(extraData: {...widget.user.extraData}..['channelsBanned'] = channelsBanned);
    setState(() {
      _checkBannedChannels(updatedUser);
    });
    await client.updateUser(updatedUser);
    Navigator.of(context).pop();
    BrandAlert.showInfo(
        context: context,
        title: AppLocalizations.of(context)?.blackList ?? '',
        subtitle: AppLocalizations.of(context)?.unBanInfo ?? '',
        mainButtonTitle: 'Ok',
        mainButtonAction: () => Navigator.of(context).pop(),
        content: null);
  }

  void _unBlockUser() async {
    final client = getIt.get<ChatService>().client;
    List channelsBanned;
    if (widget.user.extraData['channelsBanned'] != null) {
      final list = bannedChannels.toSet();
      list.remove(widget.channel.id ?? '');
      channelsBanned = list.toList();
    } else {
      channelsBanned = [];
    }
    await widget.channel.unbanUser(widget.user.id);
    var updatedUser = widget.user.copyWith(extraData: {...widget.user.extraData}..['channelsBanned'] = channelsBanned);
    setState(() {
      _checkBannedChannels(updatedUser);
    });
    await client.updateUser(updatedUser);
    Navigator.of(context).pop();
    BrandAlert.showInfo(
        context: context,
        title: AppLocalizations.of(context)?.blackList ?? '',
        subtitle: AppLocalizations.of(context)?.unBanUserInfo ?? '',
        mainButtonTitle: 'Ok',
        mainButtonAction: () => Navigator.of(context).pop(),
        content: null);
  }

  Future<User?> _updateUser() async {
    var client = getIt.get<ChatService>().client;
    var users = await client.queryUsers(
        filter: Filter.equal('id', '${user.id}')
    );
    if (users.users.length > 0) {
      needUpdate = false;
      return users.users.first;
    } else {
      return null;
    }

  }

  void _checkUser() {
    setState(() {
      userBlocked = (bannedChannels.contains(widget.channel.id)) ? true : false;
    });
  }

}
