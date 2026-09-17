import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';

part 'remove_from_wishlist_response_model.g.dart';

/// Response of `DELETE /v2/wishlist/{wishlistItemId}`:
/// `{"action": "success", "popUpMessage": "Product has been removed from your wishlist"}`.
///
/// [popUpMessage] is shown verbatim in the toast on both success and failure.
@JsonSerializable(createToJson: false)
class RemoveFromWishlistResponseModel {
  const RemoveFromWishlistResponseModel({this.action, this.popUpMessage});

  @JsonKey(fromJson: parseToStringOrNull)
  final String? action;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? popUpMessage;

  factory RemoveFromWishlistResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RemoveFromWishlistResponseModelFromJson(json);
}

extension RemoveFromWishlistResponseModelX on RemoveFromWishlistResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';

  /// Message the API sent, or null when it was blank.
  String? get message =>
      (popUpMessage?.isNotEmpty ?? false) ? popUpMessage : null;
}
