import 'package:equatable/equatable.dart';

abstract class Usecase<Type, Prams> {
  Future<Type> call({Prams prams});
}

class NoPrams extends Equatable {
  const NoPrams();
  @override
  List<Object?> get props => [];
}
