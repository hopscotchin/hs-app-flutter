import 'package:flutter/material.dart';
// import 'package:hs_app_flutter/components/atoms/app_toggle_switch.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../../../core/constants/strings/address_pincode_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/address_entity.dart';

enum AddressListMode { normal, checkout, cart }

class AddressItemCard extends StatelessWidget {
  const AddressItemCard({
    super.key,
    required this.address,
    this.onEdit,
    this.onRemove,
    this.mode = AddressListMode.normal,
    this.isSelected = false,
    this.onSelect,
    this.onSetDefault,
    this.isSettingDefault = false,
  });

  final AddressEntity address;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;
  final AddressListMode mode;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onSetDefault;
  final bool isSettingDefault;

  @override
  Widget build(BuildContext context) {
    final isSelectable = mode != AddressListMode.normal;
    final isDisabled = !address.isServicable;
    // final canSetDefault = address.isServicable && !address.isDefault;

    final nameStyle = isDisabled
        ? AppTypographyV1.bodyRegular.bold.neutralGrey4()
        : AppTypographyV1.bodyRegular.bold.textPrimary();

    final detailStyle = isDisabled
        ? AppTypographyV1.labelLarge.medium.neutralGrey4().copyWith(
            leadingDistribution: TextLeadingDistribution.even,
          )
        : AppTypographyV1.labelLarge.medium.textSecondary().copyWith(
            leadingDistribution: TextLeadingDistribution.even,
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.name, style: nameStyle),
        const SizedBox(height: 10),

        RichText(
          text: TextSpan(
            text: address.displayAddress,
            style: detailStyle.copyWith(height: 1.3),
            children: [
              TextSpan(text: '\n${address.allMobiles}', style: detailStyle.copyWith(height: 2)),
            ],
          ),
        ),

        if (isDisabled) ...[const SizedBox(height: 10), const _NonServiceableChip()],
        // if (canSetDefault) ...[
        //   AppSpacing.verticalGapSm,
        //   _SetDefaultToggle(
        //     onTap: onSetDefault,
        //     isLoading: isSettingDefault,
        //   ),
        // ],
        if (!isSelectable) ...[
          const SizedBox(height: 7),
          Row(
            children: [
              _ActionLabel(label: AddressStrings.edit, onTap: onEdit),
              AppSpacing.horizontalGapMd,
              _ActionLabel(label: AddressStrings.remove, onTap: onRemove),
            ],
          ),
        ],
      ],
    );

    if (!isSelectable) {
      return Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 20), child: content);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isDisabled ? null : onSelect,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SelectionRadio(selected: isSelected, isDisabled: isDisabled),
            AppSpacing.horizontalGapSm,
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _ActionLabel extends StatelessWidget {
  const _ActionLabel({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: AppTypographyV1.labelLarge.medium.copyWith(color: AppColors.secondaryLight),
      ),
    );
  }
}

// class _SetDefaultToggle extends StatelessWidget {
//   const _SetDefaultToggle({required this.onTap, this.isLoading = false});

//   final VoidCallback? onTap;
//   final bool isLoading;

//   @override
//   Widget build(BuildContext context) {
//     final handler = isLoading ? null : onTap;
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: handler,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AppToggleSwitch(
//             value: false,
//             onChanged: handler == null ? null : (_) => handler(),
//           ),
//           AppSpacing.horizontalGapXs,
//           Flexible(
//             child: Text(
//               AddressStrings.setAsDefault,
//               style: AppTypographyV1.labelLarge.medium.textSecondary(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _NonServiceableChip extends StatelessWidget {
  const _NonServiceableChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.onInfo, borderRadius: BorderRadius.circular(4)),
      child: Text(
        AddressStrings.nonServiceable,
        style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
      ),
    );
  }
}

class _SelectionRadio extends StatelessWidget {
  const _SelectionRadio({required this.selected, this.isDisabled = false});

  final bool selected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDisabled
        ? AppColors.neutralGrey4
        : selected
        ? AppColors.secondary
        : AppColors.neutralGrey5;
    final showDot = isDisabled || selected;
    final dotColor = isDisabled ? AppColors.neutralGrey4 : AppColors.secondary;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.8),
      ),
      child: showDot
          ? Center(
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
            )
          : null,
    );
  }
}
