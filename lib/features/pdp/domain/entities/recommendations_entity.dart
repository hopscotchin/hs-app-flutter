import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features/plp/domain/entities/page_meta_entity.dart';
import 'tile_entity.dart';

part 'recommendations_entity.freezed.dart';

@freezed
abstract class RecommendationsEntity with _$RecommendationsEntity {
  const factory RecommendationsEntity({
    /// Named for the wire (`records[]`), typed as the shared rail tile: the
    /// element carries the product plus the click block that describes it as a
    /// tap target.
    @Default([]) List<TileEntity> records,
    PageMetaEntity? pageMeta,

    /// `trackingMeta` at the rail root — `feed_size`, forwarded whole.
    Map<String, dynamic>? trackingMeta,
  }) = _RecommendationsEntity;
}
