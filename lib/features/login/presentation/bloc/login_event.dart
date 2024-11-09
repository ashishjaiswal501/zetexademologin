import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class GetLoginPressed extends LoginEvent {
  final String email;
  final String password;

  const GetLoginPressed({required this.email, required this.password});
}
