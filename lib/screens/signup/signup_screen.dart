import 'package:flutter/material.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/login/login_screen.dart';
import 'cubit/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  static const id = 'signup';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static Route route() => MaterialPageRoute(
        settings: const RouteSettings(name: id),
        builder: (context) => BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(
            authReporsitory: context.read<AuthReporsitory>(),
          ),
          child: SignupScreen(),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialogue(
                  content: state.failure.message,
                ),
              );
            } else if (state.status == SignupStatus.success) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialogue(
                  title: 'Signup',
                  content: '${state.username} Signup Successful!',
                ),
              );
              Navigator.popAndPushNamed(context, LoginScreen.id);
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
                                controller: _usernameController,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value.length < 8
                                    ? 'Please enter a valid username.'
                                    : null,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Please enter a valid email.'
                                    : null,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.length < 6
                                    ? 'Please enter valid password.'
                                    : null,
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
                                    context, SignupStatus.submitting),
                                child: Text('Sign Up'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.grey),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Back to LogIn',
                                  style: TextStyle(color: Colors.black),
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

  void _submitForm(BuildContext context, SignupStatus status) {
    if (_formKey.currentState.validate() && status == SignupStatus.submitting)
      context.read<SignupCubit>().signupWithCredentials();
  }
}
