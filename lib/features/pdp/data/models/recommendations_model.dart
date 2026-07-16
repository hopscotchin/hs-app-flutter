import 'package:json_annotation/json_annotation.dart';

import '../../../../features/plp/data/models/listing_product_model.dart';
import '../../../../features/plp/data/models/page_meta_model.dart';
import '../../domain/entities/recommendations_entity.dart';

part 'recommendations_model.g.dart';

@JsonSerializable(createToJson: false)
class RecommendationsModel {
  const RecommendationsModel({
    this.records = const [],
    this.pageMeta,
  });

  @JsonKey(defaultValue: [])
  final List<ListingProductModel> records;

  @JsonKey(defaultValue: null, fromJson: _pageMetaFromJson)
  final PageMetaModel? pageMeta;

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsModelFromJson(json);
}

PageMetaModel? _pageMetaFromJson(Object? json) =>
    json is Map<String, dynamic> ? PageMetaModel.fromJson(json) : null;

extension RecommendationsModelX on RecommendationsModel {
  RecommendationsEntity toEntity() => RecommendationsEntity(
    records: records.map((r) => r.toEntity()).toList(),
    pageMeta: pageMeta?.toEntity(),
  );
}
