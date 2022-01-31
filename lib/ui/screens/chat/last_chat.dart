import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/model/user_extension.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/locators/chat.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:sputnik/ui/components/dismissible_item.dart';
import 'package:sputnik/ui/components/empty_widget.dart';
import 'package:sputnik/ui/components/loader/loader.dart';
import 'package:sputnik/ui/components/time_status/time_status.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/chat/chat.dart';
import 'package:sputnik/ui/screens/user_pofile/user_profile.dart';
import 'package:sputnik/utils/get_stream_helpers.dart';
import 'package:sputnik/utils/named_font_weight.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'last_chat_tile.dart';

class LastChatPage extends StatefulWidget {
  const LastChatPage({Key? key}) : super(key: key);

  @override
  State<LastChatPage> createState() => _LastChatPageState();
}

class _LastChatPageState extends State<LastChatPage> {

  bool needToRefresh = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return ChannelsBloc(
      child: ChannelListCore(
        filter: Filter.and([
          Filter.equal("type", "messaging"),
          Filter.in_("members", [getIt.get<ChatService>().currentUser.id])
        ]),
        watch: true,
        emptyBuilder: (_) => EmptyWidget(text: '${AppLocalizations.of(context)?.noChatsFound ?? ''},\n${AppLocalizations.of(context)?.startChat ?? ''}',),
        errorBuilder: (_, e) => _errorWidget(theme),
        //     Container(
        //   child: Text(e.toString()),
        // ),
        listBuilder: (_, channels) {
          var chats = channels
              .map((channel) {
                final opponentUser = getOpponentUser(channel);
                if (channel.createdBy?.id == opponentUser?.id && channel.state?.lastMessage == null)
                  return null;
                if (opponentUser != null)
                  return LastChatTile(channel, opponentUser: opponentUser);
                return null;
              })
              .where((e) => e != null)
              .map((e) => e!)
              .toList();
          debugPrint('last chat:  opponnets = ${channels.map((e) => getOpponentUser(e)).map((e) => 'name: ${e?.displayName}  avatar:  ${e?.avatar} / ${e?.avatar?.length}')}');
          return ListView.separated(
            itemCount: chats.length,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            separatorBuilder: (context, index) => Divider(height: 0.5, indent: 68, endIndent: 4, color: theme.colorTheme.seconadaryGray3),
            itemBuilder: (context, index) => chats[index],
          );
        },
        loadingBuilder: (_) => Loader(text: AppLocalizations.of(context)?.loading ?? ''),
      ),
    );
  }

  Widget _errorWidget(BrandTheme theme) {
    debugPrint('ChannelListCore initialization error');
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          alignment: Alignment.topCenter,
          child: Text(AppLocalizations.of(context)?.errorChannelListCore ?? '',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: theme.colorTheme.grayText)),
        ));
  }

  void _onRefresh() async{
    _refreshController.refreshCompleted();
    setState(() {
      needToRefresh = true;
    });
  }
}
