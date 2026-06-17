import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../pdp/domain/usecases/add_to_wishlist_usecase.dart';
import '../../../pdp/domain/usecases/remove_from_wishlist_usecase.dart';
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
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;
  final PlpQueryBuilder _queryBuilder = PlpQueryBuilder();

  final Map<int, FloatingFilterSectionEntity> _floatingSectionsByPosition = {};

  PlpBloc({
    required this.getListingDataUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  }) : super(const PlpState()) {
    on<LoadPlpData>(_onLoadPlpData);
    on<LoadMorePlpData>(_onLoadMorePlpData);
    on<ApplyFilter>(_onApplyFilter);
    on<ApplyMultipleFilters>(_onApplyMultipleFilters);
    on<RemoveFilter>(_onRemoveFilter);
    on<ClearAllFilters>(_onClearAllFilters);
    on<ApplySort>(_onApplySort);
    on<ApplyFloatingFilter>(_onApplyFloatingFilter);
    on<ToggleWishlistOnProduct>(_onToggleWishlist);
  }

  Future<void> _onLoadPlpData(LoadPlpData event, Emitter<PlpState> emit) async {
    _queryBuilder.reset(
      pageType: event.pageType,
      plpId: event.plpId,
      searchQuery: event.searchQuery,
      rawSearchParams: event.rawSearchParams,
      initialFilters: event.initialFilters,
    );
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
    _queryBuilder.filterParams['isFromRefineFilter'] = 'true';
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyMultipleFilters(ApplyMultipleFilters event, Emitter<PlpState> emit) async {
    _queryBuilder.filterParams.clear();
    _queryBuilder.filterParams.addAll(event.filters);
    _queryBuilder.filterParams['isFromRefineFilter'] = 'true';
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

    _queryBuilder.filterParams['isFromRefineFilter'] = 'true';
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
    _queryBuilder.orderRule = event.orderRule;
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onApplyFloatingFilter(ApplyFloatingFilter event, Emitter<PlpState> emit) async {
    if (event.value.isEmpty) {
      _queryBuilder.filterParams.remove(event.key);
    } else {
      _queryBuilder.filterParams[event.key] = event.value;
    }
    _queryBuilder.filterParams['isFromRefineFilter'] = 'true';
    _queryBuilder.currentPage = 0;
    emit(const PlpState(status: PlpStatus.loading));
    await _fetchAndEmit(emit);
  }

  Future<void> _onToggleWishlist(ToggleWishlistOnProduct event, Emitter<PlpState> emit) async {
    final productId = event.product.id;
    final index = state.products.indexWhere((p) => p.id == productId);
    if (index < 0) return;

    final original = state.products[index];
    final removing = original.isWishlisted && original.wishlistId != null;

    final optimistic = removing
        ? original.copyWith(isWishlisted: false, wishlistId: null)
        : original.copyWith(isWishlisted: true, wishlistId: null);
    _emitUpdatedProduct(emit, index: index, updated: optimistic);

    if (removing) {
      final result = await removeFromWishlistUseCase(
        RemoveFromWishlistParams(wishlistId: original.wishlistId!),
      );
      result.fold((failure) {
        if (failure is RequestCancelledFailure) return;
        _revertProduct(emit, productId: productId, restored: original);
        _emitWishlistFeedback(emit, message: "Couldn't remove from wishlist", isError: true);
      }, (_) => _emitWishlistFeedback(emit, message: 'Removed from wishlist', isError: false));
    } else {
      final priceInt = _parsePriceToInt(original.price?.sellingPrice);
      final result = await addToWishlistUseCase(
        AddToWishlistParams(productId: productId.toString(), price: priceInt),
      );
      result.fold(
        (failure) {
          if (failure is RequestCancelledFailure) return;
          _revertProduct(emit, productId: productId, restored: original);
          _emitWishlistFeedback(emit, message: "Couldn't add to wishlist", isError: true);
        },
        (response) {
          _patchWishlistId(emit, productId: productId, wishlistId: response.wishlistItemId);
          _emitWishlistFeedback(emit, message: 'Added to wishlist', isError: false);
        },
      );
    }
  }

  void _revertProduct(
    Emitter<PlpState> emit, {
    required int productId,
    required ListingProductEntity restored,
  }) {
    final i = state.products.indexWhere((p) => p.id == productId);
    if (i < 0) return;
    _emitUpdatedProduct(emit, index: i, updated: restored);
  }

  void _patchWishlistId(
    Emitter<PlpState> emit, {
    required int productId,
    required String? wishlistId,
  }) {
    final i = state.products.indexWhere((p) => p.id == productId);
    if (i < 0) return;
    final p = state.products[i];
    if (!p.isWishlisted) return;
    _emitUpdatedProduct(
      emit,
      index: i,
      updated: p.copyWith(wishlistId: wishlistId),
    );
  }

  void _emitWishlistFeedback(
    Emitter<PlpState> emit, {
    required String message,
    required bool isError,
  }) {
    emit(
      state.copyWith(
        wishlistFeedbackTick: state.wishlistFeedbackTick + 1,
        wishlistFeedbackMessage: message,
        wishlistFeedbackIsError: isError,
      ),
    );
  }

  void _emitUpdatedProduct(
    Emitter<PlpState> emit, {
    required int index,
    required ListingProductEntity updated,
    String? feedbackMessage,
  }) {
    final current = state;
    final newProducts = List<ListingProductEntity>.from(current.products)..[index] = updated;

    final newListItems = current.listItems.map<PlpListItem>((item) {
      if (item is ProductRowItem) {
        final leftMatch = item.left.id == updated.id;
        final rightMatch = item.right?.id == updated.id;
        if (!leftMatch && !rightMatch) return item;
        return ProductRowItem(
          left: leftMatch ? updated : item.left,
          right: rightMatch ? updated : item.right,
        );
      }
      if (item is ProductXLItem && item.product.id == updated.id) {
        return ProductXLItem(product: updated);
      }
      return item;
    }).toList();

    emit(
      current.copyWith(
        products: newProducts,
        listItems: newListItems,

        wishlistFeedbackTick: feedbackMessage != null
            ? current.wishlistFeedbackTick + 1
            : current.wishlistFeedbackTick,
        wishlistFeedbackMessage: feedbackMessage ?? current.wishlistFeedbackMessage,
        wishlistFeedbackIsError: feedbackMessage != null ? false : current.wishlistFeedbackIsError,
      ),
    );
  }

  int _parsePriceToInt(String? raw) {
    if (raw == null || raw.isEmpty) return 0;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
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
        } else {
          emit(state.copyWith(status: PlpStatus.error, errorMessage: failure.message));
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

        if (isLoadMore) {
          final base = paginationBase!;
          final products = [...base.products, ...data.records];
          _accumulateFloatingSections(data.floatingFilter?.sections);
          emit(
            base.copyWith(
              isLoadingMore: false,
              products: products,
              listItems: _buildListItems(products, _orderedFloatingSections),
              totalRecords: data.totalRecords,
              currentPage: _queryBuilder.currentPage,
              hasMore: data.hasMorePages,
            ),
          );
        } else {
          // Seed orderRule from the API response so subsequent requests
          _queryBuilder.orderRule = data.pageMeta?.orderRule;

          // Fresh load (page 1 / filter / sort) — reset the cross-page
          // floating-filter accumulator and seed it with this page's sections.
          _floatingSectionsByPosition.clear();
          _accumulateFloatingSections(data.floatingFilter?.sections);

          final products = data.records;
          emit(
            PlpState(
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
            ),
          );
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
