import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_entity.freezed.dart';


@freezed
class LoginEntity with _$LoginEntity {
    const factory LoginEntity({
        @JsonKey(name: "token")
        String? token,
    }) = _LoginEntity;

    
}
