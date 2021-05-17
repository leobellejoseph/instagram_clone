import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthReporsitory _authReporsitory;
  SignupCubit({@required AuthReporsitory authReporsitory})
      : _authReporsitory = authReporsitory,
        super(SignupState.initial());

  void usernameChanged(String value) =>
      emit(state.copyWith(username: value, status: SignupStatus.initial));

  void emailChanged(String value) =>
      emit(state.copyWith(email: value, status: SignupStatus.initial));

  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, status: SignupStatus.initial));

  void signupWithCredentials() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      auth.User user = await _authReporsitory.signUpWithEmailAndPassword(
          username: state.username,
          email: state.email,
          password: state.password);
      if (user != null) {
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        Failure failure = Failure(code: 'SignUp', message: 'SignUp Failed.');
        throw failure;
      }
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: SignupStatus.error));
    }
  }
}
