import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:demozeta/features/login/presentation/bloc/login_event.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final GlobalKey<FormState> foromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: foromKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const Key('emailField'),
                controller: emailcontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  emailcontroller.text = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                key: const Key('passwordField'),
                obscureText: true,
                controller: passwordcontroller,
                 validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
                onSaved: (newValue) {
                  passwordcontroller.text = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              BlocConsumer<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                      key: const Key('loginButton'),
                      onPressed: state is LoginStateLoading
                          ? null
                          : () {
                              if (foromKey.currentState!.validate()) {
                                foromKey.currentState!.save();
                                context.read<LoginBloc>().add(GetLoginPressed(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text));
                              }
                            },
                      child: const Text("Login"));
                },
                listener: (BuildContext context, LoginState state) {
                  if (state is LoginStateSuccess) {
                    context.replaceNamed('home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
