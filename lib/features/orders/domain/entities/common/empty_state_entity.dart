import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/backend_action_entity.dart';

part 'empty_state_entity.freezed.dart';

/// The "no orders yet" / "no gift cards yet" screen, sent by the server.
///
/// Android bundles this copy in the APK — `R.string.myOrdersEmptyMsg` and
/// `R.string.empty_gift_card_title` — and the server sends `emptyStateData` for
/// Gift Cards only, so the Orders tab has never received it. Flutter bundles
/// none of it: **an absent [EmptyStateEntity] renders a blank screen**, which is
/// why the contract requires it on both tabs.
///
/// [title] is one string carrying both lines, split on `\n`, matching how
/// `v1/gift-cards` already sends it.
@freezed
abstract class EmptyStateEntity with _$EmptyStateEntity {
  const factory EmptyStateEntity({
    String? title,
    BackendActionButtonEntity? ctaAction,
  }) = _EmptyStateEntity;
}

extension EmptyStateEntityX on EmptyStateEntity {
  /// The two lines the design draws, split off the single wire string.
  ///
  /// Returns an empty list when there is nothing to show, so the caller can
  /// fall through to its own guard rather than rendering a blank column.
  List<String> get lines =>
      (title == null || title!.isEmpty) ? const [] : title!.split('\n');

  /// A CTA is only usable with both halves. Android silently navigates home
  /// when the label or the URL is empty (`OrdersListingFragment.kt:283-289`);
  /// that fallback does not survive here, so a partial CTA would render a dead
  /// button. Better to draw no button than a broken one.
  bool get hasUsableCta =>
      (ctaAction?.label?.isNotEmpty ?? false) &&
      (ctaAction?.actionUri?.isNotEmpty ?? false);
}
