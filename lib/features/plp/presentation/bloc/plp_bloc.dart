import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/floating_filter_entity.dart';
import '../../domain/entities/listing_header_entity.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_config_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../../domain/entities/selected_filter_entity.dart';
import '../../domain/entities/sorting_option_entity.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../../domain/usecases/get_listing_data_usecase.dart';

part 'plp_bloc.freezed.dart';
part 'plp_event.dart';
part 'plp_state.dart';

@injectable
class PlpBloc extends Bloc<PlpEvent, PlpState> {
  final GetListingDataUseCase getListingDataUseCase;
  final PlpQueryBuilder _queryBuilder = PlpQueryBuilder();
  CancelToken? _cancelToken;

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
      initialFilters: event.initialFilters,
    );
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onLoadMorePlpData(
    LoadMorePlpData event,
    Emitter<PlpState> emit,
  ) async {
    if (state.status != PlpStatus.loaded ||
        !state.hasMore ||
        state.isLoadingMore)
      return;
    _queryBuilder.nextPage();
    emit(state.copyWith(isLoadingMore: true));
    await _fetchAndEmit(emit, isLoadMore: true);
  }

  Future<void> _onApplyFilter(ApplyFilter event, Emitter<PlpState> emit) async {
    _queryBuilder.filterParams[event.key] = event.value;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyMultipleFilters(
    ApplyMultipleFilters event,
    Emitter<PlpState> emit,
  ) async {
    _queryBuilder.filterParams.clear();
    _queryBuilder.filterParams.addAll(event.filters);
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onRemoveFilter(
    RemoveFilter event,
    Emitter<PlpState> emit,
  ) async {
    final key = event.filterToRemove.key;
    if (key != null) _queryBuilder.filterParams.remove(key);
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onClearAllFilters(
    ClearAllFilters event,
    Emitter<PlpState> emit,
  ) async {
    _queryBuilder.filterParams.clear();
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplySort(ApplySort event, Emitter<PlpState> emit) async {
    _queryBuilder.orderRule = event.orderRule;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyFloatingFilter(
    ApplyFloatingFilter event,
    Emitter<PlpState> emit,
  ) async {
    final existing = _queryBuilder.filterParams[event.key];
    if (existing != null && existing.isNotEmpty) {
      _queryBuilder.filterParams[event.key] = '$existing,${event.value}';
    } else {
      _queryBuilder.filterParams[event.key] = event.value;
    }
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _fetchAndEmit(
    Emitter<PlpState> emit, {
    bool isLoadMore = false,
  }) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final result = await getListingDataUseCase(
      GetListingDataParams(
        pageType: _queryBuilder.pageType,
        queryParams: _queryBuilder.build(),
        cancelToken: _cancelToken,
      ),
    );

    result.fold(
      (failure) {
        if (failure.message == 'Request cancelled') return;
        if (isLoadMore) {
          _queryBuilder.prevPage();
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(
            state.copyWith(
              status: PlpStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (data) {
        if (data.records.isEmpty && !isLoadMore) {
          emit(
            state.copyWith(
              status: PlpStatus.empty,
              appliedFilters: Map.from(_queryBuilder.filterParams),
            ),
          );
          return;
        }

        final List<ListingProductEntity> products;
        final List<PlpListItem> listItems;

        if (isLoadMore) {
          products = [...state.products, ...data.records];
          listItems = _appendLoadMoreItems(state.listItems, data.records);
        } else {
          products = data.records;
          listItems = _buildListItems(
            products,
            data.floatingFilter?.sections ?? const [],
          );
        }

        emit(
          state.copyWith(
            status: PlpStatus.loaded,
            products: products,
            listItems: listItems,
            totalRecords: data.totalRecords,
            currentPage: _queryBuilder.currentPage,
            hasMore: data.hasMorePages,
            isLoadingMore: false,
            plpFilter: data.plpFilter,
            sortingOptions: data.sortingOptions,
            appliedFilters: Map.from(_queryBuilder.filterParams),
            salePlanDetail: data.salePlanDetail,
            topBanner: data.plpConfig?.topBanner,
            screenName: data.screenName,
            orderRule: data.orderRule,
          ),
        );
      },
    );
  }

  List<PlpListItem> _buildListItems(
    List<ListingProductEntity> products,
    List<FloatingFilterSectionEntity> floatingFilters,
  ) {
    if (floatingFilters.isEmpty) return _productsToRows(products);

    final sorted =
        floatingFilters
            .where((f) => f.position != null && f.tiles.isNotEmpty)
            .toList()
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

  List<PlpListItem> _appendLoadMoreItems(
    List<PlpListItem> existing,
    List<ListingProductEntity> newProducts,
  ) {
    if (newProducts.isEmpty) return existing;

    final result = List<PlpListItem>.from(existing);
    var toConvert = newProducts;

    if (result.isNotEmpty && result.last is ProductRowItem) {
      final lastRow = result.last as ProductRowItem;
      if (lastRow.right == null) {
        result.removeLast();
        toConvert = [lastRow.left, ...newProducts];
      }
    }

    result.addAll(_productsToRows(toConvert));
    return result;
  }

  List<ProductRowItem> _productsToRows(List<ListingProductEntity> products) {
    final rows = <ProductRowItem>[];
    for (var i = 0; i < products.length; i += 2) {
      rows.add(
        ProductRowItem(
          left: products[i],
          right: i + 1 < products.length ? products[i + 1] : null,
        ),
      );
    }
    return rows;
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
