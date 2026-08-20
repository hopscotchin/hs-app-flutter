import 'package:json_annotation/json_annotation.dart';

part 'promo_apply_request_model.g.dart';

/// Request body for `POST /v3/promotion/apply`. Serialized (not parsed), so
/// this is the one model in the feature that keeps `toJson`.
@JsonSerializable(createFactory: false)
class PromoApplyRequestModel {
  const PromoApplyRequestModel({required this.promoCode});

  @JsonKey(name: 'promoCode')
  final String promoCode;

  Map<String, dynamic> toJson() => _$PromoApplyRequestModelToJson(this);
}