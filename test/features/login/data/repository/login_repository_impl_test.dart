import 'dart:io';

import 'package:demozeta/core/constants/api_endpoint.dart';
import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/features/login/data/data_sources/remote/login_api_service.dart';
import 'package:demozeta/features/login/data/dto/login_dto.dart';
import 'package:demozeta/features/login/data/repository/login_repository_impl.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:dio/dio.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:retrofit/retrofit.dart';

import '../data_source/remote/login_api_service_test.dart';

class MockLoginapiService extends Mock implements LoginApiService {}

void main() {
  late MockLoginApiService mockLoginApiService;
  late LoginRespositoryImpl loginRepository;

  setUp(() {
    mockLoginApiService = MockLoginApiService();
    loginRepository =
        LoginRespositoryImpl(loginApiService: mockLoginApiService);
   
  });

  group('LoginRepository Tests', () {
    test('should return DataSuccess when login is successful', () async {
      // Arrange
      
      final loginRequest =
          LoginRequestPrams(email: 'test@example.com', password: 'password123');

      final httpResponse = HttpResponse<LoginDto>(
        const LoginDto(token: 'mockToken'), // Concrete DTO
        Response(
          requestOptions: RequestOptions(path: ApiEndpoint.login),
          statusCode: HttpStatus.ok, // HTTP Status
        ),
      );

      // Mock API response
      when(() => mockLoginApiService.login(loginRequest))
          .thenAnswer((_) async => httpResponse);

      // Act
      final result = await loginRepository.login(loginRequest);

      // Assert
      expect(result, isA<DataSuccess<LoginEntity>>());
      expect((result as DataSuccess).data.token, 'mockToken');
      verify(() => mockLoginApiService.login(loginRequest)).called(1);
    });

    test('should return DataFailed when login fails', () async {
      // Arrange
      final loginRequest = LoginRequestPrams(
          email: 'test@example.com', password: 'wrongPassword');

      final httpResponse = HttpResponse(
        const LoginDto(),
        Response(
          requestOptions: RequestOptions(path: ApiEndpoint.login),
          statusCode: HttpStatus.unauthorized,
          statusMessage: 'Invalid credentials',
        ),
      );

      // Mock API failure
      when(() => mockLoginApiService.login(loginRequest))
          .thenAnswer((_) async => httpResponse);

      // Act
      final result = await loginRepository.login(loginRequest);

      // Assert
      expect(result, isA<DataFailed>());
      expect((result as DataFailed).dioError, 'Invalid credentials');
      verify(() => mockLoginApiService.login(loginRequest)).called(1);
    });

    test('should return DataFailed on DioException', () async {
      // Arrange
      final loginRequest =
          LoginRequestPrams(email: 'test@example.com', password: 'password123');

      when(() => mockLoginApiService.login(loginRequest)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiEndpoint.login)));

      // Act
      final result = await loginRepository.login(loginRequest);

      // Assert
      expect(result, isA<DataFailed>());
      verify(() => mockLoginApiService.login(loginRequest)).called(1);
    });
  });
}
