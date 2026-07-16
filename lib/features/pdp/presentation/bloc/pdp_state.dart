part of 'pdp_bloc.dart';

enum PdpStatus { initial, loading, success, error }

@freezed
abstract class PdpState with _$PdpState {
  const factory PdpState({
    @Default(PdpStatus.initial) PdpStatus status,
    ProductDetailEntity? productDetail,
    SkuEntity? selectedSku,
    @Default(-1) int expandedDetailTab,
    @Default(false) bool isAddingToBag,
    @Default(false) bool isBuyingNow,
    // Shared one-shot snackbar channel (add-to-bag, buy-now, pincode failures).
    // The tick is bumped on every message so the UI re-fires even when the same
    // message repeats — mirrors WishlistState's feedbackTick pattern.
    @Default(0) int snackBarTick,
    String? snackBarMessage,
    @Default(false) bool snackBarIsError,
    String? errorMessage,
    RecommendationsEntity? recommendations,
    @Default(1) int recommendationsPage,
    @Default(false) bool isLoadingMoreRecommendations,
    @Default(false) bool isLoadingSizeChart,
    SizeChartEntity? sizeChart,
    String? sizeChartError,
    String? verifiedPincode,
    String? pincodeErrorMessage,
  }) = _PdpState;
}

extension PdpStateX on PdpState {
  bool get hasProduct => productDetail?.product != null;
}
