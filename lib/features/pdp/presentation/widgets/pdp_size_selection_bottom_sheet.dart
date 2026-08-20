import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../components/atoms/auto_semantics.dart';
import '../../../../components/buttons/app_button.dart';
import '../../../../components/buttons/button_enums.dart';
import '../../../../components/page_components/price_info_row.dart';
import '../../../../features/plp/domain/entities/product_price_entity.dart';
import '../bloc/pdp_bloc.dart';
import 'pdp_size_chart_bottom_sheet.dart';
import 'pdp_size_selector.dart';

// Design tokens from spec
const _kHandleColor = AppColors.brandDefault;
const _kPriceStripBg = AppColors.borderSecondary; // rgba(109, 89, 215, 0.1)
const _kSellingPriceColor = Color(0xFF333333);
const _kDiscountColor = AppColors.secondary;

void showPdpSizeSelectionBottomSheet(
  BuildContext context, {
  required bool fromBuyNow,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    showDragHandle: false,
    builder: (_) => BlocProvider.value(
      value: context.read<PdpBloc>(),
      // pageContext is the PDP page context — valid after this sheet is popped.
      child: _PdpSizeSelectionBottomSheet(
        fromBuyNow: fromBuyNow,
        pageContext: context,
      ),
    ),
  );
}

class _PdpSizeSelectionBottomSheet extends StatelessWidget {
  const _PdpSizeSelectionBottomSheet({
    required this.fromBuyNow,
    required this.pageContext,
  });

  final bool fromBuyNow;
  final BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdpBloc, PdpState>(
      builder: (context, state) {
        final product = state.productDetail?.product;
        if (product == null) return const SizedBox.shrink();

        final selectedSku = state.selectedSku;
        final effectivePrice = selectedSku?.priceInfo ?? product.priceInfo;

        // Lift the button clear of the system nav/gesture inset so it isn't
        // hidden behind the navigation bar.
        final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg + bottomInset,
          ),
          decoration: const BoxDecoration(
            color: AppColors.baseDefault,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: _kHandleColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: AppSpacing.lgMd),

              // Header: "Select Size" + "Size Chart >"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PdpStrings.selectSize,
                    key: const ValueKey(PdpTestStrings.sizeSheetTitle),
                    style: AppTypographyV1.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (product.hasSizeChart == true)
                    GestureDetector(
                      key: const ValueKey(
                        PdpTestStrings.sizeSheetSizeChartButton,
                      ),
                      onTap: () {
                        AppNavigator.goBack(context);
                        showPdpSizeChartBottomSheet(
                          pageContext,
                          productName: product.name,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            PdpStrings.sizeChart,
                            style: AppTypographyV1.bodyRegular.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: AppSpacing.iconXs,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Size chips grid
              Wrap(
                spacing: 9,
                runSpacing: 12,
                children: [
                  for (int i = 0; i < product.skus.length; i++)
                    PdpSizeChip(
                      key: ValueKey('${PdpTestStrings.sizeSheetChip}_$i'),
                      sku: product.skus[i],
                      isSelected: selectedSku?.skuId == product.skus[i].skuId,
                      onTap:
                          product.skus[i].enable == true &&
                              product.skus[i].skuId != null
                          ? () => context.read<PdpBloc>().add(
                              PdpEvent.selectSku(skuId: product.skus[i].skuId!),
                            )
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Price strip
              if (effectivePrice != null) _PriceStrip(price: effectivePrice),
              const SizedBox(height: AppSpacing.sm),

              // Add to Bag / Buy Now button. Carries the same label as the
              // docked bar's button, so the identifier is what keeps Maestro
              // from resolving the wrong one while the sheet is open.
              AutoSemantics(
                id: PdpTestStrings.sizeSheetConfirmButton,
                child: AppButton(
                  key: const ValueKey(PdpTestStrings.sizeSheetConfirmButton),
                  text: fromBuyNow ? PdpStrings.buyNow : PdpStrings.addToBag,
                  variant: ButtonVariant.primary,
                  isFullWidth: true,
                  state: selectedSku == null
                      ? ButtonState.disabled
                      : ButtonState.enabled,
                  onTap: selectedSku == null
                      ? null
                      : () {
                          AppNavigator.goBack(context);
                          final bloc = context.read<PdpBloc>();
                          final skuId = selectedSku.skuId!;
                          if (fromBuyNow) {
                            bloc.add(PdpEvent.buyNow(skuId: skuId));
                          } else {
                            // The fly-to-cart animation is played by the PDP
                            // page when the add succeeds, not on this tap.
                            bloc.add(PdpEvent.addToBag(skuId: skuId));
                          }
                        },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceStrip extends StatelessWidget {
  const _PriceStrip({required this.price});

  final ProductPriceEntity price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _kPriceStripBg,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: PriceInfoRow(
        price: price,
        sellingPriceKey: const ValueKey(
          PdpTestStrings.sizeSheetSellingPriceText,
        ),
        mrpKey: const ValueKey(PdpTestStrings.sizeSheetMrpText),
        discountKey: const ValueKey(PdpTestStrings.sizeSheetDiscountText),
        mainAxisAlignment: MainAxisAlignment.center,
        sellingPriceFontSize: 16,
        mrpFontSize: 14,
        discountFontSize: 14,
        sellingPriceColor: _kSellingPriceColor,
        discountColor: _kDiscountColor,
      ),
    );
  }
}
