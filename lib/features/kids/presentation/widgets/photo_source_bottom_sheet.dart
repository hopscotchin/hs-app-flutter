import 'package:flutter/material.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/kid_form_config_entity.dart';

enum PhotoSourceAction { takePhoto, chooseFromGallery, removePhoto }

/// What the sheet returned — either a fixed action or a chosen avatar id.
sealed class PhotoSourceResult {
  const PhotoSourceResult();
}

class PhotoSourceActionResult extends PhotoSourceResult {
  const PhotoSourceActionResult(this.action);
  final PhotoSourceAction action;
}

class PhotoSourceAvatarResult extends PhotoSourceResult {
  const PhotoSourceAvatarResult(this.avatarId);
  final int avatarId;
}

/// Last-resort local fallback, used only when an avatar has no real
/// `imageUrl` — e.g. before backend ships any illustrated artwork at all.
/// Purely a client rendering detail, not part of the API contract.
abstract final class KidAvatarCatalog {
  static const List<int> ids = [1, 2, 3, 4, 5, 6];

  static IconData iconFor(int id) => switch (id) {
    1 => Icons.cruelty_free,
    2 => Icons.face,
    3 => Icons.face_retouching_natural,
    4 => Icons.pets,
    5 => Icons.auto_awesome,
    6 => Icons.emoji_nature,
    _ => Icons.face,
  };

  static Color colorFor(int id) => switch (id) {
    1 => const Color(0xFFF8BBD0),
    2 => const Color(0xFF90CAF9),
    3 => const Color(0xFFFFCC80),
    4 => const Color(0xFFFFF59D),
    5 => const Color(0xFFB39DDB),
    6 => const Color(0xFFFFAB91),
    _ => AppColors.neutralGrey2,
  };
}

/// Avatar circle — reused both inside the picker sheet and wherever a
/// selected avatar needs to render (e.g. the form's photo preview).
///
/// Renders [imageUrl] (real artwork) if present, else falls back to
/// [KidAvatarCatalog]'s local Material-icon placeholder for [avatarId].
class KidAvatarCircle extends StatelessWidget {
  const KidAvatarCircle({super.key, required this.avatarId, this.imageUrl, this.size = 48});

  final int avatarId;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(radius: size / 2, backgroundImage: NetworkImage(imageUrl!));
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: KidAvatarCatalog.colorFor(avatarId),
      child: Icon(KidAvatarCatalog.iconFor(avatarId), size: size * 0.55, color: Colors.white),
    );
  }
}

class PhotoSourceBottomSheet extends StatelessWidget {
  const PhotoSourceBottomSheet({super.key, required this.hasPhoto, required this.avatars});

  final bool hasPhoto;

  /// The only piece of this sheet sourced from `KidFormConfigEntity` — see
  /// that entity's doc comment for why the rest of the sheet's copy stays
  /// local-only.
  final List<KidAvatarOptionEntity> avatars;

  static Future<PhotoSourceResult?> show(
    BuildContext context, {
    required bool hasPhoto,
    required List<KidAvatarOptionEntity> avatars,
  }) {
    return showModalBottomSheet<PhotoSourceResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => PhotoSourceBottomSheet(hasPhoto: hasPhoto, avatars: avatars),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No manual drag-handle bar here — the theme already draws one
            // above the sheet (same as AppBottomSheet, which doesn't draw
            // its own either); adding a second one duplicated it.
            Text(
              KidsStrings.uploadPictureSheetTitle,
              key: const ValueKey(KidsTestStrings.photoSheetTitle),
              style: AppTypographyV1.titleSmall.bold.textPrimary(),
            ),
            const SizedBox(height: 4),
            Text(
              KidsStrings.uploadPictureSheetSubtitle,
              key: const ValueKey(KidsTestStrings.photoSheetSubtitle),
              style: AppTypographyV1.bodyRegular.regular.neutralGrey6(),
            ),
            AppSpacing.verticalGapLg,
            Text(
              KidsStrings.chooseAnAvatar,
              style: AppTypographyV1.bodyRegular.bold.textPrimary(),
            ),
            AppSpacing.verticalGapSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < avatars.length; i++)
                  GestureDetector(
                    key: ValueKey('${KidsTestStrings.photoSheetAvatar}_$i'),
                    onTap: () => Navigator.of(context).pop(
                      PhotoSourceAvatarResult(avatars[i].id),
                    ),
                    child: KidAvatarCircle(
                      avatarId: avatars[i].id,
                      imageUrl: avatars[i].imageUrl,
                    ),
                  ),
              ],
            ),
            AppSpacing.verticalGapLg,
            _SourceRow(
              key: const ValueKey(KidsTestStrings.photoSheetTakePhoto),
              icon: Icons.camera_alt_outlined,
              label: KidsStrings.takePhoto,
              onTap: () =>
                  Navigator.of(context).pop(const PhotoSourceActionResult(PhotoSourceAction.takePhoto)),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SourceRow(
              key: const ValueKey(KidsTestStrings.photoSheetChooseGallery),
              icon: Icons.photo_library_outlined,
              label: KidsStrings.chooseFromGallery,
              onTap: () => Navigator.of(
                context,
              ).pop(const PhotoSourceActionResult(PhotoSourceAction.chooseFromGallery)),
            ),
            if (hasPhoto) ...[
              const SizedBox(height: AppSpacing.sm),
              _SourceRow(
                key: const ValueKey(KidsTestStrings.photoSheetRemovePhoto),
                icon: Icons.delete_outline,
                label: KidsStrings.removeCurrentPhoto,
                color: AppColors.dangerDefault,
                onTap: () => Navigator.of(
                  context,
                ).pop(const PhotoSourceActionResult(PhotoSourceAction.removePhoto)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({super.key, required this.icon, required this.label, required this.onTap, this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.neutralBlack;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (color ?? AppColors.neutralGrey1).withAlpha(color == null ? 255 : 26),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, size: 20, color: tint),
            ),
            AppSpacing.horizontalGapSm,
            Text(label, style: AppTypographyV1.bodyRegular.medium.copyWith(color: tint)),
          ],
        ),
      ),
    );
  }
}
