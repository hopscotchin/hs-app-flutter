import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address_mutation_result_entity.dart';
import '../repositories/address_repository.dart';

@lazySingleton
class SelectAddressUseCase
    implements UseCase<AddressMutationResultEntity, SelectAddressParams> {
  SelectAddressUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, AddressMutationResultEntity>> call(
    SelectAddressParams params,
  ) => _repository.selectAddress(
    addressId: params.addressId,
    cancelToken: params.cancelToken,
  );
}

class SelectAddressParams extends Equatable {
  const SelectAddressParams({required this.addressId, this.cancelToken});

  final int addressId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [addressId];
}
