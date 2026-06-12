import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/address_mutation_response_model.dart';
import '../../models/addresses_response_model.dart';
import '../../models/delete_address_response_model.dart';
import '../../models/pincode_response_model.dart';

part 'address_remote_datasource.g.dart';

@RestApi()
@lazySingleton
abstract class AddressRemoteDatasource {
  @factoryMethod
  factory AddressRemoteDatasource(Dio dio) = _AddressRemoteDatasource;

  /// `/customer/v2/addresses`.
  @GET(ApiConstants.customerAddresses)
  Future<AddressesResponseModel> getCustomerAddresses({
    @CancelRequest() CancelToken? cancelToken,
  });

  /// `/delivery/addresses/v3`.
  @GET(ApiConstants.addresses)
  Future<AddressesResponseModel> getDeliveryAddresses({
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.createAddress)
  Future<AddressMutationResponseModel> createAddress({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST(ApiConstants.createAddressCart)
  Future<AddressMutationResponseModel> createAddressCart({
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @PUT(ApiConstants.updateAddress)
  Future<AddressMutationResponseModel> updateAddress({
    @Path('addressId') required int addressId,
    @Body() required Map<String, dynamic> body,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE(ApiConstants.deleteAddress)
  Future<DeleteAddressResponseModel> deleteAddress({
    @Path('addressId') required int addressId,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET(ApiConstants.checkPincode)
  Future<PincodeResponseModel> checkPincode({
    @Path('pincode') required String pincode,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET(ApiConstants.checkPincodeExchange)
  Future<PincodeResponseModel> checkPincodeExchange({
    @Path('pincode') required String pincode,
    @Queries() Map<String, dynamic> queries = const {},
    @CancelRequest() CancelToken? cancelToken,
  });

  @PUT(ApiConstants.selectAddress)
  Future<AddressMutationResponseModel> selectAddress({
    @Path('addressId') required int addressId,
    @CancelRequest() CancelToken? cancelToken,
  });
}
