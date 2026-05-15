import 'package:equatable/equatable.dart';

import 'floating_filter_entity.dart';
import 'listing_product_entity.dart';

sealed class PlpListItem extends Equatable {
  const PlpListItem();
}

class ProductRowItem extends PlpListItem {
  final ListingProductEntity left;
  final ListingProductEntity? right;

  const ProductRowItem({required this.left, this.right});

  @override
  List<Object?> get props => [left, right];
}

class FloatingFilterItem extends PlpListItem {
  final FloatingFilterSectionEntity section;

  const FloatingFilterItem({required this.section});

  @override
  List<Object?> get props => [section];
}
