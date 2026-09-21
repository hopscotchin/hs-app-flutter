import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/utils/json_parsers.dart';
import '../../../../cart/data/models/cart_item_detail_model.dart';
import '../../../../pdp/data/models/media_model.dart';
import '../../../../plp/data/models/product_price_model.dart';
import '../../../domain/entities/listing/order_listing_record_entity.dart';
import '../common/order_status_model.dart';

part 'order_listing_record_model.g.dart';

/// One row of `records[]`, on either listing endpoint.
///
/// Ids are parsed with [parseToStringOrNull] rather than typed as `String`
/// outright: the suite has a long habit of sending one value three ways — v5
/// and v8 send `orderId` as a String at the root and an `int` inside the
/// shipment block, and `track/v3` sends an `int`. The v6 contract standardises
/// on String, and the parser makes a regression a non-event.
@JsonSerializable(createToJson: false)
class OrderListingRecordModel {
  const OrderListingRecordModel({
    this.orderId,
    this.orderItemId,
    this.actionUri,
    this.actionUriWeb,
    this.media,
    this.title,
    this.priceInfo,
    this.quantity,
    this.size,
    this.itemDetails,
    this.status,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? orderId;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? orderItemId;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? actionUri;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? actionUriWeb;

  @JsonKey(fromJson: _mediaFromJson)
  final MediaModel? media;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? title;

  @JsonKey(fromJson: _priceFromJson)
  final ProductPriceModel? priceInfo;

  @JsonKey(fromJson: parseToIntOrNull)
  final int? quantity;

  /// Absent on gift cards, free gifts, and One Size SKUs.
  @JsonKey(fromJson: parseToStringOrNull)
  final String? size;

  /// Reuses Cart's CartItemDetailModel — order details sends the identical
  /// block, so the two surfaces parse it the same way.
  @JsonKey(fromJson: _detailFromJson)
  final CartItemDetailModel? itemDetails;

  @JsonKey(fromJson: _statusFromJson)
  final OrderStatusModel? status;

  factory OrderListingRecordModel.fromJson(Map<String, dynamic> json) =>
      _$OrderListingRecordModelFromJson(json);
}

// Nested objects are decoded through guards rather than relying on automatic
// deserialization: a non-Map value — `null`, `""`, `false` — would otherwise
// throw mid-list and fail the whole page over one malformed row.
MediaModel? _mediaFromJson(Object? json) =>
    json is Map<String, dynamic> ? MediaModel.fromJson(json) : null;

ProductPriceModel? _priceFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductPriceModel.fromJson(json) : null;

CartItemDetailModel? _detailFromJson(Object? json) =>
    json is Map<String, dynamic> ? CartItemDetailModel.fromJson(json) : null;

OrderStatusModel? _statusFromJson(Object? json) =>
    json is Map<String, dynamic> ? OrderStatusModel.fromJson(json) : null;

extension OrderListingRecordModelX on OrderListingRecordModel {
  OrderListingRecordEntity toEntity() => OrderListingRecordEntity(
    orderId: orderId ?? '',
    orderItemId: orderItemId ?? '',
    actionUri: actionUri,
    actionUriWeb: actionUriWeb,
    media: media?.toEntity(),
    title: title,
    priceInfo: priceInfo?.toEntity(),
    quantity: quantity ?? 0,
    size: size,
    itemDetails: itemDetails,
    status: status?.toEntity(),
  );
}
