import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:demozeta/features/login/data/data_sources/remote/login_api_service.dart';
import 'package:demozeta/features/login/data/repository/login_repository_impl.dart';
import 'package:demozeta/features/login/domain/repository/login_repository.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:demozeta/features/login/presentation/bloc/login_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependecies() async {
  getIt.registerSingleton<Dio>(DioFactory().create());

  getIt.registerFactory<LoginApiService>(
    () => LoginApiService(getIt()),
  );
  // Repository Register
  getIt.registerSingleton<LoginRepository>(
      LoginRespositoryImpl(loginApiService: getIt<LoginApiService>()));

// UseCase Register
  getIt.registerSingleton<GetLoginUsecase>(
      GetLoginUsecase(getIt<LoginRepository>()));

// Bloc Register

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt()),
  );
}

class DioFactory {
  BaseOptions _createBaseOption() => BaseOptions(
          headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 120),
          followRedirects: false,
          validateStatus: (status) => true,
          connectTimeout: const Duration(seconds: 60));
  Dio create() => Dio(_createBaseOption())
    ..interceptors.addAll([
      AwesomeDioInterceptor(
        // Disabling headers and timeout would minimize the logging output.
        // Optional, defaults to true
        logRequestTimeout: true,
        logRequestHeaders: true,
        logResponseHeaders: true,

        // Optional, defaults to the 'log' function in the 'dart:developer' package.
        logger: debugPrint,
      ),
    ]);
}
