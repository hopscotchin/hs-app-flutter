import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/backend_action_model.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/promo_action_result_entity.dart';

part 'promo_action_response_model.g.dart';

/// The outcome text, using the same precedence as
/// `ActionResponse.validate` — `message` → `errorMessage` → `errorMsg`.
///
/// Android types promo apply/remove as a plain `ActionResponse` and its failure
/// path (`PromosActivity.handlePromoCodeFailure`) reads `message`, never
/// `popUpMessage`. An earlier version of this read `popupMessage` first, which
/// was doubly wrong: the promo endpoints don't send it, and the envelope's
/// field is `popUpMessage` (capital U) so the key never matched regardless.
Object? _readMessage(Map<dynamic, dynamic> json, String key) =>
    json['message'] ?? json['errorMessage'] ?? json['errorMsg'];

/// Some endpoints in this API report status as `{"action": "success"}` rather
/// than a `success` boolean — treat either as the outcome, or a successful
/// remove reads as a failure and shows the fallback error.
Object? _readSuccess(Map<dynamic, dynamic> json, String key) =>
    json['success'] ?? (json['action'] == 'success');

/// Both message-bar keys folded into one list, `messageBar` first — the same
/// order `ActionResponse.validate` uses, so a failure surfaced through either
/// route reads identically.
Object? _readMessageBars(Map<dynamic, dynamic> json, String key) {
  final bars = <dynamic>[];
  final single = json['messageBar'];
  if (single is Map) bars.add(single);
  final many = json['messageBars'];
  if (many is List) bars.addAll(many);
  return bars;
}

/// Response for `POST /v3/promotion/apply` and
/// `DELETE /v3/promotion/remove`. Both return the same status envelope.
@JsonSerializable(createToJson: false)
class PromoActionResponseModel {
  const PromoActionResponseModel({
    this.success = false,
    this.message = '',
    this.promoCode = '',
    this.bottomSheet,
    this.rawMessageBars = const [],
  });

  @JsonKey(name: 'success', readValue: _readSuccess, defaultValue: false)
  final bool success;
  @JsonKey(name: 'message', readValue: _readMessage, defaultValue: '')
  final String message;
  @JsonKey(name: 'promoCode', defaultValue: '')
  final String promoCode;

  /// Held raw: the sheet payload is the same `{title, description, leftAction,
  /// rightAction}` shape `BackendActionContentModel` already parses (including
  /// mapping each button's `action` to `actionUrl`), and that model is
  /// hand-rolled rather than json_serializable, so [toEntity] converts it.
  @JsonKey(name: 'bottomSheet')
  final Map<String, dynamic>? bottomSheet;

  /// Raw for the same reason as [bottomSheet] — mapped in [toEntity].
  @JsonKey(name: 'messageBars', readValue: _readMessageBars, defaultValue: [])
  final List<dynamic> rawMessageBars;

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
    messageBars: rawMessageBars
        .whereType<Map<String, dynamic>>()
        .map(MessageBarModel.fromJson)
        .toList(),
  );
}