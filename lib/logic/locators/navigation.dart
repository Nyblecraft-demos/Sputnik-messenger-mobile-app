import 'package:flutter/widgets.dart';
import 'package:sputnik/ui/screens/root/root.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get navigator => navigatorKey.currentState;
  List<MenuPage> navigationStack = [];
}
