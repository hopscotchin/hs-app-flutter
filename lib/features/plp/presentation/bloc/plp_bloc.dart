import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/floating_filter_entity.dart';
import '../../domain/entities/listing_data_entity.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../../domain/entities/query_correction_entity.dart';
import '../../domain/entities/selected_filter_entity.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../../domain/usecases/get_listing_data_usecase.dart';

part 'plp_bloc.freezed.dart';
part 'plp_event.dart';
part 'plp_state.dart';

@injectable
class PlpBloc extends BaseBloc<PlpEvent, PlpState> {
  final GetListingDataUseCase getListingDataUseCase;
  final PlpQueryBuilder _queryBuilder = PlpQueryBuilder();

  final Map<int, FloatingFilterSectionEntity> _floatingSectionsByPosition = {};
  PlpState? _lastLoaded;

  PlpBloc({required this.getListingDataUseCase}) : super(const PlpState()) {
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
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
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
    _queryBuilder.filterParams[event.key] = event.value;
    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyMultipleFilters(ApplyMultipleFilters event, Emitter<PlpState> emit) async {
    _queryBuilder.filterParams.clear();
    _queryBuilder.filterParams.addAll(event.filters);
    _queryBuilder.isFromRefineFilter = true;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onRemoveFilter(RemoveFilter event, Emitter<PlpState> emit) async {
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
    _queryBuilder.filterParams.clear();
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplySort(ApplySort event, Emitter<PlpState> emit) async {
    // Set the chosen sort before firing; the response echoes this orderRule
    // back, so the seed in _fetchAndEmit re-confirms it (mirrors Android's
    // searchRule = sortOption.orderRule → searchRule = response.orderRule).
    _queryBuilder.orderRule = event.orderRule;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyFloatingFilter(ApplyFloatingFilter event, Emitter<PlpState> emit) async {
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
          );
          _lastLoaded = loaded;
          emit(loaded);
        }
      },
    );
  }

  List<PlpListItem> _buildListItems(
    List<ListingProductEntity> products,
    List<FloatingFilterSectionEntity> floatingFilters,
  ) {
    if (floatingFilters.isEmpty) return _productsToRows(products);

    final sorted = floatingFilters.where((f) => f.position != null && f.chips.isNotEmpty).toList()
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
