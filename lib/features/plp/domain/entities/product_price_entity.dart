import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_price_entity.freezed.dart';

@freezed
abstract class ProductPriceEntity with _$ProductPriceEntity {
  const factory ProductPriceEntity({
    String? sellingPrice,
    String? mrp,
    String? discountLabel,
    double? absoluteValue,
    String? callout,
  }) = _ProductPriceEntity;
}

extension ProductPriceEntityX on ProductPriceEntity {
  bool get hasDiscount => discountLabel != null && discountLabel!.isNotEmpty;
  bool get hasCallout => callout != null && callout!.isNotEmpty;
}
