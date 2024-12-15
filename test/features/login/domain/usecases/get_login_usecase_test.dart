import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/repository/login_repository.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late MockLoginRepository loginrepository;
  late GetLoginUsecase getLoginUsecase;

  setUp(() {
    loginrepository = MockLoginRepository();
    getLoginUsecase = GetLoginUsecase(loginrepository);
  });

  group('Usecase login Test', () {
    test("should return DataSuccess when repository call succeeds ", () async {
      // arrange
      var loginprams =
          LoginRequestPrams(email: 'ashish@gamil.com', password: "admin");
      when(() => loginrepository.login(loginprams)).thenAnswer(
          (_) async => const DataSuccess(LoginEntity(token: 'mocktoken')));
      // act
      final result = await getLoginUsecase.call(prams: loginprams);

      expect(result, isA<DataSuccess<LoginEntity>>());
      final successresult = result as DataSuccess<LoginEntity>;
      expect(successresult.data, equals(const LoginEntity(token: 'mocktoken')));
      verify(() => loginrepository.login(loginprams)).called(1);
    });
  });

  test('should return DataError when repository call fails', () async {
    // Arrange
    const errorMessage = 'Login failed';
    var loginprams =
        LoginRequestPrams(email: 'ashish@gamil.com', password: "admin");

    when(() => loginrepository.login(loginprams))
        .thenAnswer((_) async => const DataFailed(errorMessage));

    // Act
    final result = await getLoginUsecase.call(prams: loginprams);

    // Assert
    expect(result, isA<DataFailed>());
    final errorResult = result as DataFailed;
    expect(errorResult.dioError, equals(errorMessage));

    verify(() => loginrepository.login(loginprams)).called(1);
  });

  test('should return DataError when params are null', () async {
    // Act
    final result = await getLoginUsecase.call(prams: null);

    // Assert
    expect(result, isA<DataFailed<LoginEntity>>());
    if (result is DataFailed<LoginEntity>) {
      expect(result.dioError, equals('Parameters cannot be null'));
    }
  });
}
