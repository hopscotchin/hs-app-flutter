import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Dark charcoal footer bar: [Logo]  App version x.x.x  [LEGAL]
class AccountFooterWidget extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onSignOut;
  final VoidCallback? onLegal;

  const AccountFooterWidget({
    super.key,
    required this.isLoggedIn,
    this.onSignOut,
    this.onLegal,
  });

  static const _footerBg = Color(0xFF3C3C3C);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign Out button — only when logged in
        if (isLoggedIn)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeightMd,
              child: OutlinedButton(
                onPressed: onSignOut ?? () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusXs,
                  ),
                  foregroundColor: AppColors.primary,
                  textStyle: AppTypography.buttonMedium,
                ),
                child: const Text('SIGN OUT'),
              ),
            ),
          ),

        // Dark footer bar
        Container(
          color: _footerBg,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Hopscotch logo
                SvgPicture.asset(
                  'assets/images/hslogo.svg',
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                AppSpacing.horizontalGapSm,
                // Version text
                Expanded(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      final info = snapshot.data!;
                      return Text(
                        'App version ${info.version} ${info.buildNumber}',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                ),
                // Legal link
                GestureDetector(
                  onTap: onLegal ?? () {},
                  child: Text(
                    'LEGAL',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      letterSpacing: AppTypography.letterSpacingWider,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
