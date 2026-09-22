import 'package:equatable/equatable.dart';

import 'cart_item_media_entity.dart';

/// A free-gift promo banner shown in the cart (e.g. "Your free gift —
/// Travel-Friendly Coloring Book + Crayons").
class GiftCardItemEntity extends Equatable {
  final List<CartItemMediaEntity> media;
  final String? title;
  final String? description;

  /// Analytics-only metadata — sent verbatim to tracking, never parsed or
  /// rendered. Raw JSON like the cart's and each item's blocks, so a new
  /// backend field needs no app release.
  ///
  /// Empty (`{}`) in the responses seen so far, which the `putAnalyticsKey`
  /// filter drops, so nothing reaches the wire until the backend fills it.
  final Map<String, dynamic>? trackingMeta;

  const GiftCardItemEntity({
    this.media = const [],
    this.title,
    this.description,
    this.trackingMeta,
  });

  String? get imgSrc => media.isEmpty ? null : media.first.url;

  @override
  List<Object?> get props => [media, title, description, trackingMeta];
}
