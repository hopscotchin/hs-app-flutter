import 'package:json_annotation/json_annotation.dart';

part 'wishlist_info_model.g.dart';

@JsonSerializable(createToJson: false)
class WishlistInfoModel {
  const WishlistInfoModel({this.id, this.isWishlisted = false, this.canWishlist = false});

  final int? id;
  @JsonKey(defaultValue: false)
  final bool isWishlisted;
  @JsonKey(defaultValue: false)
  final bool canWishlist;

  factory WishlistInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistInfoModelFromJson(json);
}
