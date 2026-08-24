import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../domain/entities/promo_offers_source.dart';
import '../../models/promo_action_response_model.dart';
import '../../models/promo_apply_request_model.dart';
import '../../models/promo_details_response_model.dart';
import '../../models/promos_offers_response_model.dart';

part 'promos_offers_api.g.dart';

/// Typed HTTP surface for the promos & offers endpoints.
@RestApi()
@lazySingleton
abstract class PromosOffersApi {
  @factoryMethod
  factory PromosOffersApi(Dio dio) = _PromosOffersApi;

  /// Wire-level entry point — callers should use [PromosOffersApiX.getPromosOffersFrom]
  /// so the surface stays typed. [productId] is `0` for cart-level offers, the
  /// product id on PDP.
  @GET(ApiConstants.promosOffers)
  Future<PromosOffersResponseModel> getPromosOffers({
    @Query('fromLocation') String fromLocation = 'cart',
    @Query('productId') int productId = 0,
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Full promo detail (promo block + about + T&C + FAQs) behind the legacy
  /// `offerterms` path.
  @GET(ApiConstants.promoOfferTerms)
  Future<PromoDetailsResponseModel> getPromoDetails({
    @Path('promoId') required int promoId,
    @CancelRequest() CancelToken? cancelToken,
  });

  /// `fromLocation` tells BE which surface applied the code — the cart's own
  /// text field vs. an Apply tap in the offers sheet. Wire-level entry point;
  /// callers should use [PromosOffersApiX.applyPromoFrom] so the surface stays
  /// typed.
  @POST(ApiConstants.promoApply)
  Future<PromoActionResponseModel> applyPromo({
    @Body() required PromoApplyRequestModel request,
    @Query('fromLocation') String fromLocation = 'cart',
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE(ApiConstants.promoRemove)
  Future<PromoActionResponseModel> removePromo({
    @Query('promoCode') required String promoCode,
    @CancelRequest() CancelToken? cancelToken,
  });
}

extension PromosOffersApiX on PromosOffersApi {
  /// Maps the domain [PromoOffersSource] to the `fromLocation` wire value.
  Future<PromosOffersResponseModel> getPromosOffersFrom({
    PromoOffersSource fromLocation = PromoOffersSource.cart,
    int productId = 0,
    CancelToken? cancelToken,
  }) => getPromosOffers(
    fromLocation: fromLocation.wireValue,
    productId: productId,
    cancelToken: cancelToken,
  );

  /// Same mapping for apply. Retrofit would serialise a Dart enum via
  /// `toString()` ("PromoOffersSource.cart"), so the enum is unwrapped here
  /// rather than typed onto the generated method.
  Future<PromoActionResponseModel> applyPromoFrom({
    required PromoApplyRequestModel request,
    PromoOffersSource fromLocation = PromoOffersSource.cart,
    CancelToken? cancelToken,
  }) => applyPromo(
    request: request,
    fromLocation: fromLocation.wireValue,
    cancelToken: cancelToken,
  );
}
