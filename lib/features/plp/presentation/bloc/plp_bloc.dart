import '../../../../core/analytics/analytics_payload_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hs_app_flutter/core/analytics/analytics_map.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/constants/analytics_properties.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/plp_events.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../pdp/domain/entities/pdp_entry_args.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/floating_filter_entity.dart';
import '../../domain/entities/listing_data_entity.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_entry_args.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../../domain/entities/query_correction_entity.dart';
import '../../domain/entities/selected_filter_entity.dart';
import '../../domain/helpers/plp_filter_segment.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../../domain/usecases/get_listing_data_usecase.dart';

part 'plp_bloc.freezed.dart';
part 'plp_event.dart';
part 'plp_state.dart';

@injectable
class PlpBloc extends BaseBloc<PlpEvent, PlpState> {
  final GetListingDataUseCase getListingDataUseCase;
  final AnalyticsHelper _analytics;
  final PlpQueryBuilder _queryBuilder = PlpQueryBuilder();

  /// Fire-once latch for the listing-viewed event. Android guards the same
  /// way (`viewedEventFired`): the event describes the *screen*, so filter /
  /// sort / pagination reloads must not re-fire it.
  bool _viewedEventFired = false;

  /// Which analytics event the in-flight reload should emit once results
  /// land. Android models this as `filterApplied` / `filterCleared` flags
  /// read in `setupAndLogFilterAnalytics()` after the listing reloads —
  /// filter and sort events report the *resulting* feed size, so they can
  /// only fire after the response, not at tap time.
  _PendingPlpAnalytics? _pending;

  /// Set when the in-flight load came from the user accepting a spelling
  /// suggestion — see [LoadPlpData.isFromQueryCorrection].
  bool _fromQueryCorrection = false;

  /// Navigation context for the current screen instance, captured at load and
  /// held for the life of the bloc — Android keeps the same values as fields
  /// read off the Intent, so a filter or sort reload does not lose them.
  PlpEntryArgs? _entryArgs;

  final Map<int, FloatingFilterSectionEntity> _floatingSectionsByPosition = {};
  PlpState? _lastLoaded;
  final Map<String, Object> localAttribution = {};

  PlpBloc({required this.getListingDataUseCase, required AnalyticsHelper analytics})
    : _analytics = analytics,
      super(const PlpState()) {
    on<LoadPlpData>(_onLoadPlpData);
    on<LoadMorePlpData>(_onLoadMorePlpData);
    on<ApplyFilter>(_onApplyFilter);
    on<ApplyMultipleFilters>(_onApplyMultipleFilters);
    on<RemoveFilter>(_onRemoveFilter);
    on<ClearAllFilters>(_onClearAllFilters);
    on<ApplySort>(_onApplySort);
    on<ApplyFloatingFilter>(_onApplyFloatingFilter);
  }

  Future<void> _onLoadPlpData(LoadPlpData event, Emitter<PlpState> emit) async {
    _queryBuilder.reset(
      pageType: event.pageType,
      plpId: event.plpId,
      searchQuery: event.searchQuery,
      rawSearchParams: event.rawSearchParams,
      initialFilters: event.initialFilters,
    );
    _lastLoaded = null;
    _viewedEventFired = false;
    _pending = null;
    _fromQueryCorrection = event.isFromQueryCorrection;
    _entryArgs = event.entryArgs;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
    localAttribution.putAllAnalyticsKeys(_analytics.orderAttribution.segmentParams);
    localAttribution.putAllAnalyticsKeys(_analytics.lpAttribution.segmentParams);
    localAttribution.putAllAnalyticsKeys(_analytics.productAttribution.segmentParams);
  }

  Future<void> _onLoadMorePlpData(LoadMorePlpData event, Emitter<PlpState> emit) async {
    if (state.status != PlpStatus.loaded || !state.hasMore || state.isLoadingMore) {
      return;
    }
    final current = state;
    _queryBuilder.nextPage();
    emit(current.copyWith(isLoadingMore: true));
    await _fetchAndEmit(emit, isLoadMore: true, paginationBase: current);
  }

