import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home Screen",
              style: TextStyle(fontSize: 22),
            ),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              if (state is LoginStateSuccess) {
                return Text("Token-> ${state.loginEntity!.token!}");
              } else {
                return const SizedBox.shrink();
              }
            })
          ],
        ),
      ),
    );
  }
}
