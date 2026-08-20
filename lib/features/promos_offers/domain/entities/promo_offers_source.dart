/// Surface that opened the offers sheet. Tells BE which offer set to return.
///
/// [wireValue] is the exact string the API has always been sent — do not
/// rename it to match the Dart identifier.
enum PromoOffersSource {
  cart('cart'),
  pdp('pdp');

  const PromoOffersSource(this.wireValue);

  final String wireValue;
}
