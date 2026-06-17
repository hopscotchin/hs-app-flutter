import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/cubits/cart_count_cubit.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/sku_entity.dart';
import '../../domain/entities/wish_list_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import '../../domain/usecases/verify_pincode_usecase.dart';

part 'pdp_event.dart';
part 'pdp_state.dart';

@injectable
class PdpBloc extends Bloc<PdpEvent, PdpState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;
  final VerifyPincodeUseCase verifyPincodeUseCase;
  final CartCountCubit cartCountCubit;

  PdpBloc({
    required this.getProductDetailsUseCase,
    required this.addToCartUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
    required this.verifyPincodeUseCase,
    required this.cartCountCubit,
  }) : super(const PdpInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<SelectSku>(_onSelectSku);
    on<ToggleWishlist>(_onToggleWishlist);
    on<AddToBag>(_onAddToBag);
    on<BuyNow>(_onBuyNow);
    on<VerifyPincode>(_onVerifyPincode);
    on<SelectColorVariant>(_onSelectColorVariant);
    on<ExpandDetailTab>(_onExpandDetailTab);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<PdpState> emit,
  ) async {
    emit(const PdpLoading());

    final result = await getProductDetailsUseCase(
      GetProductDetailsParams(productId: event.productId),
    );

    result.fold((failure) => emit(PdpError(message: failure.message)), (
      productDetail,
    ) {
      final skus = productDetail.product?.skus ?? [];
      final defaultSku = skus.where((s) => s.enable == true).firstOrNull;
      emit(PdpLoaded(productDetail: productDetail, selectedSku: defaultSku));
    });
  }

  void _onSelectSku(SelectSku event, Emitter<PdpState> emit) {
    final currentState = state;
    if (currentState is PdpLoaded) {
      final skus = currentState.productDetail.product?.skus ?? [];
      final sku = skus.where((s) => s.skuId == event.skuId).firstOrNull;
      if (sku != null) {
        emit(currentState.copyWith(selectedSku: sku));
      }
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlist event,
    Emitter<PdpState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PdpLoaded) return;

    final product = currentState.productDetail.product;
    if (product == null) return;

    final wishList = product.wishList;
    final isCurrentlyWishlisted = wishList?.status == true;

    if (isCurrentlyWishlisted && wishList?.id != null) {
      // Remove from wishlist
      final result = await removeFromWishlistUseCase(
        RemoveFromWishlistParams(wishlistId: wishList!.id!),
      );
      result.fold(
        (failure) =>
            emit(currentState.copyWith(addToBagMessage: failure.message)),
        (_) {
          final updatedProduct = product.copyWith(
            wishList: const WishListEntity(status: false),
          );
          emit(
            currentState.copyWith(
              productDetail: currentState.productDetail.copyWith(
                product: updatedProduct,
              ),
            ),
          );
        },
      );
    } else {
      // Add to wishlist
      final productId = product.id?.toString() ?? '';
      final price =
          product.price?.absoluteValue?.toInt() ??
          int.tryParse(product.price?.mrp ?? '') ??
          0;
      final skuId = currentState.selectedSku?.skuId;

      final result = await addToWishlistUseCase(
        AddToWishlistParams(productId: productId, price: price, skuId: skuId),
      );
      result.fold(
        (failure) =>
            emit(currentState.copyWith(addToBagMessage: failure.message)),
        (response) {
          final updatedProduct = product.copyWith(
            wishList: WishListEntity(id: response.wishlistItemId, status: true),
          );
          emit(
            currentState.copyWith(
              productDetail: currentState.productDetail.copyWith(
                product: updatedProduct,
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _onAddToBag(AddToBag event, Emitter<PdpState> emit) async {
    final currentState = state;
    if (currentState is! PdpLoaded) return;

    emit(
      currentState.copyWith(isAddingToBag: true, clearAddToBagMessage: true),
    );

    final result = await addToCartUseCase(AddToCartParams(skuId: event.skuId));

    final latestState = state;
    if (latestState is! PdpLoaded) return;

    result.fold(
      (failure) => emit(
        latestState.copyWith(
          isAddingToBag: false,
          addToBagMessage: failure.message,
        ),
      ),
      (response) {
        if (response.cartItemQty != null) {
          cartCountCubit.set(response.cartItemQty!);
        }
        final updated = _markSkuAsAddedToBag(latestState, event.skuId);
        emit(
          updated.copyWith(
            isAddingToBag: false,
            addToBagMessage: response.message ?? 'Added to bag',
          ),
        );
      },
    );
  }

  Future<void> _onBuyNow(BuyNow event, Emitter<PdpState> emit) async {
    final currentState = state;
    if (currentState is! PdpLoaded) return;

    emit(currentState.copyWith(isBuyingNow: true, clearAddToBagMessage: true));

    final result = await addToCartUseCase(
      AddToCartParams(skuId: event.skuId, fromBuyNow: true),
    );

    final latestState = state;
    if (latestState is! PdpLoaded) return;

    result.fold(
      (failure) => emit(
        latestState.copyWith(
          isBuyingNow: false,
          addToBagMessage: failure.message,
        ),
      ),
      (response) {
        if (response.cartItemQty != null) {
          cartCountCubit.set(response.cartItemQty!);
        }
        final updated = _markSkuAsAddedToBag(latestState, event.skuId);
        emit(
          updated.copyWith(
            isBuyingNow: false,
            addToBagMessage: response.message,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyPincode(
    VerifyPincode event,
    Emitter<PdpState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PdpLoaded) return;

    final product = currentState.productDetail.product;
    if (product == null) return;

    final productId = product.id;
    if (productId == null) return;

    final result = await verifyPincodeUseCase(
      VerifyPincodeParams(productId: productId, pincode: event.pincode),
    );

    final latestState = state;
    if (latestState is! PdpLoaded) return;

    result.fold(
      (failure) => emit(latestState.copyWith(addToBagMessage: failure.message)),
      (pincodeCheck) {
        final currentProduct = latestState.productDetail.product;
        if (currentProduct == null) return;

        // Update per-SKU EDD info from the pincode response
        final updatedSkus = currentProduct.skus.map((sku) {
          final matchingSku = pincodeCheck.skus
              .where((s) => s.skuId == sku.skuId)
              .firstOrNull;
          if (matchingSku?.eddInfo != null) {
            return sku.copyWith(eddInfo: matchingSku!.eddInfo);
          }
          return sku;
        }).toList();

        final updatedProduct = currentProduct.copyWith(
          eddInfo: pincodeCheck.eddInfo ?? currentProduct.eddInfo,
          isServiceable: pincodeCheck.isServiceable,
          serviceGuarantee: pincodeCheck.serviceGuarantee.isNotEmpty
              ? pincodeCheck.serviceGuarantee
              : null,
          visualCues: pincodeCheck.visualCues.isNotEmpty
              ? pincodeCheck.visualCues
              : null,
          skus: updatedSkus,
          pinCode: event.pincode,
        );

        // Update selectedSku's EDD from response if available
        var updatedSelectedSku = latestState.selectedSku;
        if (updatedSelectedSku != null) {
          final matchingSku = pincodeCheck.skus
              .where((s) => s.skuId == updatedSelectedSku!.skuId)
              .firstOrNull;
          if (matchingSku?.eddInfo != null) {
            updatedSelectedSku = updatedSelectedSku.copyWith(
              eddInfo: matchingSku!.eddInfo,
            );
          }
        }

        emit(
          latestState.copyWith(
            productDetail: latestState.productDetail.copyWith(
              product: updatedProduct,
            ),
            selectedSku: updatedSelectedSku,
          ),
        );
      },
    );
  }

  void _onSelectColorVariant(SelectColorVariant event, Emitter<PdpState> emit) {
    add(LoadProductDetails(productId: event.productId));
  }

  void _onExpandDetailTab(ExpandDetailTab event, Emitter<PdpState> emit) {
    final currentState = state;
    if (currentState is PdpLoaded) {
      final newIndex = currentState.expandedDetailTab == event.tabIndex
          ? -1
          : event.tabIndex;
      emit(currentState.copyWith(expandedDetailTab: newIndex));
    }
  }

  PdpLoaded _markSkuAsAddedToBag(PdpLoaded currentState, String skuId) {
    final product = currentState.productDetail.product;
    if (product == null) return currentState;

    final updatedSkus = product.skus.map((sku) {
      if (sku.skuId == skuId) {
        return sku.copyWith(isAddedToBag: true);
      }
      return sku;
    }).toList();

    final updatedProduct = product.copyWith(skus: updatedSkus);
    final updatedProductDetail = currentState.productDetail.copyWith(
      product: updatedProduct,
    );

    // Update selectedSku if it matches
    var updatedSelectedSku = currentState.selectedSku;
    if (updatedSelectedSku?.skuId == skuId) {
      updatedSelectedSku = updatedSelectedSku!.copyWith(isAddedToBag: true);
    }

    return currentState.copyWith(
      productDetail: updatedProductDetail,
      selectedSku: updatedSelectedSku,
    );
  }
}
