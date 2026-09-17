import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/analytics_helper.dart';
import 'package:hs_app_flutter/core/cubits/cart_count_cubit.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_data_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_meta_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/domain/usecases/get_listing_data_usecase.dart';
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart';
import 'package:hs_app_flutter/features/plp/presentation/pages/plp_page.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/presentation/cubit/wishlist_cubit.dart';

import '../../analytics/support/analytics_test_harness.dart';

class MockGetListingDataUseCase extends Mock implements GetListingDataUseCase {}

class MockAddToWishlist extends Mock implements AddToWishlistUseCase {}

class MockRemoveFromWishlist extends Mock implements RemoveFromWishlistUseCase {}

/// `plp_scrolled` has exactly one trigger — the PLP going away — mirroring
/// Android's `stopScrollTracking()` (`PLPAnalytics.kt:624`, called from
/// `ProductListActivity:857`). It fires even with zero scroll depth, because
/// `ScrollTrackingHelper.getScrollDepthParams()` still returns params in the
/// `isUnScrolled && isUnSent` case (`ScrollTrackingHelper.java:74`).
///
/// Regression: the payload used to read the bloc via `context.read` while
/// assembling itself inside `dispose()`. The element is defunct by then, so
/// the lookup threw `"Looking up a deactivated widget's ancestor is unsafe."`
/// mid-argument — the log call was never reached and the event never shipped.
/// One trigger, and it was throwing, so the event was entirely dead.
void main() {
  late AnalyticsTestHarness h;
  late MockGetListingDataUseCase usecase;

  // A full first page — 20 products over 10 two-up rows, far more than fits in
  // the 800x600 test viewport. The count matters: the bug this pins is the
  // payload reporting every loaded product rather than the visible ones.
  final products = List.generate(
    20,
    (i) => ListingProductEntity(
      id: i + 1,
      name: 'Product ${i + 1}',
      trackingMeta: {'brand': 'Brand ${i % 3}'},
    ),
  );

  setUpAll(() {
    registerFallbackValue(
      const GetListingDataParams(pageType: PageType.plp, queryParams: {}),
    );
  });

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    usecase = MockGetListingDataUseCase();

    when(() => usecase.call(any())).thenAnswer(
      (_) async => Right<Failure, ListingDataEntity>(
        ListingDataEntity(
          records: products,
          pageMeta: const PageMetaEntity(totalCount: 788, pageTitle: 'Dresses'),
          trackingMeta: const {AnalyticsProperties.plpType: 'Product listing'},
        ),
      ),
    );

    for (final reg in [
      () => sl.registerFactory<PlpBloc>(
            () => PlpBloc(getListingDataUseCase: usecase, analytics: h.analytics),
          ),
      () => sl.registerLazySingleton<AnalyticsHelper>(() => h.analytics),
      () => sl.registerLazySingleton<WishlistCubit>(
            () => WishlistCubit(MockAddToWishlist(), MockRemoveFromWishlist()),
          ),
    ]) {
      reg();
    }

    // The harness sets this for device-info lookups during build; testWidgets
    // asserts every foundation debug var is unset when the body ends, so it
    // has to go back now rather than in tearDown.
    debugDefaultTargetPlatformOverride = null;
  });

  tearDown(() async {
    await sl.reset();
    h.tearDown();
  });

  Future<void> pumpPlp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
            BlocProvider<CartCountCubit>.value(value: CartCountCubit(h.prefs)),
          ],
          child: const PlpPage(pageType: PageType.plp, plpId: 42),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('fires on teardown even when the user never scrolled', (
    tester,
  ) async {
    await pumpPlp(tester);
    expect(h.hasEvent(AnalyticsEvents.plpScrolled), isFalse,
        reason: 'nothing ships while the listing is still on screen');

    // Tear the route down — the single trigger.
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();

    expect(h.hasEvent(AnalyticsEvents.plpScrolled), isTrue,
        reason: 'plp_scrolled must ship as the PLP goes away');
  });

  testWidgets('carries the page blob and scroll geometry', (tester) async {
    await pumpPlp(tester);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();

    final e = h.singleEvent(AnalyticsEvents.plpScrolled);
    expect(e[AnalyticsProperties.plpType], 'Product listing');
    expect(e.containsKey(AnalyticsProperties.totalRows), isTrue);
    // Dispatched via logScrollEvent, which omits the timestamp — Android's
    // scroll contract.
    expect(e.containsKey(AnalyticsProperties.timestamp), isFalse);
  });

  testWidgets('a bounce reports zero depth explicitly, not by omission', (
    tester,
  ) async {
    await pumpPlp(tester);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();

    final e = h.singleEvent(AnalyticsEvents.plpScrolled);
    // Android writes the scroll-depth trio with plain `put`/`putAll`
    // (`ScrollTrackingHelper:79-88`, `PLPAnalytics:748`), so it bypasses the
    // drop-at-zero rule every other key obeys. Dashboards read absent and 0
    // differently: absent means "no report", 0 means "arrived and left".
    expect(e[AnalyticsProperties.fromRow], 1);
    expect(e[AnalyticsProperties.scrolledRow], 0);
    expect(e[AnalyticsProperties.scrolledHeight], 0);
  });

  testWidgets('a bounce reports only what was on screen, not the whole page', (
    tester,
  ) async {
    await pumpPlp(tester);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();

    final e = h.singleEvent(AnalyticsEvents.plpScrolled);
    final reported = e[AnalyticsProperties.productId] as List;

    // The regression: the empty scroll window fell into `plpScrollRange`'s
    // `start == 0 && end == 0` branch, which reports `0 .. itemCount` — every
    // loaded product. Android's bounce payload lists a single viewport's
    // worth, because its window already ends at the last visible row.
    expect(reported, isNotEmpty);
    expect(reported.length, lessThan(products.length),
        reason: 'must not dump the whole loaded page on a bounce');

    // Whatever is reported is a leading run of the list — the viewport starts
    // at the top and the seeded window is [0, rowsSeen * 2).
    expect(reported, products.take(reported.length).map((p) => '${p.id}'));

    // Narrowing the range must not manufacture scroll depth.
    expect(e[AnalyticsProperties.scrolledRow], 0);
    expect(e[AnalyticsProperties.scrolledHeight], 0);
    expect(e[AnalyticsProperties.fromRow], 1);
  });
}
