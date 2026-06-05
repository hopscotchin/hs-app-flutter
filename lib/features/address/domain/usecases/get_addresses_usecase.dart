import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/addresses_list_entity.dart';
import '../repositories/address_repository.dart';

@lazySingleton
class GetAddressesUseCase
    implements UseCase<AddressesListEntity, GetAddressesParams> {
  GetAddressesUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, AddressesListEntity>> call(
    GetAddressesParams params,
  ) => _repository.getAddresses(cancelToken: params.cancelToken);
}

class GetAddressesParams extends Equatable {
  const GetAddressesParams({this.cancelToken});

  final CancelToken? cancelToken;

  @override
  List<Object?> get props => const [];
}
