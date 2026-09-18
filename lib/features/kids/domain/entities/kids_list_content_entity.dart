import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/entities/message_bar_entity.dart';
import 'child_entity.dart';

part 'kids_list_content_entity.freezed.dart';

/// My Kids **list** screen's backend-driven copy + footer avatar images —
/// sourced from the existing `GET v2/questionnaire/list` response (a sibling
/// `content` object alongside `children`, not a separate endpoint — see
/// PROFILE_KIDS_API_CONTRACT.md §3). Everything else on this screen (the
/// baby-illustration empty-state icon, delete-confirm dialog copy) stays
/// local-only.
///
/// [fallback] carries today's hardcoded copy — used transparently whenever
/// the response omits `content` or a field within it, so the screen keeps
/// working exactly as it does today until backend ships this.
@freezed
abstract class KidsListContentEntity with _$KidsListContentEntity {
  const factory KidsListContentEntity({
    // Empty-state (no children yet) heading/subheading.
    required String emptyStateTitle,
    required String emptyStateSubtitle,
    // Info banner shown above a populated list — the backend sends this as
    // a full message-bar object (title/message/bgColor/...), the same shape
    // used everywhere else in the app, not separate title/subtitle strings.
    // Null means "don't show a banner" — the fallback has no hardcoded copy
    // to show in its place (unlike every other field here), so the screen
    // renders with no banner at all until backend actually sends one.
    required MessageBarEntity? messageBar,
    // Persistent "Add child" / "Add another child" footer row.
    required String addChildLabel,
    required String addAnotherChildLabel,
    required String addChildSubtitle,
    // The footer row's two overlapping preview circles. Nullable entries —
    // null means "no image yet, render the local generic-person placeholder"
    // (a client-only rendering detail, not part of the contract).
    required List<String?> footerAvatars,
  }) = _KidsListContentEntity;

  factory KidsListContentEntity.fallback() => const KidsListContentEntity(
    emptyStateTitle: KidsStrings.emptyStateTitle,
    emptyStateSubtitle: KidsStrings.emptyStateSubtitle,
    messageBar: null,
    addChildLabel: KidsStrings.addChild,
    addAnotherChildLabel: KidsStrings.addAnotherChild,
    addChildSubtitle: KidsStrings.addChildSubtitle,
    footerAvatars: [null, null],
  );
}

/// Bundles the list + its accompanying screen content, since both arrive
/// together in one `GET v2/questionnaire/list` response.
@freezed
abstract class ChildrenListResult with _$ChildrenListResult {
  const factory ChildrenListResult({
    required List<ChildEntity> children,
    required KidsListContentEntity content,
  }) = _ChildrenListResult;
}
