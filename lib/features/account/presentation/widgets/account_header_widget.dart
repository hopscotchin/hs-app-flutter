import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class AccountHeaderWidget extends StatelessWidget {

  const AccountHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignedOutHeader();
  }
}

/// Header shown when user is logged in.
/// Displays "Hey" + name, phone/email, and profile image.
class _SignedInHeader extends StatelessWidget {

  const _SignedInHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
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
                  'Hey',
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Hello',
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGapSm,
              ],
            ),
          ),
          AppSpacing.horizontalGapMd,
          // Right: Profile image
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary,
              child: Text(
                      "Hello",
                      style: AppTypography.headlineLarge.copyWith(
                        fontWeight: AppTypography.semiBold,
                        color: AppColors.onPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
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
          Text(
            'Hey there!',
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: AppTypography.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalGapXs,
          Text(
            'Sign in or join to do a lot more with your Hopscotch account',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
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
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusXs,
                ),
                textStyle: AppTypography.buttonMedium,
              ),
              child: const Text('SIGN IN'),
            ),
          ),
          AppSpacing.verticalGapSm,
          Center(
            child: GestureDetector(
              onTap: () => AppNavigator.goToJoinUs(context),
              child: Text.rich(
                TextSpan(
                  text: 'New to Hopscotch?  ',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Join us',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: AppTypography.semiBold,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
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
