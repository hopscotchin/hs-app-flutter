import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hs_app_flutter/core/analytics/attribution/utm_header_util.dart';
import 'package:hs_app_flutter/core/services/pref_manager.dart';

/// UTM cache — in-memory + disk. `clearUtmParams` MUST wipe every field
/// on both stores or stale UTM keys ride onto identify calls after a
/// campaign ends (regression: utmGender was silently retained,
/// poisoning gender-cohort segmentation).
void main() {
  late UtmHeaderUtil utm;
  late PrefManager prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = PrefManager(await SharedPreferences.getInstance());
    utm = UtmHeaderUtil(prefs);
  });

  test('clearUtmParams wipes every field in memory AND on disk', () async {
    // Seed every UTM field.
    await utm.setUtmSource('src');
    await utm.setUtmCampaign('camp');
    await utm.setUtmMedium('med');
    await utm.setUtmContent('cont');
    await utm.setUtmTerm('term');
    await utm.setUtmGender('Girl');
    await utm.setDeeplink('hopscotch://…');
    utm.utmSection = 'sec';
    utm.utmProduct = 'prod';
    utm.utmPromo = 'promo';

    // Sanity — populated in-memory + disk.
    expect(utm.utmGender, 'Girl');
    expect(prefs.utmGender, 'Girl');

    await utm.clearUtmParams();

    // In-memory: every field null.
    expect(utm.utmSource, isNull);
    expect(utm.utmCampaign, isNull);
    expect(utm.utmMedium, isNull);
    expect(utm.utmContent, isNull);
    expect(utm.utmTerm, isNull);
    expect(utm.utmGender, isNull,
        reason: 'regression: utmGender was silently retained after clear');
    expect(utm.deeplink, isNull);
    expect(utm.utmSection, isNull);
    expect(utm.utmProduct, isNull);
    expect(utm.utmPromo, isNull);

    // Disk: every UTM key cleared (mirrors in-memory state).
    expect(prefs.utmSource, isNull);
    expect(prefs.utmCampaign, isNull);
    expect(prefs.utmMedium, isNull);
    expect(prefs.utmContent, isNull);
    expect(prefs.utmTerm, isNull);
    expect(prefs.utmGender, isNull,
        reason: 'regression: setUtmGender(null) was missing from clear');
    expect(prefs.utmDeeplink, isNull);

    // isUtmChanged always flipped (matches Android).
    expect(utm.isUtmChanged, isTrue);
  });

  test('hydrateFromDisk restores every UTM field including gender', () async {
    await prefs.setUtmSource('src');
    await prefs.setUtmGender('Boy');

    utm.hydrateFromDisk();

    expect(utm.utmSource, 'src');
    expect(utm.utmGender, 'Boy');
  });
}
