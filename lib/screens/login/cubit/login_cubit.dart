import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthReporsitory _authReporsitory;
  LoginCubit({@required AuthReporsitory authReporsitory})
      : _authReporsitory = authReporsitory,
        super(LoginState.initial());

  void emailChanged(String value) =>
      emit(state.copyWith(email: value, status: LoginStatus.initial));

  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, status: LoginStatus.initial));

  void loginWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      auth.User user = await _authReporsitory.logInWithEmailAndPassword(
          email: state.email, password: state.password);
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.reference().child('users');

        await userRef.child(user.uid).once().then((snap) {
          if (snap != null) {}
        });
        emit(state.copyWith(
            username: user.displayName, status: LoginStatus.success));
      } else {
        Failure failure = Failure(code: 'User', message: 'Login Failed.');
        throw failure;
      }
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: LoginStatus.error));
    }
  }
}
