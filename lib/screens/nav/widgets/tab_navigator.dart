import 'package:flutter/material.dart';
import 'package:instagram_clone/enums/bottom_nav_item.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/config/custom_router.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator({@required this.navigatorKey, @required this.item});
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context))
        ];
      },
      onGenerateRoute: CustomRoute.onGenerateNestedRouted,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostScreen();
      case BottomNavItem.notifications:
        return NotificationScreen();
      case BottomNavItem.profile:
        return ProfileScreen();
      default:
        return Scaffold();
    }
  }
}