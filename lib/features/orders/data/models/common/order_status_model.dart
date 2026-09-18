import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/backend_action_model.dart';
import '../../../../../core/utils/json_parsers.dart';
import '../../../domain/entities/common/order_status_entity.dart';

part 'order_status_model.g.dart';

/// `status` on a listing record or an order-details item —
/// `{icon, title, subtitle, action}`.
///
/// Resolved strings plus an optional link. No colour field and no status code:
/// the redesign paints every status in one neutral token pair, and nothing on
/// the client branches on a machine value. See [OrderStatusEntity].
@JsonSerializable(createToJson: false)
class OrderStatusModel {
  const OrderStatusModel({this.icon, this.title, this.subtitle, this.action});

  /// An SVG URL. Rendered through `CustomImage`, which handles SVG where
  /// `CachedImageWidget` does not.
  @JsonKey(fromJson: parseToStringOrNull)
  final String? icon;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? title;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? subtitle;

  /// Order details only — the inline "· Track" link. Absent on the listing.
  @JsonKey(fromJson: _actionFromJson)
  final BackendActionButtonModel? action;

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusModelFromJson(json);
}

/// Decoded through a guard rather than automatic deserialization, so a non-Map
/// value cannot throw and take the whole page down over one link.
BackendActionButtonModel? _actionFromJson(Object? json) =>
    json is Map<String, dynamic>
    ? BackendActionButtonModel.fromJson(json)
    : null;

extension OrderStatusModelX on OrderStatusModel {
  OrderStatusEntity toEntity() => OrderStatusEntity(
    icon: icon,
    title: title,
    subtitle: subtitle,
    action: action,
  );
}
