import 'package:flutter/material.dart';

import '../../core/analytics/home/home_component_click_handlers.dart';
import '../../core/analytics/home/home_track_analytic_manager.dart';
import '../../core/constants/image_constants.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../core/di/injection.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/custom_image.dart';

/// Shared timing for the chevron flip and the expand/collapse panel size, so
/// the icon and the panel it controls move in lockstep.
const Duration _kAccordionAnimationDuration = Duration(milliseconds: 200);
const Curve _kAccordionAnimationCurve = Curves.easeInOut;

/// Renders one Categories-tab row from a `CategoryAccordion` component, and
/// recursively any nested `subCategory` rows to arbitrary depth. Leaf rows
/// (`tile.isNested == false`) navigate directly on tap; nested rows
/// (`subCategory` non-empty) expand in place to reveal their children, which
/// are themselves rendered the same way — so a `subCategory` entry that is
/// itself nested (e.g. SETS → Skirt Sets → Skirt Sets 1/2/3) expands in turn.
class CategoryAccordionWidget extends StatelessWidget {
  const CategoryAccordionWidget({
    super.key,
    required this.accordionData,
    required this.isExpanded,
    required this.onToggleExpand,
    this.keyPrefix,
    this.onTapLog,
  });

  final CategoryAccordionData accordionData;

  /// Whether this section's root row is expanded. Owned by the ancestor that
  /// lays out sibling sections (e.g. the Categories page), so only one
  /// section is expanded at a time.
  final bool isExpanded;

  /// Toggles [isExpanded] in the owning ancestor.
  final VoidCallback onToggleExpand;

  /// Component-level automation key prefix, e.g. `categories_ca_2`. Null → unkeyed.
  final String? keyPrefix;

  /// Fires when a row, at any depth, is tapped and actually navigates.
  final void Function(CategoryAccordionTile tile)? onTapLog;

  void _logTap(CategoryAccordionTile tile) {
    final override = onTapLog;
    if (override != null) {
      override(tile);
      return;
    }
    sl<HomeTrackAnalyticManager>().onCategoryAccordionTapped(
      accordionData,
      tile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tile = accordionData.tile;
    if (tile == null || (tile.title ?? '').isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AccordionNode(
          tile: tile,
          depth: 0,
          ownKey: keyPrefix == null
              ? null
              : '${keyPrefix}_${HomeComponentTestStrings.accordionRow}',
          childKeyBase: keyPrefix,
          onTap: _logTap,
          isExpanded: isExpanded,
          onToggleExpand: onToggleExpand,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Divider(
            height: 1,
            thickness: 0.8,
            color: AppColors.neutralGrey2,
          ),
        ),
      ],
    );
  }
}

