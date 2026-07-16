import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/wishlist_response_entity.dart';

part 'wishlist_response_model.g.dart';

@JsonSerializable(createToJson: false)
class WishlistResponseModel {
  const WishlistResponseModel({this.action, this.message, this.wishlistItemId});

  @JsonKey(defaultValue: null) final String? action;
  @JsonKey(defaultValue: null) final String? message;
  @JsonKey(defaultValue: null, fromJson: parseToStringOrNull) final String? wishlistItemId;

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistResponseModelFromJson(json);
}

extension WishlistResponseModelX on WishlistResponseModel {
  WishlistResponseEntity toEntity() => WishlistResponseEntity(
    action: action,
    message: message,
    wishlistItemId: wishlistItemId,
  );
}