  Future<void> _onApplyFilter(ApplyFilter event, Emitter<PlpState> emit) async {
    _pending = const _PendingFilterAnalytics(
      isCleared: false,
      clickSource: FilterClickSource.standardFilter,
    );
    _queryBuilder.filterParams[event.key] = event.value;
    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyMultipleFilters(ApplyMultipleFilters event, Emitter<PlpState> emit) async {
    _pending = _PendingFilterAnalytics(
      isCleared: false,
      clickSource: event.clickSource,
    );
    _queryBuilder.filterParams.clear();
    _queryBuilder.filterParams.addAll(event.filters);
    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onRemoveFilter(RemoveFilter event, Emitter<PlpState> emit) async {
    _pending = const _PendingFilterAnalytics(
      isCleared: false,
      clickSource: FilterClickSource.standardFilter,
    );
    final key = event.filterToRemove.filterKey;
    final value = event.filterToRemove.filterValue;

    if (key == null || key.isEmpty) return;

    final existing = _queryBuilder.filterParams[key];
    if (existing == null || value == null || value.isEmpty) {
      // No value context — fall back to removing the whole key.
      _queryBuilder.filterParams.remove(key);
    } else if (existing.contains(',')) {
      final remaining = existing.split(',').where((v) => v.isNotEmpty && v != value).toList();
      if (remaining.isEmpty) {
        _queryBuilder.filterParams.remove(key);
      } else {
        _queryBuilder.filterParams[key] = remaining.join(',');
      }
    } else {
      _queryBuilder.filterParams.remove(key);
    }

    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onClearAllFilters(ClearAllFilters event, Emitter<PlpState> emit) async {
    _pending = const _PendingFilterAnalytics(
      isCleared: true,
      clickSource: FilterClickSource.standardFilter,
    );
    _queryBuilder.filterParams.clear();
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplySort(ApplySort event, Emitter<PlpState> emit) async {
    // Set the chosen sort before firing; the response echoes this orderRule
    // back, so the seed in _fetchAndEmit re-confirms it (mirrors Android's
    // searchRule = sortOption.orderRule → searchRule = response.orderRule).
    // Resolve both names BEFORE mutating the builder — `_sortNameFor` reads
    // the option list off the current state, and the reload replaces it.
    final fromSort = _sortNameFor(_queryBuilder.orderRule);
    final newSort = _sortNameFor(event.orderRule);
    // Android only logs when the rule actually changes.
    if (event.orderRule != _queryBuilder.orderRule) {
      _pending = _PendingSortAnalytics(fromSort: fromSort, newSort: newSort);
    }
    _queryBuilder.orderRule = event.orderRule;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyFloatingFilter(ApplyFloatingFilter event, Emitter<PlpState> emit) async {
    _pending = const _PendingFilterAnalytics(
      isCleared: false,
      clickSource: FilterClickSource.floatingFilter,
    );
    _reseedFilterParamsFromSelectedFilters(state.plpFilter?.selectedFilters ?? const []);

    if (event.value.isEmpty) {
      _queryBuilder.filterParams.remove(event.key);
    } else {
      _queryBuilder.filterParams[event.key] = event.value;

      _queryBuilder.filterParams.addAll(
        _treeAncestorParams(event.key, event.value.split(',').toSet()),
      );
    }
    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Map<String, String> _treeAncestorParams(String key, Set<String> values) {
    final result = <String, String>{};
    if (values.isEmpty) return result;
    final sections = state.plpFilter?.filterSections ?? const [];
    for (final section in sections) {
      if ((section.uiType?.toLowerCase() ?? '') != 'tree' || section.filterList.isEmpty) {
        continue;
      }
      for (final category in section.filterList.first.filters) {
        final catKey = category.filterKey ?? '';
        final catVal = category.filterValue ?? '';
        for (final sub in category.filters) {
          final subKey = sub.filterKey ?? '';
          final subVal = sub.filterValue ?? '';
          // Selected node is a subCategory → its parent is the category.
          if (subKey == key && values.contains(subVal)) {
            if (catKey.isNotEmpty && catVal.isNotEmpty) result[catKey] = catVal;
          }
          // Selected node is a productClass → parents are subCategory + category.
          for (final productClass in sub.filters) {
            if ((productClass.filterKey ?? '') == key &&
                values.contains(productClass.filterValue ?? '')) {
              if (catKey.isNotEmpty && catVal.isNotEmpty) result[catKey] = catVal;
              if (subKey.isNotEmpty && subVal.isNotEmpty) result[subKey] = subVal;
            }
          }
        }
      }
    }
    return result;
  }

  /// Rebuilds [PlpQueryBuilder.filterParams] from the backend's authoritative
  /// `selectedFilters`, keyed by `filterKey` with the `filterValue` (never the
  /// display label). Keeps [PlpState.appliedFilters] in sync with server truth
  /// so the filter sheet and filter page show server-preselected filters as
  /// selected. No-ops on an empty list so it never wipes in-flight params.
  void _reseedFilterParamsFromSelectedFilters(List<SelectedFilterEntity> selected) {
    if (selected.isEmpty) return;
    final reseeded = <String, String>{};
    for (final sf in selected) {
      final key = sf.filterKey;
      final value = sf.filterValue;
      if (key == null || key.isEmpty || value == null || value.isEmpty) continue;
      reseeded[key] = reseeded.containsKey(key) ? '${reseeded[key]},$value' : value;
    }
    _queryBuilder.filterParams
      ..clear()
      ..addAll(reseeded);
  }

  Future<void> _fetchAndEmit(
    Emitter<PlpState> emit, {
    bool isLoadMore = false,
    PlpState? paginationBase,
  }) async {
    final cancelToken = swapCancelToken();

    final result = await getListingDataUseCase(
      GetListingDataParams(
        pageType: _queryBuilder.pageType,
        queryParams: _queryBuilder.build(),
        cancelToken: cancelToken,
      ),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        if (isLoadMore) {
          _queryBuilder.prevPage();
          emit(paginationBase!.copyWith(isLoadingMore: false));
        } else if (_lastLoaded != null && _lastLoaded!.products.isNotEmpty) {
          emit(_lastLoaded!);
        } else {
          emit(
            state.copyWith(
              status: PlpStatus.empty,
              appliedFilters: Map.from(_queryBuilder.filterParams),
              errorMessage: failure.message,
            ),
          );
        }
      },
      (data) {
        // Mirror the backend's authoritative selection into filterParams (by
        // filterKey/filterValue, never the label) so a fresh load with
        // server-preselected filters shows them selected in the filter sheet and
        // filter page. Skipped for pagination — it carries the same selection.
        if (!isLoadMore) {
          _reseedFilterParamsFromSelectedFilters(data.filters?.selectedFilters ?? const []);
        }
        if (data.records.isEmpty && !isLoadMore) {
          // Carry the filter payload (sections + selectedFilters) and orderRule
          // into the empty state so the applied-filter chips and the filter bar
          // stay visible — the user can then loosen/remove filters to recover
          // results instead of hitting a dead end.
          _queryBuilder.orderRule = data.effectiveOrderRule;
          emit(
            PlpState(
              status: PlpStatus.empty,
              plpFilter: data.filters,
              appliedFilters: Map.from(_queryBuilder.filterParams),
              currentOrderRule: _queryBuilder.orderRule,
              banners: data.banners,
              screenName: data.screenName,
              screenSubtitle: data.screenSubtitle,
              pageType: _queryBuilder.pageType,
              trackingMeta: data.trackingMeta,
              orderAttribution: data.orderAttribution,
            ),
          );
          return;
        }

        if (isLoadMore) {
          final base = paginationBase!;
          final products = [...base.products, ...data.records];
          _accumulateFloatingSections(data.floatingFilter?.sections);
          final loaded = base.copyWith(
            isLoadingMore: false,
            products: products,
            listItems: _buildListItems(products, _orderedFloatingSections),
            totalRecords: data.totalRecords,
            currentPage: _queryBuilder.currentPage,
            hasMore: data.hasMorePages,
          );
          _lastLoaded = loaded;
          emit(loaded);
        } else {
          // Seed orderRule from the response (root-level for v6/v8, like
          // Android's searchRule = response.orderRule) so pagination,
          // filter-apply, and the /v2/filter refresh echo it back instead of
          // dropping to -1. A user-chosen sort survives because the backend
          // echoes the applied orderRule, so re-seeding re-confirms it.
          _queryBuilder.orderRule = data.effectiveOrderRule;

          // Fresh load (page 1 / filter / sort) — reset the cross-page
          // floating-filter accumulator and seed it with this page's sections.
          _floatingSectionsByPosition.clear();
          _accumulateFloatingSections(data.floatingFilter?.sections);

          final products = data.records;
          final loaded = PlpState(
            status: PlpStatus.loaded,
            products: products,
            listItems: _buildListItems(products, _orderedFloatingSections),
            totalRecords: data.totalRecords,
            currentPage: _queryBuilder.currentPage,
            hasMore: data.hasMorePages,
            plpFilter: data.filters,
            banners: data.banners,
            appliedFilters: Map.from(_queryBuilder.filterParams),
            screenName: data.screenName,
            screenSubtitle: data.screenSubtitle,
            queryCorrection: data.queryCorrection,
            currentOrderRule: _queryBuilder.orderRule,
            messageBars: data.messageBars,
            // Analytics reads this for `from_page`; the load-more path inherits
            // it through `base.copyWith`.
            pageType: _queryBuilder.pageType,
            trackingMeta: data.trackingMeta,
            orderAttribution: data.orderAttribution,
          );
          _lastLoaded = loaded;
          emit(loaded);
          _fireListingAnalytics(data);
        }
      },
    );
  }

  /// Emits the analytics for a completed fresh load. Ordering matters: the
  /// listing-viewed event goes first (it describes the screen the user
  /// landed on), then whichever filter/sort interaction triggered this
  /// particular reload.
  ///
  /// Not awaited — Segment queues to disk, and blocking the emit path on
  /// network would stall the UI.
  void _fireListingAnalytics(ListingDataEntity data) {
    // `_fireListingAnalytics` runs after the emit, so `state` already
    // reflects `data`. Reuse the same merged blob every widget-side event
    // reads (orderAttribution + trackingMeta, trackingMeta wins) instead
    // of recomputing it here.
    final meta = state.plpAnalyticsMeta;

    if (!_viewedEventFired) {
      _viewedEventFired = true;
      if (_fromQueryCorrection) {
        // Android's setAnalyticsAfterQueryCorrection path: the corrected search
        // re-fires products_searched with a deliberately smaller payload and
        // the correction type stamped on it, instead of the full viewed set.
        _fromQueryCorrection = false;
        _analytics.logProductsSearchedAfterQueryCorrection(
          trackingMeta: meta,
          queryCorrection: QueryCorrection.suggestionUsed,
          // Android's corrected-search payload keeps the same client-owned
          // section and tile-action detail as the uncorrected one
          // (`PLPAnalytics.kt:929-937`); only the identity keys shrink.
          addFromDetails: _entryArgs?.addFromDetails,
        );
      } else {
        // Event-name selection only — the wire value is the blob's plp_type.
        // The blob owns page identity; the entry args own how the user got
        // here. `putAnalyticsKey` drops the nulls, so a deeplink open simply
        // ships without the pair rather than with placeholders.
        _analytics.logListingViewed(
          plpType: _routePlpType,
          // Android switches to `promo_products_viewed` when the PLP was
          // opened with a `promotionId` request param
          // (`PLPAnalytics.kt:285`). Flutter has no promo-PLP route yet, so
          // the only signal available is the blob's own plp_type — without
          // this, a promo blob would ship under `products_searched`.
          isPromo: meta?[AnalyticsProperties.plpType] == PlpType.promotionProducts,
          trackingMeta: meta,
          fromScreen: _entryArgs?.fromScreen,
          fromLocation: _entryArgs?.fromLocation,
          position: _entryArgs?.position,
          // Boutique-only pair — see `logListingViewed`. Gated here rather
          // than inside the payload builder because this is where the page's
          // identity is known, and the blob is authoritative on it (it knows
          // kinds the route cannot infer, like Reco and Promotion products).
          row: _isBoutique ? _entryArgs?.row : null,
          fromFeedSize: _isBoutique ? _entryArgs?.fromFeedSize : null,
          addFromDetails: _entryArgs?.addFromDetails,
          suggestionIndex: _entryArgs?.suggestionIndex,
          keyword: _entryArgs?.keyword,
          suggestionTrackingData: _entryArgs?.suggestionTrackingData,
        );
      }
    }

    final pending = _pending;
    _pending = null;
    switch (pending) {
      case null:
        break;
      case _PendingFilterAnalytics(:final isCleared, :final clickSource):
        _analytics.logFilterApplied(
          isFilterCleared: isCleared,
          // Filter-response blob merged on top of the page blob — same
          // pass-through contract, just a second backend source.
          trackingMeta: buildAnalyticsPayload(
            nodes: [meta, data.filters?.trackingMeta],
          ),
          clickSource: clickSource,
          // Built from the response's own filter tree, so the dynamic keys
          // (`department_filter`, …) use the backend's analytics names rather
          // than the query params.
          filterSegment: PlpFilterSegment.build(
            data.filters?.filterSections ?? const [],
          ),
          fromScreen: data.screenName,
        );
      case _PendingSortAnalytics(:final fromSort, :final newSort):
        _analytics.logSortingApplied(
          trackingMeta: meta,
          fromSort: fromSort,
          newSort: newSort,
        );
    }
  }

  /// Whether this bloc is driving a boutique — gates the `row` /
  /// `from_feed_size` pair, which Android writes only in
  /// `addCommonBoutiqueProperties`.
  ///
  /// Derived from the route via [_routePlpType], not from the backend's
  /// `plp_type` string: the route is the same fact, known before the first
  /// response and not dependent on the blob spelling the value the client
  /// expects. Android decides the same way, from intent extras rather than
  /// from the response (`PLPAnalytics.kt:115-121`).
  ///
  /// Goes through [_routePlpType] rather than comparing [PageType] directly so
  /// one mapping decides what kind of listing this is. A page type that later
  /// also reports as a boutique is then handled in that one switch.
  bool get _isBoutique => _routePlpType == PlpType.boutique;

  /// Segment's `plp_type` vocabulary for the page this bloc is driving,
  /// derived from the route. Mirrors Android's intent-extra branch
  /// (`PLPAnalytics.kt:115-121`), which splits the same three ways.
  String get _routePlpType => switch (_queryBuilder.pageType) {
    PageType.boutique => PlpType.boutique,
    PageType.search => PlpType.search,
    PageType.plp => PlpType.productListing,
  };

  /// `eventSortName` for an order rule, read from the option's backend
  /// tracking blob. Falls back to the display label, then the raw rule.
  /// The analytics name for [orderRule] — `"PriceHighLow"`, not the
  /// `"Price high to low"` a user sees.
  ///
  /// The response sends `eventSortName` at the option's top level. This used to
  /// read it out of a nested `trackingMeta`, which sort options do not carry,
  /// so every lookup missed and `sorting_applied` shipped the display label.
  /// `label` remains the last resort so an option the backend forgot to name
  /// still reports something.
  String _sortNameFor(int? orderRule) {
    final options = state.plpFilter?.sortingOptions?.options ?? const [];
    for (final o in options) {
      if (o.orderRule != orderRule) continue;
      final eventName = o.eventSortName;
      if (eventName != null && eventName.isNotEmpty) return eventName;
      return o.label ?? '';
    }
    return orderRule?.toString() ?? '';
  }

  List<PlpListItem> _buildListItems(
    List<ListingProductEntity> products,
    List<FloatingFilterSectionEntity> floatingFilter,
  ) {
    if (floatingFilter.isEmpty) return _productsToRows(products);

    final sorted = floatingFilter.where((f) => f.position != null && f.chips.isNotEmpty).toList()
      ..sort((a, b) => a.position!.compareTo(b.position!));

    final items = <PlpListItem>[];
    var startIndex = 0;

    for (final section in sorted) {
      final pos = section.position!.clamp(0, products.length);
      if (pos > startIndex) {
        items.addAll(_productsToRows(products.sublist(startIndex, pos)));
      }
      items.add(FloatingFilterItem(section: section));
      startIndex = pos;
    }

    if (startIndex < products.length) {
      items.addAll(_productsToRows(products.sublist(startIndex)));
    }

    return items;
  }

  /// Adds [sections] to the cross-page accumulator, keeping the first section
  /// seen at any given position (pages may re-send already-shown sections).
  void _accumulateFloatingSections(List<FloatingFilterSectionEntity>? sections) {
    if (sections == null) return;
    for (final section in sections) {
      final position = section.position;
      if (position == null) continue;
      _floatingSectionsByPosition.putIfAbsent(position, () => section);
    }
  }

  List<FloatingFilterSectionEntity> get _orderedFloatingSections =>
      _floatingSectionsByPosition.values.toList();

  List<PlpListItem> _productsToRows(List<ListingProductEntity> products) {
    final items = <PlpListItem>[];
    var i = 0;
    while (i < products.length) {
      final product = products[i];
      if (product.isXLTile) {
        items.add(ProductXLItem(product: product));
        i++;
      } else {
        final nextIsRegular = i + 1 < products.length && !products[i + 1].isXLTile;
        final right = nextIsRegular ? products[i + 1] : null;
        items.add(ProductRowItem(left: product, right: right));
        i += right != null ? 2 : 1;
      }
    }
    return items;
  }
}

/// What the in-flight reload should report once results land. Filter and sort
/// events carry the *resulting* feed size, so they can't fire at tap time —
/// they're parked here and emitted from [PlpBloc._fireListingAnalytics].
sealed class _PendingPlpAnalytics {
  const _PendingPlpAnalytics();
}

class _PendingFilterAnalytics extends _PendingPlpAnalytics {
  const _PendingFilterAnalytics({required this.isCleared, required this.clickSource});

  final bool isCleared;
  final String clickSource;
}

class _PendingSortAnalytics extends _PendingPlpAnalytics {
  const _PendingSortAnalytics({required this.fromSort, required this.newSort});

  final String fromSort;
  final String newSort;
}
