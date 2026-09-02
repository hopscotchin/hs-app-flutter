import 'package:flutter/material.dart';

import '../../../../components/atoms/auto_semantics.dart';
import '../../../../components/buttons/app_button.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../core/utils/text_fit.dart';

class PdpAddToBagBar extends StatelessWidget {
  final bool soldOut;
  final bool isAddingToBag;
  final bool isBuyingNow;
  final bool isAddedToBag;
  final VoidCallback onAddToBag;
  final VoidCallback onBuyNow;
  final Key? addToBagKey;
  final Key? buyNowKey;

  const PdpAddToBagBar({
    super.key,
    this.soldOut = false,
    this.isAddingToBag = false,
    this.isBuyingNow = false,
    this.isAddedToBag = false,
    required this.onAddToBag,
    required this.onBuyNow,
    this.addToBagKey,
    this.buyNowKey,
  });

  bool get _isLoading => isAddingToBag || isBuyingNow;

  /// The style AppButton would use for a medium button's label, mirrored here
  /// so the labels can be measured before they are built. Must track
  /// AppButton._textStyle (bodyLarge.semiBold, 16px).
  static TextStyle get _ctaBaseStyle => AppTypographyV1.bodyLarge.semiBold;

  /// Every label either CTA can show. Both buttons are sized to the widest of
  /// the whole set, which is what makes them equal to each other AND keeps the
  /// bar's width fixed when the state flips — sizing to the live label would
  /// shrink the pill on add-to-bag ("Go To Bag" is 77.3px against "Add To Bag"'s
  /// 85.6px) and visibly re-centre it under the user's finger.
  ///
  /// To try a longer label, change the string in PdpStrings: both the
  /// measurement and the button read it from there, so they cannot disagree.
  static const List<String> _ctaLabels = [
    PdpStrings.buyNow,
    PdpStrings.addToBag,
    PdpStrings.goToBag,
  ];

  /// A hair of width beyond what the label measures, per button.
  ///
  /// Sizing a box to exactly its label's measured width leaves nothing for
  /// sub-pixel disagreement between measurement and paint, and Text ellipsises
  /// on any overflow at all — so the widest label, the only one whose box has no
  /// slack, was the only one that got cut.
  static const double _labelSlack = 2;

  /// Fixed width the bar spends regardless of the labels: the 6px frame on each
  /// side, the 6px gap between the buttons, and AppButton's own 20px of hugging
  /// padding plus the slack on both sides of each of the two labels.
  static const double _barChrome = 6 * 2 + 6 + (AppSpacing.lgMd * 2) * 2 + _labelSlack * 2;

  /// Least gap left between the bar and the screen edge in the extreme case
  /// where the labels are long enough that the bar would otherwise overflow.
  static const double _minScreenMargin = 24;

  ButtonState _stateFor({required bool loading}) {
    if (loading) return ButtonState.loading;
    if (soldOut || _isLoading) return ButtonState.disabled;
    return ButtonState.enabled;
  }

  @override
  Widget build(BuildContext context) {
    // The bar takes only the width its two labels need, and no more — no side
    // padding, no fixed 296, no equal halves. Each button hugs its own label at
    // AppButton's design padding, so nothing is ever squeezed and the labels sit
    // at their spec size in every ordinary case.
    return Center(
      child: Container(
        width: 296,
        height: PdpStrings.addToBagBarHeight,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.baseDefault,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: const Color(0xFFF6F6F6)),
          boxShadow: const [
            BoxShadow(color: Color(0x05000000), blurRadius: 37.7, offset: Offset(0, 25)),
          ],
        ),
        child: Row(
          children: [
            // Buy Now — light purple
            Expanded(
              child: AutoSemantics.fromKey(
                buyNowKey,
                child: AppButton(
                  key: buyNowKey,
                  // Label stays "Buy Now" whatever the inventory — sold out
                  // is communicated by the disabled state, not by swapping the
                  // CTA out for a different one.
                  text: PdpStrings.buyNow,
                  variant: ButtonVariant.tertiary,
                  isFullWidth: true,
                  state: _stateFor(loading: isBuyingNow),
                  onTap: onBuyNow,
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Add to Bag — dark purple filled
            Expanded(
              child: AutoSemantics.fromKey(
                addToBagKey,
                child: AppButton(
                  key: addToBagKey,
                  text: isAddedToBag ? PdpStrings.goToBag : PdpStrings.addToBag,
                  variant: ButtonVariant.primary,
                  isFullWidth: true,
                  state: _stateFor(loading: isAddingToBag),
                  onTap: onAddToBag,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
