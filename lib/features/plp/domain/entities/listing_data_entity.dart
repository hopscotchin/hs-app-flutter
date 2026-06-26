import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';
import 'banner_entity.dart';
import 'floating_filter_entity.dart';
import 'listing_product_entity.dart';
import 'notification_nudge_entity.dart';
import 'page_meta_entity.dart';
import 'plp_filter_entity.dart';
import 'query_correction_entity.dart';
import 'tracking_meta_entity.dart';

part 'listing_data_entity.freezed.dart';

@freezed
abstract class ListingDataEntity with _$ListingDataEntity {
  const factory ListingDataEntity({
    PageMetaEntity? pageMeta,
    TrackingMetaEntity? trackingMeta,
    NotificationNudgeEntity? notificationNudge,
    @Default([]) List<BannerEntity> banners,
    FloatingFilterEntity? floatingFilter,
    PlpFilterEntity? filters,
    @Default([]) List<ListingProductEntity> records,
    QueryCorrectionEntity? queryCorrection,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    @Default(-1) int orderRule,
  }) = _ListingDataEntity;
}

extension ListingDataEntityX on ListingDataEntity {
  bool get hasMorePages => pageMeta?.hasNextPage ?? false;
  int get totalRecords => pageMeta?.totalCount ?? 0;
  int get pageNo => pageMeta?.page ?? 0;
  String? get screenName => pageMeta?.pageTitle;
  String? get screenSubtitle => pageMeta?.pageSubtitle;

  int get effectiveOrderRule => orderRule != -1 ? orderRule : (pageMeta?.orderRule ?? -1);
}
