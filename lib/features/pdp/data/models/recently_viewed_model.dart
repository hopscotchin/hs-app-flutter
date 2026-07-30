import 'package:json_annotation/json_annotation.dart';

import '../../../plp/data/models/listing_product_model.dart';
import '../../domain/entities/recently_viewed_entity.dart';

part 'recently_viewed_model.g.dart';

@JsonSerializable(createToJson: false)
class ViewConfigModel {
  const ViewConfigModel({
    this.tileWidth = 240.0,
    this.tileHeight = 214.0,
    this.minTilesToShow = 3,
    this.imageCornerRadius = 4.0,
    this.navigation = false,
    this.snapping = false,
    this.showPageIndicators = false,
    this.peepingFactor = 0,
  });

  @JsonKey(defaultValue: 240.0)
  final double tileWidth;
  @JsonKey(defaultValue: 214.0)
  final double tileHeight;
  @JsonKey(defaultValue: 3)
  final int minTilesToShow;
  @JsonKey(defaultValue: 4.0)
  final double imageCornerRadius;
  @JsonKey(defaultValue: false)
  final bool navigation;
  @JsonKey(defaultValue: false)
  final bool snapping;
  @JsonKey(defaultValue: false)
  final bool showPageIndicators;
  @JsonKey(defaultValue: 0)
  final int peepingFactor;

  factory ViewConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ViewConfigModelFromJson(json);
}

extension ViewConfigModelX on ViewConfigModel {
  RecentlyViewedViewConfigEntity toEntity() => RecentlyViewedViewConfigEntity(
    tileWidth: tileWidth,
    tileHeight: tileHeight,
    minTilesToShow: minTilesToShow,
    imageCornerRadius: imageCornerRadius,
    navigation: navigation,
    snapping: snapping,
    showPageIndicators: showPageIndicators,
    peepingFactor: peepingFactor,
  );
}

@JsonSerializable(createToJson: false)
class RecentlyViewedHeadingModel {
  const RecentlyViewedHeadingModel({this.url, this.width, this.height});

  @JsonKey(defaultValue: null)
  final String? url;
  @JsonKey(defaultValue: null)
  final int? width;
  @JsonKey(defaultValue: null)
  final int? height;

  factory RecentlyViewedHeadingModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyViewedHeadingModelFromJson(json);
}

extension RecentlyViewedHeadingModelX on RecentlyViewedHeadingModel {
  RecentlyViewedHeadingEntity toEntity() =>
      RecentlyViewedHeadingEntity(url: url, width: width, height: height);
}

@JsonSerializable(createToJson: false)
class RecentlyViewedMarginsModel {
  const RecentlyViewedMarginsModel({
    this.top = 12.0,
    this.bottom = 12.0,
    this.horizontal = 16.0,
    this.innerHorizontalMargin = 8.0,
    this.titleBottomMargin = 0.0,
    this.titleHorizontalMargin = 0.0,
  });

  @JsonKey(defaultValue: 12.0)
  final double top;
  @JsonKey(defaultValue: 12.0)
  final double bottom;
  @JsonKey(defaultValue: 16.0)
  final double horizontal;
  @JsonKey(defaultValue: 8.0)
  final double innerHorizontalMargin;
  @JsonKey(defaultValue: 0.0)
  final double titleBottomMargin;
  @JsonKey(defaultValue: 0.0)
  final double titleHorizontalMargin;

  factory RecentlyViewedMarginsModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyViewedMarginsModelFromJson(json);
}

extension RecentlyViewedMarginsModelX on RecentlyViewedMarginsModel {
  RecentlyViewedMarginsEntity toEntity() => RecentlyViewedMarginsEntity(
    top: top,
    bottom: bottom,
    horizontal: horizontal,
    innerHorizontalMargin: innerHorizontalMargin,
    titleBottomMargin: titleBottomMargin,
    titleHorizontalMargin: titleHorizontalMargin,
  );
}

@JsonSerializable(createToJson: false)
class RecentlyViewedTileModel {
  const RecentlyViewedTileModel({this.product});

  @JsonKey(defaultValue: null, fromJson: _productFromJson)
  final ListingProductModel? product;

  factory RecentlyViewedTileModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyViewedTileModelFromJson(json);
}

ListingProductModel? _productFromJson(Object? json) =>
    json is Map<String, dynamic> ? ListingProductModel.fromJson(json) : null;

@JsonSerializable(createToJson: false)
class RecentlyViewedModel {
  const RecentlyViewedModel({
    this.viewConfig,
    this.tiles = const [],
    this.heading,
    this.margins,
  });

  @JsonKey(defaultValue: null, fromJson: _viewConfigFromJson)
  final ViewConfigModel? viewConfig;

  @JsonKey(defaultValue: [])
  final List<RecentlyViewedTileModel> tiles;

  @JsonKey(name: 'heading', defaultValue: null, fromJson: _headingFromJson)
  final RecentlyViewedHeadingModel? heading;

  @JsonKey(defaultValue: null, fromJson: _marginsFromJson)
  final RecentlyViewedMarginsModel? margins;

  factory RecentlyViewedModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyViewedModelFromJson(json);
}

ViewConfigModel? _viewConfigFromJson(Object? json) =>
    json is Map<String, dynamic> ? ViewConfigModel.fromJson(json) : null;

RecentlyViewedHeadingModel? _headingFromJson(Object? json) =>
    json is Map<String, dynamic>
    ? RecentlyViewedHeadingModel.fromJson(json)
    : null;

RecentlyViewedMarginsModel? _marginsFromJson(Object? json) =>
    json is Map<String, dynamic>
    ? RecentlyViewedMarginsModel.fromJson(json)
    : null;

extension RecentlyViewedModelX on RecentlyViewedModel {
  RecentlyViewedEntity toEntity() => RecentlyViewedEntity(
    viewConfig: viewConfig?.toEntity(),
    tiles: tiles
        .where((t) => t.product != null)
        .map((t) => t.product!.toEntity())
        .toList(),
    heading: heading?.toEntity(),
    margins: margins?.toEntity(),
  );
}
