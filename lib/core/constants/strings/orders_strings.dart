/// Copy for the Orders screen that the client legitimately owns.
///
/// Deliberately short. Almost everything the screen shows — status lines, empty
/// states, the support heading, button labels — arrives resolved from the
/// backend, which is the whole point of the v6 contract. Android bundles that
/// copy in the APK (`R.string.myOrdersEmptyMsg`, `R.string.empty_gift_card_title`,
/// `R.string.need_help_with_your_orders`); nothing here replaces it, because a
/// bundled fallback is what let the Orders tab ship for years with no
/// server-sent empty state at all.
///
/// What is left is chrome: the screen title, the two tab labels, and the
/// message shown when the network fails before any copy could arrive.
class OrdersStrings {
  OrdersStrings._();

  static const String screenTitle = 'Orders';

  static const String tabOrders = 'Orders';
  static const String tabGiftCards = 'Gift Cards';

  /// Row labels on the item card. Client-owned because they are structural —
  /// the wire sends the values (`quantity`, `size`) and never the words. Android
  /// bundles them the same way, as `R.string.qty` / `R.string.size` in
  /// `item_order.xml`.
  static const String qtyLabel = 'Qty:';
  static const String sizeLabel = 'Size:';

  /// Only used when the request fails outright and the server sent no message
  /// of its own — `Failure.message` is preferred wherever it exists.
  static const String genericError = 'Something went wrong. Please try again.';
}
