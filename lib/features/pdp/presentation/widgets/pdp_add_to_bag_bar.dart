import 'package:flutter/material.dart';

import '../../../../components/atoms/auto_semantics.dart';
import '../../../../components/buttons/app_button.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

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

  ButtonState _stateFor({required bool loading}) {
    if (loading) return ButtonState.loading;
    if (soldOut || _isLoading) return ButtonState.disabled;
    return ButtonState.enabled;
  }

  @override
  Widget build(BuildContext context) {
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
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 37.7,
              offset: Offset(0, 25),
            ),
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
                  text: soldOut ? PdpStrings.soldOut : PdpStrings.buyNow,
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
