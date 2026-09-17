import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/features/plp/data/models/sorting_option_model.dart';

/// `sorting_applied` reports `from_sort` / `new_sort` using the backend's
/// `eventSortName` — `"PriceHighLow"` — not the display `label`
/// `"Price high to low"`.
///
/// Regression: `eventSortName` was only ever read out of a nested
/// `trackingMeta` map. Sort options do not carry one — the response sends the
/// name at the option's top level — so every lookup missed and the event
/// shipped the human-readable label instead.
void main() {
  // Verbatim from a live PLP response.
  const json = <String, dynamic>{
    'orderRule': 1,
    'label': 'Price high to low',
    'isSelected': true,
    'eventSortName': 'PriceHighLow',
  };

  test('the top-level eventSortName is parsed', () {
    final option = SortingOptionModel.fromJson(json).toEntity();

    expect(option.eventSortName, 'PriceHighLow');
    expect(option.label, 'Price high to low');
    expect(option.orderRule, 1);
    expect(option.isSelected, isTrue);
    // Sort options carry no trackingMeta blob at all -- which is exactly why
    // reading the name out of one always failed. The field is gone from the
    // model and entity, so this is now enforced by the type rather than a
    // null check.
  });

  test('every option in the live sortingOptions block resolves a name', () {
    const options = [
      {'orderRule': -1, 'label': 'Relevance', 'eventSortName': 'Relevance'},
      {
        'orderRule': 1,
        'label': 'Price high to low',
        'eventSortName': 'PriceHighLow',
      },
      {
        'orderRule': 2,
        'label': 'Price low to high',
        'eventSortName': 'PriceLowHigh',
      },
      {'orderRule': 7, 'label': 'New Arrivals', 'eventSortName': 'NewArrivals'},
    ];

    final parsed = options
        .map((o) => SortingOptionModel.fromJson(o).toEntity())
        .toList();

    expect(
      parsed.map((o) => o.eventSortName),
      ['Relevance', 'PriceHighLow', 'PriceLowHigh', 'NewArrivals'],
    );
    // The two differ for three of the four — sending `label` would have been
    // wrong on every one of those.
    expect(
      parsed.where((o) => o.eventSortName != o.label).length,
      3,
    );
  });

  test('an option with no eventSortName still parses', () {
    final option = SortingOptionModel.fromJson(const {
      'orderRule': 3,
      'label': 'Discount',
    }).toEntity();

    expect(option.eventSortName, isNull);
    expect(option.label, 'Discount');
  });
}
