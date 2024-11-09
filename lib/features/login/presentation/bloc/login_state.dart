import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final LoginEntity? loginEntity;
  final String? dioError;
  const LoginState({this.loginEntity, this.dioError});

  @override
  List<Object?> get props => [loginEntity, dioError];
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial();
}

class LoginStateSuccess extends LoginState {
  const LoginStateSuccess(LoginEntity loginEntity)
      : super(loginEntity: loginEntity);
}

class LoginStateError extends LoginState {
  const LoginStateError(String dioError) : super(dioError: dioError);
}
