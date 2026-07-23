import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hs_app_flutter/components/appbar/appbar_base.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class HsAppbar extends AppBarBase {
  /// Internal generative constructor — callers are responsible for resolving [leading].
  const HsAppbar._raw({
    super.key,
    super.leading,
    super.center,
    super.actions,
    super.backgroundColor,
    super.padding,
    super.height,
    super.showBottomBorder,
    super.leadingGap,
  });

  /// SVG back arrow, left-aligned bold title, optional bottom hairline on
  /// [AppColors.baseDefault] background.
  factory HsAppbar({
    Key? key,
    required String title,
    VoidCallback? onLeadingTap,
    Widget? leading,
    List<Widget>? actions,
    bool showBottomBorder = true,
    bool showBackButton = true,
    Key? titleKey,
    Key? backButtonKey,
  }) {
    return HsAppbar._raw(
      key: key,
      leading: leading ?? (showBackButton ? _BackButton(key: backButtonKey, onBack: onLeadingTap) : null),
      center: Text(
        title,
        key: titleKey,
        style: AppTypographyV1.titleMedium.bold.copyWith(color: AppColors.neutralBlack),
      ),
      actions: actions,
      backgroundColor: AppColors.baseDefault,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: null,
      showBottomBorder: showBottomBorder,
      leadingGap: 16,
    );
  }

  /// Only Title (centered), no back button, no actions.
  factory HsAppbar.titleOnly({
    required String title,
    bool showBottomBorder = true,
    Key? titleKey,
  }) {
    return HsAppbar._raw(
      center: Text(
        title,
        key: titleKey,
        style: AppTypographyV1.titleMedium.bold.copyWith(color: AppColors.neutralBlack),
      ),
      backgroundColor: AppColors.baseDefault,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: null,
      showBottomBorder: showBottomBorder,
    );
  }

  /// Left Image + Right Actions, no back button.
  factory HsAppbar.image({required Widget image, List<Widget>? actions}) {
    return HsAppbar._raw(leading: image, actions: actions);
  }

  /// Left Text + Right Actions, with default back button.
  factory HsAppbar.text({
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return HsAppbar._raw(
      leading: showBackButton ? const _DefaultBackButton() : null,
      center: Align(alignment: Alignment.centerLeft, child: Text(title)),
      actions: actions,
    );
  }

  /// Back + Title + Subtitle + Actions.
  factory HsAppbar.withSubtitle({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return HsAppbar._raw(
      leading: showBackButton ? const _DefaultBackButton() : null,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title), if (subtitle != null) Text(subtitle)],
      ),
      actions: actions,
    );
  }
}

class _DefaultBackButton extends StatelessWidget {
  const _DefaultBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.maybePop(context),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback? onBack;

  const _BackButton({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        icon: SvgPicture.asset(ImageConstants.arrowBack),
      ),
    );
  }
}
