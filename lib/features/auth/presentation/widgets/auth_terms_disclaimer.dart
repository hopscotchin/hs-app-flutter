import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// "By signing in…" row with tappable T&C and Privacy Policy links.
///
/// Taps open the corresponding page in the in-app browser by default.
/// Pass [onTermsTap] / [onPrivacyTap] to override the default behaviour.
class AuthTermsDisclaimer extends StatelessWidget {
  const AuthTermsDisclaimer({super.key, this.onTermsTap, this.onPrivacyTap});

  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  static final _base = AppTypographyV1.labelMedium.regular.copyWith(color: AppColors.neutralBlack);
  static final _link = AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.secondary);

  void _openTerms() => launchUrl(
    Uri.parse('${EnvironmentConfig.baseUrl}/${AuthStrings.termsPath}${AuthStrings.legalUrlParams}'),
    mode: LaunchMode.inAppBrowserView,
  );

  void _openPrivacy() => launchUrl(
    Uri.parse(
      '${EnvironmentConfig.baseUrl}/${AuthStrings.privacyPath}${AuthStrings.legalUrlParams}',
    ),
    mode: LaunchMode.inAppBrowserView,
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        Text(AuthStrings.termsPrefix, style: _base),
        GestureDetector(
          onTap: onTermsTap ?? _openTerms,
          child: Text(AuthStrings.termsAndConditionsUpper, style: _link),
        ),
        Text(AuthStrings.termsAnd, style: _base),
        GestureDetector(
          onTap: onPrivacyTap ?? _openPrivacy,
          child: Text(AuthStrings.privacyPolicyUpper, style: _link),
        ),
      ],
    );
  }
}
