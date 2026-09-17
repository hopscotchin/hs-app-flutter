import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/move_to_cart_result_entity.dart';

part 'move_to_cart_response_model.g.dart';

/// Response of `POST /v2/wishlist/move-to-cart`:
/// `{"action": "success", "cartItemQty": 3}`.
///
/// On failure the API returns a non-success `action` plus a `popUpMessage`
/// to surface verbatim; [failureMessage] resolves what to show.
@JsonSerializable(createToJson: false)
class MoveToCartResponseModel {
  const MoveToCartResponseModel({
    this.action,
    this.cartItemQty,
    this.popUpMessage,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? action;

  @JsonKey(fromJson: parseToIntOrNull)
  final int? cartItemQty;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? popUpMessage;

  factory MoveToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoveToCartResponseModelFromJson(json);
}

extension MoveToCartResponseModelX on MoveToCartResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';

  /// Message for a failed move: whatever the API sent, else a generic line.
  String? get failureMessage =>
      (popUpMessage?.isNotEmpty ?? false) ? popUpMessage : null;

  MoveToCartResultEntity toEntity() =>
      MoveToCartResultEntity(cartItemQty: cartItemQty);
}
