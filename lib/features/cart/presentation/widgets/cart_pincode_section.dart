import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../pincode/presentation/widgets/pincode_bottom_sheet.dart';
import '../../domain/entities/delivery_pincode_entity.dart';

class CartPincodeSection extends StatelessWidget {
  final DeliveryPincodeEntity? pincode;
  final ValueChanged<String>? onPincodeSelected;

  const CartPincodeSection({
    super.key,
    this.pincode,
    this.onPincodeSelected,
  });

  Future<void> _openSheet(BuildContext context) async {
    final result = await PincodeBottomSheet.show(context);
    if (result != null && context.mounted) {
      onPincodeSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pincode == null ||
        (pincode!.pincode == null && pincode!.city == null)) {
      return const SizedBox.shrink();
    }

    final prefix = pincode!.pincodeMessage ?? 'Deliver to';
    final formattedPincode = _formatPincode(pincode!.pincode);
    final displayText = [
      if (pincode!.city != null) pincode!.city!,
      if (formattedPincode != null) formattedPincode,
    ].join(' - ');

    return Column(
      children: [
        const Divider(height: 1, color: AppColors.dividerLight),
        InkWell(
          onTap: () => _openSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 22,
                  color: AppColors.textPrimary,
                ),
                AppSpacing.horizontalGapLMd,
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '$prefix ',
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: displayText,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.dividerLight),
      ],
    );
  }

  /// Formats a 6-digit pincode with a space: "520015" → "520 015".
  String? _formatPincode(String? pincode) {
    if (pincode == null) return null;
    final digits = pincode.replaceAll(RegExp(r'\s'), '');
    if (digits.length == 6) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    }
    return pincode;
  }
}
