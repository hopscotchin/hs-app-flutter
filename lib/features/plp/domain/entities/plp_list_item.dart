import 'package:freezed_annotation/freezed_annotation.dart';

import 'floating_filter_entity.dart';
import 'listing_product_entity.dart';

part 'plp_list_item.freezed.dart';

@freezed
sealed class PlpListItem with _$PlpListItem {
  const factory PlpListItem.productRow({
    required ListingProductEntity left,
    ListingProductEntity? right,
  }) = ProductRowItem;

  const factory PlpListItem.productXL({
    required ListingProductEntity product,
  }) = ProductXLItem;

  const factory PlpListItem.floatingFilter({
    required FloatingFilterSectionEntity section,
  }) = FloatingFilterItem;
}
