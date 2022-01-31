import 'package:get_it/get_it.dart';
import 'package:sputnik/logic/locators/chat.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/logic/locators/user_time_reward.dart';

export 'package:sputnik/logic/locators/chat.dart';

final getIt = GetIt.instance;

void getItSetup() {
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<ChatService>(ChatService());
  getIt.registerSingleton<UserRewardInterval>(UserRewardInterval());
}
