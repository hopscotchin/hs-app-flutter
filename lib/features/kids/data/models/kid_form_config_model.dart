import '../../../../core/extensions/string_extensions.dart';
import '../../domain/entities/kid_form_config_entity.dart';

/// Parses `GET v2/questionnaire/form-config`. Colors arrive as hex strings
/// and images as URLs — same convention as `VisualCueModel`/`FilterModel`
/// elsewhere in the app (hex color fields, never an enum; remote image URL
/// for an icon, never a local icon-name enum). Every field is read
/// defensively (`as String? ?? fallback`) since this is a brand-new,
/// not-yet-implemented endpoint — a partial or malformed response should
/// degrade field-by-field, not fail the whole parse.
class KidFormConfigModel {
  static KidFormConfigEntity fromJson(Map<String, dynamic> json) {
    final fallback = KidFormConfigEntity.fallback();
    return KidFormConfigEntity(
      heading: json['heading'] as String? ?? fallback.heading,
      subheading: json['subheading'] as String? ?? fallback.subheading,
      bannerTitle: json['bannerTitle'] as String? ?? fallback.bannerTitle,
      bannerSubtitle: json['bannerSubtitle'] as String? ?? fallback.bannerSubtitle,
      bannerBackgroundColor: (json['bannerBackgroundColor'] as String?).toColorOr(
        fallback.bannerBackgroundColor,
      ),
      consentText: json['consentText'] as String? ?? fallback.consentText,
      viewPrivacyPolicyLabel: json['viewPrivacyPolicyLabel'] as String? ?? fallback.viewPrivacyPolicyLabel,
      viewPrivacyPolicyUrl: json['viewPrivacyPolicyUrl'] as String? ?? fallback.viewPrivacyPolicyUrl,
    );
  }
}
