part of 'find_user.dart';

class _ByPhone extends StatefulWidget {
  const _ByPhone({Key? key}) : super(key: key);

  @override
  __ByPhoneState createState() => __ByPhoneState();
}

class __ByPhoneState extends State<_ByPhone> {
  bool isAccessToFind = true;
  TextEditingController controller = TextEditingController();
  ChatService chatService = getIt.get<ChatService>();
  Future<void> find(String phone) async {
    isAccessToFind = false;
    if (phone.length > 2) {
      await Future.delayed(Duration(milliseconds: 300));
      QueryUsersResponse resp = await chatService.client.queryUsers(
        filter: Filter.and([
          Filter.equal("phone", '+$phone'),
          Filter.notEqual("id", chatService.currentUser.id)
        ]),
      );
      setState(() {
        users = resp.users;
      });
    }
    debugPrint('Sended!');
    isAccessToFind = true;
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: brandTheme.colorTheme.backgroundColor1,
              prefixIcon: Icon(CupertinoIcons.search,
                  size: 20, color: BrandColors.primary),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 52, minHeight: 40),
              hintStyle: TextStyle(
                  fontSize: 15, color: CupertinoColors.secondaryLabel),
              hintText: AppLocalizations.of(context)?.phoneNumber,
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
          SizedBox(height: 4),
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
