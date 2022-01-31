part of 'find_user.dart';

class _ByName extends StatefulWidget {
  const _ByName({Key? key}) : super(key: key);

  @override
  __ByNameState createState() => __ByNameState();
}

class __ByNameState extends State<_ByName> {
  TextEditingController controller = TextEditingController();
  ChatService chatService = getIt.get<ChatService>();
  bool isAccessToFind = true;

  Future<void> find(text) async {
    isAccessToFind = false;
    if (text.length > 2) {
      QueryUsersResponse resp = await chatService.client.queryUsers(
          filter: Filter.and([
        Filter.autoComplete('name', text),
        Filter.notEqual('id', chatService.currentUser.id)
      ]));
      var queriedUsers = resp.users;
      QueryUsersResponse? nickResp = await _findNickName(text);
      if (nickResp != null) queriedUsers.addAll(nickResp.users);
      setState(() {
        users = queriedUsers;
      });
    }
    isAccessToFind = true;
  }

  Future<QueryUsersResponse?> _findNickName(text) async {
    if (text.length > 2) {
      QueryUsersResponse resp = await chatService.client.queryUsers(
          filter: Filter.and([
        Filter.equal('nickname', text),
        Filter.notEqual('id', chatService.currentUser.id)
      ]));
      return resp;
    }
  }

  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();

    return Padding(
      padding: paddingV24H0,
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
            onChanged: (value) async {
              if (isAccessToFind) await find(value);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: brandTheme.colorTheme.backgroundColor1,
              prefixIcon: Icon(CupertinoIcons.search,
                  size: 20, color: BrandColors.primary),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 52, minHeight: 40),
              hintStyle: TextStyle(
                  fontSize: 15, color: CupertinoColors.secondaryLabel),
              hintText: AppLocalizations.of(context)?.accountName ?? '',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
          SizedBox(height: 2),
          if (users.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)?.notFound ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.secondaryLabel),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ContactTiles.searchList(users[index]),
                );
              },
              itemCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
