import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/ui/components/brand_error/error.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';

class SimpleBlocObserver extends BlocObserver {
  final navigatorKey = getIt.get<NavigationService>().navigatorKey;

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    navigatorKey.currentState?.push(
      materialRoute(
        BrandError(error: error, stackTrace: stackTrace),
      ),
    );
    super.onError(cubit, error, stackTrace);
  }
}
