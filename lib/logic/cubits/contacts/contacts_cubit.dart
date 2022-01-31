import 'package:hive/hive.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/cubits/auth_dependent/auth_dependent_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

part 'contacts_state.dart';

class ContactsCubit extends AuthDependentCubit<ContactsState> {
  ContactsCubit(AuthenticationCubit authCubit)
      : super(
          authCubit,
          Loaded.empty(),
        );

  Box<List<String>> box = Hive.box(BNames.contactBook);

  @override
  void clear() {
    box.clear();
  }

  ChatService chatService = getIt.get<ChatService>();

  @override
  void load(_) async {
    List<String>? userIds = box.get(BNames.contactBook, defaultValue: []);
    if (userIds != null) {
      if (userIds.isEmpty) {
        emit(Loaded.empty());
      } else {
        _showUsersWithIds(userIds);
      }
    }
  }

  void add(User? user) async {
    List<String>? userIds = box.get(BNames.contactBook, defaultValue: []);
    if (userIds != null) {
      if (user?.id != null && !userIds.contains(user?.id)) {
        var newIds = [...userIds, user!.id];
        box.put(BNames.contactBook, [...userIds, user.id]);
        _showUsersWithIds(newIds);
      }
    }
  }

  _showUsersWithIds(List<String> userIds) async {
    emit(Loading());
     QueryUsersResponse resp = await chatService.client.queryUsers(
       filter: Filter.in_("id", userIds),
       sort: [SortOption('last_active')],
     );


    var users = resp.users;
    emit(Loaded(users));
  }
}
