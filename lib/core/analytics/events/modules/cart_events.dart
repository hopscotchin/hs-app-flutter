import '../../analytics_map.dart';
import '../../analytics_payload_builder.dart';
import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Cart-surface events: `cart_viewed`, `product_update_clicked`,
/// `product_updated`, `product_added_to_wishlist` (cart variant),
/// `promo_code_applied` / `_failed` / `_removed`, `pincode_check_clicked`,
/// `pincode_checked`, `shipping_info_viewed`.
///
/// **The backend's `trackingMeta` blocks ARE the payload.** Android derives
/// `quantity_status`, `price_status`, `cart_filler_reco`, `image_url` and the
/// whole price block from the cart response in
/// `CartAnalytics.kt` — three separate implementations of the same two status
/// rules, which its own `docs/CART_ANALYTICS.md` calls out as the file's main
/// consistency risk. Those derivations have moved server-side: `/shopping-cart`
/// now answers with a cart-level `trackingMeta`, a per-item
/// `wishlistInfo.trackingMeta`, and a per-promo `trackingMeta`, each already
/// carrying the finished analytics values. This module forwards them verbatim.
///
/// So each method takes a `Map` rather than a typed cart. Nothing is renamed,
/// re-typed or defaulted here, and a new backend dimension reaches the
/// dashboards without an app release. The call site supplies only what the
/// server cannot know: which screen the user came from, which control they
/// tapped, whether this is the session's first cart load, and the before/after
/// values of a change the app itself made.
///
/// Assembled by [buildAnalyticsPayload] — server nodes first, the app's own
/// facts last — so a `trackingMeta` key can never overwrite a client-owned one.
extension CartEvents on AnalyticsHelper {
  /// `cart_viewed` — every cart response: first load, and every reload
  /// (promo change, quantity step, pincode change, merge, pull-to-refresh).
  ///
  /// Ports `CartAnalytics.fireCartViewedEvent` + `CartObserver.sendCartViewedEvent`,
  /// which together own the event on Android: the fragment builds the price
  /// block, the observer stamps `first_load` and `atc_user` and fires it.
  ///
  /// [trackingMeta] is the cart-level block, which carries the entire price and
  /// status payload Android derives by hand — `total_item_price`,
  /// `total_amount`, `shipping`, `net_amount`, `sku_count`, `total_quantity`,
  /// `message_bar`, `cart_filler_reco`, `quantity_status`, `price_status`,
  /// `image_url`, `shipping_minimum`, `atc_user`.
  ///
  /// An **empty cart** sends only the client-owned keys, matching Android's
  /// `else` branch — the backend simply sends no `trackingMeta` for one, so
  /// that shape falls out of the passthrough rather than needing a branch here.
  ///
  /// `funnel: "Cart"` is not set here: `AppNavigationObserver` applies
  /// [Funnel.cart] on the cart route push, so `attribution: true` already
  /// carries it.
  ///
  /// [tti] is time-to-interact in milliseconds: how long the user waited
  /// between opening the cart and this response being on screen. Measured by
  /// the caller, since the clock starts at the tap — before any of this exists.
  ///
  /// [isFirstLoad] is supplied by the caller rather than tracked here —
  /// `CartBloc` owns the flag, because "has the cart been loaded yet this
  /// session" is cart state, not analytics-transport state. Android keeps it in
  /// a `FirstCartLoad` singleton for the same reason: it is read once per
  /// process, so exactly one `cart_viewed` reports `Yes`.
  Future<void> logCartViewed({
    required String fromScreen,
    required String fromLocation,
    required String cartViewState,
    required bool isFirstLoad,
    int? tti,
    Map<String, dynamic>? trackingMeta,
  }) {
    return logEvent(
      AnalyticsEvents.cartViewed,
      buildAnalyticsPayload(
        nodes: [trackingMeta],
        payload: <String, Object?>{}
          ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
          ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
          ..putAnalyticsKey(AnalyticsProperties.cartViewState, cartViewState)
          ..putAnalyticsKey(AnalyticsProperties.tti, tti)
          // Written raw, not through putAnalyticsKey — `first_load` is a
          // Yes/No dimension where "No" is the meaningful majority case, so
          // it must never be dropped. Android bypasses its own filter here
          // too (`properties[FIRST_LOAD] = firstLoad`, a plain put).
          ..[AnalyticsProperties.firstLoad] = isFirstLoad
              ? AnalyticsDefaults.yes
              : AnalyticsDefaults.no,
      ),
      attribution: true,
    );
  }

