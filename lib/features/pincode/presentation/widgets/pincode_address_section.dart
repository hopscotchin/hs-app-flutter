import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../../address/presentation/widgets/address_item_card.dart';

class PincodeAddressSection extends StatelessWidget {
  const PincodeAddressSection({
    super.key,
    required this.title,
    required this.addresses,
    required this.selectedAddressId,
    required this.onSelect,
    this.topSpacing = 28,
  });

  final String title;
  final List<AddressEntity> addresses;
  final int? selectedAddressId;
  final ValueChanged<int> onSelect;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.md, topSpacing, AppSpacing.md, AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTypographyV1.labelLarge.bold.textPrimary(),
              ),
              AppSpacing.horizontalGapXs,
              const Expanded(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.dividerLight,
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < addresses.length; i++) ...[
          AddressItemCard(
            address: addresses[i],
            mode: AddressListMode.checkout,
            isSelected: addresses[i].id == selectedAddressId,
            onSelect: () => onSelect(addresses[i].id),
          ),
          if (i != addresses.length - 1) ...[
            const Divider(
              height: 1,
              color: AppColors.dividerLight,
              indent: 16,
              endIndent: 16,
            ),
            AppSpacing.verticalGapLgMd,
          ],
        ],
      ],
    );
  }
}