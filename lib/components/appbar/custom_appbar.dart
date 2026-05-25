import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/appbar/appbar_base.dart';

class CustomAppbar extends AppBarBase {
  final bool showBackButton;
  final VoidCallback? onBack;

  CustomAppbar({
    super.key,
    Widget? leading,
    super.center,
    super.actions,
    this.showBackButton = true,
    this.onBack,
    super.backgroundColor,
    super.padding,
    super.height,
    super.hasDivider
  }) : super(
         leading: _resolveLeading(
           leading: leading,
           showBackButton: showBackButton,
           onBack: onBack,
         ),
       );

  /// 🔹 1. Only Title (centered)
  factory CustomAppbar.titleOnly({required String title}) {
    return CustomAppbar(
      showBackButton: false,
      center: Center(child: Text(title)),
    );
  }

  /// 🔹 2. Left Image + Right Actions
  factory CustomAppbar.image({required Widget image, List<Widget>? actions}) {
    return CustomAppbar(
      leading: image,
      actions: actions,
      showBackButton: false,
    );
  }

  /// 🔹 3. Left Text + Right Actions
  factory CustomAppbar.text({required String title, List<Widget>? actions}) {
    return CustomAppbar(
      center: Align(alignment: Alignment.centerLeft, child: Text(title)),
      actions: actions,
    );
  }

  /// 🔹 4. Back + Title + Subtitle + Actions
  factory CustomAppbar.withSubtitle({
    required String title,
    String? subtitle,
    List<Widget>? actions,
  }) {
    return CustomAppbar(
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title), if (subtitle != null) Text(subtitle)],
      ),
      actions: actions,
    );
  }

  /// Leading priority resolver
  static Widget? _resolveLeading({
    Widget? leading,
    required bool showBackButton,
    VoidCallback? onBack,
  }) {
    if (leading != null) return leading;

    if (showBackButton) {
      return _DefaultBackButton(onBack: onBack);
    }

    return null;
  }
}

class _DefaultBackButton extends StatelessWidget {
  final VoidCallback? onBack;

  const _DefaultBackButton({this.onBack});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onBack ?? () => Navigator.maybePop(context),
    );
  }
}