  /// `product_update_clicked` — the user tapped a row control (+/-, remove,
  /// move-to-wishlist), before the API is called.
  ///
  /// Ports `CartAnalytics.fireProductUpdateClicked` (`CartProductViewHolder:236`).
  /// Android fires it with `isAttributionDataRequired = false`; mirrored.
  ///
  /// Typed rather than a `trackingMeta` passthrough, unlike most events here.
  /// The cart response carries no per-line analytics block: the nearest thing,
  /// `wishlistInfo.trackingMeta`, is the finished *move-to-wishlist* payload
  /// and describes the product as the wishlist would report it. Forwarding it
  /// put that blob's `sku`, `product_id`, `price` and `brand` on this event —
  /// a different product than the row the user touched.
  ///
  /// [price] is the **unit** price, matching Android's `product.price`.
  /// `product_updated` sends line totals instead; see there.
  Future<void> logProductUpdateClicked({
    required String fromLocation,
    String? sku,
    int? productId,
    String? brand,
    num? price,
    int? quantity,
    String? quantityStatus,
    String? priceStatus,
  }) => logEvent(
    AnalyticsEvents.productUpdateClicked,
    <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, FromScreens.shoppingCart)
      ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
      ..putAnalyticsKey(AnalyticsProperties.sku, sku)
      ..putAnalyticsKey(AnalyticsProperties.productId, productId)
      ..putAnalyticsKey(AnalyticsProperties.brand, brand)
      ..putAnalyticsKey(AnalyticsProperties.price, price)
      ..putAnalyticsKey(AnalyticsProperties.quantity, quantity)
      // One-element lists: the same keys `cart_viewed` sends across the whole
      // bag, so a dashboard groups on them without caring which event carried
      // them.
      ..putAnalyticsKey(AnalyticsProperties.quantityStatus, [?quantityStatus])
      ..putAnalyticsKey(AnalyticsProperties.priceStatus, [?priceStatus]),
    attribution: false,
  );

  /// `product_updated` — a quantity change or a removal **succeeded**.
  ///
  /// Ports `CartAnalytics.logProductUpdatedEvent`, called from
  /// `CartViewModel:193` (remove) and `:216` (quantity).
  ///
  /// [price] and [newPrice] are **line totals**, not unit prices: Android sends
  /// `product.price * oldQty` and `product.price * newQty`. The before/after
  /// pair is the one thing the server cannot supply — it knows the new state,
  /// not the state the row was in when the user tapped.
  ///
  /// [newPrice] is sent on **every** update, a removal included — Android
  /// writes it unguarded (`CartAnalytics:17`), where a removal makes it equal
  /// to [price] because the line's quantity has not changed. Only
  /// [newQuantity] is conditional, behind Android's
  /// `if (product.quantity != oldQty)`.
  ///
  /// That leaves a removal and a quantity-change distinguishable only by the
  /// absence of `new_quantity` — the event's biggest gap, per Android's own
  /// doc — so [fromLocation] is sent here as well
  /// ([FromLocations.updateCart] vs [FromLocations.removeCartItem]), which is
  /// the fix that doc recommends. ⚠️ New property for this event; no Android
  /// build emits it.
  ///
  /// Note it is the **control**, not the reload reason: the `cart_viewed` of
  /// the refetch that follows a removal reports [FromLocations.deleteCart]
  /// instead, which is Android's own value for that slot.
  ///
  /// [imageUrl] is this line's own image. Android sends
  /// `getAnyItemImageFromCartApartFrom` here — deliberately *a different cart
  /// item's* picture, which its own doc flags as unintended. Not reproduced.
  Future<void> logProductUpdated({
    required String fromScreen,
    required String fromLocation,
    String? sku,
    int? productId,
    String? brand,
    int? quantity,
    int? newQuantity,
    num? price,
    num? newPrice,
    String? imageUrl,
    String? quantityStatus,
    String? priceStatus,
  }) => logEvent(
    AnalyticsEvents.productUpdated,
    <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
      ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
      ..putAnalyticsKey(AnalyticsProperties.sku, sku)
      ..putAnalyticsKey(AnalyticsProperties.productId, productId)
      ..putAnalyticsKey(AnalyticsProperties.brand, brand)
      ..putAnalyticsKey(AnalyticsProperties.price, price)
      ..putAnalyticsKey(AnalyticsProperties.newPrice, newPrice)
      ..putAnalyticsKey(AnalyticsProperties.quantity, quantity)
      ..putAnalyticsKey(AnalyticsProperties.newQuantity, newQuantity)
      ..putAnalyticsKey(AnalyticsProperties.imageUrl, imageUrl)
      ..putAnalyticsKey(AnalyticsProperties.quantityStatus, [?quantityStatus])
      ..putAnalyticsKey(AnalyticsProperties.priceStatus, [?priceStatus]),
    attribution: false,
  );

  /// `product_added_to_wishlist`, cart variant — move-to-wishlist succeeded.
  ///
  /// Ports `CartAnalytics.logProductAddedToWishList` +
  /// `CartObserver.handleProductWishListedEvent`, which on Android is a
  /// two-stage assembly: the cart module writes ~25 product properties off
  /// `CartProductDto`, then the observer looks the SKU up in
  /// `trackingData.itemLevelTrackingData` and folds in `taste`, `hbt`,
  /// `merch_type`, `v_country`, `style`, `season`, `pattern`, `character`,
  /// `weave`.
  ///
  /// Both stages are now one server block: [trackingMeta] is the item's
  /// `wishlistInfo.trackingMeta`, which carries the product identity, the
  /// variant, the pricing, the classification, the flags, the cart-level promo
  /// context **and** those nine merchandising attributes already resolved.
  ///
  /// Deliberately separate from `WishlistEvents.logProductAddedToWishlist`
  /// despite the shared event name. That method defaults `from_location` to the
  /// wishlist button and stamps `atc_user` from prefs; this one reports a move
  /// out of the bag, and its `atc_user` arrives inside the block already
  /// resolved against login state (Android's `CartObserver.getATCUserType`
  /// folding, which the backend now does). Routing the cart through it would
  /// mean re-adding both of those as parameters and letting the prefs value
  /// overwrite the server's.
  ///
  /// Android's `image_count: 0` is not reproduced — a literal `0` that its own
  /// `putAnalyticsKey` drops, so the key never reaches the wire there either.
  /// It comes from the block when the backend sends a real count.
  ///
  /// The cart's promo state is **not** sent. Android puts `promo_codes` and
  /// `promo_applied_count` here (`CartAnalytics:256`, `:260`), but they
  /// describe the whole bag rather than the line being moved, and this event
  /// reports one product. ⚠️ A deliberate divergence: both keys go empty on
  /// this event where Android populates them.
  Future<void> logProductMovedToWishlistFromCart({Map<String, dynamic>? trackingMeta}) => logEvent(
    AnalyticsEvents.productAddedToWishlist,
    buildAnalyticsPayload(
      nodes: [trackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromScreen, FromScreens.shoppingCart)
        ..putAnalyticsKey(AnalyticsProperties.fromLocation, FromLocations.moveToWishlist),
    ),
    attribution: true,
  );

  /// `promo_code_applied` — a code was applied, by the user or auto-applied by
  /// the server.
  ///
  /// Ports `CartAnalytics.logPromoCodeApplied`. Android writes
  /// `promotion_discount` **twice** — once from `getPromoAppliedDiscount`, then
  /// again inside `getPromoListData`, where the second write wins; collapsed to
  /// the single value here, which its own doc asks for.
  Future<void> logPromoCodeApplied({required CartPromoPayload promo}) =>
      logEvent(AnalyticsEvents.promoCodeApplied, promo.toProps(), attribution: true);

  /// `promo_code_removed` — the user removed a code, or the server
  /// force-removed one (`forceRemove: true` on the promo block).
  ///
  /// Ports `CartAnalytics.logPromoCodeRemoved`. [removedPromoCode] is the one
  /// property that does not describe the cart's current state — by the time
  /// this fires the code is gone from the list, so it is passed explicitly.
  Future<void> logPromoCodeRemoved({
    required CartPromoPayload promo,
    required String removedPromoCode,
  }) => logEvent(
    AnalyticsEvents.promoCodeRemoved,
    promo.toProps()..putAnalyticsKey(AnalyticsProperties.removedPromoCode, removedPromoCode),
    attribution: true,
  );

  /// `promo_code_failed` — the apply call answered `success: false` (mistyped,
  /// expired, cart not eligible, mobile not verified).
  ///
  /// ⚠️ **Not fired by Android's cart.** `promo_code_failed` exists in its
  /// `AnalyticsHelper` (`:1034`) but the `hscart` module never calls it, which
  /// `docs/CART_ANALYTICS.md` flags as an open question — so today a rejected
  /// code is invisible in the funnel. Firing it restores the event Android's
  /// helper already declares rather than inventing one.
  ///
  /// [failedPromoCode] is the code the user typed and [promoError] the
  /// server's reason; both are the event's whole point, and neither can come
  /// from the cart, whose state a rejection leaves untouched.
  Future<void> logPromoCodeFailed({
    required CartPromoPayload promo,
    required String failedPromoCode,
    String? promoError,
  }) => logEvent(
    AnalyticsEvents.promoCodeFailed,
    promo.toProps()
      ..putAnalyticsKey(AnalyticsProperties.failedPromoCode, failedPromoCode)
      ..putAnalyticsKey(AnalyticsProperties.promoError, promoError),
    attribution: true,
  );

  /// `pincode_check_clicked` — the delivery-pincode row was tapped, before the
  /// sheet opens.
  ///
  /// Ports `CartAnalytics.logPinCodeClickedEvent` (`CartFragment:277`).
  /// [fromPincode] is the pincode currently applied to the cart, falling back
  /// to [AnalyticsDefaults.standard] when none is — Android's exact branch on
  /// `cart.deliveryPincode.pincode.isNullOrEmpty()`.
  Future<void> logPincodeCheckClicked({required String fromScreen, String? fromPincode}) =>
      logEvent(
        AnalyticsEvents.pincodeCheckClicked,
        <String, Object?>{}
          ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
          ..putAnalyticsKey(
            AnalyticsProperties.fromPincode,
            (fromPincode == null || fromPincode.isEmpty) ? AnalyticsDefaults.standard : fromPincode,
          ),
        attribution: false,
      );

  /// `pincode_checked` — a pincode was submitted and the serviceability call
  /// answered.
  ///
  /// `shipped_address` is always `"No"`: the new sheet has no saved-address
  /// path for the pincode itself, so every check is a manual entry. It is sent
  /// rather than omitted because the dashboard splits on it, and a missing key
  /// would silently merge manual entries into the "unknown" bucket.
  Future<void> logPincodeChecked({
    required String fromScreen,
    required String pincode,
    String? fromPincode,
  }) => logEvent(
    AnalyticsEvents.pincodeChecked,
    <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
      ..putAnalyticsKey(AnalyticsProperties.pincode, pincode)
      ..putAnalyticsKey(
        AnalyticsProperties.fromPincode,
        (fromPincode == null || fromPincode.isEmpty) ? AnalyticsDefaults.standard : fromPincode,
      )
      ..putAnalyticsKey(AnalyticsProperties.shippedAddress, AnalyticsDefaults.no),
    attribution: false,
  );

  /// `shipping_info_viewed` — a shipping/offer info affordance was opened
  /// (the price-summary info sheets, the "see offers" link).
  ///
  /// Ports `CartAnalytics.logShippingInfoViewedEvent` (`CartFragment:559`).
  ///
  /// Shipping fee only. The platform-fee row has its own event — see
  /// [logPlatformFeeInfoViewed].
  Future<void> logShippingInfoViewed({required String fromLocation}) => logEvent(
    AnalyticsEvents.shippingInfoViewed,
    <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, FromScreens.shoppingCart)
      ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation),
    attribution: false,
  );
}

