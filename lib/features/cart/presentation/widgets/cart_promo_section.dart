import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';

import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/promotion_data_entity.dart';

/// Promo-code card: offer-code input (prefix icon + "Apply" suffix) over a
/// "See All Offers" link, or an applied-promo summary once a code is active.
class CartPromoSection extends StatefulWidget {
  final PromotionDataEntity? promotionData;
  final bool isLoading;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;
  final VoidCallback? onSeeAllOffers;

  const CartPromoSection({
    super.key,
    this.promotionData,
    this.isLoading = false,
    required this.onApply,
    required this.onRemove,
    this.onSeeAllOffers,
  });

  @override
  State<CartPromoSection> createState() => _CartPromoSectionState();
}

class _CartPromoSectionState extends State<CartPromoSection> {
  static const int _maxCodeLength = 100;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  bool get _isApplied => widget.promotionData?.isApplied == true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void didUpdateWidget(covariant CartPromoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear the typed code once the apply call actually succeeds (promo
    // flips to applied) rather than optimistically on tap — a failed apply
    // (wrong/expired code) leaves the text in place so the user can retry.
    final justApplied = !(oldWidget.promotionData?.isApplied ?? false) && _isApplied;
    if (justApplied) _controller.clear();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _controller.text.trim();
    if (code.isNotEmpty && !widget.isLoading) widget.onApply(code);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutralGrey2, width: 1),
        borderRadius: AppSpacing.borderRadiusMd,
        gradient: const LinearGradient(
          colors: [AppColors.surfaceHighlightAlt, AppColors.surfaceHighlight],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (_isApplied) _buildAppliedState() else _buildOfferCodeField(),
          _buildSeeAllOffersRow(),
        ],
      ),
    );
  }

  // ─── Offer code input ───────────────────────────────────────

  // Top corners only, matching the outer card's radius (12) — the field
  // sits flush against the card with no margin/gap, directly above the
  // "See All Offers" row below (bottom stays square, no gap between them).
  static const _fieldRadius = BorderRadius.only(
    topLeft: Radius.circular(AppSpacing.radiusMd),
    topRight: Radius.circular(AppSpacing.radiusMd),
    bottomLeft: Radius.circular(AppSpacing.radiusSm),
    bottomRight: Radius.circular(AppSpacing.radiusSm),
  );

  Widget _buildOfferCodeField() {
    // The rounded white background is painted here (ClipRRect + ColoredBox)
    // rather than via InputDecoration's border/fill — an OutlineInputBorder
    // always reserves extra layout space for its stroke (even at width: 0),
    // which showed up as a visible border ring and a mismatched radius.
    // No border at all now, so there's nothing to reserve or clip.
    return ClipRRect(
      borderRadius: _fieldRadius,
      child: ColoredBox(
        color: AppColors.whiteColor,
        child: TextFormField(
          key: const ValueKey(CartTestStrings.promoCodeInput),
          controller: _controller,
          focusNode: _focusNode,
          textCapitalization: TextCapitalization.characters,
          // Promo codes are alphanumeric, so whitespace is never valid input.
          // Denying it at the formatter blocks typed *and* pasted spaces, which
          // is stricter than trimming on submit: the field can never hold a
          // value that looks applied but isn't.
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          // Real codes are a handful of characters; the cap is only there to
          // stop a paste of arbitrary length reaching the API. Enforced without
          // `maxLength` so the field doesn't grow a counter under it.
          maxLength: _maxCodeLength,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
          enabled: !widget.isLoading,
          style: AppTypographyV1.bodyRegular.regular.textPrimary(),
          onFieldSubmitted: (_) => _submit(),
          onTapOutside: (_) => _focusNode.unfocus(),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            // `hint` (widget) rather than `hintText` (String) so the placeholder
            // can carry its own automation key, like `OutlinedTextField` does.
            hint: Text(
              CartStrings.enterOfferCode,
              key: const ValueKey(CartTestStrings.promoCodeInputHint),
              style: AppTypographyV1.bodyLarge.regular.copyWith(color: AppColors.neutralGrey5),
            ),
            // prefixIcon/suffixIcon (not prefix/suffix) render unconditionally
            // — `prefix`/`suffix` only reserve space once focused/has text.
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: CustomImage(
                path: ImageConstants.promoOffer,
                width: AppSpacing.iconMd,
                height: AppSpacing.iconMd,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            // The full-screen overlay (CartState.isCartUpdating) already
            // covers apply-in-flight — no need for a second, inline spinner
            // here as well.
            suffixIcon: GestureDetector(
              key: const ValueKey(CartTestStrings.promoApplyButton),
              behavior: HitTestBehavior.opaque,
              onTap: _hasText && !widget.isLoading ? _submit : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  CommonStrings.apply,
                  style: AppTypographyV1.labelLarge.bold.copyWith(
                    color: _hasText ? AppColors.brandPrimary : AppColors.neutralGrey5,
                  ),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // ─── Applied-promo summary ───────────────────────────────────

  Widget _buildAppliedState() {
    final promo = widget.promotionData!;
    final couponText = promo.appliedCouponText ?? '${promo.promoCode ?? ''} ${CartStrings.applied}';
    // toColorOrNull (not toColor): an unparseable backend hex must fall through
    // to the text style's own color rather than becoming transparent/invisible.
    final couponColor = promo.appliedCouponTextColor.toColorOrNull;
    final savingsText =
        promo.savingsText ??
        (promo.discountAmount != null
            ? '${CartStrings.yourSavings} ₹${promo.discountAmount}'
            : null);
    final savingsColor = promo.savingsTextColor.toColorOrNull;

    return ClipRRect(
      borderRadius: _fieldRadius,
      child: ColoredBox(
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lmd),
          // The icon and "Remove" are inflexible, so Row sizes them at their
          // intrinsic width first and "Remove" stays pinned to the right edge.
          // The labels live in an Expanded that soaks up all remaining width:
          // short labels hug the left and the slack shows up as a gap before
          // "Remove"; a long savings string instead wraps onto a second line
          // within that same space rather than overflowing the card.
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomImage(
                path: ImageConstants.promoOffer,
                width: AppSpacing.iconMd,
                height: AppSpacing.iconMd,
              ),
              AppSpacing.horizontalGapXs,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        couponText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypographyV1.labelLarge.regular.textPrimary().copyWith(
                          color: couponColor,
                        ),
                      ),
                    ),
                    if (savingsText != null) ...[
                      AppSpacing.horizontalGapXs,
                      const ColoredBox(
                        color: AppColors.neutralGrey3,
                        child: SizedBox(height: AppSpacing.md, width: 1),
                      ),
                      AppSpacing.horizontalGapXs,
                      Flexible(
                        child: Text(
                          savingsText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypographyV1.labelLarge.bold.linkColor().copyWith(
                            color: savingsColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.horizontalGapXs,
              // Same as the Apply button above — the full-screen overlay
              // already blocks interaction while the remove call is in
              // flight, so this doesn't need its own loading state.
              GestureDetector(
                key: const ValueKey(CartTestStrings.promoRemoveButton),
                behavior: HitTestBehavior.opaque,
                onTap: widget.isLoading ? null : widget.onRemove,
                child: Text(
                  CommonStrings.remove,
                  style: AppTypographyV1.labelLarge.bold.brandPrimary(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── See all offers ──────────────────────────────────────────

  Widget _buildSeeAllOffersRow() {
    return InkWell(
      key: const ValueKey(CartTestStrings.promoSeeAllOffersButton),
      onTap: widget.onSeeAllOffers,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('See All Offers', style: AppTypographyV1.bodyMedium.medium.brandPrimary()),
            const Icon(Icons.arrow_forward, size: 18, color: AppColors.brandPrimary),
          ],
        ),
      ),
    );
  }
}
