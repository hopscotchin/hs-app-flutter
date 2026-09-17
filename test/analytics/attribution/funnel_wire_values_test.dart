import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';

/// Funnel wire values are a cross-platform dashboard contract. Each one must
/// equal its Android counterpart in
/// `hsapp/.../attribution/AttributionConstants.java` character for character.
void main() {
  test('every funnel matches Android AttributionConstants verbatim', () {
    expect(Funnel.discover.wire, 'Discover'); // FUNNEL_DISCOVER
    expect(Funnel.categories.wire, 'Categories'); // FUNNEL_CATEGORIES
    expect(Funnel.cart.wire, 'Cart'); // FUNNEL_CART
    expect(Funnel.account.wire, 'Account'); // FUNNEL_ACCOUNT
    expect(Funnel.wishlist.wire, 'Wishlist'); // FUNNEL_WISHLIST
  });

  test('search funnel is "Search", not the "Search results" plp_name', () {
    // Regression: this shipped as 'Search results', which is the *plp_name*
    // value (PLPAnalytics SEARCH_RESULTS), not the funnel. Android's
    // FUNNEL_SEARCH is 'Search'.
    expect(Funnel.search.wire, 'Search');
    expect(Funnel.fromWire('Search'), Funnel.search);
    expect(Funnel.fromWire('Search results'), isNull);
  });
}
