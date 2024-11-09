import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/features/login/data/dto/login_dto.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';

abstract class LoginRepository {
  Future<DataState<LoginEntity>> login(LoginRequestPrams? loginRequest);
}
