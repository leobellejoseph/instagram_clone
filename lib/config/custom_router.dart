import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/screens.dart';

class CustomRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Scaffold(),
          settings: const RouteSettings(name: '/'),
        );
      case SplashScreen.id:
        return SplashScreen.route();
      case LoginScreen.id:
        return LoginScreen.route();
      case NavScreen.id:
        return NavScreen.route();
      case SignupScreen.id:
        return SignupScreen.route();
      default:
        return _erorrRoute();
    }
  }

  static Route onGenerateNestedRouted(RouteSettings settings) {
    switch (settings.name) {
      case EditProfileScreen.id:
        return EditProfileScreen.route(args: settings.arguments);
      case ProfileScreen.id:
        return ProfileScreen.route(args: settings.arguments);
      default:
        return _erorrRoute();
    }
  }

  static Route _erorrRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
