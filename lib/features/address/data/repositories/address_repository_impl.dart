import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/address_input.dart';
import '../../domain/entities/address_mutation_result_entity.dart';
import '../../domain/entities/address_source.dart';
import '../../domain/entities/addresses_list_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/remote/address_remote_datasource.dart';
import '../models/address_mutation_response_model.dart';
import '../models/addresses_response_model.dart';
import '../models/pincode_response_model.dart';

@LazySingleton(as: AddressRepository)
class AddressRepositoryImpl with SafeApiCall implements AddressRepository {
  AddressRepositoryImpl(this._remoteDatasource, this._networkInfo);

  final AddressRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, AddressesListEntity>> getAddresses({
    AddressSource source = AddressSource.delivery,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = switch (source) {
        AddressSource.delivery => await _remoteDatasource.getDeliveryAddresses(
            cancelToken: cancelToken,
          ),
        AddressSource.customer => await _remoteDatasource.getCustomerAddresses(
            cancelToken: cancelToken,
          ),
      };
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, AddressMutationResultEntity>> createAddress({
    required AddressInput input,
    bool cartFlow = false,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = cartFlow
          ? await _remoteDatasource.createAddressCart(
              body: input.toJson(),
              cancelToken: cancelToken,
            )
          : await _remoteDatasource.createAddress(
              body: input.toJson(),
              cancelToken: cancelToken,
            );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, AddressMutationResultEntity>> updateAddress({
    required int addressId,
    required AddressInput input,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _remoteDatasource.updateAddress(
        addressId: addressId,
        body: input.toJson(),
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> deleteAddress({
    required int addressId,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _remoteDatasource.deleteAddress(
        addressId: addressId,
        cancelToken: cancelToken,
      );
      return response.popUpMessage;
    });
  }

  @override
  Future<Either<Failure, PincodeInfoEntity>> checkPincode({
    required String pincode,
    bool exchangeFlow = false,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = exchangeFlow
          ? await _remoteDatasource.checkPincodeExchange(
              pincode: pincode,
              queries: const {'deliveryAction': 'EXCHANGE'},
              cancelToken: cancelToken,
            )
          : await _remoteDatasource.checkPincode(
              pincode: pincode,
              cancelToken: cancelToken,
            );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, AddressMutationResultEntity>> selectAddress({
    required int addressId,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _remoteDatasource.selectAddress(
        addressId: addressId,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }
}
