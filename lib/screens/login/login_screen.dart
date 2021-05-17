import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/login/cubit/login_cubit.dart';
import 'package:instagram_clone/screens/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const id = 'login';
  static Route route() => PageRouteBuilder(
        settings: const RouteSettings(name: id),
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            authReporsitory: context.read<AuthReporsitory>(),
          ),
          child: LoginScreen(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialogue(content: state.failure.message),
              );
            } else if (state.status == LoginStatus.success) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Login Success'),
                  content: Text('${state.email}'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.blueAccent.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 4,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Instagram',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Please enter a valid email.'
                                    : null,
                                controller: _emailController,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                              ),
                              TextFormField(
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.length < 6
                                    ? 'Please enter valid password.'
                                    : null,
                                controller: _passwordController,
                                autocorrect: false,
                                enableSuggestions: false,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration:
                                    const InputDecoration(hintText: 'Password'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _submitForm(
                                    context, LoginStatus.submitting),
                                child: Text('Log In'),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  primary: Colors.blue,
                                ),
                                onPressed: () => Navigator.pushNamed(
                                    context, SignupScreen.id),
                                child: Text(
                                  'Don\'t have an account? Sign up',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, LoginStatus status) {
    if (_formKey.currentState.validate() && status == LoginStatus.submitting)
      context.read<LoginCubit>().loginWithCredentials();
  }
}
