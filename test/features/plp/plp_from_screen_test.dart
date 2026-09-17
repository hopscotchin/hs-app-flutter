import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart';

/// `from_screen` for events fired *on* a listing. Android uses the page's own
/// name and falls back to a per-type constant
/// (`ProductListActivity.kt:716` — `salePlanDetail?.name ?: FromScreens.BOUTIQUE`).
void main() {
  test('uses the listing name when the response supplies one', () {
    const state = PlpState(screenName: 'Dresses', pageType: PageType.plp);
    expect(state.plpFromScreen, 'Dresses');
  });

  test('a boutique with no name reports "Boutique Plp", not "PLP"', () {
    // The search endpoint that serves boutiques returns no pageTitle, so this
    // is the common case rather than an edge one.
    const state = PlpState(pageType: PageType.boutique);
    expect(state.plpFromScreen, FromScreens.boutique);
    expect(state.plpFromScreen, 'Boutique Plp');
  });

  test('a named boutique still prefers its own name', () {
    const state = PlpState(screenName: 'water yellowA', pageType: PageType.boutique);
    expect(state.plpFromScreen, 'water yellowA');
  });

  for (final type in [PageType.plp, PageType.search]) {
    test('${type.name} with no name falls back to "PLP"', () {
      expect(PlpState(pageType: type).plpFromScreen, FromScreens.plp);
    });
  }
}
