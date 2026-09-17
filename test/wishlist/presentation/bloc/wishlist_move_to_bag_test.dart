import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/events/analytics_helper.dart';
import 'package:hs_app_flutter/core/cubits/cart_count_cubit.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/core/services/pref_manager.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/wishlist_info_entity.dart';
import 'package:hs_app_flutter/features/wishlist/domain/entities/move_to_cart_result_entity.dart';
import 'package:hs_app_flutter/features/wishlist/domain/entities/wishlist_page_entity.dart';
import 'package:hs_app_flutter/features/wishlist/domain/entities/wishlist_product_entity.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/get_wishlist_page_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/move_to_cart_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/presentation/bloc/wishlist_listing_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWishlistPageUseCase extends Mock
    implements GetWishlistPageUseCase {}

class MockRemoveFromWishlistUseCase extends Mock
    implements RemoveFromWishlistUseCase {}

class MockMoveToCartUseCase extends Mock implements MoveToCartUseCase {}

/// The bloc only fires `wishlist_viewed` through this; stub the whole helper.
class MockAnalyticsHelper extends Mock implements AnalyticsHelper {}

/// Only the two members [CartCountCubit] touches.
class _FakePrefManager extends Fake implements PrefManager {
  int _qty = 0;

  @override
  int get cartItemQty => _qty;

  @override
  Future<void> setCartItemQty(int value) async => _qty = value;
}

const _kItem = WishlistProductEntity(
  product: ListingProductEntity(
    id: 944042,
    name: 'Gray Cat Print Sleeveless Top And Shorts',
    wishlistInfo: WishlistInfoEntity(id: 14938643, isWishlisted: true),
  ),
  moveToBagSku: 'DOP-3045211',
);

/// In stock, but the listing gave no usable `wishlistInfo.id`.
const _kNoWishlistIdItem = WishlistProductEntity(
  product: ListingProductEntity(id: 1, name: 'No wishlist id'),
  moveToBagSku: 'SKU-1',
);

const _kSoldOutItem = WishlistProductEntity(
  product: ListingProductEntity(id: 943717, name: 'Sold out', soldOut: true),
  moveToBagSku: 'OPT-1',
);

const _kLoaded = WishlistListingState(
  status: WishlistStatus.success,
  page: WishlistPageEntity(totalRecords: 1, items: [_kItem]),
  currentPage: 1,
);

void main() {
  late MockGetWishlistPageUseCase getPage;
  late MockRemoveFromWishlistUseCase removeFromWishlist;
  late MockMoveToCartUseCase moveToCart;
  late CartCountCubit cartCount;
  late MockAnalyticsHelper analytics;

  setUpAll(() {
    registerFallbackValue(
      const MoveToCartParams(wishlistItemId: 'x', skuId: 'x'),
    );
    registerFallbackValue(const RemoveFromWishlistParams(wishlistId: 'x'));
    registerFallbackValue(<String, Object?>{});
  });

  setUp(() {
    getPage = MockGetWishlistPageUseCase();
    removeFromWishlist = MockRemoveFromWishlistUseCase();
    moveToCart = MockMoveToCartUseCase();
    cartCount = CartCountCubit(_FakePrefManager());
    analytics = MockAnalyticsHelper();
    // Per-item events route through the extension onto `logEvent`.
    when(
      () => analytics.logEvent(
        any(),
        any(),
        attribution: any(named: 'attribution'),
      ),
    ).thenAnswer((_) async {});
  });

  WishlistListingBloc build() => WishlistListingBloc(
    getPage,
    removeFromWishlist,
    moveToCart,
    cartCount,
    analytics,
  );

  group('MoveWishlistItemToBag', () {
    blocTest<WishlistListingBloc, WishlistListingState>(
      'moves the item in one call, drops the tile and shows the success toast',
      build: build,
      seed: () => _kLoaded,
      setUp: () => when(() => moveToCart(any())).thenAnswer(
        (_) async => const Right(MoveToCartResultEntity(cartItemQty: 3)),
      ),
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kItem)),
      expect: () => [
        _kLoaded.copyWith(processingIds: const {944042}),
        _kLoaded.copyWith(
          page: const WishlistPageEntity(totalRecords: 0),
          message: 'Moved to bag',
        ),
      ],
      verify: (_) {
        // Bag badge follows the count the API reported.
        expect(cartCount.state, 3);
        verify(
          () => moveToCart(
            const MoveToCartParams(
              wishlistItemId: '14938643',
              skuId: 'DOP-3045211',
            ),
          ),
        ).called(1);
        // No separate remove call — the endpoint does both halves.
        verifyNever(() => removeFromWishlist(any()));
      },
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'sends the size picked in the sheet instead of the wishlisted SKU',
      build: build,
      seed: () => _kLoaded,
      setUp: () => when(() => moveToCart(any())).thenAnswer(
        (_) async => const Right(MoveToCartResultEntity(cartItemQty: 1)),
      ),
      act: (bloc) =>
          bloc.add(const MoveWishlistItemToBag(_kItem, skuId: 'DOP-3045212')),
      verify: (_) => verify(
        () => moveToCart(
          const MoveToCartParams(
            wishlistItemId: '14938643',
            skuId: 'DOP-3045212',
          ),
        ),
      ).called(1),
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'keeps the tile and toasts the API message on failure',
      build: build,
      seed: () => _kLoaded,
      setUp: () => when(() => moveToCart(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'This size just sold out')),
      ),
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kItem)),
      expect: () => [
        _kLoaded.copyWith(processingIds: const {944042}),
        _kLoaded.copyWith(message: 'This size just sold out'),
      ],
      verify: (_) => expect(cartCount.state, 0),
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'leaves the bag count alone when the API omits cartItemQty',
      build: build,
      seed: () => _kLoaded,
      setUp: () => when(
        () => moveToCart(any()),
      ).thenAnswer((_) async => const Right(MoveToCartResultEntity())),
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kItem)),
      verify: (_) => expect(cartCount.state, 0),
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'does not call the API for a sold-out item',
      build: build,
      seed: () => _kLoaded,
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kSoldOutItem)),
      expect: () => [
        _kLoaded.copyWith(message: 'This product is currently unavailable.'),
      ],
      verify: (_) => verifyNever(() => moveToCart(any())),
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'does not call the API without a wishlist item id',
      build: build,
      seed: () => _kLoaded,
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kNoWishlistIdItem)),
      expect: () => [
        _kLoaded.copyWith(message: 'Something went wrong. Please try again.'),
      ],
      verify: (_) => verifyNever(() => moveToCart(any())),
    );

    blocTest<WishlistListingBloc, WishlistListingState>(
      'ignores a second tap while the first is in flight',
      build: build,
      seed: () => _kLoaded.copyWith(processingIds: const {944042}),
      act: (bloc) => bloc.add(const MoveWishlistItemToBag(_kItem)),
      expect: () => const <WishlistListingState>[],
      verify: (_) => verifyNever(() => moveToCart(any())),
    );
  });
}
