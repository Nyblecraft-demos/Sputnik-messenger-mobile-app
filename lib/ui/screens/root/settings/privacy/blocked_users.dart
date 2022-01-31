import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/components/loader/loader.dart';
import 'package:sputnik/utils/get_stream_helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'blocked_user_tile.dart';

class BlockedUsersPagePage extends StatelessWidget {
  const BlockedUsersPagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations
            .of(context)
            ?.blackList ?? ''),
        leading: BrandBackButton(),
      ),
      body: ChannelsBloc(
        child: ChannelListCore(
          filter: Filter.and([
            Filter.equal("type", "messaging"),
            Filter.in_("members", [getIt.get<ChatService>().currentUser.id])
          ]),
          watch: true,
          emptyBuilder: (_) => Loader(text: AppLocalizations.of(context)?.noBlackListFound ?? ''),
          errorBuilder: (_, e) => _errorWidget(theme, context),
          //     Container(
          //   child: Text(e.toString()),
          // ),
          listBuilder: (_, channels) {
            var chats = channels
                .map((channel) {
              final opponentUser = getOpponentUser(channel);
              if (opponentUser?.extraData['channelsBanned'] is List) {
                var channelsBanned = opponentUser?.extraData['channelsBanned'] as List<dynamic>?;
                if (channel.createdBy?.id == opponentUser?.id && channel.state?.lastMessage == null)
                  return null;
                if (opponentUser != null && channelsBanned != null)
                  if (channelsBanned.contains(channel.id)) {
                    return BlockedUserTile(channel, opponentUser: opponentUser);
                  } else {
                    return null;
                  }
              }
              return null;
            })
                .where((e) => e != null)
                .map((e) => e!)
                .toList();
            return chats.isEmpty
              ? Loader(text: AppLocalizations.of(context)?.noBlackListFound ?? '')
              : ListView.separated(
              itemCount: chats.length,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              separatorBuilder: (context, index) => Divider(height: 0.5, indent: 68, endIndent: 4, color: theme.colorTheme.seconadaryGray3),
              itemBuilder: (context, index) => chats[index],
            );
          },
          loadingBuilder: (_) => Loader(text: AppLocalizations.of(context)?.loading ?? ''),
        ),
      ),
    );
  }

  Widget _errorWidget(BrandTheme theme, BuildContext context) {
    debugPrint('ChannelListCore initialization error');
    return Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          alignment: Alignment.topCenter,
          child: Text(AppLocalizations.of(context)?.errorBlackListCore ?? '',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: theme.colorTheme.grayText)),
        );
  }
}