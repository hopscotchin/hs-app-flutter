import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/environment.dart';
import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/theme/colors.dart';

part 'kid_form_config_entity.freezed.dart';

/// Add/Edit-Kid screen's "why we ask" banner + consent/privacy-policy copy,
/// plus the photo-sheet's avatar catalog — sourced from
/// `GET v2/questionnaire/form-config` (see ApiConstants.kidsFormConfig — a
/// newly-proposed endpoint, not yet built by backend). Everything else on
/// the screen (AppBar title, field labels, button labels, dialog copy)
/// stays local-only in [KidsStrings] — only the content backend actually
/// needs to be able to change is modeled here.
///
/// [fallback] carries today's hardcoded copy/colors — used transparently
/// whenever the endpoint 404s, errors, or hasn't shipped yet, so the screen
/// keeps working exactly as it does today until backend implements this.
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
    // Shown on the screen's own photo-picker circle (the tappable trigger
    // that opens the bottom sheet) before the user has chosen a photo or
    // avatar — the empty-state image. Root-level, not per-avatar: this is
    // one generic image for the trigger itself, distinct from each avatar
    // option's own [KidAvatarOptionEntity.imageUrl] inside the sheet.
    String? placeholderImage,
    required List<KidAvatarOptionEntity> avatars,
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
    avatars: KidAvatarOptionEntity.fallbackList(),
  );
}

/// One avatar option shown in the photo-picker bottom sheet. [imageUrl] is
/// the real illustrated artwork, once backend/design have it — null today
/// (no illustrated assets exist yet), in which case the client falls back
/// to its own local Material-icon placeholder (see PhotoSourceBottomSheet's
/// KidAvatarCatalog), a last-resort client-only rendering detail not part
/// of this contract.
@freezed
abstract class KidAvatarOptionEntity with _$KidAvatarOptionEntity {
  const factory KidAvatarOptionEntity({
    required int id,
    String? imageUrl,
  }) = _KidAvatarOptionEntity;

  static List<KidAvatarOptionEntity> fallbackList() => const [
    KidAvatarOptionEntity(id: 1),
    KidAvatarOptionEntity(id: 2),
    KidAvatarOptionEntity(id: 3),
    KidAvatarOptionEntity(id: 4),
    KidAvatarOptionEntity(id: 5),
    KidAvatarOptionEntity(id: 6),
  ];
}
