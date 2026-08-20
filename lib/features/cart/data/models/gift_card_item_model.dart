import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/gift_card_item_entity.dart';
import 'cart_item_media_model.dart';

class GiftCardItemModel extends GiftCardItemEntity {
  const GiftCardItemModel({super.media, super.title, super.description});

  factory GiftCardItemModel.fromJson(Map<String, dynamic> json) {
    return GiftCardItemModel(
      media: CartItemMediaModel.listFromJson(json['media'] as List<dynamic>?),
      title: parseToStringOrNull(json['title']),
      description: parseToStringOrNull(json['description']),
    );
  }
}
