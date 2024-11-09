import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:demozeta/features/login/presentation/bloc/login_event.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                controller: emailcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter email address";
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  emailcontroller.text = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter password";
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  passwordcontroller.text = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                return ElevatedButton(
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
