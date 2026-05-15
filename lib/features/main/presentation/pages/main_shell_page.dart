import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../../../components/badge_icon.dart';
import '../../../../core/constants/image_constants.dart';
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
        height: 60,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
        decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(2, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          child: Row(
            children: List.generate(5, (index) {
              final isSelected = navigationShell.currentIndex == index;
              const icons = [
                ImageConstants.discover,
                ImageConstants.categories,
                ImageConstants.studio,
                ImageConstants.profile,
                ImageConstants.bag,
              ];
              const labels = [
                'Home',
                'Categories',
                'Studio',
                'Profile',
                'Cart',
              ];
              final iconColor = isSelected
                  ? AppColors.primary
                  : AppColors.secondaryInActive;
              // Studio is a brand logo — preserve its original colors
              final svgIcon = SvgPicture.asset(
                icons[index],
                width: 20,
                height: 20,
                colorFilter: index == 2
                    ? null
                    : ColorFilter.mode(iconColor, BlendMode.srcIn),
              );
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
                    height: 52,
                    decoration: isSelected
                        ? BoxDecoration(
                      color: AppColors.secondaryExtra,
                      borderRadius: BorderRadius.circular(8),
                    )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //need to use bloc builder with particular value to show the count not the context.watch because it listens to the entire cart changes
                        if (index == 4)
                          BadgeIcon(
                            count: 2,
                            child: svgIcon,
                          )
                        else
                          svgIcon,
                        const SizedBox(height: 6.0),
                        Text(
                          labels[index],
                          style: AppTypography.labelSmall.copyWith(
                            color: iconColor,
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
