import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/config/environment.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';

class AccountFooterWidget extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onSignOut;
  final VoidCallback? onLegal;
  final VoidCallback? onSignIn;

  const AccountFooterWidget({
    super.key,
    required this.isLoggedIn,
    this.onSignOut,
    this.onLegal,
    this.onSignIn
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.neutralGrey6,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
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
              ),
            Row(
              children: [
                // Hopscotch logo
                SvgPicture.asset(
                  ImageConstants.hsFullLogoWhite,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                // Version text
                Expanded(
                  child: Center(
                    child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final info = snapshot.data!;
                        final versionText = EnvironmentConfig.isDebug
                            ? '${AccountStrings.appVerison} ${info.version} ${info.buildNumber}'
                            : '${AccountStrings.appVerison} ${info.version}';
                        return Text(
                          versionText,
                          style: AppTypographyV1.bodyLarge.regular.copyWith(
                            color: AppColors.neutralGrey0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Legal link
                GestureDetector(
                  onTap: onLegal ?? () {},
                  child: Text(
                    AccountStrings.legal,
                    style: AppTypographyV1.bodyLarge.bold.copyWith(
                      color: AppColors.neutralGrey0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