/// One row of a `CategoryAccordion` tree, at any depth. Whether *this* node
/// is expanded is controlled by its parent (so siblings can enforce
/// one-at-a-time expansion); it separately owns which one of its own
/// `subCategory` children is expanded, for the same reason one level down.
class _AccordionNode extends StatefulWidget {
  const _AccordionNode({
    required this.tile,
    required this.depth,
    required this.ownKey,
    required this.childKeyBase,
    required this.onTap,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final CategoryAccordionTile tile;
  final int depth;

  /// Automation key for this node's own tappable row. Null → unkeyed.
  final String? ownKey;

  /// Base automation-key prefix children compose their own `ownKey`/
  /// `childKeyBase` from, e.g. `hp_ca_8` at depth 0 → children key
  /// `hp_ca_8_sub_0`, whose own children key `hp_ca_8_sub_0_sub_0`.
  final String? childKeyBase;

  final void Function(CategoryAccordionTile tile) onTap;

  /// Whether this node's own row is expanded, decided by the parent that
  /// lays out this node's siblings.
  final bool isExpanded;

  /// Toggles [isExpanded] in the parent.
  final VoidCallback onToggleExpand;

  @override
  State<_AccordionNode> createState() => _AccordionNodeState();
}

class _AccordionNodeState extends State<_AccordionNode> {
  // Index into `tile.subCategory` of the one child currently expanded, so
  // only one direct child is ever open at a time. Lives here (not on the
  // children themselves) because it's a property of the set of siblings,
  // not of any one child.
  int? _expandedChildIndex;

  Key? _valueKey(String? value) => value == null ? null : ValueKey(value);

  @override
  Widget build(BuildContext context) {
    final tile = widget.tile;
    final nested = tile.isNested;
    final expanded = widget.isExpanded;

    if (!nested) {
      return _row(
        title: tile.title ?? '',
        onTap: () {
          widget.onTap(tile);
          ActionUrlHandler.navigate(context, tile.actionUri);
        },
        key: _valueKey(widget.ownKey),
      );
    }

    final header = _row(
      title: tile.title ?? '',
      // The asset points down natively (0 turns); collapsed rotates it -90°
      // (counter-clockwise) to point right instead, then back to 0 (down)
      // once expanded.
      trailingIcon: Icons.keyboard_arrow_down,
      rotationTurns: expanded ? 0 : -0.25,
      // Slightly darker while expanded, the usual light tertiary tone
      // otherwise — color carries the expanded/collapsed state, not just the
      // glyph. Halfway between tertiary and secondary so it stays subtle
      // rather than jumping straight to the darker secondary tone.
      iconColor: expanded
          ? AppColors.neutralGrey6
          : AppColors.neutralGrey5,
      onTap: widget.onToggleExpand,
      key: _valueKey(widget.ownKey),
    );

    // A parent wraps its own children — leaf or nested alike — in one shaded
    // sub-panel, inset from the screen edges. The panel's shade is keyed off
    // the children's depth (1 → light, 2+ → darker), so a 3-level branch
    // (e.g. SETS → Skirt Sets → Skirt Sets 1/2/3) reads as two visually
    // distinct tiers instead of the same shade repeating at every level; a
    // 2-level branch (e.g. a single flat child) still gets the tier-1 shade
    // instead of no shading at all.
    final childDepth = widget.depth + 1;
    // Built only while expanded — collapsing swaps this subtree out for the
    // zero-height box below, discarding descendant _AccordionNode state, so a
    // later re-expand starts each grandchild fresh rather than remembering
    // which one was open. Both branches fix width to the full available
    // width so AnimatedSize below only ever animates height (top-to-bottom
    // reveal) instead of also animating width from the collapsed state's
    // natural zero-width size.
    Widget panel = const SizedBox(width: double.infinity, height: 0);
    if (expanded) {
      final children = Column(
        children: [
          for (var i = 0; i < tile.subCategory.length; i++)
            Builder(
              builder: (context) {
                final childKey = widget.childKeyBase == null
                    ? null
                    : '${widget.childKeyBase}_${HomeComponentTestStrings.accordionSubCategory}_$i';
                return _AccordionNode(
                  tile: tile.subCategory[i],
                  depth: childDepth,
                  ownKey: childKey,
                  childKeyBase: childKey,
                  onTap: widget.onTap,
                  isExpanded: _expandedChildIndex == i,
                  onToggleExpand: () => setState(() {
                    _expandedChildIndex = _expandedChildIndex == i ? null : i;
                  }),
                );
              },
            ),
        ],
      );

      panel = SizedBox(
        width: double.infinity,
        child: Container(
          // Left-only inset — the right edge stays flush with the header's,
          // so every level's trailing chevron lines up in the same column
          // instead of creeping left as the panel's own margin compounds.
          margin: EdgeInsets.only(left: childDepth == 1 ? AppSpacing.sm : AppSpacing.xs),
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: childDepth == 1
                ? AppColors.neutralGrey1
                : AppColors.neutralGrey2,
          ),
          child: children,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        ClipRect(
          child: AnimatedSize(
            duration: _kAccordionAnimationDuration,
            curve: _kAccordionAnimationCurve,
            alignment: Alignment.topCenter,
            child: panel,
          ),
        ),
      ],
    );
  }

  Widget _row({
    required String title,
    required VoidCallback onTap,
    Key? key,
    bool showChevron = true,
    IconData trailingIcon = Icons.chevron_right,
    Color iconColor = AppColors.textTertiary,
    double rotationTurns = 0,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xsm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(title, style: AppTypographyV1.bodyRegular.regular),
            ),
            if (showChevron)
              AnimatedRotation(
                turns: rotationTurns,
                duration: _kAccordionAnimationDuration,
                curve: _kAccordionAnimationCurve,
                child: trailingIcon == Icons.keyboard_arrow_down
                    ? CustomImage(
                        path: ImageConstants.arrowDown,
                        width: AppSpacing.iconMd,
                        height: AppSpacing.iconMd,
                        color: iconColor,
                      )
                    : Icon(trailingIcon, color: iconColor),
              ),
          ],
        ),
      ),
    );
  }
}
