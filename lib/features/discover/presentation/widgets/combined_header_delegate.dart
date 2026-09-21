import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/cubits/cart_count_cubit.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';

import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/constants/strings/search_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';

class CombinedHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Toolbar slot height shared by every host (Home, Categories, Search) so
  /// the logo/wishlist/bag row renders identically across all three.
  static const double defaultToolbarHeight = 80.0;

  const CombinedHeaderDelegate({
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabTapped,
    required this.toolbarHeight,
    required this.tabsHeight,
    this.bgImageUrl,
    this.isImageDark = false,
    // Categories/Search reuse this same header for the logo/icon row but
    // don't want the gender filter strip — set false to collapse it
    // entirely (not just render it empty, which would still reserve space).
    this.showFilters = true,
    this.showSearchBar = false,
    this.searchPlaceholder,
    this.onSearchTap,
    // Inline "search mode" — swaps the static placeholder bar for a real,
    // editable text field with a back arrow. Off by default so Home (which
    // always navigates to a separate Search page on tap) is unaffected.
    this.searchActive = false,
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchBack,
    this.onSearchClear,
    this.searchInputKey,
    this.searchBackButtonKey,
    this.searchClearButtonKey,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onTabTapped;
  final double toolbarHeight;
  final double tabsHeight;
  final String? bgImageUrl;
  final bool isImageDark;
  final bool showFilters;
  final bool showSearchBar;
  final String? searchPlaceholder;
  final VoidCallback? onSearchTap;
  final bool searchActive;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchBack;
  final VoidCallback? onSearchClear;
  final Key? searchInputKey;
  final Key? searchBackButtonKey;
  final Key? searchClearButtonKey;

  static const double _searchBarHeight = 56;

  double get _tabsSlotHeight => showFilters ? tabsHeight : 0;
  double get _searchSlotHeight => showSearchBar ? _searchBarHeight : 0;

  @override
  double get minExtent => _searchSlotHeight + _tabsSlotHeight;

  @override
  double get maxExtent => toolbarHeight + _searchSlotHeight + _tabsSlotHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = (shrinkOffset / toolbarHeight).clamp(0.0, 1.0);

    return ClipRect(
      child: Stack(
        children: [
          if (bgImageUrl != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: maxExtent,
              child: CachedImageWidget(imageUrl: bgImageUrl!),
            )
          else
            const Positioned.fill(child: ColoredBox(color: AppColors.baseDefault)),
          // Skip the app-bar layer once it's fully collapsed — at t == 1.0 the
          // Opacity would otherwise allocate an offscreen buffer to render a
          // fully-transparent subtree every scroll frame.
          if (t < 1.0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: toolbarHeight,
              child: Transform.translate(
                offset: Offset(0, -shrinkOffset),
                child: Opacity(
                  opacity: 1.0 - t,
                  child: _AppBarContent(isImageDark: isImageDark),
                ),
              ),
            ),
          if (showSearchBar)
            Positioned(
              bottom: _tabsSlotHeight,
              left: 0,
              right: 0,
              height: _searchBarHeight,
              child: searchActive
                  ? _HeaderSearchInput(
                      controller: searchController!,
                      focusNode: searchFocusNode,
                      hint: searchPlaceholder,
                      onBack: onSearchBack,
                      onChanged: onSearchChanged,
                      onSubmitted: onSearchSubmitted,
                      onClear: onSearchClear,
                      inputKey: searchInputKey,
                      backButtonKey: searchBackButtonKey,
                      clearButtonKey: searchClearButtonKey,
                    )
                  : _HeaderSearchBar(
                      placeholder: searchPlaceholder,
                      onTap: onSearchTap,
                    ),
            ),
          if (showFilters)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: tabsHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.neutralBlack.withValues(alpha: 0.03),
                    ),
                  ),
                ),
                // Reserve the strip height before sortingOptions arrive so the
                // tabs slot doesn't pop into existence and shove content down.
                // RepaintBoundary so the tab strip's paint layer isn't redrawn
                // on every scroll frame (the persistent header rebuilds for the
                // app-bar fade — the tabs themselves don't change with scroll).
                child: labels.isEmpty
                    ? const SizedBox.shrink()
                    : RepaintBoundary(
                        child: _TabsRow(
                          labels: labels,
                          selectedIndex: selectedIndex,
                          onTabSelected: onTabSelected,
                          onTabTapped: onTabTapped,
                          isImageDark: isImageDark,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(CombinedHeaderDelegate old) {
    if (old.bgImageUrl != bgImageUrl) return true;
    if (old.isImageDark != isImageDark) return true;
    if (old.selectedIndex != selectedIndex) return true;
    if (old.showFilters != showFilters) return true;
    if (old.showSearchBar != showSearchBar) return true;
    if (old.searchPlaceholder != searchPlaceholder) return true;
    if (old.searchActive != searchActive) return true;
    if (old.labels.length != labels.length) return true;
    for (int i = 0; i < labels.length; i++) {
      if (old.labels[i] != labels[i]) return true;
    }
    return false;
  }
}

class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar({this.placeholder, this.onTap});

  final String? placeholder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hint = (placeholder ?? '').isNotEmpty ? placeholder! : SearchStrings.searchHintText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgMd, vertical: AppSpacing.xs),
      child: InkWell(
        key: const ValueKey(CategoriesTestStrings.searchBar),
        borderRadius: AppSpacing.borderRadiusXs,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xsm),
          decoration: BoxDecoration(
            color: AppColors.baseDefault,
            border: Border.all(color: AppColors.dividerLight),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Row(
            children: [
              SvgPicture.asset(ImageConstants.searchIcon, width: 20, height: 20),
              AppSpacing.horizontalGapXs,
              Expanded(
                child: Text(
                  hint,
                  key: const ValueKey(CategoriesTestStrings.searchBarHint),
                  style: AppTypographyV1.bodyRegular.regular.disabled(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSearchInput extends StatelessWidget {
  const _HeaderSearchInput({
    required this.controller,
    this.focusNode,
    this.hint,
    this.onBack,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.inputKey,
    this.backButtonKey,
    this.clearButtonKey,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hint;
  final VoidCallback? onBack;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Fires after the clear button empties [controller] — dispatch a
  /// bloc `ClearQuery` (or equivalent) here.
  final VoidCallback? onClear;
  final Key? inputKey;
  final Key? backButtonKey;
  final Key? clearButtonKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.lgMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        decoration: BoxDecoration(
          color: AppColors.baseDefault,
          border: Border.all(color: AppColors.dividerLight),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Row(
          children: [
            IconButton(
              key: backButtonKey,
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            Expanded(child: _field()),
          ],
        ),
      ),
    );
  }

  Widget _field() {
    final node = focusNode;
    if (node == null) return _textField(hideHint: false);
    return ListenableBuilder(
      listenable: node,
      builder: (context, _) => _textField(hideHint: node.hasFocus),
    );
  }

  Widget _textField({required bool hideHint}) {
    final hintText = (hint ?? '').isNotEmpty ? hint! : 'Search for products, brands and more';
    return TextField(
      key: inputKey,
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: AppTypographyV1.bodyRegular.regular.textPrimary(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        // Hidden while focused (even with no text yet) so the hint never
        // overlaps the caret — the outer Container's grey border is the only
        // visible border in every state; the theme's purple `focusedBorder`
        // is explicitly overridden below so it never shows here.
        hintText: hideHint ? null : hintText,
        hintStyle: AppTypographyV1.bodyRegular.regular.disabled(),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xsm),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              key: clearButtonKey,
              icon: const Icon(Icons.close, size: 20, color: AppColors.primary),
              onPressed: () {
                controller.clear();
                onClear?.call();
              },
            );
          },
        ),
      ),
    );
  }
}

class _TabsRow extends StatelessWidget {
  const _TabsRow({
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabTapped,
    required this.isImageDark,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onTabTapped;
  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final activeFg = isImageDark ? AppColors.brandDefault : AppColors.textPrimary;
    final inactiveFg = isImageDark ? AppColors.secondaryExtra : AppColors.neutralGrey5;
    final activeBg = isImageDark ? AppColors.baseDefault : AppColors.secondaryExtra;

    final clamped = selectedIndex.clamp(0, labels.length - 1);

    // Hoist per-build invariants out of the generate loop so we allocate
    // each style/decoration once instead of per segment.
    final activeStyle = AppTypographyV1.bodyLarge.bold.copyWith(color: activeFg);
    final inactiveStyle = AppTypographyV1.bodyLarge.regular.copyWith(color: inactiveFg);
    final activePillDecoration = BoxDecoration(
      color: activeBg,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    );

    // Listener catches every pointer-up — including re-taps on the currently
    // selected segment, which SegmentedButton.onSelectionChanged ignores —
    // so the scroll-to-top affordance still works.
    return Listener(
      onPointerUp: (_) => onTabTapped(),
      child: SegmentedButton<int>(
        segments: List<ButtonSegment<int>>.generate(labels.length, (i) {
          final isSelected = i == clamped;
          return ButtonSegment<int>(
            value: i,
            // Render the pill inside the label so it hugs the text rather than
            // filling the equal-width segment. Centered so the strip reads as
            // a single balanced row.
            label: Align(
              alignment: Alignment.center,
              child: Container(
                key: ValueKey(
                  '${HomeComponentTestStrings.homePage}_${HomeComponentTestStrings.tab}_$i',
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: isSelected ? activePillDecoration : null,
                child: Text(labels[i], style: isSelected ? activeStyle : inactiveStyle),
              ),
            ),
          );
        }),
        selected: <int>{clamped},
        showSelectedIcon: false,
        expandedInsets: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        onSelectionChanged: (Set<int> selection) {
          if (selection.isNotEmpty) onTabSelected(selection.first);
        },
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.transparent),
          overlayColor: WidgetStatePropertyAll(AppColors.transparent),
          side: WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({this.isImageDark = false});

  final bool isImageDark;

  @override
  Widget build(BuildContext context) {
    final svgFilter = isImageDark
        ? const ColorFilter.mode(AppColors.baseDefault, BlendMode.srcIn)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          RepaintBoundary(
            child: SvgPicture.asset(
              ImageConstants.hsLogo,
              height: 50,
              placeholderBuilder: (_) => const SizedBox(height: 46),
            ),
          ),
          const Spacer(),
          GestureDetector(
            key: const ValueKey(
              '${HomeComponentTestStrings.homePage}_${HomeComponentTestStrings.wishlistButton}',
            ),
            onTap: () => AppNavigator.goToWishlistGated(
              context,
              fromScreen: FromScreens.discover,
            ),
            child: RepaintBoundary(
              child: SvgPicture.asset(
                ImageConstants.heart,
                height: 20,
                width: 20,
                colorFilter: svgFilter,
                placeholderBuilder: (_) => const SizedBox(height: 20, width: 20),
              ),
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            key: const ValueKey(
              '${HomeComponentTestStrings.homePage}_${HomeComponentTestStrings.cartButton}',
            ),
            onTap: () => AppNavigator.goToCart(
              context,
              sourcePage: const SourcePage(
                fromScreen: FromScreens.discover,
                fromLocation: FromLocations.cartIconButton,
              ),
            ),
            child: BadgeIcon(
              count: context.watch<CartCountCubit>().state,
              icon: SvgPicture.asset(
                ImageConstants.bag,
                height: 20,
                width: 20,
                colorFilter: svgFilter,
                placeholderBuilder: (_) => const SizedBox(height: 20, width: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
