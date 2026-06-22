import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/models/visual_cue_model.dart';
import '../../domain/entities/listing_product_entity.dart';
import 'media_item_model.dart';
import 'product_price_model.dart';
import 'wishlist_info_model.dart';

part 'listing_product_model.g.dart';

@JsonSerializable(createToJson: false)
class ListingProductModel {
  const ListingProductModel({
    required this.id,
    required this.name,
    this.brandName,
    this.quantity = 0,
    this.soldOut = false,
    this.isXLTile = false,
    this.isCPT = false,
    this.wishlistInfo,
    this.media = const [],
    this.priceInfo,
    this.colorVariants,
    this.actionUri,
    this.visualCue,
    this.trackingMeta,
  });

  final int id;
  final String name;
  final String? brandName;
  @JsonKey(defaultValue: 0)
  final int quantity;
  @JsonKey(defaultValue: false)
  final bool soldOut;
  @JsonKey(defaultValue: false)
  final bool isXLTile;
  @JsonKey(defaultValue: false)
  final bool isCPT;

  final WishlistInfoModel? wishlistInfo;

  @JsonKey(defaultValue: [])
  final List<MediaItemModel> media;

  final ProductPriceModel? priceInfo;

  final String? colorVariants;
  final String? actionUri;

  @JsonKey(name: 'visualCue')
  final Map<String, dynamic>? visualCue;

  final Map<String, dynamic>? trackingMeta;

  factory ListingProductModel.fromJson(Map<String, dynamic> json) =>
      _$ListingProductModelFromJson(json);

  ListingProductEntity toEntity() {
    final imageUrls = media
        .where((m) => m.isImage && (m.url?.isNotEmpty ?? false))
        .map((m) => m.url!)
        .toList(growable: false);

    final cue = (visualCue == null || visualCue!.isEmpty)
        ? null
        : VisualCueModel.fromJson(visualCue!);
    final cues = cue == null ? const <VisualCueEntity>[] : <VisualCueEntity>[cue];

    return ListingProductEntity(
      id: id,
      name: name,
      brandName: brandName,
      isWishlisted: wishlistInfo?.isWishlisted ?? false,
      canWishlist: wishlistInfo?.canWishlist ?? false,
      wishlistId: wishlistInfo?.id?.toString(),
      quantity: quantity,
      soldOut: soldOut,
      isXLTile: isXLTile,
      isCPT: isCPT,
      imageUrls: imageUrls,
      price: priceInfo?.toEntity(),
      colorVariants: _normalizeColorVariantsLabel(colorVariants),
      actionUri: actionUri,
      visualCues: cues,
      trackingMeta: trackingMeta,
    );
  }
}

String? _normalizeColorVariantsLabel(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  if (!trimmed.contains('Variant(')) return trimmed;
  final count = RegExp(r'Variant\(').allMatches(trimmed).length;
  return count > 0 ? '+$count Colors' : null;
}
