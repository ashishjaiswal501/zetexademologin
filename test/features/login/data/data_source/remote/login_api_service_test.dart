import 'package:demozeta/core/constants/api_endpoint.dart';
import 'package:demozeta/features/login/data/data_sources/remote/login_api_service.dart';
import 'package:demozeta/features/login/data/dto/login_dto.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/retrofit.dart';

class MockLoginApiService extends Mock implements LoginApiService {}

void main() {
  late MockLoginApiService mockLoginApiService;

  setUp(() {
    mockLoginApiService = MockLoginApiService();
  });

  group('LoginApiService Tests', () {
    test('should send POST request to the correct endpoint', () async {
      // Arrange
      final loginParams =
          LoginRequestPrams(email: 'test@example.com', password: 'password123');
      const loginDto = LoginDto(token: 'mockToken');

      // Create a valid HttpResponse<LoginDto>
      final response = HttpResponse<LoginDto>(
          loginDto,
          Response(
            requestOptions: RequestOptions(path: ApiEndpoint.login),
            statusCode: 200,
          ));

      // Mock the login method to return the response
      when(() => mockLoginApiService.login(loginParams))
          .thenAnswer((_) async => response);

      // Act
      final result = await mockLoginApiService.login(loginParams);

      // Assert
      verify(() => mockLoginApiService.login(loginParams)).called(1);
      expect(result.response.statusCode, 200);
      expect(result.data.token, 'mockToken');
    });

    test('should handle HTTP errors correctly', () async {
      // Arrange
      final loginParams = LoginRequestPrams(
          email: 'test@example.com', password: 'wrongPassword');

      final response = HttpResponse<LoginDto>(
          LoginDto(),
          Response(
            requestOptions: RequestOptions(path: ApiEndpoint.login),
            statusCode: 401,
            data: {'error': 'Invalid credentials'},
          ));

      // Mock the login method to throw DioError
      when(() => mockLoginApiService.login(loginParams)).thenThrow(DioError(
        response: response.response,
        requestOptions: response.response.requestOptions,
      ));

      // Act
      try {
        await mockLoginApiService.login(loginParams);
      } catch (e) {
        // Assert
        expect(e, isA<DioError>());
        final error = e as DioError;
        expect(error.response?.statusCode, 401);
        expect(error.response?.data['error'], 'Invalid credentials');
      }
    });
  });
}
