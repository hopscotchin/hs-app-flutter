import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features/plp/domain/entities/listing_product_entity.dart';
import '../../../../features/plp/domain/entities/page_meta_entity.dart';

part 'recommendations_entity.freezed.dart';

@freezed
abstract class RecommendationsEntity with _$RecommendationsEntity {
  const factory RecommendationsEntity({
    @Default([]) List<ListingProductEntity> records,
    PageMetaEntity? pageMeta,
  }) = _RecommendationsEntity;
}
