import '../../../../core/extensions/string_extensions.dart';
import '../../domain/entities/kid_form_config_entity.dart';

/// `GET v2/questionnaire/form-config` response. Colors arrive as hex strings
/// and images as URLs — same convention as `VisualCueModel`/`FilterModel`
/// elsewhere in the app (hex color fields, never an enum; remote image URL
/// for an icon, never a local icon-name enum). Every field is read
/// defensively (`as String? ?? fallback`) since a partial or malformed
/// response should degrade field-by-field, not fail the whole parse.
class KidFormConfigResponseModel {
  const KidFormConfigResponseModel({
    required this.action,
    this.message,
    this.heading,
    this.subheading,
    this.bannerTitle,
    this.bannerSubtitle,
    this.bannerBackgroundColor,
    this.consentText,
    this.viewPrivacyPolicyLabel,
    this.viewPrivacyPolicyUrl,
    this.placeholderImageBoy,
    this.placeholderImageGirl,
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
  final String? placeholderImageBoy;
  final String? placeholderImageGirl;

  bool get isSuccessful => action?.toLowerCase() == 'success';

  factory KidFormConfigResponseModel.fromJson(Map<String, dynamic> json) {
    final placeholderImages = json['placeholderImages'] as Map<String, dynamic>?;
    return KidFormConfigResponseModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      heading: json['heading'] as String?,
      subheading: json['subheading'] as String?,
      bannerTitle: json['bannerTitle'] as String?,
      bannerSubtitle: json['bannerSubtitle'] as String?,
      bannerBackgroundColor: json['bannerBackgroundColor'] as String?,
      consentText: json['consentText'] as String?,
      viewPrivacyPolicyLabel: json['viewPrivacyPolicyLabel'] as String?,
      viewPrivacyPolicyUrl: json['viewPrivacyPolicyUrl'] as String?,
      placeholderImageBoy: placeholderImages?['boy'] as String?,
      placeholderImageGirl: placeholderImages?['girl'] as String?,
    );
  }

  /// Maps onto [KidFormConfigEntity], filling any missing/unparseable field
  /// from [KidFormConfigEntity.fallback] so a partial response still renders
  /// a fully-populated screen.
  KidFormConfigEntity toEntity() {
    final fallback = KidFormConfigEntity.fallback();
    return KidFormConfigEntity(
      heading: heading ?? fallback.heading,
      subheading: subheading ?? fallback.subheading,
      bannerTitle: bannerTitle ?? fallback.bannerTitle,
      bannerSubtitle: bannerSubtitle ?? fallback.bannerSubtitle,
      bannerBackgroundColor: bannerBackgroundColor.toColorOr(fallback.bannerBackgroundColor),
      consentText: consentText ?? fallback.consentText,
      viewPrivacyPolicyLabel: viewPrivacyPolicyLabel ?? fallback.viewPrivacyPolicyLabel,
      viewPrivacyPolicyUrl: viewPrivacyPolicyUrl ?? fallback.viewPrivacyPolicyUrl,
      placeholderImageBoy: placeholderImageBoy,
      placeholderImageGirl: placeholderImageGirl,
    );
  }
}
