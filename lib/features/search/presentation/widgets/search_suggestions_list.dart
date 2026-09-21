import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/search_suggestion_entity.dart';

/// Autosuggest results list — reused by the Search page and Categories'
/// inline search. `<b>` tags in `displayName` (server-highlighted match)
/// render bold; everything else in the default regular weight.
class SearchSuggestionsList extends StatelessWidget {
  const SearchSuggestionsList({
    super.key,
    required this.suggestions,
    required this.onTap,
    required this.itemKey,
  });

  final List<SearchSuggestionEntity> suggestions;
  final ValueChanged<SearchSuggestionEntity> onTap;

  /// Built by the caller from its own screen-scoped automation-key constant,
  /// e.g. `(i) => ValueKey('${SearchTestStrings.suggestionItem}_$i')` — keeps
  /// `tool/generate_automation_keys.dart`'s usage grep able to trace the key
  /// back to a real `<Screen>TestStrings` member.
  final Key Function(int index) itemKey;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      itemCount: suggestions.length,
      separatorBuilder: (_, _) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lgMd),
        child: Divider(height: 1, thickness: 0.8, color: AppColors.border),
      ),
      itemBuilder: (context, index) {
        final s = suggestions[index];
        final raw = s.displayName?.isNotEmpty == true ? s.displayName! : (s.term ?? '');
        if (raw.isEmpty) return const SizedBox.shrink();
        return ListTile(
          key: itemKey(index),
          // Tighten the row's vertical footprint — default ListTile sizing
          // (56px min height + 4px min vertical padding) reads too spaced
          // out for a dense suggestions list.
          visualDensity: VisualDensity.compact,
          minVerticalPadding: AppSpacing.xxxs,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxxs,
          ),
          // Same down-pointing arrow asset as the category accordion's
          // chevron (`ImageConstants.arrowDown`), rotated a quarter turn
          // counter-clockwise to point right, instead of a Material glyph.
          trailing: const RotatedBox(
            quarterTurns: -1,
            child: CustomImage(
              path: ImageConstants.arrowDown,
              width: AppSpacing.iconMd,
              height: AppSpacing.iconMd,
              color: AppColors.neutralGrey5,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Text.rich(
              TextSpan(
                style: AppTypographyV1.bodyRegular.regular.textPrimary(),
                children: _highlightedSpans(raw),
              ),
            ),
          ),
          onTap: () => onTap(s),
        );
      },
    );
  }

  List<TextSpan> _highlightedSpans(String html) {
    final fragment = html_parser.parseFragment(html);
    final spans = <TextSpan>[];
    _appendNodeSpans(fragment.nodes, spans, isBold: false);
    if (spans.isEmpty) spans.add(TextSpan(text: html));
    return spans;
  }

  void _appendNodeSpans(List<dom.Node> nodes, List<TextSpan> out, {required bool isBold}) {
    for (final node in nodes) {
      if (node is dom.Text) {
        if (node.text.isEmpty) continue;
        out.add(
          TextSpan(
            text: node.text,
            // Matched substring is medium weight at the same body/100 size
            // as the rest of the row — not `bodyLarge`, which is a distinct
            // 16px ("H5") token, not a heavier variant of this same size.
            style: isBold ? AppTypographyV1.bodyRegular.medium : null,
          ),
        );
      } else if (node is dom.Element) {
        final descendantsBold = isBold || node.localName == 'b';
        _appendNodeSpans(node.nodes, out, isBold: descendantsBold);
      }
    }
  }
}
