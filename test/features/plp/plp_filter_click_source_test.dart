import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_data_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_meta_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/page_type.dart';
import 'package:hs_app_flutter/features/plp/domain/usecases/get_listing_data_usecase.dart';
import 'package:hs_app_flutter/features/plp/presentation/bloc/plp_bloc.dart';

import '../../analytics/support/analytics_test_harness.dart';

class MockGetListingDataUseCase extends Mock implements GetListingDataUseCase {}

/// `click_source` on `filter_applied` names the control the user applied from.
///
/// Regression: the sticky bar's per-section bottom sheet and the full-screen
/// filter page both call `StickyFilterBar.onFiltersApplied`, which the header
/// wired to `ApplyMultipleFilters`. The handler then hard-coded
/// `standard_filters`, so every sticky-sheet apply was reported as if it came
/// from the filter page — the two surfaces were indistinguishable downstream.
void main() {
  late AnalyticsTestHarness h;
  late MockGetListingDataUseCase usecase;
  late PlpBloc bloc;

  setUpAll(() {
    registerFallbackValue(
      const GetListingDataParams(pageType: PageType.plp, queryParams: {}),
    );
  });

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    usecase = MockGetListingDataUseCase();
    when(() => usecase.call(any())).thenAnswer(
      (_) async => const Right<Failure, ListingDataEntity>(
        ListingDataEntity(
          records: [ListingProductEntity(id: 1, name: 'A dress')],
          pageMeta: PageMetaEntity(totalCount: 12, pageTitle: 'Dresses'),
        ),
      ),
    );
    bloc = PlpBloc(getListingDataUseCase: usecase, analytics: h.analytics);
  });

  tearDown(() async {
    await bloc.close();
    h.tearDown();
  });

  Future<Map<String, Object?>> applyEvent(PlpEvent event) async {
    bloc.add(const LoadPlpData(pageType: PageType.plp, plpId: 42));
    await bloc.stream.firstWhere((s) => s.status == PlpStatus.loaded);
    bloc.add(event);
    await bloc.stream.firstWhere((s) => s.status == PlpStatus.loaded);
    return h.singleEvent(AnalyticsEvents.filterApplied);
  }

  Future<Map<String, Object?>> applyWith(String clickSource) => applyEvent(
    ApplyMultipleFilters(
      filters: const {'department': 'girls'},
      clickSource: clickSource,
    ),
  );

  test('a sticky-sheet apply reports sticky_filter', () async {
    final e = await applyWith(FilterClickSource.stickyFilter);
    expect(e[AnalyticsProperties.clickSource], FilterClickSource.stickyFilter);
    expect(e[AnalyticsProperties.clickSource], 'sticky_filter');
  });

  test('a filter-page apply reports standard_filters', () async {
    final e = await applyWith(FilterClickSource.standardFilter);
    expect(
      e[AnalyticsProperties.clickSource],
      FilterClickSource.standardFilter,
    );
    expect(e[AnalyticsProperties.clickSource], 'standard_filters');
  });

  // The floating row is the third surface. It has its own event rather than
  // sharing `ApplyMultipleFilters`, so it cannot pick up another surface's
  // source -- but pin it here anyway, next to the other two, so all three read
  // as one contract.
  test('a floating-row apply reports floating_filter', () async {
    final e = await applyEvent(
      const ApplyFloatingFilter(key: 'department', value: 'girls'),
    );
    expect(
      e[AnalyticsProperties.clickSource],
      FilterClickSource.floatingFilter,
    );
    expect(e[AnalyticsProperties.clickSource], 'floating_filter');
  });

  // Android's own spelling is inconsistent -- `sticky_filter` is singular
  // while the other two are not -- so pin the literals. These are dashboard
  // keys; a "tidy-up" that pluralises one breaks a funnel silently.
  test('the three wire values match Android verbatim', () {
    expect(FilterClickSource.stickyFilter, 'sticky_filter');
    expect(FilterClickSource.standardFilter, 'standard_filters');
    expect(FilterClickSource.floatingFilter, 'floating_filter');
  });
}
