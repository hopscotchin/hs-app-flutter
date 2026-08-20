import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/error/failures.dart';
import '../../../cart/domain/usecases/add_to_cart_usecase.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/recommendations_entity.dart';
import '../../domain/entities/size_chart_entity.dart';
import '../../domain/entities/sku_entity.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../domain/usecases/get_size_chart_usecase.dart';
import '../../domain/usecases/verify_pincode_usecase.dart';

part 'pdp_bloc.freezed.dart';
part 'pdp_event.dart';
part 'pdp_state.dart';

@injectable
class PdpBloc extends BaseBloc<PdpEvent, PdpState> {
  PdpBloc({
    required this.getProductDetailsUseCase,
    required this.getRecommendationsUseCase,
    required this.addToCartUseCase,
    required this.verifyPincodeUseCase,
    required this.cartCountCubit,
    required this.getSizeChartUseCase,
  }) : super(const PdpState()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<LoadRecommendations>(_onLoadRecommendations);
    on<LoadMoreRecommendations>(_onLoadMoreRecommendations);
    on<SelectSku>(_onSelectSku);
    on<AddToBag>(_onAddToBag);
    on<BuyNow>(_onBuyNow);
    on<VerifyPincode>(_onVerifyPincode);
    on<SelectColorVariant>(_onSelectColorVariant);
    on<ExpandDetailTab>(_onExpandDetailTab);
    on<LoadSizeChart>(_onLoadSizeChart);
  }

  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final VerifyPincodeUseCase verifyPincodeUseCase;
  final CartCountCubit cartCountCubit;
  final GetSizeChartUseCase getSizeChartUseCase;

