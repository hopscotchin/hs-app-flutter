import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../plp/domain/entities/notification_nudge_entity.dart';
import '../../../../plp/domain/entities/page_meta_entity.dart';
import '../common/empty_state_entity.dart';
import '../common/support_section_entity.dart';
import 'order_listing_record_entity.dart';

part 'orders_listing_entity.freezed.dart';

/// One page of either listing.
///
/// Both endpoints return this shape; only the contents differ. The Gift Cards
/// tab sends no [notificationNudge] and no [support] — its artboard goes from
/// the tab bar straight to the cards and ends after the last one. Android shows
/// both on both tabs, so that is a deliberate change rather than a port.
@freezed
abstract class OrdersListingEntity with _$OrdersListingEntity {
  const factory OrdersListingEntity({
    /// Always present, never absent — an absent primary collection reads as a
    /// failure rather than an empty result. v5 omitted `items` entirely when
    /// empty while `v1/gift-cards` sent `[]`; one shape now.
    @Default(<OrderListingRecordEntity>[])
    List<OrderListingRecordEntity> records,

    PageMetaEntity? pageMeta,

    /// Sent only when [records] is empty.
    EmptyStateEntity? emptyState,

    /// Orders tab only.
    NotificationNudgeEntity? notificationNudge,

    /// Orders tab only. App-config in practice — see [SupportSectionEntity].
    SupportSectionEntity? support,

    /// The analytics blob, forwarded to Segment whole. **Never read a key out
    /// of it.** Keeping it an untyped map is what lets the backend add a
    /// dimension without an app release.
    Map<String, dynamic>? trackingMeta,
  }) = _OrdersListingEntity;
}

extension OrdersListingEntityX on OrdersListingEntity {
  /// Straight off `pageMeta`, not derived. v5 forced the client to infer this
  /// by comparing loaded rows against a total that was itself wrong on the
  /// gift-cards endpoint — 13 reported for 15 rows.
  bool get hasNextPage => pageMeta?.hasNextPage ?? false;

  bool get isEmpty => records.isEmpty;

  /// Appends [next]'s rows to this page, keeping [next]'s metadata.
  ///
  /// Everything except [records] comes from the newer response: `pageMeta`
  /// carries the fresh `hasNextPage`, and `trackingMeta` the fresh counts. The
  /// nudge and support block are page-level and identical across pages, but
  /// taking them from [next] keeps a single rule — newest wins, except the list
  /// itself, which accumulates.
  OrdersListingEntity merge(OrdersListingEntity next) =>
      next.copyWith(records: [...records, ...next.records]);
}
