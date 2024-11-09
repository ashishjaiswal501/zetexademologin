import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_entity.freezed.dart';


@freezed
class LoginEntity with _$LoginEntity {
    const factory LoginEntity({
        @JsonKey(name: "token")
        String? token,
    }) = _LoginEntity;

    
}