  Future<void> _onLoadProductDetails(LoadProductDetails event, Emitter<PdpState> emit) async {
    emit(const PdpState(status: PdpStatus.loading));
    final token = swapCancelToken();

    final result = await getProductDetailsUseCase(
      GetProductDetailsParams(productId: event.productId, cancelToken: token),
    );

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
        emit(PdpState(status: PdpStatus.error, errorMessage: f.message));
      },
      (productDetail) {
        emit(PdpState(status: PdpStatus.success, productDetail: productDetail));
        add(PdpEvent.loadRecommendations(productId: event.productId));
      },
    );
  }

  Future<void> _onLoadRecommendations(LoadRecommendations event, Emitter<PdpState> emit) async {
    final current = state;
    if (current.status != PdpStatus.success) return;

    final token = swapCancelToken();
    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(productId: event.productId, cancelToken: token),
    );

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
      },
      (recommendations) =>
          emit(state.copyWith(recommendations: recommendations, recommendationsPage: 1)),
    );
  }

  Future<void> _onLoadMoreRecommendations(
    LoadMoreRecommendations event,
    Emitter<PdpState> emit,
  ) async {
    final current = state;
    if (current.status != PdpStatus.success) return;
    final existing = current.recommendations;
    if (existing == null) return;
    if (existing.pageMeta?.hasNextPage != true) return;
    if (current.isLoadingMoreRecommendations) return;

    final productId = current.productDetail?.product?.id;
    if (productId == null) return;

    final nextPage = current.recommendationsPage + 1;
    emit(current.copyWith(isLoadingMoreRecommendations: true));

    final token = swapCancelToken();
    final result = await getRecommendationsUseCase(
      GetRecommendationsParams(productId: productId, pageNo: nextPage, cancelToken: token),
    );

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
        emit(current.copyWith(isLoadingMoreRecommendations: false));
      },
      (newPage) => emit(
        current.copyWith(
          isLoadingMoreRecommendations: false,
          recommendationsPage: nextPage,
          recommendations: existing.copyWith(
            records: [...existing.records, ...newPage.records],
            pageMeta: newPage.pageMeta,
          ),
        ),
      ),
    );
  }

  void _onSelectSku(SelectSku event, Emitter<PdpState> emit) {
    final current = state;
    if (current.status != PdpStatus.success) return;
    final skus = current.productDetail?.product?.skus ?? [];
    final sku = skus.where((s) => s.skuId == event.skuId).firstOrNull;
    if (sku == null) return;
    emit(current.copyWith(selectedSku: sku));
  }

  Future<void> _onAddToBag(AddToBag event, Emitter<PdpState> emit) async {
    final current = state;
    if (current.status != PdpStatus.success) return;

    emit(current.copyWith(isAddingToBag: true));

    final result = await addToCartUseCase(AddToCartParams(skuId: event.skuId));

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
        emit(
          current.copyWith(
            isAddingToBag: false,
            snackBarTick: current.snackBarTick + 1,
            snackBarMessage: f.message,
            snackBarIsError: true,
          ),
        );
      },
      (response) {
        if (response.cartItemQty != null) {
          cartCountCubit.set(response.cartItemQty!);
        }
        final updated = _markSkuAsAddedToBag(current, event.skuId);
        emit(
          updated.copyWith(
            isAddingToBag: false,
            snackBarTick: current.snackBarTick + 1,
            snackBarMessage: response.message ?? 'Added to bag',
            snackBarIsError: false,
            addToBagSuccessTick: current.addToBagSuccessTick + 1,
          ),
        );
      },
    );
  }

  Future<void> _onBuyNow(BuyNow event, Emitter<PdpState> emit) async {
    final current = state;
    if (current.status != PdpStatus.success) return;

    emit(current.copyWith(isBuyingNow: true));

    final result = await addToCartUseCase(AddToCartParams(skuId: event.skuId, fromBuyNow: true));

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
        emit(
          current.copyWith(
            isBuyingNow: false,
            snackBarTick: current.snackBarTick + 1,
            snackBarMessage: f.message,
            snackBarIsError: true,
          ),
        );
      },
      (response) {
        if (response.cartItemQty != null) {
          cartCountCubit.set(response.cartItemQty!);
        }
        final updated = _markSkuAsAddedToBag(current, event.skuId);
        // No success snackbar here (Android shows none for buy-now either): the
        // page plays the fly-to-cart animation off this tick and then hands off
        // to the cart, so a toast would surface on the wrong screen.
        emit(
          updated.copyWith(
            isBuyingNow: false,
            buyNowSuccessTick: current.buyNowSuccessTick + 1,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyPincode(VerifyPincode event, Emitter<PdpState> emit) async {
    final current = state;
    if (current.status != PdpStatus.success) return;

    final product = current.productDetail?.product;
    if (product == null) return;

    final productId = product.id;
    if (productId == null) return;

    final token = swapCancelToken();
    final result = await verifyPincodeUseCase.call(
      VerifyPincodeParams(productId: productId, pincode: event.pincode, cancelToken: token),
    );

    result.fold(
      (f) {
        if (f is RequestCancelledFailure) return;
        // Network/unknown failure — reported to the (still-open) sheet, which
        // shows it inline and lets the user retry. Prefer server-provided bars
        // (cart-style) when present, else wrap the plain message.
        emit(
          current.copyWith(
            pincodeVerifyTick: current.pincodeVerifyTick + 1,
            pincodeVerifyError: _pincodeError(f.message),
          ),
        );
      },
      (pincodeCheck) {
        final action = pincodeCheck.action?.toLowerCase();
        final isFailure = action != null && action != 'success';
        if (isFailure) {
          // Not serviceable for this product. Leave verifiedPincode untouched —
          // the pincode isn't accepted — and hand the message(s) to the sheet.
          // The verify response carries only a plain string today, so wrap it;
          // if the endpoint ever returns bars, prefer them here (like cart).
          emit(
            current.copyWith(
              pincodeVerifyTick: current.pincodeVerifyTick + 1,
              pincodeVerifyError: _pincodeError(pincodeCheck.message),
            ),
          );
          return;
        }

        final updatedSkus = product.skus.map((sku) {
          final matchingSku = pincodeCheck.skus.where((s) => s.skuId == sku.skuId).firstOrNull;
          if (matchingSku?.eddInfo != null) {
            return sku.copyWith(eddInfo: matchingSku!.eddInfo);
          }
          return sku;
        }).toList();

        final updatedProduct = product.copyWith(
          eddInfo: pincodeCheck.eddInfo ?? product.eddInfo,
          isServiceable: pincodeCheck.isServiceable,
          serviceGuarantee: pincodeCheck.serviceGuarantee.isNotEmpty
              ? pincodeCheck.serviceGuarantee
              : product.serviceGuarantee,
          visualCue: pincodeCheck.visualCues.isNotEmpty
              ? pincodeCheck.visualCues.first
              : product.visualCue,
          skus: updatedSkus,
        );

        var updatedSelectedSku = current.selectedSku;
        if (updatedSelectedSku != null) {
          final matchingSku = pincodeCheck.skus
              .where((s) => s.skuId == updatedSelectedSku!.skuId)
              .firstOrNull;
          if (matchingSku?.eddInfo != null) {
            updatedSelectedSku = updatedSelectedSku.copyWith(eddInfo: matchingSku!.eddInfo);
          }
        }

        emit(
          current.copyWith(
            productDetail: current.productDetail!.copyWith(product: updatedProduct),
            selectedSku: updatedSelectedSku,
            verifiedPincode: event.pincode,
            // A null error signals success to the awaiting sheet, which then pops.
            pincodeVerifyTick: current.pincodeVerifyTick + 1,
            pincodeVerifyError: null,
          ),
        );
      },
    );
  }

  /// Resolves the verify failure [message] to a plain error string, falling
  /// back to a generic message when the API returns nothing usable.
  String _pincodeError(String? message) =>
      message != null && message.isNotEmpty
          ? message
          : CommonStrings.somethingWentWrong;

  void _onSelectColorVariant(SelectColorVariant event, Emitter<PdpState> emit) {
    add(PdpEvent.loadProductDetails(productId: event.productId));
  }

  void _onExpandDetailTab(ExpandDetailTab event, Emitter<PdpState> emit) {
    final current = state;
    if (current.status != PdpStatus.success) return;
    final newIndex = current.expandedDetailTab == event.tabIndex ? -1 : event.tabIndex;
    emit(current.copyWith(expandedDetailTab: newIndex));
  }

  Future<void> _onLoadSizeChart(LoadSizeChart event, Emitter<PdpState> emit) async {
    final current = state;
    if (current.status != PdpStatus.success) return;

    final productId = current.productDetail?.product?.id;
    if (productId == null) return;

    emit(current.copyWith(isLoadingSizeChart: true, sizeChartError: null));
    final token = swapCancelToken();
    final result = await getSizeChartUseCase(
      GetSizeChartParams(productId: productId, cancelToken: token),
    );
    result.fold((f) {
      if (f is RequestCancelledFailure) return;
      emit(current.copyWith(isLoadingSizeChart: false, sizeChartError: f.message));
    }, (entity) => emit(current.copyWith(isLoadingSizeChart: false, sizeChart: entity)));
  }

  PdpState _markSkuAsAddedToBag(PdpState current, String skuId) {
    final product = current.productDetail?.product;
    if (product == null) return current;

    final updatedSkus = product.skus.map((sku) {
      if (sku.skuId == skuId) return sku.copyWith(isAddedToBag: true);
      return sku;
    }).toList();

    var updatedSelectedSku = current.selectedSku;
    if (updatedSelectedSku?.skuId == skuId) {
      updatedSelectedSku = updatedSelectedSku!.copyWith(isAddedToBag: true);
    }

    return current.copyWith(
      productDetail: current.productDetail!.copyWith(product: product.copyWith(skus: updatedSkus)),
      selectedSku: updatedSelectedSku,
    );
  }
}
