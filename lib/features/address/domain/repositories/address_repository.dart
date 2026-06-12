import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/address_input.dart';
import '../entities/address_mutation_result_entity.dart';
import '../entities/address_source.dart';
import '../entities/addresses_list_entity.dart';
import '../entities/pincode_info_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, AddressesListEntity>> getAddresses({
    AddressSource source = AddressSource.delivery,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, AddressMutationResultEntity>> createAddress({
    required AddressInput input,
    bool cartFlow = false,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, AddressMutationResultEntity>> updateAddress({
    required int addressId,
    required AddressInput input,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> deleteAddress({
    required int addressId,
    CancelToken? cancelToken,
  });

  /// Look up a pincode. When [exchangeFlow] is true, hits the exchange
  /// variant with a `deliveryAction` query param.
  Future<Either<Failure, PincodeInfoEntity>> checkPincode({
    required String pincode,
    bool exchangeFlow = false,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, AddressMutationResultEntity>> selectAddress({
    required int addressId,
    CancelToken? cancelToken,
  });
}
