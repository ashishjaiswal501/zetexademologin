
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
class LoginDto with _$LoginDto {
  const factory LoginDto({
    @JsonKey(name: "token") String? token,
  }) = _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}


