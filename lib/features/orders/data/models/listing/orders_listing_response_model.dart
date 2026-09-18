import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/utils/json_parsers.dart';
import '../../../../plp/data/models/notification_nudge_model.dart';
import '../../../../plp/data/models/page_meta_model.dart';
import '../../../domain/entities/listing/orders_listing_entity.dart';
import '../common/empty_state_model.dart';
import '../common/support_section_model.dart';
import 'order_listing_record_model.dart';

part 'orders_listing_response_model.g.dart';

/// The root envelope for both listing endpoints.
///
/// Mirrors PLP's `ListingDataModel` — same `action` / `message` / `pageMeta` /
/// `trackingMeta` / `notificationNudge` / `records[]` spine — because the two
/// screens are the same kind of thing and there is no reason for them to differ.
@JsonSerializable(createToJson: false)
class OrdersListingResponseModel {
  const OrdersListingResponseModel({
    this.action,
    this.message,
    this.pageMeta,
    this.emptyState,
    this.notificationNudge,
    this.support,
    this.trackingMeta,
    this.records = const [],
  });

  /// `"success"` on the happy path. The BFF returns HTTP 200 even for logical
  /// failures, signalling them here with a human-readable [message] — so this
  /// field is the only thing standing between an error response and a screen
  /// that says "no orders". See [isFailure].
  @JsonKey(fromJson: parseToStringOrNull)
  final String? action;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? message;

  @JsonKey(fromJson: _pageMetaFromJson)
  final PageMetaModel? pageMeta;

  @JsonKey(fromJson: _emptyStateFromJson)
  final EmptyStateModel? emptyState;

  /// Orders tab only.
  @JsonKey(fromJson: _nudgeFromJson)
  final NotificationNudgeModel? notificationNudge;

  /// Orders tab only.
  @JsonKey(fromJson: _supportFromJson)
  final SupportSectionModel? support;

  /// Forwarded to Segment whole. Never read a key out of it.
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? trackingMeta;

  @JsonKey(defaultValue: <OrderListingRecordModel>[])
  final List<OrderListingRecordModel> records;

  factory OrdersListingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersListingResponseModelFromJson(json);

  /// True for anything that is not an explicit success.
  ///
  /// Tests `!= 'success'` rather than `== 'failure'`: the captured responses
  /// use `"action":"error"`, and PLP's `== 'failure'` check would wave that
  /// through. Absent `action` is treated as success — some endpoints omit it
  /// on the happy path.
  bool get isFailure => action != null && action!.toLowerCase() != 'success';
}

// Every nested object is decoded through a guard rather than automatic
// deserialization, so a non-Map value cannot throw and take down the page.
PageMetaModel? _pageMetaFromJson(Object? json) =>
    json is Map<String, dynamic> ? PageMetaModel.fromJson(json) : null;

EmptyStateModel? _emptyStateFromJson(Object? json) =>
    json is Map<String, dynamic> ? EmptyStateModel.fromJson(json) : null;

NotificationNudgeModel? _nudgeFromJson(Object? json) =>
    json is Map<String, dynamic> ? NotificationNudgeModel.fromJson(json) : null;

SupportSectionModel? _supportFromJson(Object? json) =>
    json is Map<String, dynamic> ? SupportSectionModel.fromJson(json) : null;

extension OrdersListingResponseModelX on OrdersListingResponseModel {
  OrdersListingEntity toEntity() => OrdersListingEntity(
    records: records.map((r) => r.toEntity()).toList(growable: false),
    pageMeta: pageMeta?.toEntity(),
    emptyState: emptyState?.toEntity(),
    notificationNudge: notificationNudge?.toEntity(),
    support: support?.toEntity(),
    // Collapse an empty map to null so the analytics layer can treat "no node"
    // as one case — the same treatment ProductModel gives PDP's blob.
    trackingMeta: (trackingMeta?.isEmpty ?? true) ? null : trackingMeta,
  );
}
