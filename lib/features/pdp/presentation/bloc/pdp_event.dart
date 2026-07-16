part of 'pdp_bloc.dart';

@freezed
sealed class PdpEvent with _$PdpEvent {
  const factory PdpEvent.loadProductDetails({required int productId}) =
      LoadProductDetails;
  const factory PdpEvent.selectSku({required String skuId}) = SelectSku;
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
