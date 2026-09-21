/// The two tabs on the Orders screen.
///
/// They are separate endpoints — `orders-listing/v6` and `gift-cards-listing/v2` —
/// returning the identical envelope and record shape, so one repository, one
/// bloc and one card widget serve both. A gift-card row is a strict subset of
/// an order row: same keys, minus `size`.
///
/// [wireValue] is what the backend puts in `trackingMeta.tab` and what
/// `order_listing_viewed` reports. It exists so the client never has to derive
/// the dimension itself — the value is read off the response node, and this
/// enum only names the two possibilities for routing and tab state.
enum OrdersTab {
  orders('orders'),
  giftCards('gift_cards');

  const OrdersTab(this.wireValue);

  final String wireValue;
}
