import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GenerateLoginTicketUseCase
    implements UseCase<String, GenerateLoginTicketParams> {
  GenerateLoginTicketUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, String>> call(GenerateLoginTicketParams params) =>
      _repository.generateLoginTicket(cancelToken: params.cancelToken);
}

class GenerateLoginTicketParams extends Equatable {
  const GenerateLoginTicketParams({this.cancelToken});

  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [];
}