import 'package:json_annotation/json_annotation.dart';

import '../../../../features/plp/data/models/page_meta_model.dart';
import '../../domain/entities/tile_entity.dart';
import '../../domain/entities/recommendations_entity.dart';
import 'tile_model.dart';

part 'recommendations_model.g.dart';

@JsonSerializable(createToJson: false)
class RecommendationsModel {
  const RecommendationsModel({this.records = const [], this.pageMeta, this.trackingMeta});

  /// `records[]` — each entry is `{ trackingMeta, product }`, the same shape as a
  /// recently-viewed tile, so one model serves both rails.
  ///
  /// The entry's node holds the prefixed `clicked_product_*` block; the product's
  /// own node keeps its unprefixed names. They are separate nodes because merging
  /// them onto a rail-click event would overwrite the product being viewed with
  /// the one that was tapped.
  @JsonKey(defaultValue: [])
  final List<TileModel> records;

  @JsonKey(defaultValue: null, fromJson: _pageMetaFromJson)
  final PageMetaModel? pageMeta;

  /// Rail root: `feed_size`, the total items in the rail.
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? trackingMeta;

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsModelFromJson(json);
}

PageMetaModel? _pageMetaFromJson(Object? json) =>
    json is Map<String, dynamic> ? PageMetaModel.fromJson(json) : null;

extension RecommendationsModelX on RecommendationsModel {
  RecommendationsEntity toEntity() => RecommendationsEntity(
    records: records.map((r) => r.toEntity()).whereType<TileEntity>().toList(),
    pageMeta: pageMeta?.toEntity(),
    trackingMeta: trackingMeta,
  );
}
