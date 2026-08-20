import 'package:equatable/equatable.dart';

import 'cart_item_media_entity.dart';

/// A free-gift promo banner shown in the cart (e.g. "Your free gift —
/// Travel-Friendly Coloring Book + Crayons").
class GiftCardItemEntity extends Equatable {
  final List<CartItemMediaEntity> media;
  final String? title;
  final String? description;

  const GiftCardItemEntity({
    this.media = const [],
    this.title,
    this.description,
  });

  String? get imgSrc => media.isEmpty ? null : media.first.url;

  @override
  List<Object?> get props => [media, title, description];
}
