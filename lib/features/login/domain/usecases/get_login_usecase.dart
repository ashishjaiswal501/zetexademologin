import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/core/usecase/usecase.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/repository/login_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_login_usecase.g.dart';

class GetLoginUsecase
    implements Usecase<DataState<LoginEntity>, LoginRequestPrams> {
  final LoginRepository loginRepository;
  GetLoginUsecase(this.loginRepository);
  @override
  Future<DataState<LoginEntity>> call({LoginRequestPrams? prams}) {
    return loginRepository.login(prams);
  }
}

@JsonSerializable()
class LoginRequestPrams {
  String email;
  String password;

  LoginRequestPrams({this.email = '', this.password = ''});

  factory LoginRequestPrams.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestPramsFromJson(json);

  // / Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LoginRequestPramsToJson(this);
}
