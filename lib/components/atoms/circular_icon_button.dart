import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

class CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool showShadow;

  const CircleIconButton({
    super.key,
    required this.onTap,
    required this.child,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: AppColors.neutralBlack.withAlpha(50),
                    blurRadius: 7,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
