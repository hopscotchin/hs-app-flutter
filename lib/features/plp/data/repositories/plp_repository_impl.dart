import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/listing_data_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/pincode_check_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/repositories/plp_repository.dart';
import '../datasources/remote/plp_api.dart';
import '../models/pincode_check_model.dart';

@LazySingleton(as: PlpRepository)
class PlpRepositoryImpl with SafeApiCall implements PlpRepository {
  PlpRepositoryImpl(this._api, this._networkInfo);

  final PlpApi _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ListingDataEntity>> getListingData({
    required PageType pageType,
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      // Search + Boutique share /search/product/v6 (matches Android, where
      // the autocomplete-driven PLP uses the same search endpoint). Regular
      // PLP uses /products/v8.
      final usesSearchEndpoint = pageType == PageType.boutique || pageType == PageType.search;
      final model = usesSearchEndpoint
          ? await _api.getBoutiqueProducts(queryParams: queryParams, cancelToken: cancelToken)
          : await _api.getPlpProducts(queryParams: queryParams, cancelToken: cancelToken);
      // The BFF returns HTTP 200 even for logical failures (`action: failure`).
      // Surface it through the normal error channel so the bloc can fall back
      // to the previously loaded content (or empty when there's nothing yet).
      if (model.isFailure) {
        final message = model.message;
        throw (message != null && message.isNotEmpty)
            ? ApiFailureException(message: message)
            : const ApiFailureException();
      }
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, PlpFilterEntity>> getFilterData({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final model = await _api.getFilterData(queryParams: queryParams, cancelToken: cancelToken);
      if (model.isFailure) {
        final message = model.message;
        throw (message != null && message.isNotEmpty)
            ? ApiFailureException(message: message)
            : const ApiFailureException();
      }
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, PincodeCheckEntity>> checkPincode({
    required String pincode,
    int productId = -1,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final model = await _api.checkPincode(
        pincode: pincode,
        productId: productId,
        cancelToken: cancelToken,
      );
      return model.toEntity();
    });
  }
}
