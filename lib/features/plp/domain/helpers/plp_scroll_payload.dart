import '../entities/listing_product_entity.dart';

/// The half-open product range `[start, end)` a `plp_scrolled` event should
/// describe, and the de-duplicated attribute lists over it.
///
/// Split out of the tracker because this is where Android's index arithmetic
/// lives, and it is the part most likely to be got subtly wrong: the tracker
/// counts **rows**, the product list holds **items**, and the two-column grid
/// means one row is two products. Every `* 2` below is that conversion.
///
/// Ports `PLPAnalytics.setTrackingData` (`:658`) and `setTrackingDetail`
/// (`:673`).
class PlpScrollRange {
  const PlpScrollRange(this.start, this.end);

  final int start;
  final int end;

  bool get isEmpty => end <= start;

  @override
  String toString() => 'PlpScrollRange($start, $end)';

  @override
  bool operator ==(Object other) =>
      other is PlpScrollRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Resolves the row window `[startRow, endRow]` against a list of [itemCount]
/// products, reproducing Android's three branches verbatim:
///
/// ```kotlin
/// if (startingIndex == 0 && endingIndex == 0)      → (start, currentItemSize)
/// else if (endingIndex * 2 <= currentItemSize)     → (start == 1 ? 1 : start * 2, end * 2)
/// else if (endingIndex * 2 >= currentItemSize)     → (start, currentItemSize)
/// ```
///
/// The `start == 1 ? 1 : start * 2` special case is not a typo in the original:
/// row 1 maps to item 1, not item 2, so the first product of the list is not
/// skipped. [productsIn] then maps that 1 back to 0. The two together mean row
/// 1 yields items `[0, end*2)`, which is what Android ships.
PlpScrollRange plpScrollRange({
  required int startRow,
  required int endRow,
  required int itemCount,
}) {
  if (startRow == 0 && endRow == 0) {
    return PlpScrollRange(startRow, itemCount);
  }
  if (endRow * 2 <= itemCount) {
    return PlpScrollRange(startRow == 1 ? 1 : startRow * 2, endRow * 2);
  }
  return PlpScrollRange(startRow, itemCount);
}

/// Products inside [range], clamped to the list. Mirrors
/// `getTrackingData`'s `drop(startingIndex).take(end - startingIndex)`,
/// including its remapping of a start of 1 back to 0.
List<ListingProductEntity> productsIn(
  List<ListingProductEntity> products,
  PlpScrollRange range,
) {
  if (products.isEmpty) return const [];
  final start = (range.start == 1 ? 0 : range.start).clamp(0, products.length);
  final end = range.end.clamp(start, products.length);
  return products.sublist(start, end);
}

/// The seven viewed-range lists on `plp_scrolled`.
///
/// Each is a **de-duplicated set in first-seen order**, so the lists have
/// different lengths and are *not* positionally aligned with one another —
/// index 2 of `brand` has nothing to do with index 2 of `product_id`. Android
/// builds them as `Set`s for the same reason. Do not zip them downstream.
///
/// `category`, `subcategory`, `product_type` and `merch_type` are read from the
/// per-product `trackingMeta` blob because the listing response has no typed
/// fields for them. They stay empty until the backend adds those keys — and
/// because empty lists are dropped on the way out, the event simply omits them
/// rather than shipping `[]`.
class PlpScrollLists {
  const PlpScrollLists({
    required this.brand,
    required this.productIds,
    required this.xlProductIds,
    required this.category,
    required this.subCategory,
    required this.productType,
    required this.merchType,
  });

  final List<String> brand;
  final List<String> productIds;
  final List<String> xlProductIds;
  final List<String> category;
  final List<String> subCategory;
  final List<String> productType;
  final List<String> merchType;
}

/// Per-product `trackingMeta` keys the scroll lists read. Named here rather
/// than inline so the backend ask stays greppable from one place.
class ProductTrackingKeys {
  ProductTrackingKeys._();

  static const String category = 'category';
  static const String subCategory = 'subcategory';
  static const String productType = 'product_type';
  static const String merchType = 'merch_type';
}

PlpScrollLists plpScrollLists(List<ListingProductEntity> products) {
  final brand = <String>{};
  final productIds = <String>{};
  final xlProductIds = <String>{};
  final category = <String>{};
  final subCategory = <String>{};
  final productType = <String>{};
  final merchType = <String>{};

  for (final p in products) {
    final id = p.id.toString();
    productIds.add(id);
    if (p.isXLTile) xlProductIds.add(id);
    final brandName = p.brandName;
    if (brandName != null && brandName.isNotEmpty) brand.add(brandName);

    final meta = p.trackingMeta;
    if (meta == null) continue;
    _addIfString(category, meta[ProductTrackingKeys.category]);
    _addIfString(subCategory, meta[ProductTrackingKeys.subCategory]);
    _addIfString(productType, meta[ProductTrackingKeys.productType]);
    _addIfString(merchType, meta[ProductTrackingKeys.merchType]);
  }

  return PlpScrollLists(
    brand: brand.toList(),
    productIds: productIds.toList(),
    xlProductIds: xlProductIds.toList(),
    category: category.toList(),
    subCategory: subCategory.toList(),
    productType: productType.toList(),
    merchType: merchType.toList(),
  );
}

void _addIfString(Set<String> into, Object? value) {
  if (value is String && value.isNotEmpty) into.add(value);
}

/// `total_rows` — `((totalRecords + 1) / 2) + extraRowCount`, integer division,
/// matching `saveScrollMetaData` (`:634`). The `+ 1` rounds a trailing odd
/// product up to its own row.
int plpTotalRows({required int totalRecords, required int extraRowCount}) =>
    ((totalRecords + 1) ~/ 2) + extraRowCount;

/// Reference viewport width every scroll height is normalised against.
/// Android's `Constants.BASE_UNIT` (`:135`).
const int plpScrollBaseUnit = 375;

/// Normalises a row height into the width-independent unit `scrolled_height`
/// is reported in.
///
/// `scrolled_height` is **not** pixels. Android divides every row height by the
/// display width and rescales to a 375-wide reference viewport, so the figure
/// means "how many 375-unit-wide screenfuls deep did the user get" and is
/// comparable across devices:
///
/// ```java
/// // ProductsListingAdapter:151
/// viewHeight = ceil(BASE_UNIT * tileHeight * 1.0 / DefaultDisplay.displayWidth);
/// // ScrollTrackingHelper.getScaledHeight:28 — same ratio
/// ```
///
/// [rawHeight] and [displayWidth] only have to share a unit — the ratio cancels
/// it. Android feeds physical pixels; passing Flutter's logical pixels for both
/// yields the same number, so there is no `devicePixelRatio` to thread through.
///
/// Returns 0 rather than dividing by zero before the first layout, which the
/// caller then accumulates harmlessly.
int plpScaledRowHeight(double rawHeight, double displayWidth) {
  if (displayWidth <= 0 || rawHeight <= 0) return 0;
  return (plpScrollBaseUnit * rawHeight / displayWidth).ceil();
}
