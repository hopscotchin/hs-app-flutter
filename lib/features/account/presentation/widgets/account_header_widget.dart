import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/constants/strings/account_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../domain/entities/account_entity.dart';

class AccountHeaderWidget extends StatelessWidget {
  final AccountEntity account;

  const AccountHeaderWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return account.isLoggedIn ? _SignedInHeader(account: account) : const _SignedOutHeader();
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
        AppSpacing.lg,
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
                AppSpacing.verticalGapSm,
                _buildContactRow(),
              ],
            ),
          ),
          AppSpacing.horizontalGapMd,
          // Right: Profile image
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: account.avatarUrl != null && account.avatarUrl!.isNotEmpty
                  ? ClipOval(
                      child: CachedImageWidget(imageUrl: account.avatarUrl!, width: 48, height: 48),
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
      return Text(AuthStrings.doMoreWithAccount, style: AppTypographyV1.labelLarge.textSecondary());
    }

    return Row(
      children: [
        Icon(
          hasPhone ? Icons.phone_android : Icons.alternate_email,
          size: AppSpacing.iconXs,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            hasPhone ? _formattedPhone : account.email!,
            style: AppTypographyV1.labelLarge.textSecondary(),
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
  const _SignedOutHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AccountStrings.heyThere, style: AppTypographyV1.bodyLarge.bold.textPrimary()),
          AppSpacing.verticalGapXs,
          Text(
            AccountStrings.signOutHeaderSubTitle,
            style: AppTypographyV1.bodyRegular.textPrimary(),
          ),
          AppSpacing.verticalGapMd,
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeightLg,
            child: ElevatedButton(
              onPressed: () => AppNavigator.goToLogin(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXs),
                textStyle: AppTypographyV1.bodyLarge.bold,
              ),
              child: const Text(AccountStrings.signIn),
            ),
          ),
          AppSpacing.verticalGapSm,
          Center(
            child: GestureDetector(
              onTap: () => AppNavigator.goToJoinUs(context),
              child: Text.rich(
                TextSpan(
                  text: AccountStrings.newToHopscotch,
                  style: AppTypographyV1.labelMedium.textPrimary(),
                  children: [
                    TextSpan(
                      text: AuthStrings.joinUs,
                      style: AppTypographyV1.labelMedium.bold.brand(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
