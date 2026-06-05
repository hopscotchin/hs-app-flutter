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
class UpdateAddressUseCase
    implements UseCase<AddressMutationResultEntity, UpdateAddressParams> {
  UpdateAddressUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, AddressMutationResultEntity>> call(
    UpdateAddressParams params,
  ) => _repository.updateAddress(
    addressId: params.addressId,
    input: params.input,
    cancelToken: params.cancelToken,
  );
}

class UpdateAddressParams extends Equatable {
  const UpdateAddressParams({
    required this.addressId,
    required this.input,
    this.cancelToken,
  });

  final int addressId;
  final AddressInput input;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [addressId, input];
}
