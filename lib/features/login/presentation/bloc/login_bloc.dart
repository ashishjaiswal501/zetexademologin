import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:demozeta/features/login/presentation/bloc/login_event.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetLoginUsecase getLoginUsecase;
  LoginBloc(this.getLoginUsecase) : super(const LoginStateInitial()) {
    on<GetLoginPressed>(onLogin);
  }

  void onLogin(GetLoginPressed event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginStateLoading());
      final dataState = await getLoginUsecase.call(
          prams:
              LoginRequestPrams(email: event.email, password: event.password));

      if (dataState is DataSuccess<LoginEntity> && dataState.data != null) {
        emit(LoginStateSuccess(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(LoginStateError(dataState.dioError!));
      }
    } catch (e) {
      emit(LoginStateError(e.toString()));
    }
  }
}
