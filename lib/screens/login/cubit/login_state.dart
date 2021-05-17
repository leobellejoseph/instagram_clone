part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String username;
  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;
  const LoginState(
      {@required this.username,
      @required this.email,
      @required this.password,
      @required this.status,
      @required this.failure});

  factory LoginState.initial() {
    return LoginState(
      username: '',
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props =>
      [this.username, this.email, this.password, this.status, this.failure];

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String username,
    String email,
    String password,
    LoginStatus status,
    Failure failure,
  }) {
    return LoginState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
