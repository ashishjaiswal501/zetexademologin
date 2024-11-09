import 'package:demozeta/features/login/data/dto/login_dto.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';

extension LoginEntityExtention on LoginDto {
  LoginEntity? get toLoginEntity => LoginEntity(token: token);
}
