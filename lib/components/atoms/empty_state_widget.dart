import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../buttons/app_button.dart';
import '../buttons/button_enums.dart';

// ─── Type enum ────────────────────────────────────────────────────────────────

enum EmptyStateType {
  // ── Empty states ──────────────────────────────
  wishlist,
  cart,
  search,
  orders,
  plp,
  discover,
  generic,
  addAddresss,
  kidsProfile,
  offers,
  payments,

  // ── Error states ──────────────────────────────
  serverError,
  networkError,
  notFound,
}

// ─── Internal config per type ────────────────────────────────────────────────

class _EmptyStateConfig {
  final String icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final (double, double) iconSize;

  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    required this.iconSize,
  });
}

const _configs = <EmptyStateType, _EmptyStateConfig>{
  EmptyStateType.wishlist: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/empty_wishlist.svg',
    title: 'Your Wishlist Is Empty!',
    subtitle: 'Heart your fave styles to save them for later!',
    buttonLabel: 'Wishlist NOW',
    iconSize: (60, 40),
  ),
  EmptyStateType.cart: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/empty_bag.svg',
    title: 'Your Empty Bag Needs Some Love',
    subtitle: 'Time to start your next style haul.',
    buttonLabel: 'Start Shopping',
    iconSize: (60, 40),
  ),
  EmptyStateType.search: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/search.svg',
    title: 'No Matches Found',
    subtitle: 'Try a different keyword to uncover more styles.',
    buttonLabel: 'Search Again',
    iconSize: (60, 40),
  ),
  EmptyStateType.orders: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/empty_bag.svg',
    title: 'No Orders Placed Yet',
    subtitle: 'Browse the latest styles and start your haul!',
    buttonLabel: 'Shop Now',
    iconSize: (60, 40),
  ),
  EmptyStateType.plp: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/plp_no_product_found.svg',
    title: 'Oops! Nothing Here',
    subtitle: 'Try fewer filters and keep exploring.',
    iconSize: (64, 40),
    buttonLabel: 'Show All Products',
  ),
  EmptyStateType.discover: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/plp_no_product_found.svg',
    title: 'Oops! Nothing Here',
    subtitle: 'Looks like there\'s nothing to show yet.',
    iconSize: (64, 40),
    buttonLabel: 'Try Again',
  ),
  EmptyStateType.generic: _EmptyStateConfig(
    icon: '',
    title: 'Nothing Here!',
    subtitle: "Looks like there's nothing to show yet.",
    iconSize: (60, 40),
  ),
  EmptyStateType.addAddresss: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/add_address.svg',
    title: 'Help Us Find You',
    subtitle: 'Your next order is waiting for an address.',
    buttonLabel: 'Add Address',
    iconSize: (60, 40),
  ),
  EmptyStateType.kidsProfile: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/kids_profile.svg',
    title: 'Tell Us About Your Li’l Ones',
    subtitle: "We'll help you find their next fave styles.",
    buttonLabel: 'Add kids\' profile',
    iconSize: (60, 40),
  ),
  EmptyStateType.payments: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/no_payment_details.svg',
    title: 'No Payment Details Saved',
    subtitle: "Add your preferred payment method, and you're all set.",
    buttonLabel: 'Add Details',
    iconSize: (60, 40),
  ),
  EmptyStateType.offers: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/no_offers.svg',
    title: 'Oops! No Offers Right Now',
    subtitle: 'Hop back later for exciting deals!',
    buttonLabel: 'Keep Shopping',
    iconSize: (60, 40),
  ),

  // ── Error configs ────────────────────────────────────────────────────────
  EmptyStateType.serverError: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/server_error.svg',
    title: 'Oops! Something Went Wrong',
    subtitle: 'We\'re fixing things behind the scenes.',
    buttonLabel: 'Try Again',
    iconSize: (81, 62),
  ),
  EmptyStateType.networkError: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/no_network.svg',
    title: 'Opps! No Network!',
    subtitle: 'Check your connection to hop back in!',
    buttonLabel: 'Try Again',
    iconSize: (81, 62),
  ),
  EmptyStateType.notFound: _EmptyStateConfig(
    icon: 'assets/icons/empty_states/not_found.svg',
    title: 'Page Not Found!',
    subtitle: "We couldn't find what you were looking for.",
    buttonLabel: 'Go Back',
    iconSize: (81, 62),
  ),
};

