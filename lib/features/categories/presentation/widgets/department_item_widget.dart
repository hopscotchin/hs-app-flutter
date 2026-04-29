import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/department_entity.dart';

class DepartmentItemWidget extends StatelessWidget {
  final DepartmentEntity department;
  final VoidCallback? onTap;

  const DepartmentItemWidget({super.key, required this.department, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.listItemPadding,
        child: Row(
          children: [
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Text(department.label, style: AppTypography.titleSmall),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