/// The body every promo event shares, assembled once.
///
/// A value object rather than a pile of named parameters because all three
/// events send the **same eleven properties** and differ only in their one or
/// two extras — so the shape is stated once and cannot drift between them.
///
/// **Mapped, not forwarded.** The other cart blocks (`trackingMeta` on the cart
/// and on `wishlistInfo`) already use analytics key names, so they pass through
/// untouched. The promo block does not: it carries the backend's own field
/// names — `code`, `discount`, `applied`, `isMerchRule`, `autoApplied`,
/// `forceRemove`, `merchRuleType`, `action` — and shares **not one name** with
/// the payload these events must emit. Forwarding it put those eight on the
/// wire and produced none of `item_discount`, `promotion_discount` or
/// `merch_promo`.
class CartPromoPayload {
  const CartPromoPayload({
    this.totalItemPrice,
    this.totalAmount,
    this.fromShipping,
    this.fromNetAmount,
    this.itemDiscount,
    this.promotionDiscount,
    this.merchPromo = false,
    this.promoCodes = const [],
    this.promoAppliedCount = 0,
  });

  /// Price context, from `orderDetails`. Named `from_shipping` /
  /// `from_net_amount` here against `cart_viewed`'s `shipping` / `net_amount`
  /// — the same two backend fields under different keys, which is why these
  /// cannot come from the cart's flat block either.
  final num? totalItemPrice;
  final num? totalAmount;
  final num? fromShipping;
  final num? fromNetAmount;

