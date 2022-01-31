import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/chat.dart';
import 'package:sputnik/logic/model/user_extension.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:sputnik/ui/components/dismissible_item.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/user_pofile/user_profile.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class BlockedUserTile extends StatefulWidget {
  const BlockedUserTile(
      this.channel, {
        required this.opponentUser,
        Key? key,
      }) : super(key: key);

  final Channel channel;
  final User opponentUser;

  @override
  _BlockedUserTile createState() => _BlockedUserTile();
}

class _BlockedUserTile extends State<BlockedUserTile> {

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return Card(
        elevation: 0,
        child: DismissibleItem(
          onDismissed: (_) async {
            _unBlockUser();
          },
          //TODO: remove ''
          key: Key(widget.channel.id ?? ''),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
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

  void _unBlockUser() async {
    final client = getIt.get<ChatService>().client;
    List channelsBanned;
    if (widget.opponentUser.extraData['channelsBanned'] != null) {
      channelsBanned = widget.opponentUser.extraData['channelsBanned'] as List<dynamic>;
      channelsBanned.remove(widget.channel.id ?? '');
    } else {
      channelsBanned = [];
    }
    await widget.channel.unbanUser(widget.opponentUser.id);
    var updatedUser = widget.opponentUser.copyWith(extraData: {...widget.opponentUser.extraData}..['channelsBanned'] = channelsBanned);
    await client.updateUser(updatedUser);
  }
}