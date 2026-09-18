import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/kid_form_config_entity.dart';

part 'kid_form_config_response_model.g.dart';

/// `GET v2/questionnaire/form-config` response. Colors arrive as hex strings
/// and images as URLs — same convention as `VisualCueModel`/`FilterModel`
/// elsewhere in the app (hex color fields, never an enum; remote image URL
/// for an icon, never a local icon-name enum). Every field is nullable and
/// [toEntity] fills any missing/unparseable one from
/// [KidFormConfigEntity.fallback], so a partial response still renders a
/// fully-populated screen.
@JsonSerializable(createToJson: false)
class KidFormConfigResponseModel {
  const KidFormConfigResponseModel({
    this.action,
    this.message,
    this.heading,
    this.subheading,
    this.bannerTitle,
    this.bannerSubtitle,
    this.bannerBackgroundColor,
    this.consentText,
    this.viewPrivacyPolicyLabel,
    this.viewPrivacyPolicyUrl,
    this.placeholderImages,
  });

  final String? action;
  final String? message;
  final String? heading;
  final String? subheading;
  final String? bannerTitle;
  final String? bannerSubtitle;
  final String? bannerBackgroundColor;
  final String? consentText;
  final String? viewPrivacyPolicyLabel;
  final String? viewPrivacyPolicyUrl;

  /// Raw `{"boy": url, "girl": url}` blob — extracted by key in [toEntity]
  /// rather than in `fromJson`, since json_serializable can't map two
  /// fields onto the same JSON key.
  final Map<String, dynamic>? placeholderImages;

  factory KidFormConfigResponseModel.fromJson(Map<String, dynamic> json) =>
      _$KidFormConfigResponseModelFromJson(json);
}

extension KidFormConfigResponseModelX on KidFormConfigResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';

  KidFormConfigEntity toEntity() {
    final fallback = KidFormConfigEntity.fallback();
    return KidFormConfigEntity(
      heading: heading ?? fallback.heading,
      subheading: subheading ?? fallback.subheading,
      bannerTitle: bannerTitle ?? fallback.bannerTitle,
      bannerSubtitle: bannerSubtitle ?? fallback.bannerSubtitle,
      bannerBackgroundColor: bannerBackgroundColor ?? fallback.bannerBackgroundColor,
      consentText: consentText ?? fallback.consentText,
      viewPrivacyPolicyLabel: viewPrivacyPolicyLabel ?? fallback.viewPrivacyPolicyLabel,
      viewPrivacyPolicyUrl: viewPrivacyPolicyUrl ?? fallback.viewPrivacyPolicyUrl,
      placeholderImageBoy: placeholderImages?['boy'] as String?,
      placeholderImageGirl: placeholderImages?['girl'] as String?,
    );
  }
}
