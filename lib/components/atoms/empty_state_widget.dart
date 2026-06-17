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
  generic,

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
    icon: '',
    title: 'Your Wishlist Is Empty!',
    subtitle: 'Heart your fave styles to save them for later!',
    buttonLabel: 'Wishlist NOW',
    iconSize: (60, 40),
  ),
  EmptyStateType.cart: _EmptyStateConfig(
    icon: '',
    title: 'Your Bag Is Empty!',
    subtitle: "Looks like you haven't added anything yet.",
    buttonLabel: 'Shop NOW',
    iconSize: (60, 40),
  ),
  EmptyStateType.search: _EmptyStateConfig(
    icon: '',
    title: 'No Results Found!',
    subtitle: 'Try a different search or browse our categories.',
    iconSize: (60, 40),
  ),
  EmptyStateType.orders: _EmptyStateConfig(
    icon: '',
    title: 'No Orders Yet!',
    subtitle: 'Your order history will show up here.',
    buttonLabel: 'Shop NOW',
    iconSize: (60, 40),
  ),
  EmptyStateType.plp: _EmptyStateConfig(
    icon: 'assets/icons/plp_no_product_found.svg',
    title: 'Oops! Nothing Here',
    subtitle: 'Try fewer filters and keep exploring.',
    iconSize: (64, 40),
    buttonLabel: 'Show All Products',
  ),
  EmptyStateType.generic: _EmptyStateConfig(
    icon: '',
    title: 'Nothing Here!',
    subtitle: "Looks like there's nothing to show yet.",
    iconSize: (60, 40),
  ),

  // ── Error configs ────────────────────────────────────────────────────────
  EmptyStateType.serverError: _EmptyStateConfig(
    icon: 'assets/icons/no_network.svg',
    title: 'Something went wrong',
    subtitle:
        'We\'re having trouble loading this information right now. Please try again in a moment.',
    buttonLabel: 'Try Again',
    iconSize: (81, 62),
  ),
  EmptyStateType.networkError: _EmptyStateConfig(
    icon: 'assets/icons/no_network.svg',
    title: 'No Internet Connection!',
    subtitle: 'Please check your connection and try again.',
    buttonLabel: 'Try Again',
    iconSize: (81, 62),
  ),
  EmptyStateType.notFound: _EmptyStateConfig(
    icon: 'assets/icons/not_found.svg',
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

  const EmptyStateWidget({
    super.key,
    this.type,
    this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
            const SizedBox(height: 40),
            Text(
              _resolvedTitle,
              style: AppTypographyV1.bodyLarge.bold.neutralGrey6(),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapLg,
            Text(
              _resolvedSubtitle,
              style: AppTypographyV1.bodySmall.medium.neutralGrey6(),
              textAlign: TextAlign.center,
            ),
            if (_resolvedButtonLabel != null) ...[
              const SizedBox(height: 40),
              AppButton(
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
