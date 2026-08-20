import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/backend_action_model.dart';
import '../../domain/entities/promo_action_result_entity.dart';

part 'promo_action_response_model.g.dart';

/// The toast text. Remove sends it as `popupMessage`; `message` is kept as a
/// fallback so an apply/remove that uses the plainer key still surfaces.
Object? _readMessage(Map<dynamic, dynamic> json, String key) =>
    json['popupMessage'] ?? json['message'];

/// Some endpoints in this API report status as `{"action": "success"}` rather
/// than a `success` boolean — treat either as the outcome, or a successful
/// remove reads as a failure and shows the fallback error.
Object? _readSuccess(Map<dynamic, dynamic> json, String key) =>
    json['success'] ?? (json['action'] == 'success');

/// Response for `POST /v3/promotion/apply` and
/// `DELETE /v3/promotion/remove`. Both return the same status envelope.
@JsonSerializable(createToJson: false)
class PromoActionResponseModel {
  const PromoActionResponseModel({
    this.success = false,
    this.message = '',
    this.promoCode = '',
    this.bottomSheet,
  });

  @JsonKey(name: 'success', readValue: _readSuccess, defaultValue: false)
  final bool success;
  @JsonKey(name: 'popupMessage', readValue: _readMessage, defaultValue: '')
  final String message;
  @JsonKey(name: 'promoCode', defaultValue: '')
  final String promoCode;

  /// Held raw: the sheet payload is the same `{title, description, leftAction,
  /// rightAction}` shape `BackendActionContentModel` already parses (including
  /// mapping each button's `action` to `actionUrl`), and that model is
  /// hand-rolled rather than json_serializable, so [toEntity] converts it.
  @JsonKey(name: 'bottomSheet')
  final Map<String, dynamic>? bottomSheet;

  factory PromoActionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PromoActionResponseModelFromJson(json);
}

extension PromoActionResponseModelX on PromoActionResponseModel {
  PromoActionResultEntity toEntity() => PromoActionResultEntity(
    success: success,
    message: message,
    promoCode: promoCode,
    bottomSheet: bottomSheet == null
        ? null
        : BackendActionContentModel.fromJson(bottomSheet!),
  );
}