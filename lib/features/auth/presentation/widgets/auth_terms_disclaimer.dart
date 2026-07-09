import 'package:flutter/material.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// "By signing in…" row with tappable T&C and Privacy Policy links.
///
/// Taps open the corresponding page in the ported in-app WebView by default.
/// Pass [onTermsTap] / [onPrivacyTap] to override the default behaviour.
class AuthTermsDisclaimer extends StatelessWidget {
  const AuthTermsDisclaimer({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.termsKey,
    this.privacyKey,
  });

  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final Key? termsKey;
  final Key? privacyKey;

  static final _base = AppTypographyV1.labelMedium.regular.copyWith(color: AppColors.neutralBlack);
  static final _link = AppTypographyV1.labelMedium.bold.copyWith(color: AppColors.secondary);

  void _openTerms(BuildContext context) => AppNavigator.goToWebView(
    context,
    url:
        '${EnvironmentConfig.webBaseUrl}/${AuthStrings.termsPath}${AuthStrings.legalUrlParams}',
    title: AuthStrings.termsAndConditions,
  );

  void _openPrivacy(BuildContext context) => AppNavigator.goToWebView(
    context,
    url:
        '${EnvironmentConfig.webBaseUrl}/${AuthStrings.privacyPath}${AuthStrings.legalUrlParams}',
    title: AuthStrings.privacyPolicy,
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
          key: termsKey,
          onTap: onTermsTap ?? () => _openTerms(context),
          child: Text(AuthStrings.termsAndConditionsUpper, style: _link),
        ),
        Text(AuthStrings.termsAnd, style: _base),
        GestureDetector(
          key: privacyKey,
          onTap: onPrivacyTap ?? () => _openPrivacy(context),
          child: Text(AuthStrings.privacyPolicyUpper, style: _link),
        ),
      ],
    );
  }
}
