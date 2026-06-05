import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address_input.dart';
import '../entities/address_mutation_result_entity.dart';
import '../repositories/address_repository.dart';

@lazySingleton
class CreateAddressUseCase
    implements UseCase<AddressMutationResultEntity, CreateAddressParams> {
  CreateAddressUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, AddressMutationResultEntity>> call(
    CreateAddressParams params,
  ) => _repository.createAddress(
    input: params.input,
    cartFlow: params.cartFlow,
    cancelToken: params.cancelToken,
  );
}

class CreateAddressParams extends Equatable {
  const CreateAddressParams({
    required this.input,
    this.cartFlow = false,
    this.cancelToken,
  });

  final AddressInput input;
  final bool cartFlow;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [input, cartFlow];
}
