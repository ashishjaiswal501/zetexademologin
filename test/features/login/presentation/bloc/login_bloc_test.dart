import 'package:bloc_test/bloc_test.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:demozeta/features/login/presentation/bloc/login_event.dart';
import 'package:demozeta/features/login/presentation/bloc/login_state.dart';
import 'package:demozeta/core/resources/data_state.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

// Create a mock class for GetLoginUsecase using mocktail
class MockGetLoginUsecase extends Mock implements GetLoginUsecase {}

void main() {
  late MockGetLoginUsecase mockGetLoginUsecase;
  late LoginBloc loginBloc;

  setUp(() {
    mockGetLoginUsecase = MockGetLoginUsecase();
    loginBloc = LoginBloc(mockGetLoginUsecase);
    when(() => mockGetLoginUsecase.call(prams: any(named: 'prams')))
        .thenAnswer((invocation) async {
      final params = invocation.namedArguments[const Symbol('prams')]
          as LoginRequestPrams?;
      if (params == null) {
        return const DataFailed<LoginEntity>('Parameters cannot be null');
      } else if (params.email == 'wrong@example.com' &&
          params.password == 'wrongpassword') {
        return const DataFailed('Invalid credentials');
      } else if (params.email == 'wrong@example.com' &&
          params.password == 'wrongpassword2') {
        return const DataFailed('Unexpected error');
      }
      return const DataSuccess(LoginEntity(token: 'mockToken'));
    });
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc Tests', () {
    const loginEntity = LoginEntity(token: 'mockToken');

    test('initial state is LoginStateInitial', () {
      expect(loginBloc.state, const LoginStateInitial());
    });

    blocTest<LoginBloc, LoginState>(
      'emits [LoginStateLoading, LoginStateSuccess] when login is successful',
      build: () {
        when(() => mockGetLoginUsecase.call(
              prams: LoginRequestPrams(
                  email: 'test@example.com', password: 'password'),
            )).thenAnswer(
          (_) async => const DataSuccess(loginEntity),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(const GetLoginPressed(
        email: 'test@example.com',
        password: 'password',
      )),
      expect: () => [
        const LoginStateLoading(),
        const LoginStateSuccess(loginEntity),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginStateLoading, LoginStateError] when login fails',
      build: () {
        when(() => mockGetLoginUsecase.call(
              prams: LoginRequestPrams(
                  email: 'wrong@example.com', password: 'wrongpassword'),
            )).thenAnswer(
          (_) async => const DataFailed('Invalid credentials'),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(const GetLoginPressed(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      )),
      expect: () => [
        const LoginStateLoading(),
        const LoginStateError('Invalid credentials'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginStateLoading, LoginStateError] when exception is thrown',
      build: () {
        when(() => mockGetLoginUsecase.call(
              prams: LoginRequestPrams(
                  email: 'wrong@example.com', password: 'wrongpassword2'),
            )).thenThrow(const DataFailed('Unexpected error'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const GetLoginPressed(
        email: 'wrong@example.com',
        password: 'wrongpassword2',
      )),
      expect: () => [
        const LoginStateLoading(),
        const LoginStateError('Unexpected error'),
      ],
    );
  });
}
