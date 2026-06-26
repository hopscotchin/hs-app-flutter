import '../../../../core/constants/strings/legal_strings.dart';

enum LegalTouchPoint { terms, privacy, aboutUs }

extension LegalTouchPointX on LegalTouchPoint {
  String get path => switch (this) {
    LegalTouchPoint.terms => 'about/Terms',
    LegalTouchPoint.privacy => 'about/privacy',
    LegalTouchPoint.aboutUs => 'about/AboutUs',
  };

  /// WebView app-bar title for this page.
  String get title => switch (this) {
    LegalTouchPoint.terms => LegalStrings.termsAndConditions,
    LegalTouchPoint.privacy => LegalStrings.privacyPolicy,
    LegalTouchPoint.aboutUs => LegalStrings.aboutUs,
  };
}