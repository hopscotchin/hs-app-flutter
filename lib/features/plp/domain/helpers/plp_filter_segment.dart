import '../../../../core/analytics/constants/analytics_properties.dart';
import '../entities/filter_entity.dart';
import '../entities/filter_section_entity.dart';

/// Builds the dynamic filter block on `filter_applied`.
///
/// Ports `FilterItemSelectionHelper` (`features/.../plpfilters/ui/helpers/`),
/// which is where Android assembles five properties out of the selected filter
/// leaves. The subtlety worth knowing before touching this file: **the four
/// list/count properties apply four different exclusion rules to the same
/// selection.** They are not variations on one filtered list, and lining them
/// up "for consistency" would change what analytics receives:
///
/// | Property | Rule | Android |
/// |---|---|---|
/// | `<section>_filter` | no exclusions at all | `setSegmentEventList` `:372` |
/// | `filter_section` | excludes `subcategory` + `product_type`, keeps attributes | `setFilterSection` `:349` |
/// | `filter_section_count` | same two exclusions, plus an is-empty check | `setFilterSectionCount` `:291` |
/// | `filter_attribute` | attributes only, and only with a non-empty section name | `setFilterAttribute` `:330` |
/// | `filter_attribute_count` | attributes only, **no** name check | `setFilterAttributeCount` `:312` |
///
/// The last two disagreeing is why `filter_attribute_count` can legitimately
/// exceed `filter_attribute.length`. That is Android behaviour, mirrored here
/// rather than corrected, so the two platforms report identically.
///
/// `non_preorder_filter` is **not** built here — it arrives in the page-level
/// `trackingMeta` blob from the backend.
class PlpFilterSegment {
  PlpFilterSegment._();

  /// Sections whose selections are excluded from `filter_section` and its
  /// count. Note these are `sectionTracking` values, not filter keys, and that
  /// `subcategory` is one word — the only multi-word analytics property that
  /// breaks the underscore pattern.
  static const Set<String> _sectionExclusions = {'subcategory', 'product_type'};

  /// Suffix Android appends to a section's tracking name to form the dynamic
  /// property key: `department` → `department_filter`.
  static const String _filterSuffix = '_filter';

  static const String _sectionTrackingKey = 'sectionTracking';
  static const String _isAttributeKey = 'isAttribute';

  /// Builds the segment from the response's own filter tree, reading the
  /// `isSelected` leaves rather than the applied-params map, so the analytics
  /// name (`sectionTracking`) and `isAttribute` come straight from the backend.
  ///
  /// Walks the tree to full depth: a category selection sits at level 1 and a
  /// product-type selection at level 3, each carrying its own section name.
  static Map<String, Object?> build(List<FilterSectionEntity> sections) {
    final selected = <PlpSelectedLeaf>[];
    for (final section in sections) {
      // filterList holds group wrappers whose children are the real leaves;
      // the recursive walk covers both without special-casing the wrapper.
      _collectSelected(section.filterList, selected);
    }
    return buildFromLeaves(selected);
  }

  /// Test seam, and the shape any future selected-filters source maps into.
  static Map<String, Object?> buildFromLeaves(List<PlpSelectedLeaf> selected) {
    if (selected.isEmpty) return const {};

    // Per-section value lists, insertion-ordered. No exclusions — every
    // selected leaf reports under its own `<section>_filter` key.
    final bySection = <String, List<String>>{};
    for (final leaf in selected) {
      if (leaf.sectionTracking.isEmpty || leaf.label.isEmpty) continue;
      bySection.putIfAbsent(leaf.sectionTracking, () => <String>[]).add(leaf.label);
    }

    final props = <String, Object?>{};
    for (final entry in bySection.entries) {
      props['${entry.key}$_filterSuffix'] = entry.value;
    }

    // filter_section: distinct section names, minus the two exclusions.
    // Attributes are NOT excluded here, so an attribute filter appears in both
    // filter_section and filter_attribute.
    final sectionNames = bySection.keys
        .where((name) => !_sectionExclusions.contains(name))
        .toList();
    if (sectionNames.isNotEmpty) {
      props[AnalyticsProperties.filterSection] = sectionNames;
      props[AnalyticsProperties.filterSectionCount] = sectionNames.length;
    }

    // filter_attribute: attribute leaves that actually have a section name.
    final attributeValues = selected
        .where((l) => l.isAttribute && l.sectionTracking.isNotEmpty && l.label.isNotEmpty)
        .map((l) => l.label)
        .toSet()
        .toList();
    if (attributeValues.isNotEmpty) {
      props[AnalyticsProperties.filterAttribute] = attributeValues;
    }

    // filter_attribute_count: every attribute leaf, name or not. Deliberately
    // a different population from the list above.
    final attributeCount = selected.where((l) => l.isAttribute).length;
    if (attributeCount > 0) {
      props[AnalyticsProperties.filterAttributeCount] = attributeCount;
    }

    return props;
  }

  static void _collectSelected(
    List<FilterEntity> filters,
    List<PlpSelectedLeaf> into,
  ) {
    for (final filter in filters) {
      if (filter.isSelected) {
        final meta = filter.trackingMeta;
        into.add(
          PlpSelectedLeaf(
            label: filter.label ?? '',
            sectionTracking: meta?[_sectionTrackingKey] is String
                ? meta![_sectionTrackingKey] as String
                : '',
            isAttribute: meta?[_isAttributeKey] == true,
          ),
        );
      }
      // Children are independent selections, not alternatives to the parent —
      // a user can pick a category *and* a product type under it, and both
      // report.
      if (filter.filters.isNotEmpty) _collectSelected(filter.filters, into);
    }
  }
}

/// One selected filter leaf, reduced to what analytics needs.
class PlpSelectedLeaf {
  const PlpSelectedLeaf({
    required this.label,
    required this.sectionTracking,
    required this.isAttribute,
  });

  final String label;
  final String sectionTracking;
  final bool isAttribute;
}
