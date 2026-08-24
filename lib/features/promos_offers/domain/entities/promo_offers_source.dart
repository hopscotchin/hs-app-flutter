/// Surface that opened the offers sheet. Tells BE which offer set to return.
///
/// [wireValue] is the exact string the API has always been sent — do not
/// rename it to match the Dart identifier.
enum PromoOffersSource {
  /// The cart's own promo field — the user typed the code by hand.
  cart('cart'),
  pdp('pdp'),

  /// The offers bottom sheet — the user tapped Apply on a listed offer.
  offerList('offer-list');

  const PromoOffersSource(this.wireValue);

  final String wireValue;
}
