import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/kids_list_content_entity.dart';

part 'kids_list_content_model.g.dart';

/// Parses the `content` object inside `GET v2/questionnaire/list`'s response
/// (a sibling of `children`, not a separate endpoint). Every field is
/// nullable and [toEntity] fills any missing one from
/// [KidsListContentEntity.fallback], so a partial or missing `content`
/// object degrades field-by-field instead of failing the whole parse.
@JsonSerializable(createToJson: false)
class KidsListContentModel {
  const KidsListContentModel({
    this.emptyStateTitle,
    this.emptyStateSubtitle,
    this.bannerTitle,
    this.bannerSubtitle,
    this.addChildLabel,
    this.addAnotherChildLabel,
    this.addChildSubtitle,
    this.footerAvatars,
  });

  final String? emptyStateTitle;
  final String? emptyStateSubtitle;
  final String? bannerTitle;
  final String? bannerSubtitle;
  final String? addChildLabel;
  final String? addAnotherChildLabel;
  final String? addChildSubtitle;

  /// The footer row's two overlapping preview circles. A `null` entry means
  /// "no image yet, render the local generic-person placeholder" — see
  /// [KidsListContentEntity.footerAvatars].
  final List<String?>? footerAvatars;

  factory KidsListContentModel.fromJson(Map<String, dynamic> json) =>
      _$KidsListContentModelFromJson(json);
}

extension KidsListContentModelX on KidsListContentModel {
  KidsListContentEntity toEntity() {
    final fallback = KidsListContentEntity.fallback();
    return KidsListContentEntity(
      emptyStateTitle: emptyStateTitle ?? fallback.emptyStateTitle,
      emptyStateSubtitle: emptyStateSubtitle ?? fallback.emptyStateSubtitle,
      bannerTitle: bannerTitle ?? fallback.bannerTitle,
      bannerSubtitle: bannerSubtitle ?? fallback.bannerSubtitle,
      addChildLabel: addChildLabel ?? fallback.addChildLabel,
      addAnotherChildLabel: addAnotherChildLabel ?? fallback.addAnotherChildLabel,
      addChildSubtitle: addChildSubtitle ?? fallback.addChildSubtitle,
      footerAvatars: footerAvatars ?? fallback.footerAvatars,
    );
  }
}
