import 'package:flutter/material.dart';
import 'package:sputnik/ui/components/base_tabbar.dart';
import 'package:sputnik/ui/helpers/phone_services/notifications/notifications.dart';
import 'package:sputnik/ui/screens/chat/last_chat.dart';
import 'package:sputnik/ui/screens/chat/statuses.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int _currentPosition = 0;

  Widget build(BuildContext context) {
    NotificationService.chatList = _currentPosition == 0 ? true : false;
    List<TabItem> tabsContent = [
      TabItem(
        tab: BaseTab(text: AppLocalizations.of(context)?.chats ?? ''),
        page: LastChatPage(),
      ),
      // TabItem(
      //   tab: BaseTab(text: AppLocalizations.of(context)?.statuses ?? ''),
      //   page: StatusesPage(),
      // ),
    ];
    return DefaultTabController(
      initialIndex: _currentPosition,
      length: tabsContent.length,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 1,
            bottom: BaseTabBar(
                tabs: tabsContent.map((e) => e.tab).toList(),
                onTap: (index) {
                  setState(() {
                    _currentPosition = index;
                  });
                }
            ),
          ),
          body: TabBarView(
            children: tabsContent.map((e) => e.page).toList(),
          ),
      ),
    );
  }
}