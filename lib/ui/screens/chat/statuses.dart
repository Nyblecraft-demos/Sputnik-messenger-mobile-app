import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/cubits/contacts/contacts_cubit.dart';
import 'package:sputnik/logic/forms/send_form/send_form.dart';
import 'package:sputnik/logic/model/status.dart';
import 'package:sputnik/ui/components/brand_avatar_circle/brand_avatar_circle.dart';
import 'package:sputnik/ui/helpers/phone_services/gallery/gallery.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class StatusesPage extends StatelessWidget {
  const StatusesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contactState = context.watch<ContactsCubit>().state;
    var theme = context.watch<BrandTheme>();
    List<User> contacts;
    if (contactState is Loaded) {
      contacts = (context.watch<ContactsCubit>().state as Loaded)
          .users
          .where((c) => c.status != null)
          .toList();
    } else {
      contacts = [];
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.topCenter,
      child: Text(
          AppLocalizations.of(context)?.inProgress ?? '',
          //'В разработке, скоро будет доступно',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.colorTheme.grayText)
      ),
    );
    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     SizedBox(height: 10),
    //     _StatusCard(),
    //     if (contacts.isNotEmpty) _FriendStatusList(contacts),
    //   ],
    // );
  }
}

class _FriendStatusList extends StatelessWidget {
  const _FriendStatusList(
    this.contacts, {
    Key? key,
  }) : super(key: key);

  final List<User> contacts;
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return

      ListView.separated(
      shrinkWrap: true,
      itemCount: contacts.length + 1,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      separatorBuilder: (context, index) => Divider(height: 0.5, indent: 68, endIndent: 20, color: CupertinoColors.separator),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
            child: Text('Недавно', style: theme.highlightedText.copyWith(fontSize: 18)),
          );
        }

        var user = contacts[index - 1];
        return Container(
          height: 80,
          padding: EdgeInsets.fromLTRB(10, 10, 19, 10),
          child: Row(
            children: [
              BrandAvatarCircle(
                user: user,
                size: 68,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(user.name, style: theme.h3, overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.5),
                    Text(
                      user.status?.createdAt != null ? timeago.format(user.status!.createdAt!, locale: 'ru') : '',
                      style: theme.body.copyWith(color: theme.body.color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var authCubit = context.watch<AuthenticationCubit>();
    var currentUser = (authCubit.state as Authenticated).user;
    var hasStatus = currentUser.status != null;
    return Container(
      height: 80,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   color: theme.colorTheme.bubleBackground,
      // ),
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          BrandAvatarCircle(
            user: currentUser,
            size: 52,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Мой статус',
                        style: theme.h3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  '${hasStatus ? 'Сменить' : 'Добавить'} статус',
                  style: theme.body.copyWith(
                    color: hasStatus
                        ? theme.body.color
                        : theme.body.color?.withOpacity(0.5),
                    fontStyle: hasStatus ? FontStyle.normal : FontStyle.italic,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          circleIcon(
            icon: CupertinoIcons.photo_camera_solid,
            size: 18,
            onTap: () => addImage(authCubit)
          ),
          // BlueCircle(
          //   BrandIcons.add_photo,
          //   onTap: () => addImage(authCubit),
          // ),
          if (hasStatus) ...[
            SizedBox(width: 10),
            circleIcon(
                icon: CupertinoIcons.xmark,
                size: 15,
                onTap: () => authCubit.update(user: currentUser.setStatus(null))
            ),
            // BlueCircle(
            //   Ionicons.close,
            //   onTap: () => authCubit.update(user: currentUser.setStatus(null)),
            //   color: BrandColors.red,
            //   size: 20,
            // ),
          ],
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

  void addImage(AuthenticationCubit cubit) async {
    var url = await Gallery.pickPhoto();
    var newStatus = Status(imageUrl: url, createdAt: DateTime.now());
    var currentUser = getIt.get<ChatService>().currentUser;
    cubit.update(user: currentUser.setStatus(newStatus));
  }

  void remove(AuthenticationCubit cubit) async {
    var currentUser = getIt.get<ChatService>().currentUser;
    cubit.update(user: currentUser.setStatus(null));
  }
}
