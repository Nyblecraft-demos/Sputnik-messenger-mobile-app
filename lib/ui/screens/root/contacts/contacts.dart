import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/contacts/contacts_cubit.dart';
import 'package:sputnik/ui/components/blue_circle/blue_circle.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/components/brand_contact_tiles/brand_contact_tiles.dart';
import 'package:sputnik/ui/route_transitions/slide_bottom.dart';
import 'package:sputnik/ui/screens/find_user/find_user.dart';
import 'package:sputnik/ui/screens/invite_friends/invite_friends.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part './button.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    var state = context.watch<ContactsCubit>().state;
    //var brandTheme = context.watch<BrandTheme>();

    final buttons = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: BrandButton.secondary(
              text: AppLocalizations.of(context)?.addContact ?? '',
              backgroundColor: theme.colorTheme.buttonsColorEnable,
              textColor: theme.colorTheme.textButtonsColorEnable,
              onPressed: () => Navigator.of(context).push(SlideBottomRoute(FindUserPage())),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
              child: BrandButton.secondary(
            text: AppLocalizations.of(context)?.inviteFriends ?? '',
                backgroundColor: theme.colorTheme.buttonsColorEnable,
                textColor: theme.colorTheme.textButtonsColorEnable,
            onPressed: () => navigate(context)),
          )
        ],
      ),
    );

    List<Widget> listItems = [buttons];
    if (state is Loaded) {
      if (state.users.isEmpty) {
        return Column(
          children: [
            buttons,
            Expanded(
                child: Center(
                    child:
                    Text(
                        AppLocalizations.of(context)?.noContacts ?? '',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: CupertinoColors.secondaryLabel),
                        textAlign: TextAlign.center))),
            SizedBox(height: 44)],
        );
      } else {
        listItems += state.users.map((contact) => ContactTile(contact: contact)).toList();
      }
    } else if (state is Loading) {
      return Column(
        children: [
          buttons,
          Expanded(
              child: Center(
                  child:
                  Text(
                      AppLocalizations.of(context)?.loadingContacts ?? '',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: CupertinoColors.secondaryLabel),
                      textAlign: TextAlign.center))),
          SizedBox(height: 44)],
      );
    }
    return ListView.separated(
      itemCount: listItems.length,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      separatorBuilder: (context, index) => index > 0 ? Divider(height: 0.5, indent: 68, endIndent: 20, color: CupertinoColors.separator) : SizedBox.shrink(),
      itemBuilder: (context, index) => listItems[index],
    );
  }

  void navigate(BuildContext context) async {
    final contacts = await getContacts();
    Navigator.of(context).push(SlideBottomRoute(InviteFriendsPage(contacts)));
  }

  Future<List<Contact>> getContacts({String? query}) async {
    debugPrint('InviteFriendsPage:  status = ${await Permission.contacts.status}');
    final permission = await Permission.contacts.request();
    if (!permission.isGranted) {
      openAppSettings();
    }
    if (permission.isGranted) {
      List<Contact> data = await FlutterContacts.getContacts(withProperties: true);
      return data;
    } else {
      return [];
    }
  }
}
