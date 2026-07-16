part of 'cart_actions_cubit.dart';

/// Global add-to-cart state shared by every screen.
///
/// [addedSkus] drives the per-SKU "ADD TO BAG → GO TO BAG" affordance so the
/// label stays consistent wherever the same SKU appears.
@freezed
abstract class CartActionsState with _$CartActionsState {
  const factory CartActionsState({
    @Default(<String>{}) Set<String> addedSkus,
    @Default(<String>{}) Set<String> inFlight,
    @Default(0) int feedbackTick,
    String? feedbackMessage,
    @Default(false) bool feedbackIsError,
  }) = _CartActionsState;
}

extension CartActionsStateX on CartActionsState {
  bool isAdded(String skuId) => addedSkus.contains(skuId);
  bool isInFlight(String skuId) => inFlight.contains(skuId);
}
