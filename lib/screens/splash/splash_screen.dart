import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  static const id = '/splash';
  static Route route() => MaterialPageRoute(
        settings: const RouteSettings(name: id),
        builder: (_) => SplashScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (context, state) async {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(LoginScreen.id);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavScreen.id);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SpinKitFadingCircle(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
