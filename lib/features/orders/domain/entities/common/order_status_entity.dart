import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/backend_action_entity.dart';

part 'order_status_entity.freezed.dart';

/// The status block on an order row: an icon and up to two lines of copy.
///
/// Everything here arrives resolved. Android picks the drawable from a ~90-line
/// `if/else` over nineteen status codes — duplicated across two adapters that
/// have already drifted — then runs a five-field precedence chain to decide
/// which message wins. Both move to the backend: [icon] is a URL, [title] and
/// [subtitle] are final strings.
///
/// **No colour, and no status code.** The redesign paints every status in the
/// same neutral token pair, so Android's colour-by-status system is retired
/// rather than migrated, and nothing on the client branches on a machine value.
/// See `docs/orders/android-business-logic.md` §1-§3.
///
/// Shared by the listing card, the order-details item and the return item.
/// Each surface uses three of the four fields, and the pairs are disjoint
/// today — the listing sends `subtitle` and no `action`, details sends `action`
/// and no `subtitle`. That is what the artboards ask for rather than a rule:
/// nothing stops details growing a second line or the listing an inline link,
/// which is why all four are nullable on one model instead of two models.
@freezed
abstract class OrderStatusEntity with _$OrderStatusEntity {
  const factory OrderStatusEntity({
    String? icon,
    String? title,
    String? subtitle,

    /// An optional inline link after [title], rendered as "· Track".
    ///
    /// Order details only. Replaces v8's `showTrackOrder`, an int 0|1 the
    /// client turned into a hard-coded label and a hand-built destination —
    /// both now arrive resolved.
    ///
    /// Not the only thing that can sit at the end of that row: on a delivered
    /// item the artboard puts the rating stars there instead, and those come
    /// from the item's own `rating` block, not from here. The two are mutually
    /// exclusive, and the page decides which to pass.
    BackendActionButtonEntity? action,
  }) = _OrderStatusEntity;
}

extension OrderStatusEntityX on OrderStatusEntity {
  /// Whether the block has anything to draw. Android hides the whole row when
  /// its message precedence resolves to nothing, and the contract expresses
  /// that by omitting the object rather than sending empty strings — but a
  /// half-populated block is still possible, so the widget checks.
  bool get hasContent =>
      (title?.isNotEmpty ?? false) || (subtitle?.isNotEmpty ?? false);

  /// A link is only usable with both halves — a label with no destination
  /// renders a dead control, which is worse than rendering none.
  bool get hasAction =>
      (action?.label?.isNotEmpty ?? false) &&
      (action?.actionUri?.isNotEmpty ?? false);
}
