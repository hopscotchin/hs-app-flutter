import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';

/// Dark charcoal footer bar: [Logo]  App version x.x.x  [LEGAL]
class AccountFooterWidget extends StatelessWidget {
  final bool isLoggedIn;
  final bool? hasGuestData;
  final VoidCallback? onSignOut;
  final VoidCallback? onLegal;
  final VoidCallback? onForgetMe;
  final VoidCallback? onSignIn;

  const AccountFooterWidget({
    super.key,
    required this.isLoggedIn,
    this.hasGuestData,
    this.onSignOut,
    this.onLegal,
    this.onForgetMe,
    this.onSignIn
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.neutralGrey6,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoggedIn)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
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
                        textStyle: AppTypographyV1.bodyRegular.semiBold,
                        backgroundColor: AppColors.container,
                      ),
                      child: const Text(AuthStrings.signOut),
                    ),
                  ),
                )
              else if (hasGuestData == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeightMd,
                        child: ElevatedButton(
                          onPressed: onSignIn ?? () {},
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusXs,
                            ),
                            foregroundColor: AppColors.container,
                            textStyle: AppTypographyV1.bodyRegular.semiBold,
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(AccountStrings.signIn),
                        ),
                      ),
                      AppSpacing.verticalGapSm,
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.buttonHeightMd,
                        child: OutlinedButton(
                          onPressed: onForgetMe ?? () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusXs,
                            ),
                            foregroundColor: AppColors.primary,
                            textStyle: AppTypographyV1.bodyRegular.semiBold,
                            backgroundColor: AppColors.container,
                          ),
                          child: Text(
                            AccountStrings.forgetMe,
                            style: AppTypographyV1.bodyRegular.semiBold.brand(),
                          ),
                        ),
                      ),
                      AppSpacing.verticalGapSm,
                      Text(
                        AccountStrings.eraseMessage,
                        style: AppTypographyV1.labelLarge.neutralGrey0(),
                      ),
                      AppSpacing.verticalGapSm,
                      const Divider(height: 1, color: AppColors.neutralGrey0,)
                    ],
                  ),
                ),
              Row(
                children: [
                  // Hopscotch logo
                  SvgPicture.asset(
                    ImageConstants.hsFullLogoWhite,
                    height: AppSpacing.iconLg,
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
                          '${AccountStrings.appVerison} ${info.version} ${info.buildNumber}',
                          style: AppTypographyV1.bodyRegular.copyWith(
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
                      AccountStrings.legal,
                      style: AppTypographyV1.bodyRegular.semiBold.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
