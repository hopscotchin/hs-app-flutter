import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart';

import '../../../../components/badge_icon.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 66,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(2, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: List.generate(5, (index) {
              final isSelected = navigationShell.currentIndex == index;
              final icons = [
                Icons.home_outlined,
                Icons.category_outlined,
                Icons.camera_alt_outlined,
                Icons.person_outline,
                Icons.shopping_bag_outlined,
              ];
              final activeIcons = [
                Icons.home,
                Icons.category,
                Icons.camera_alt,
                Icons.person,
                Icons.shopping_bag,
              ];
              final labels = [
                'Home',
                'Categories',
                'Moments',
                'Account',
                'Cart',
              ];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 49,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxxs,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: AppColors.secondaryExtra,
                            borderRadius: BorderRadius.circular(50),
                          )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //need to use bloc builder with particular value to show the count not the context.watch because it listens to the entire cart changes
                        if (index == 4)
                          BadgeIcon(
                            icon: isSelected
                                ? activeIcons[index]
                                : icons[index],
                            iconSize: 20,
                            count: 2,
                            iconColor: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          )
                        else
                          Icon(
                            isSelected ? activeIcons[index] : icons[index],
                            size: 20,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          labels[index],
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
