import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:instagram_clone/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthReporsitory _authRepository;
  StreamSubscription<auth.User> _userSubscription;
  AuthBloc({@required AuthReporsitory authReporsitory})
      : _authRepository = authReporsitory,
        super(
          AuthState.unknown(),
        ) {
    _userSubscription = _authRepository.user.listen(
      (user) => add(
        AuthUserChanged(user: user),
      ),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    try {
      //final currentState = state;
      if (event is AuthUserChanged) {
        yield* _mapAuthUserChangedToState(event);
      } else if (event is AuthLogoutRequested) {
        await _authRepository.logOut();
      }
    } catch (e) {
      print(e);
    }
  }
}

Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
  yield event.user != null
      ? AuthState.authenticated(user: event.user)
      : AuthState.unauthenticated();
}