// ─── Widget ───────────────────────────────────────────────────────────────────

/// Reusable empty-state screen component.
///
/// Usage — type-driven (all copy & icon come from [EmptyStateType]):
/// ```dart
/// EmptyStateWidget(
///   type: EmptyStateType.wishlist,
///   onButtonTap: () => context.go('/home'),
/// )
/// ```
///
/// Usage — fully custom (type is optional as a base; any param overrides it):
/// ```dart
/// EmptyStateWidget(
///   icon: Icon(Icons.error_outline, size: 56, color: AppColors.dangerDefault),
///   title: 'Something went wrong',
///   subtitle: 'Please try again later.',
///   buttonLabel: 'Retry',
///   onButtonTap: onRetry,
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// Optional base type — provides default icon, title, subtitle and button
  /// label.  Any of the explicit params below will override the type default.
  final EmptyStateType? type;

  /// Custom icon widget.  When provided, overrides the type default.
  /// Typically an [Icon] or [Image]; rendered inside the grey circle.
  final Widget? icon;

  /// Override title text.
  final String? title;

  /// Override subtitle / description text.
  final String? subtitle;

  /// Button label.  Pass an empty string or omit to hide the button entirely.
  /// Overrides the type default.
  final String? buttonLabel;

  /// Callback for the primary button.
  final VoidCallback? onButtonTap;

  /// Outer horizontal padding (default: [AppSpacing.xl] = 32 dp).
  final EdgeInsets padding;

  /// Automation keys (null → unkeyed; each caller passes its own screen keys).
  final Key? titleKey;
  final Key? subtitleKey;
  final Key? buttonKey;

  const EmptyStateWidget({
    super.key,
    this.type,
    this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    this.titleKey,
    this.subtitleKey,
    this.buttonKey,
  }) : assert(
         type != null || (title != null && subtitle != null),
         'Provide either a type or explicit title + subtitle.',
       );

  // ── Resolve values (explicit param wins over type default) ────────────────

  _EmptyStateConfig? get _config => type != null ? _configs[type!] : null;

  Widget get _resolvedIcon => _config?.icon.isNotNullOrEmpty ?? false
      ? CustomImage(path: _config!.icon, height: _config!.iconSize.$2, width: _config!.iconSize.$1)
      : const Icon(Icons.inbox_outlined, size: 56, color: AppColors.brandDefault);

  String get _resolvedTitle => title ?? _config?.title ?? '';

  String get _resolvedSubtitle => subtitle ?? _config?.subtitle ?? '';

  /// `null`  → use type default (may also be null → no button).
  /// `''`    → explicitly hide the button.
  /// any str → show that label.
  String? get _resolvedButtonLabel {
    if (buttonLabel != null) return buttonLabel!.isEmpty ? null : buttonLabel;
    return _config?.buttonLabel;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIconAvatar(child: _resolvedIcon),
            const SizedBox(height: 30),
            Text(
              _resolvedTitle,
              key: titleKey,
              style: AppTypographyV1.bodyLarge.bold.neutralGrey6(),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapSm,
            Text(
              _resolvedSubtitle,
              key: subtitleKey,
              style: AppTypographyV1.bodySmall.medium.neutralGrey6(),
              textAlign: TextAlign.center,
            ),
            if (_resolvedButtonLabel != null) ...[
              const SizedBox(height: 30),
              AppButton(
                key: buttonKey,
                text: _resolvedButtonLabel!,
                variant: ButtonVariant.primary,
                isFullWidth: true,
                size: ButtonSize.medium,
                onTap: onButtonTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Circle avatar ────────────────────────────────────────────────────────────

class _CircleIconAvatar extends StatelessWidget {
  final Widget child;

  const _CircleIconAvatar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142,
      height: 142,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.neutralGrey2),
      alignment: Alignment.center,
      child: child,
    );
  }
}