  /// The applied promo's discount. Both keys come from the one backend
  /// `discount` field; [promotionDiscount] is dropped when not above zero,
  /// matching Android's `takeIf { it > 0 }`, while [itemDiscount] is sent
  /// whenever the cart has one — a rejected code still reports the discount
  /// already on the bag.
  final num? itemDiscount;
  final num? promotionDiscount;

  /// `merch_promo`, sent as `"Yes"` / `"No"`. Always present: "not a
  /// merchandising promo" is a real answer, and Android writes it unguarded.
  final bool merchPromo;

  /// Every code on the cart. Singular key `promo_code` holding an array —
  /// Android's naming, and the opposite of `product_added_to_wishlist`'s
  /// plural `promo_codes` for the same data.
  final List<String> promoCodes;

  final int promoAppliedCount;

  Map<String, Object?> toProps() => <String, Object?>{}
    ..putAnalyticsKey(AnalyticsProperties.fromScreen, FromScreens.shoppingCart)
    ..putAnalyticsKey(AnalyticsProperties.totalItemPrice, totalItemPrice)
    ..putAnalyticsKey(AnalyticsProperties.totalAmount, totalAmount)
    ..putAnalyticsKey(AnalyticsProperties.fromShipping, fromShipping)
    ..putAnalyticsKey(AnalyticsProperties.fromNetAmount, fromNetAmount)
    ..putAnalyticsKey(AnalyticsProperties.itemDiscount, itemDiscount)
    ..putAnalyticsKey(AnalyticsProperties.promotionDiscount, promotionDiscount)
    ..putAnalyticsKey(
      AnalyticsProperties.merchPromo,
      merchPromo ? AnalyticsDefaults.yes : AnalyticsDefaults.no,
    )
    // Written raw so an empty cart still reports the dimension: `[]` and `0`
    // are the honest answers for "no promo on this cart", and a dropped key
    // would merge those into the unattributed bucket.
    ..[AnalyticsProperties.promoCode] = promoCodes
    ..[AnalyticsProperties.promoAppliedCount] = promoAppliedCount;
}
