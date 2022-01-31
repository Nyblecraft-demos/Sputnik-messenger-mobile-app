import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart' as Email_Sender;
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteFriendsPage extends StatefulWidget {
  const InviteFriendsPage(this.contacts, {Key? key}) : super(key: key);

  final List<Contact> contacts;

  @override
  State<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  Timer? searchOnStoppedTyping;
  TextEditingController controller = TextEditingController();
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    _checkContacts();
    filteredContacts.addAll(contacts);
    super.initState();
  }

  void _checkContacts() {
    widget.contacts.forEach((contact) {
      if (contact.phones.length > 1) {
        contact.phones.asMap().forEach((key, value) {
          contacts.add(
              Contact(
                  displayName: contact.displayName,
                  phones: [value],
                  emails: (contact.emails.length > key) ? [contact.emails[key]] : null));
        });
      } else {
        contacts.add(contact);
      }
    });
  }

  void _onChangeHandler(value) {
    const duration = Duration(milliseconds:400);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping = new Timer(duration, () => _filterContacts(value)));
  }


  void _filterContacts(String text) {
    var filtered = contacts.where((contact) => contact.displayName.toLowerCase().contains(text.toLowerCase())).toList();
    setState(() {
      filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    //var state = context.watch<ContactsCubit>().state;
    var theme = context.watch<BrandTheme>();

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.listOfContacts ?? ''),
          leading: BrandBackButton(),
        ),
        body: Padding(
          padding: paddingV10H0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextField(
                maxLines: 1,
                controller: controller,
                style: TextStyle(fontSize: 15, color: CupertinoColors.label),
                textAlign: TextAlign.start,
                scrollPadding: EdgeInsets.only(bottom: 70),
                onChanged: _onChangeHandler,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorTheme.backgroundColor1,
                  prefixIcon: Icon(CupertinoIcons.search, size: 20, color: BrandColors.primary),
                  prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 40),
                  hintStyle: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel),
                  hintText: AppLocalizations.of(context)?.contactName ?? '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.transparent, width: 0),

                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.transparent, width: 0),

                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
              ),
              SizedBox(height: 2),
              if (filteredContacts.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        AppLocalizations.of(context)?.noContacts ?? '',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: CupertinoColors.secondaryLabel),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredContacts.length,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  separatorBuilder: (context, index) => Divider(height: 0.5, indent: 20, endIndent: 20, color: CupertinoColors.separator),
                  itemBuilder: (context, index) {
                      return tile(contact: filteredContacts[index], context: context);
                      },
              ),
              ),
            ],
          ),
        )



        // widget.contacts.length > 0 ?
        // ListView.separated(
        //   itemCount: widget.contacts.length,
        //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        //   separatorBuilder: (context, index) => Divider(height: 0.5, indent: 20, endIndent: 20, color: CupertinoColors.separator),
        //   itemBuilder: (context, index) {
        //     //debugPrint('InviteFriendsPage:  contact = ${data[index].displayName}  phones = ${data[index].phones}');
        //     return tile(contact: widget.contacts[index], context: context);
        //   },
        // ) : Center(
        //     child: Text(AppLocalizations.of(context)?.noContacts ?? '',
        //         style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: CupertinoColors.secondaryLabel),
        //         overflow: TextOverflow.ellipsis,
        //         maxLines: 1
        //     )
        // )
    );
  }

  Widget tile({required Contact contact, required BuildContext context}) {
    var theme = context.watch<BrandTheme>();
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          //BrandAvatarCicle(contact: contact),
          //SizedBox(width: 10),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.displayName, style: theme.h3, overflow: TextOverflow.ellipsis, maxLines: 1),
                  SizedBox(height: 2),
                  Text(
                      (contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty) ? contact.phones.first.number : "",
                      style: theme.small,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)
                ],
              )
          ),
          SizedBox(width: 10),
          circleIcon(
              icon: CupertinoIcons.envelope_fill,
              onTap: () => (contact.emails.isNotEmpty && contact.emails.first.address.isNotEmpty) ? sendEmail(context, email: contact.emails.first.address) : null,
              color: (contact.emails.isNotEmpty && contact.emails.first.address.isNotEmpty) ? BrandColors.primary : BrandColors.grey3
          ),
          SizedBox(width: 10),
          circleIcon(
              icon: CupertinoIcons.text_bubble_fill,
              onTap: () => (contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty) ? sendInvitingSMS(context, number: contact.phones.first.number) : null,
              color: (contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty) ? BrandColors.primary : BrandColors.grey3
          ),
        ],
      ),
    );
  }

  Widget circleIcon({required IconData icon, VoidCallback? onTap, double? size = 18, Color? color}) {
    var content = Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.secondarySystemFill, //color != null ? color : BrandColors.blue1,
      ),
      child: Icon(icon, color: color, size: size),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: content)
        : content;
  }

  Future<void> sendInvitingSMS(BuildContext context, {required String? number}) async {
    if (number == null || number.isEmpty) {
      return;
    }
    List<String> recipient = [number];
    String message = '${AppLocalizations.of(context)?.invite} https://sputnik-1.com/ ${AppLocalizations.of(context)?.join}';
    String _result = await sendSMS(message: message, recipients: recipient)
        .catchError((onError) {
      debugPrint('Sending sms error: $onError');
    });
    debugPrint('Sending sms result: $_result');
  }

  Future<void> sendEmail(BuildContext context, {required String? email}) async {
    debugPrint('InviteFriendPage:  send email to $email:  isOS = ${Platform.isIOS}  isAndroid = ${Platform.isAndroid}');
    if (email != null) {
      final emailConst = Email_Sender.Email(
        body: '${AppLocalizations.of(context)?.invite} https://sputnik-1.com/ ${AppLocalizations.of(context)?.join}',
        subject: AppLocalizations.of(context)?.sputnikMessenger ?? '',
        recipients: [email],
        isHTML: false,
      );

      String platformResponse;

      try {
        await Email_Sender.FlutterEmailSender.send(emailConst);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(platformResponse),
        ),
      );
    }
  }
}
