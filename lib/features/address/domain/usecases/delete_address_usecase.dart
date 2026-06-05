import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/address_repository.dart';

@lazySingleton
class DeleteAddressUseCase implements UseCase<String, DeleteAddressParams> {
  DeleteAddressUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, String>> call(DeleteAddressParams params) =>
      _repository.deleteAddress(
        addressId: params.addressId,
        cancelToken: params.cancelToken,
      );
}

class DeleteAddressParams extends Equatable {
  const DeleteAddressParams({required this.addressId, this.cancelToken});

  final int addressId;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [addressId];
}
