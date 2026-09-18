import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/message_bar_model.dart';
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
    this.messageBar,
    this.addChildLabel,
    this.addAnotherChildLabel,
    this.addChildSubtitle,
    this.footerAvatars,
  });

  final String? emptyStateTitle;
  final String? emptyStateSubtitle;

  /// Full message-bar object for the info banner above a populated list —
  /// same shape used everywhere else in the app, not separate title/
  /// subtitle strings.
  final MessageBarModel? messageBar;
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
      messageBar: messageBar ?? fallback.messageBar,
      addChildLabel: addChildLabel ?? fallback.addChildLabel,
      addAnotherChildLabel: addAnotherChildLabel ?? fallback.addAnotherChildLabel,
      addChildSubtitle: addChildSubtitle ?? fallback.addChildSubtitle,
      footerAvatars: footerAvatars ?? fallback.footerAvatars,
    );
  }
}
