import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../auth/presentation/widgets/auth_footer_link_row.dart';
import '../../domain/entities/account_entity.dart';

class AccountHeaderWidget extends StatelessWidget {
  final AccountEntity account;
  final VoidCallback? onForgetMe;

  const AccountHeaderWidget({super.key, required this.account, this.onForgetMe});

  @override
  Widget build(BuildContext context) {
    return account.isLoggedIn
        ? _SignedInHeader(account: account)
        : _SignedOutHeader(account: account, onForgetMe: onForgetMe);
  }
}

/// Header shown when user is logged in.
/// Displays "Hey" + name, phone/email, and profile image.
class _SignedInHeader extends StatelessWidget {
  final AccountEntity account;

  const _SignedInHeader({required this.account});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lgMd,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Greeting + contact info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AccountStrings.hey} ${account.name ?? ''}',
                  style: AppTypographyV1.bodyLarge.bold.textPrimary(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGapMd,
                _buildContactRow(),
              ],
            ),
          ),
          AppSpacing.horizontalGapMd,
          // Right: Profile image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: account.avatarUrl != null && account.avatarUrl!.isNotEmpty
                  ? Border.all(color: AppColors.borderSecondary)
                  : null,
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: account.avatarUrl != null && account.avatarUrl!.isNotEmpty
                  ? CachedImageWidget(
                      imageUrl: account.avatarUrl!,
                      width: 48,
                      height: 48,
                      borderRadius: BorderRadius.circular(24),
                    )
                  : Text(
                      _initials,
                      style: AppTypographyV1.titleMedium.semiBold.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow() {
    final hasPhone = account.phone != null && account.phone!.isNotEmpty;
    final hasEmail = account.email != null && account.email!.isNotEmpty;

    if (!hasPhone && !hasEmail) {
      return Text(AuthStrings.doMoreWithAccount, style: AppTypographyV1.labelLarge.textSeconday());
    }

    return Row(
      children: [
        SvgPicture.asset(
          ImageConstants.accountMobileIcon,
          width: AppSpacing.iconXs,
          height: AppSpacing.iconXs,
          colorFilter: const ColorFilter.mode(AppColors.neutralGrey5, BlendMode.srcIn),
        ),
        AppSpacing.horizontalGapSm,
        Flexible(
          child: Text(
            hasPhone ? _formattedPhone : account.email!,
            style: AppTypographyV1.labelLarge.medium.copyWith(color: AppColors.neutralGrey5),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String get _formattedPhone {
    final phone = account.phone!;
    if (phone.length == 10) {
      return '+91 ${phone.substring(0, 5)} ${phone.substring(5, 10)}';
    }
    return phone;
  }

  String get _initials {
    final name = account.name ?? '';
    if (name.isEmpty) return 'G';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

/// Header shown when user is NOT logged in.
/// "Hey there!" greeting, sign-in message, SIGN IN button, Join us link.
class _SignedOutHeader extends StatelessWidget {
  final AccountEntity account;
  final VoidCallback? onForgetMe;

  const _SignedOutHeader({required this.account, this.onForgetMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lgMd,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AccountStrings.heyThere, style: AppTypographyV1.bodyLarge.bold.textPrimary()),
          AppSpacing.verticalGapSm,
          Text(
            AccountStrings.signOutHeaderSubTitle,
            style: AppTypographyV1.labelLarge.regular.textPrimary(),
          ),
          AppSpacing.verticalGapLgMd,
          SizedBox(
            width: double.infinity,
            height: AppSpacing.xxl,
            child: TextButton(
              onPressed: () => AppNavigator.goToLogin(context),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXs),
                textStyle: AppTypographyV1.bodyLarge.bold,
              ),
              child: const Text(AccountStrings.signIn),
            ),
          ),
          if (account.hasGuestData) ...[
            AppSpacing.verticalGapSm,
            SizedBox(
              width: double.infinity,
              height: AppSpacing.xxl,
              child: OutlinedButton(
                onPressed: onForgetMe,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXs),
                  foregroundColor: AppColors.primary,
                  textStyle: AppTypographyV1.bodyRegular.semiBold,
                  backgroundColor: AppColors.container,
                ),
                child: Text(AccountStrings.forgetMe, style: AppTypographyV1.bodyLarge.bold.brand()),
              ),
            ),
            AppSpacing.verticalGapSm,
            Center(
              child: Text(
                AccountStrings.eraseMessage,
                style: AppTypographyV1.labelMedium.regular.textPrimary(),
              ),
            ),
          ],
          AppSpacing.verticalGapLgMd,
          AuthFooterLinkRow(
            promptText: AuthStrings.newToHopscotch,
            actionLabel: AuthStrings.joinUs.toUpperCase(),
            onActionTap: () => AppNavigator.goToJoinUs(context),
          ),
        ],
      ),
    );
  }
}
