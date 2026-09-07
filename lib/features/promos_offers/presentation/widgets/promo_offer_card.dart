import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/dotted_border_box.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../domain/entities/promo_offer_entity.dart';

class PromoOfferCard extends StatelessWidget {
  /// Roughly what one card occupies, for loading shimmers that stand in for it.
  /// Cards are content-sized, so this is an estimate: the code badge floors the
  /// height at 76 (52 min badge + 12 padding top/bottom), and most offers add a
  /// savings pill on top of that.
  static const double approxHeight = 96;

  const PromoOfferCard({
    super.key,
    required this.offer,
    this.onApply,
    this.onRemove,
    this.onAction,
    this.onViewTerms,
    this.isBusy = false,
    this.isLocked = false,
    this.codeKey,
    this.titleKey,
    this.descriptionKey,
    this.validityKey,
    this.savingsKey,
    this.applyButtonKey,
    this.removeButtonKey,
    this.termsKey,
    this.ctaKey,
    this.savingsTextFromCart,
  });

  final PromoOfferEntity offer;
  final VoidCallback? onApply;
  final VoidCallback? onRemove;

  /// Tap on the backend-driven CTA ([PromoOfferEntity.actionLabel] /
  /// [PromoOfferEntity.actionUri]). Rendered only when [onAction] is non-null.
  final VoidCallback? onAction;
  final VoidCallback? onViewTerms;

  /// This card's own apply/remove is in flight — show a loader on its button.
  final bool isBusy;

  /// Another card's action is in flight — dim this one so only one promo can
  /// be mutated at a time.
  final bool isLocked;

  // Automation keys — composed by the caller so they carry the offer's index
  // (offer list) or the screen slug (details page).
  final Key? codeKey;
  final Key? titleKey;
  final Key? descriptionKey;
  final Key? validityKey;
  final Key? savingsKey;
  final Key? applyButtonKey;
  final Key? removeButtonKey;
  final Key? termsKey;
  final Key? ctaKey;
  final String? savingsTextFromCart;

  bool get _enabled => offer.isApplicable;

  /// No apply/remove handler means the card is informational (the details page
  /// renders it that way), so it drops the action button entirely rather than
  /// showing a dead one.
  bool get _isReadOnly => onApply == null && onRemove == null;

  ButtonState get _buttonState {
    if (isBusy) return ButtonState.loading;
    if (isLocked) return ButtonState.disabled;
    return ButtonState.enabled;
  }

  Color get _textColor => AppColors.neutralBlack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.neutralGrey1,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (offer.showCodeBadge) ...[
              _CodeBadge(key: codeKey, code: offer.code),
              AppSpacing.horizontalGapXs,
            ],
            Expanded(child: _details(context)),
            if (!_isReadOnly) ...[AppSpacing.horizontalGapXs, _actionButton()],
          ],
        ),
      ),
    );
  }

  Widget _details(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offer.title,
          key: titleKey,
          style: AppTypographyV1.bodySmall.bold.copyWith(color: _textColor),
        ),
        if (offer.description.isNotEmpty || offer.showTerms) ...[
          AppSpacing.verticalGapXxxs,
          Text.rich(
            key: descriptionKey,
            TextSpan(
              text: offer.description,
              style: AppTypographyV1.labelLarge.regular.copyWith(
                color: _textColor,
              ),
              children: [
                if (offer.showTerms) ...[
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      key: termsKey,
                      onTap: onViewTerms,
                      child: Text(
                        offer.termsText!,
                        style: AppTypographyV1.labelLarge.medium.brandPrimary(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (offer.showValidity) ...[
          Text(
            offer.validityText!,
            key: validityKey,
            style: AppTypographyV1.labelLarge.regular.copyWith(
              color: _textColor,
            ),
          ),
        ],
        if (offer.showSavings) ...[const SizedBox(height: 6), _savingsRow()],
        if (onAction != null) ...[AppSpacing.verticalGapXxs, _ctaLink()],
      ],
    );
  }

  Widget _savingsRow() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.brandSecondary.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_offer_outlined,
              size: AppSpacing.iconXs,
              color: AppColors.brandSecondary,
            ),
            AppSpacing.horizontalGapXxs,
            Text(
              savingsTextFromCart.isNotNullOrEmpty
                  ? savingsTextFromCart ?? ''
                  : offer.savingsText ?? '',
              key: savingsKey,
              style: AppTypographyV1.labelLarge.semiBold.linkColor(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaLink() {
    return GestureDetector(
      key: ctaKey,
      onTap: onAction,
      behavior: HitTestBehavior.opaque,
      child: Text.rich(
        TextSpan(
          text: offer.actionLabel!,
          style: AppTypographyV1.labelLarge.semiBold.linkColor(),
          children: const [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.chevron_right,
                size: AppSpacing.iconXs,
                color: AppColors.linkDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton() {
    if (!_enabled) {
      return SecondaryButton.inactive(
        key: applyButtonKey,
        text: CommonStrings.apply,
        size: ButtonSize.small,
      );
    }
    if (offer.isApplied) {
      return SecondaryButton.defaultType(
        key: removeButtonKey,
        text: CommonStrings.remove,
        size: ButtonSize.small,
        state: _buttonState,
        onTap: onRemove,
      );
    }
    return SecondaryButton.defaultType(
      key: applyButtonKey,
      text: CommonStrings.apply,
      size: ButtonSize.small,
      state: _buttonState,
      onTap: onApply,
    );
  }
}

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({super.key, required this.code});

  static const double _width = 54;
  static const double _minHeight = 52;

  final String code;

  @override
  Widget build(BuildContext context) {
    const borderColor = AppColors.brandSecondary;
    final bgColor = AppColors.brandSecondary.withAlpha(0x1A);
    const textColor = AppColors.brandPrimary;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: _width,
        maxWidth: _width,
        minHeight: _minHeight,
      ),
      child: DottedBorderBox(
        color: borderColor,
        child: ColoredBox(
          color: bgColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: AppTypographyV1.labelLarge.bold.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
