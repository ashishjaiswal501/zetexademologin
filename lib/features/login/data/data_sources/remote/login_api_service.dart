import 'package:demozeta/core/constants/api_endpoint.dart';
import 'package:demozeta/features/login/data/dto/login_dto.dart';
import 'package:demozeta/features/login/domain/usecases/get_login_usecase.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'login_api_service.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class LoginApiService {
  factory LoginApiService(Dio dio) = _LoginApiService;

  @POST(ApiEndpoint.login)
  Future<HttpResponse<LoginDto>> login(@Body() LoginRequestPrams loginRequestPrams);
}
