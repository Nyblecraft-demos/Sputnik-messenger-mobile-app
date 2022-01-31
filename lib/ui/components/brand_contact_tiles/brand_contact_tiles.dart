import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/contacts/contacts_cubit.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/components/brand_icons/brand_icons.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/chat/chat.dart';
import 'package:sputnik/ui/screens/user_pofile/user_profile.dart';
import 'package:sputnik/utils/help_functions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:sputnik/logic/model/user_extension.dart';

class ContactTiles {
  static Widget contactList(User contact) => ContactTile(contact: contact);

  static Widget searchList(User contact) => SearchTile(contact: contact);
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    this.contact,
  }) : super(key: key);

  final User? contact;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    //var borderColor = theme.colorTheme.backgroundColor1;
    return Container(
      height: 68,
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(width: 0.5, color: borderColor),
      //   ),
      // ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (contact != null)
            GestureDetector(
              onTap: () => Navigator.of(context).push(materialRoute(
                  UserProfile(user: contact!)
              )),
              child: BrandAvatarCircle(user: contact!, size: 48, showStatus: true),
            ),
          SizedBox(width: 10),
          Expanded(child: _name(theme, contact)),
          SizedBox(width: 10),
          circleIcon(
            icon: CupertinoIcons.phone_fill,
            //color: CupertinoColors.systemGreen,
            onTap: () => callPhone(contact?.phoneNumber),
          ),
          SizedBox(width: 10),
          circleIcon(
            icon: CupertinoIcons.paperplane_fill,
            onTap: () async {
              var client = getIt.get<ChatService>().client;
              var channel = client.channel("messaging", extraData: {
                "members": [contact?.id, client.state.user?.id]
              });
              await channel.watch();
              debugPrint('contact:  message icon pressed:  contact id = ${contact?.id}  client id = ${client.state.user?.id}');
              Navigator.of(context).push(materialRoute(
                StreamChannel(channel: channel, child: ChatPage(contact!)),
              ));
            },
          ),
          //BlueCircle(BrandIcons.envelop),
        ],
      ),
    );
  }

  Widget circleIcon({required IconData icon, VoidCallback? onTap, double? size = 18, Color? color = BrandColors.primary }) {
    var content = Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.secondarySystemFill, //color != null ? color : BrandColors.blue1,
      ),
      child: Center(child: Icon(icon, color: color, size: size)),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  Widget _name(BrandTheme theme, User? contact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                contact?.getShortName() ?? '',
                style: theme.h3,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
        if (contact?.extraData['wallet'] != null) ...[
          SizedBox(width: 4),
          Icon(
            BrandIcons.ouro,
            color: BrandColors.blue1,
            size: 18,
          )
        ],
      ],
    );
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({
    Key? key,
    this.contact,
  }) : super(key: key);

  final User? contact;

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return Container(
      height: 68,
      //padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (contact != null)
            GestureDetector(
              onTap: () => Navigator.of(context).push(materialRoute(
                  UserProfile(user: contact!)
              )),
              child: BrandAvatarCircle(user: contact!, size: 48, showStatus: true),
            ),
          SizedBox(width: 10),
          Expanded(child: _name(theme, contact)),
          SizedBox(width: 10),
          circleIcon(
            icon: CupertinoIcons.paperplane_fill,
            onTap: () async {
              var client = getIt.get<ChatService>().client;

              var channel = client.channel("messaging", extraData: {
                "members": [contact?.id, client.state.user?.id]
              });
              await channel.watch();
              debugPrint('searchTile:  start messaging with user = ${contact?.id}');
              Navigator.of(context).push(materialRoute(
                StreamChannel(
                  channel: channel,
                  child: ChatPage(contact!),
                ),
              ));
            },
          ),
          SizedBox(width: 10),
          circleIcon(
            icon: CupertinoIcons.person_add_solid,
            onTap: () {
              debugPrint('searchTile:  add contact = $contact');
              context.read<ContactsCubit>().add(contact);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget circleIcon({required IconData icon, VoidCallback? onTap, double? size = 18, Color? color = BrandColors.primary }) {
    var content = Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.secondarySystemFill, //color != null ? color : BrandColors.blue1,
      ),
      child: Icon(icon, color: color, size: size),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  Widget _name(BrandTheme theme, User? contact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                contact?.getShortName() ?? '',
                style: theme.h3,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
        if (contact?.extraData['wallet'] != null) ...[
          SizedBox(width: 4),
          Icon(
            BrandIcons.ouro,
            color: BrandColors.blue1,
            size: 18,
          )
        ],
      ],
    );
  }
}
