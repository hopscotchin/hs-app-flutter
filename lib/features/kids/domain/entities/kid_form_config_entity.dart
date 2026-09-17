import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/theme/colors.dart';

part 'kid_form_config_entity.freezed.dart';

/// Add/Edit-Kid screen's "why we ask" banner + consent/privacy-policy copy +
/// gender placeholder avatars — sourced from `GET v2/questionnaire/form-config`
/// (see ApiConstants.kidsFormConfig). Everything else on the screen (AppBar
/// title, field labels, button labels, dialog copy) stays local-only in
/// [KidsStrings] — only the content backend actually needs to be able to
/// change is modeled here.
///
/// [fallback] carries today's hardcoded copy/colors — used transparently
/// whenever the endpoint 404s, errors, or times out, so the screen keeps
/// working exactly as it does today.
@freezed
abstract class KidFormConfigEntity with _$KidFormConfigEntity {
  const factory KidFormConfigEntity({
    required String heading,
    required String subheading,
    required String bannerTitle,
    required String bannerSubtitle,
    required Color bannerBackgroundColor,
    required String consentText,
    required String viewPrivacyPolicyLabel,
    required String viewPrivacyPolicyUrl,
    // Gender-specific "no photo yet" avatars. Nullable — null means "render
    // the local generic-person placeholder" (a client-only rendering detail,
    // not part of the contract), same convention as
    // `KidsListContentEntity.footerAvatars`.
    required String? placeholderImageBoy,
    required String? placeholderImageGirl,
  }) = _KidFormConfigEntity;

  factory KidFormConfigEntity.fallback() => KidFormConfigEntity(
    heading: KidsStrings.formHeading,
    subheading: KidsStrings.formSubheading,
    bannerTitle: KidsStrings.whyWeAskBannerTitle,
    bannerSubtitle: KidsStrings.whyWeAskBannerSubtitle,
    bannerBackgroundColor: AppColors.neutralGrey1,
    consentText: KidsStrings.consentText,
    viewPrivacyPolicyLabel: KidsStrings.viewPrivacyPolicy,
    viewPrivacyPolicyUrl:
        '${EnvironmentConfig.webBaseUrl}/${AuthStrings.privacyPath}${AuthStrings.legalUrlParams}',
    placeholderImageBoy: null,
    placeholderImageGirl: null,
  );
}
