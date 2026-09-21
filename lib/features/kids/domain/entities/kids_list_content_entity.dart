import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/entities/message_bar_entity.dart';
import 'child_entity.dart';

part 'kids_list_content_entity.freezed.dart';

/// My Kids **list** screen's backend-driven copy — sourced directly from the
/// `GET v2/questionnaire/list` response's `emptyState`/`addChildContainer`/
/// `messageBar` fields (siblings of `children`, not a separate endpoint —
/// see PROFILE_KIDS_API_CONTRACT.md §3). The backend now pre-resolves the
/// "Add child" vs "Add another child" copy itself (it already knows from
/// the same response whether `children` is empty), so there's a single
/// [addChildTitle] rather than two client-chosen variants.
///
/// [fallback] carries today's hardcoded copy — used transparently whenever
/// the response omits a field, so the screen degrades gracefully instead of
/// failing the whole parse.
@freezed
abstract class KidsListContentEntity with _$KidsListContentEntity {
  const factory KidsListContentEntity({
    // Empty-state (no children yet) heading/subheading.
    required String emptyStateTitle,
    required String emptyStateSubtitle,
    // Backend-sent illustration for the empty state. Currently captured for
    // completeness only — the empty state still renders its local default
    // illustration; wiring this through needs `EmptyStateWidget`'s `icon`
    // override to actually be read by `_resolvedIcon`, which it isn't today.
    String? emptyStateIcon,
    // Info banner shown above a populated list — the backend sends this as
    // a full message-bar object (title/message/bgColor/...), the same shape
    // used everywhere else in the app, not separate title/subtitle strings.
    // Null means "don't show a banner" — the fallback has no hardcoded copy
    // to show in its place (unlike every other field here), so the screen
    // renders with no banner at all until backend actually sends one.
    required MessageBarEntity? messageBar,
    // Persistent "Add child" footer row. Backend-resolved single title.
    required String addChildTitle,
    required String addChildSubtitle,
    // Single leading/trailing icons, replacing the old two-avatar preview
    // stack and hardcoded "+" glyph. Null renders the local placeholder.
    String? addChildLeadingIcon,
    String? addChildTrailingIcon,
  }) = _KidsListContentEntity;

  factory KidsListContentEntity.fallback() => const KidsListContentEntity(
    emptyStateTitle: KidsStrings.emptyStateTitle,
    emptyStateSubtitle: KidsStrings.emptyStateSubtitle,
    messageBar: null,
    addChildTitle: KidsStrings.addChild,
    addChildSubtitle: KidsStrings.addChildSubtitle,
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
