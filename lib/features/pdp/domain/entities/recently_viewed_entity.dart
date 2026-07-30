import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../plp/domain/entities/listing_product_entity.dart';

part 'recently_viewed_entity.freezed.dart';

@freezed
abstract class RecentlyViewedViewConfigEntity
    with _$RecentlyViewedViewConfigEntity {
  const factory RecentlyViewedViewConfigEntity({
    @Default(240.0) double tileWidth,
    @Default(214.0) double tileHeight,
    @Default(3) int minTilesToShow,
    @Default(4.0) double imageCornerRadius,
    @Default(false) bool navigation,
    @Default(false) bool snapping,
    @Default(false) bool showPageIndicators,
    @Default(0) int peepingFactor,
  }) = _RecentlyViewedViewConfigEntity;
}

@freezed
abstract class RecentlyViewedHeadingEntity with _$RecentlyViewedHeadingEntity {
  const factory RecentlyViewedHeadingEntity({
    String? url,
    int? width,
    int? height,
  }) = _RecentlyViewedHeadingEntity;
}

@freezed
abstract class RecentlyViewedMarginsEntity with _$RecentlyViewedMarginsEntity {
  const factory RecentlyViewedMarginsEntity({
    @Default(12.0) double top,
    @Default(12.0) double bottom,
    @Default(16.0) double horizontal,
    @Default(8.0) double innerHorizontalMargin,
    @Default(0.0) double titleBottomMargin,
    @Default(0.0) double titleHorizontalMargin,
  }) = _RecentlyViewedMarginsEntity;
}

@freezed
abstract class RecentlyViewedEntity with _$RecentlyViewedEntity {
  const factory RecentlyViewedEntity({
    RecentlyViewedViewConfigEntity? viewConfig,
    @Default([]) List<ListingProductEntity> tiles,
    RecentlyViewedHeadingEntity? heading,
    RecentlyViewedMarginsEntity? margins,
  }) = _RecentlyViewedEntity;
}
