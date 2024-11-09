import 'dart:io';

import 'package:demozeta/core/resources/data_state.dart';
import 'package:demozeta/features/login/data/data_sources/remote/login_api_service.dart';
import 'package:demozeta/features/login/domain/entity/login_entity.dart';
import 'package:demozeta/features/login/domain/repository/login_repository.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:dio/dio.dart';
import 'package:demozeta/features/login/data/mapper/login_mapper.dart';

class LoginRespositoryImpl implements LoginRepository {
  final LoginApiService loginApiService;
  LoginRespositoryImpl({required this.loginApiService});

  @override
  Future<DataState<LoginEntity>> login(LoginRequestPrams? loginRequest) async {
    try {
      final httpResponse = await loginApiService.login(loginRequest!);

      if (httpResponse.response.statusCode == HttpStatus.accepted ||
          httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.toLoginEntity!);
      } else {
        return DataFailed(httpResponse.response.statusMessage!);
      }
    } on DioException catch (e) {
      return DataFailed(e.toString());
    }
  }
}
