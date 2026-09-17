import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/wishlist_info_entity.dart';

part 'wishlist_info_model.g.dart';

@JsonSerializable(createToJson: false)
class WishlistInfoModel {
  const WishlistInfoModel({this.id, this.isWishlisted = false, this.canWishlist = false, this.trackingMeta});

  @JsonKey(fromJson: parseToIntOrNull)
  final int? id;
  @JsonKey(fromJson: parseToBool)
  final bool isWishlisted;
  @JsonKey(fromJson: parseToBool)
  final bool canWishlist;
  final Map<String, dynamic>? trackingMeta;

  factory WishlistInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistInfoModelFromJson(json);

  WishlistInfoEntity toEntity() =>
      WishlistInfoEntity(id: id, isWishlisted: isWishlisted, canWishlist: canWishlist, trackingMeta: trackingMeta);
}
