import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/add_to_cart_response_entity.dart';
import '../repositories/cart_repository.dart';

@lazySingleton
class AddToCartUseCase
    implements UseCase<AddToCartResponseEntity, AddToCartParams> {
  final CartRepository repository;
  final AnalyticsHelper analyticsHelper;

  AddToCartUseCase(this.repository, this.analyticsHelper);

  @override
  Future<Either<Failure, AddToCartResponseEntity>> call(
    AddToCartParams params,
  ) {
    // Assemble the request body once. Caller's per-item tracking (PDP-owned
    // slice) then the funnel-level order attribution merged on top —
    // attribution wins on collision, since the funnel context is the source
    // of truth for anything that reappears on `product_ordered` at order time.
    final body = <String, Object?>{
      'sku': params.skuId,
      'quantity': '${params.quantity}',
      ...params.trackingParams,
      ...analyticsHelper.orderAttribution.segmentParams,
      ...analyticsHelper.lpAttribution.segmentParams,
      ...analyticsHelper.productAttribution.segmentParams,
    };
    if (params.fromBuyNow) {
      return repository.buyNow(body);
    }
    return repository.addToCart(body);
  }
}

class AddToCartParams extends Equatable {
  final String skuId;
  final int quantity;
  final bool fromBuyNow;

  /// Per-item tracking the caller assembles (e.g. PDP's `product.trackingMeta`
  /// slice). Forwarded to the ATC request body verbatim after being merged
  /// with `OrderAttributionHelper.segmentParams` inside the use case.
  final Map<String, Object?> trackingParams;

  const AddToCartParams({
    required this.skuId,
    this.quantity = 1,
    this.fromBuyNow = false,
    this.trackingParams = const <String, Object?>{},
  });

  @override
  List<Object?> get props => [skuId, quantity, fromBuyNow, trackingParams];
}
