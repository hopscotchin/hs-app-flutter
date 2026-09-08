part of 'pdp_bloc.dart';

@freezed
sealed class PdpEvent with _$PdpEvent {
  /// [colorVariant] is `true` only when a colour swatch led here. It goes on the
  /// request, and the response answers `redirected_from_colour_widget` — see
  /// `docs/analytics/pdp/contract/passthrough-spec.md` §2.1.
  const factory PdpEvent.loadProductDetails({
    required int productId,
    @Default(false) bool colorVariant,
  }) = LoadProductDetails;
  /// [fromLocation] distinguishes the inline size strip from the bottom sheet —
  /// Android sends `Size list upfront` vs `Add to cart button` on
  /// `size_selected` (`SizeSelectionView.kt:32` / `SizeSelectionDialog.kt:93`).
  const factory PdpEvent.selectSku({
    required String skuId,
    required String fromLocation,
  }) = SelectSku;
  const factory PdpEvent.addToBag({required String skuId}) = AddToBag;
  const factory PdpEvent.buyNow({required String skuId}) = BuyNow;
  const factory PdpEvent.verifyPincode({required String pincode}) =
      VerifyPincode;
  const factory PdpEvent.selectColorVariant({required int productId}) =
      SelectColorVariant;
  const factory PdpEvent.expandDetailTab({required int tabIndex}) =
      ExpandDetailTab;
  const factory PdpEvent.loadRecommendations({required int productId}) =
      LoadRecommendations;
  const factory PdpEvent.loadMoreRecommendations() = LoadMoreRecommendations;
  const factory PdpEvent.loadSizeChart() = LoadSizeChart;
}
