// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_viewed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewConfigModel _$ViewConfigModelFromJson(Map<String, dynamic> json) =>
    ViewConfigModel(
      tileWidth: (json['tileWidth'] as num?)?.toDouble() ?? 240.0,
      tileHeight: (json['tileHeight'] as num?)?.toDouble() ?? 214.0,
      minTilesToShow: (json['minTilesToShow'] as num?)?.toInt() ?? 3,
      imageCornerRadius: (json['imageCornerRadius'] as num?)?.toDouble() ?? 4.0,
      navigation: json['navigation'] as bool? ?? false,
      snapping: json['snapping'] as bool? ?? false,
      showPageIndicators: json['showPageIndicators'] as bool? ?? false,
      peepingFactor: (json['peepingFactor'] as num?)?.toInt() ?? 0,
    );

RecentlyViewedHeadingModel _$RecentlyViewedHeadingModelFromJson(
  Map<String, dynamic> json,
) => RecentlyViewedHeadingModel(
  url: json['url'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

RecentlyViewedMarginsModel _$RecentlyViewedMarginsModelFromJson(
  Map<String, dynamic> json,
) => RecentlyViewedMarginsModel(
  top: (json['top'] as num?)?.toDouble() ?? 12.0,
  bottom: (json['bottom'] as num?)?.toDouble() ?? 12.0,
  horizontal: (json['horizontal'] as num?)?.toDouble() ?? 16.0,
  innerHorizontalMargin:
      (json['innerHorizontalMargin'] as num?)?.toDouble() ?? 8.0,
  titleBottomMargin: (json['titleBottomMargin'] as num?)?.toDouble() ?? 0.0,
  titleHorizontalMargin:
      (json['titleHorizontalMargin'] as num?)?.toDouble() ?? 0.0,
);

RecentlyViewedTileModel _$RecentlyViewedTileModelFromJson(
  Map<String, dynamic> json,
) => RecentlyViewedTileModel(product: _productFromJson(json['product']));

RecentlyViewedModel _$RecentlyViewedModelFromJson(Map<String, dynamic> json) =>
    RecentlyViewedModel(
      viewConfig: _viewConfigFromJson(json['viewConfig']),
      tiles:
          (json['tiles'] as List<dynamic>?)
              ?.map(
                (e) =>
                    RecentlyViewedTileModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      heading: _headingFromJson(json['heading']),
      margins: _marginsFromJson(json['margins']),
    );
