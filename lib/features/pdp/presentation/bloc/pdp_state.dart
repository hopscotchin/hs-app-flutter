part of 'pdp_bloc.dart';

enum PdpStatus { initial, loading, success, error }

@freezed
abstract class PdpState with _$PdpState {
  const factory PdpState({
    @Default(PdpStatus.initial) PdpStatus status,
    ProductDetailEntity? productDetail,
    SkuEntity? selectedSku,
    @Default(0) int expandedDetailTab,
    @Default(false) bool isAddingToBag,
    @Default(false) bool isBuyingNow,
    // Shared one-shot snackbar channel (add-to-bag, buy-now). The tick is bumped
    // on every message so the UI re-fires even when the same message repeats —
    // mirrors WishlistState's feedbackTick pattern. (Pincode-verify failures use
    // the pincodeVerify* channel below so the sheet can show them inline.)
    @Default(0) int snackBarTick,
    String? snackBarMessage,
    @Default(false) bool snackBarIsError,
    // Bumped only when an add-to-bag call comes back successful, so the PDP can
    // play the fly-to-cart animation on a server-confirmed add and never on a
    // failed one. A tick (not a bool) so consecutive adds each fire.
    @Default(0) int addToBagSuccessTick,
    // The buy-now equivalent: bumped only on a server-confirmed buy-now. It is a
    // separate channel because the PDP does more with it — the same fly-to-cart
    // animation, and then a hand-off to the cart in buy-now mode (Android's
    // `AddToBagAnimationHandler` end-listener calling `goToCart(fromBuyNow)`).
    @Default(0) int buyNowSuccessTick,
    String? errorMessage,
    RecommendationsEntity? recommendations,
    @Default(1) int recommendationsPage,
    @Default(false) bool isLoadingMoreRecommendations,
    @Default(false) bool isLoadingSizeChart,
    SizeChartEntity? sizeChart,
    String? sizeChartError,
    String? verifiedPincode,
    // PDP pincode-verify outcome, consumed by the pincode sheet so it can stay
    // open and surface the failure inline. The tick bumps on every completion so
    // the awaiting caller resolves even when the same result repeats; the error
    // string is null on success and a plain message on failure.
    @Default(0) int pincodeVerifyTick,
    String? pincodeVerifyError,
  }) = _PdpState;
}

extension PdpStateX on PdpState {
  bool get hasProduct => productDetail?.product != null;
}
