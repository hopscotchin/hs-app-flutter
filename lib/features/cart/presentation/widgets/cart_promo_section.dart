import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/promotion_data_entity.dart';

class CartPromoSection extends StatefulWidget {
  final PromotionDataEntity? promotionData;
  final bool isLoading;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  const CartPromoSection({
    super.key,
    this.promotionData,
    this.isLoading = false,
    required this.onApply,
    required this.onRemove,
  });

  @override
  State<CartPromoSection> createState() => _CartPromoSectionState();
}

class _CartPromoSectionState extends State<CartPromoSection> {
  final _controller = TextEditingController();
  bool _isExpanded = false;

  bool get _isApplied => widget.promotionData?.isApplied == true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColors.dividerLight),
        if (_isApplied)
          _buildAppliedState()
        else if (_isExpanded)
          _buildExpandedInput()
        else
          _buildCollapsedRow(),
        const Divider(height: 1, color: AppColors.dividerLight),
      ],
    );
  }

  Widget _buildCollapsedRow() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.local_offer_outlined,
              size: 22,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.promotionData?.sectionTitle ?? 'Apply promo code',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedState() {
    final promo = widget.promotionData!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.local_offer_outlined,
                size: 22,
                color: AppColors.textPrimary,
              ),
              Positioned(
                left: -3,
                top: -3,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 8, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promo.promoCode ?? '',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (promo.message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      promo.message!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            GestureDetector(
              onTap: widget.onRemove,
              child: const Icon(
                Icons.cancel,
                size: 22,
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 22,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) widget.onApply(value.trim());
              },
            ),
          ),
          const SizedBox(width: 8),
          if (widget.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            TextButton(
              onPressed: () {
                final code = _controller.text.trim();
                if (code.isNotEmpty) widget.onApply(code);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'APPLY',
                style: AppTypography.buttonSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
