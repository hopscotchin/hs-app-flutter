import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/filter_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/filter_section_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/helpers/plp_filter_segment.dart';

PlpSelectedLeaf _leaf(
  String label,
  String section, {
  bool isAttribute = false,
}) => PlpSelectedLeaf(
  label: label,
  sectionTracking: section,
  isAttribute: isAttribute,
);

FilterEntity _f(
  String label, {
  bool selected = false,
  String? section,
  bool isAttribute = false,
  List<FilterEntity> children = const [],
}) => FilterEntity(
  label: label,
  isSelected: selected,
  filters: children,
  trackingMeta: section == null
      ? null
      : {'sectionTracking': section, 'isAttribute': isAttribute},
);

void main() {
  group('dynamic <section>_filter keys', () {
    test('names the key from sectionTracking, not the query param', () {
      // The Gender section is `browse` on the wire but `department` in
      // analytics — getting this wrong yields browse_filter.
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
      ]);

      expect(props['department_filter'], ['Boys']);
      expect(props.containsKey('browse_filter'), isFalse);
    });

    test('groups multiple values of one section into a single list', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
        _leaf('Girls', 'department'),
      ]);

      expect(props['department_filter'], ['Boys', 'Girls']);
    });

    test('emits one key per section when several are selected', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
        _leaf('Red', 'colour'),
      ]);

      expect(props['department_filter'], ['Boys']);
      expect(props['colour_filter'], ['Red']);
    });

    test('applies no exclusions — subcategory gets its own key even though '
        'it is excluded from filter_section', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Tops', 'subcategory'),
      ]);

      expect(props['subcategory_filter'], ['Tops']);
      expect(props.containsKey('filter_section'), isFalse);
    });
  });

  group('filter_section and its count', () {
    test('excludes subcategory and product_type but keeps everything else', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
        _leaf('Tops', 'subcategory'),
        _leaf('T-Shirt', 'product_type'),
        _leaf('Red', 'colour'),
      ]);

      expect(props['filter_section'], ['department', 'colour']);
      expect(props['filter_section_count'], 2);
    });

    test('counts sections, not selected values', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
        _leaf('Girls', 'department'),
        _leaf('Home', 'department'),
      ]);

      expect(props['filter_section_count'], 1);
    });

    test('does not exclude attributes, so an attribute reports in both '
        'filter_section and filter_attribute', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Cotton', 'fabric', isAttribute: true),
      ]);

      expect(props['filter_section'], ['fabric']);
      expect(props['filter_attribute'], ['Cotton']);
    });
  });

  group('attribute list vs attribute count', () {
    test('the count can exceed the list, because only the list requires a '
        'section name — Android behaviour, mirrored deliberately', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Cotton', 'fabric', isAttribute: true),
        _leaf('Nameless', '', isAttribute: true),
      ]);

      expect(props['filter_attribute'], ['Cotton']);
      expect(props['filter_attribute_count'], 2);
    });

    test('ignores non-attribute selections in both', () {
      final props = PlpFilterSegment.buildFromLeaves([
        _leaf('Boys', 'department'),
      ]);

      expect(props.containsKey('filter_attribute'), isFalse);
      expect(props.containsKey('filter_attribute_count'), isFalse);
    });
  });

  group('build from a filter tree', () {
    test('walks all three levels, each carrying its own section name', () {
      final sections = [
        FilterSectionEntity(
          filterKey: 'category',
          filterList: [
            _f(
              'group',
              children: [
                _f(
                  'Apparel',
                  selected: true,
                  section: 'category',
                  children: [
                    _f(
                      'Tops',
                      selected: true,
                      section: 'subcategory',
                      children: [
                        _f('T-Shirt', selected: true, section: 'product_type'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ];

      final props = PlpFilterSegment.build(sections);

      expect(props['category_filter'], ['Apparel']);
      expect(props['subcategory_filter'], ['Tops']);
      expect(props['product_type_filter'], ['T-Shirt']);
      expect(
        props['filter_section'],
        ['category'],
        reason: 'the other two levels are excluded from filter_section',
      );
    });

    test('a selected parent and child both report — the child is not an '
        'alternative to the parent', () {
      final sections = [
        FilterSectionEntity(
          filterList: [
            _f(
              'group',
              children: [
                _f(
                  'Apparel',
                  selected: true,
                  section: 'category',
                  children: [_f('Tops', selected: true, section: 'subcategory')],
                ),
              ],
            ),
          ],
        ),
      ];

      final props = PlpFilterSegment.build(sections);

      expect(props['category_filter'], ['Apparel']);
      expect(props['subcategory_filter'], ['Tops']);
    });

    test('returns an empty map when nothing is selected, so no filter keys '
        'reach the payload at all', () {
      final sections = [
        FilterSectionEntity(
          filterList: [
            _f('group', children: [_f('Apparel', section: 'category')]),
          ],
        ),
      ];

      expect(PlpFilterSegment.build(sections), isEmpty);
    });

    test('skips leaves the backend sent without a trackingMeta blob', () {
      final sections = [
        FilterSectionEntity(
          filterList: [
            _f('group', children: [_f('Orphan', selected: true)]),
          ],
        ),
      ];

      expect(PlpFilterSegment.build(sections), isEmpty);
    });
  });
}
