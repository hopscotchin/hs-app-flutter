import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

class CartCheckoutBar extends StatelessWidget {
  final int itemCount;
  final int totalAmount;
  final bool isLoading;
  final VoidCallback? onCheckout;

  const CartCheckoutBar({
    super.key,
    required this.itemCount,
    required this.totalAmount,
    this.isLoading = false,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.paddingOf(context).bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.container,
        border: Border(top: BorderSide(color: AppColors.dividerLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '\u20B9${_formatIndian(totalAmount)}',
                style: AppTypography.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Text(
                      'PROCEED TO CHECKOUT',
                      style: AppTypography.buttonSmall.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formats a number in Indian numbering system (e.g. 4293 → 4,293).
  static String _formatIndian(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return str;
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formatted = rest.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (match) => '${match[1]},',
    );
    return '$formatted,$lastThree';
  }
}
