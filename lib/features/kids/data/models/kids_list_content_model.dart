import '../../domain/entities/kids_list_content_entity.dart';

/// Parses the `content` object inside `GET v2/questionnaire/list`'s response
/// (a sibling of `children`, not a separate endpoint). Every field is read
/// defensively (`as String? ?? fallback`) since this is a newly-proposed
/// addition to an existing, not-yet-fully-implemented contract — a partial
/// or missing `content` object should degrade field-by-field, not fail the
/// whole parse.
class KidsListContentModel {
  static KidsListContentEntity fromJson(Map<String, dynamic>? json) {
    final fallback = KidsListContentEntity.fallback();
    if (json == null) return fallback;
    return KidsListContentEntity(
      emptyStateTitle: json['emptyStateTitle'] as String? ?? fallback.emptyStateTitle,
      emptyStateSubtitle: json['emptyStateSubtitle'] as String? ?? fallback.emptyStateSubtitle,
      bannerTitle: json['bannerTitle'] as String? ?? fallback.bannerTitle,
      bannerSubtitle: json['bannerSubtitle'] as String? ?? fallback.bannerSubtitle,
      addChildLabel: json['addChildLabel'] as String? ?? fallback.addChildLabel,
      addAnotherChildLabel: json['addAnotherChildLabel'] as String? ?? fallback.addAnotherChildLabel,
      addChildSubtitle: json['addChildSubtitle'] as String? ?? fallback.addChildSubtitle,
      footerAvatars: _footerAvatarsFromJson(json['footerAvatars'] as List<dynamic>?) ?? fallback.footerAvatars,
    );
  }

  static List<String?>? _footerAvatarsFromJson(List<dynamic>? json) {
    if (json == null) return null;
    return json.map((e) => e as String?).toList();
  }
}
