# Analytics — Recipe for adding a new event

Follow this procedure every single time. No shortcuts.

## Step 1. Check Android first

Search `AnalyticsHelper.java`, `AnalyticsEvents.java`, `AnalyticsProperties.java` for the event you intend to track. **If it exists, use the exact same string for the event name and every property key.** If multiple Android methods log to the same event name, port the union of all properties so we do not lose any field.

```
grep -n "logCartViewed\|cart_viewed" \
  /Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsHelper.java
```

## Step 2. Add (or reuse) the constants

In `lib/core/analytics/constants/analytics_events.dart`:
```dart
static const String cartViewed = 'cart_viewed';
```

In `lib/core/analytics/constants/analytics_properties.dart`, add any new property keys. **String values must be identical to Android** — check casing, underscores, the `[time] ` prefix on time keys, and trailing/leading spaces (e.g. `'profile_photo_uploaded '` has a trailing space on Android — preserve bug-for-bug parity unless you have explicit sign-off to fix it).

## Step 3. Add the typed helper method

Add the method to the right module file under `lib/core/analytics/events/modules/`. Use an `extension` on `AnalyticsHelper`:

```dart
extension CartEvents on AnalyticsHelper {
  Future<void> logCartViewed({
    required String fromScreen,
    String? fromLocation,
    required double totalItemPrice,
    required double totalAmount,
    double? credit,
    double? shipping,
    double netAmount = 0,
    int skuCount = 0,
    int totalQuantity = 0,
    String? messageBarType,
    List<String>? quantityStatus,
    List<String>? priceStatus,
    required int tti,
    String? cartViewState,
    List<String>? imgUrls,
  }) {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: fromScreen,
      if (fromLocation != null) AnalyticsProperties.fromLocation: fromLocation,
      if (totalItemPrice > 0) AnalyticsProperties.totalItemPrice: totalItemPrice,
      if (totalQuantity > 0) AnalyticsProperties.totalAmount: totalAmount,
      if (credit != null && credit > 0) AnalyticsProperties.credit: credit,
      if (shipping != null && shipping > 0) AnalyticsProperties.shipping: shipping,
      if (totalQuantity > 0) AnalyticsProperties.netAmount: netAmount,
      if (skuCount > 0) AnalyticsProperties.skuCount: skuCount,
      if (totalQuantity > 0) AnalyticsProperties.totalQuantity: totalQuantity,
      AnalyticsProperties.tti: tti,
      AnalyticsProperties.cartViewState: cartViewState ?? AnalyticsDefaults.none,
      AnalyticsProperties.firstLoad:
          firstCartLoad.value ? AnalyticsDefaults.yes : AnalyticsDefaults.no,
      if (messageBarType != null) AnalyticsProperties.messageBar: messageBarType,
      if (quantityStatus != null && quantityStatus.isNotEmpty)
        AnalyticsProperties.quantityStatus: quantityStatus,
      if (priceStatus != null && priceStatus.isNotEmpty)
        AnalyticsProperties.priceStatus: priceStatus,
      if (imgUrls != null && imgUrls.isNotEmpty)
        AnalyticsProperties.imageUrl: imgUrls,
    };
    if (commonProperties.shouldAddFirstScreen) {
      commonProperties.add(AnalyticsDefaults.firstScreen);
    }
    logAppLaunched(AnalyticsDefaults.fromScreens.shoppingCart);
    return logEvent(
      AnalyticsEvents.cartViewed,
      props,
      attribution: true,
      universal: true,
    );
  }
}
```

**The two boolean flags matter.** They are not decorative:

| Flag | Android equivalent | When true |
|---|---|---|
| `attribution` | `isAttributionDataRequired` | Event needs UTM + LP + TabPage + Order attribution merged. Pass `true` for *user funnel* events: page viewed, product viewed, cart viewed, ATC, checkout, promo, search. Pass `false` for utility events: lifecycle, auth OTP, feature card, otp_sent, login_viewed. |
| `universal` | `addUniversalProperties` | Event needs the one-shot `universal` list (currently used to flag `First screen`). Pass `true` on the first page-viewed-style event of each session/screen. |
| `useSavedAttribution` | `useSavedAttributionData` | Use the persisted attribution snapshot rather than the live one. Pass `true` only for scroll events fired after backgrounding (matches `logScrollEvent` in Android). |

Match Android for each event — never guess.

## Step 4. Call from the Bloc

Analytics is injected; never call `sl<>()` from a widget.

```dart
@injectable
class CartBloc extends BaseBloc<CartEvent, CartState> {
  CartBloc(this._repo, this._analytics) : super(const CartState());
  final CartRepository _repo;
  final AnalyticsHelper _analytics;

  Future<void> _onLoad(CartLoad event, Emitter<CartState> emit) async {
    final stopwatch = Stopwatch()..start();
    final result = await _repo.loadCart();
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, error: f.message)),
      (cart) {
        emit(state.copyWith(status: CartStatus.loaded, cart: cart));
        _analytics.logCartViewed(
          fromScreen: event.fromScreen,
          fromLocation: event.fromLocation,
          totalItemPrice: cart.order.productAmount,
          totalAmount: cart.order.totalAmount,
          credit: cart.order.credit,
          shipping: cart.order.shipping,
          netAmount: cart.order.payAmount,
          skuCount: cart.items.length,
          totalQuantity: cart.order.itemCount,
          tti: stopwatch.elapsedMilliseconds,
          cartViewState: cart.viewState,
          priceStatus: cart.priceStatus,
          quantityStatus: cart.quantityStatus,
          imgUrls: cart.imageUrls,
        );
      },
    );
  }
}
```

## Step 5. Verify the payload

Before opening the PR:

1. Trigger the event in dev build with the Segment Debug View open.
2. Trigger the same scenario on Android. Capture both payloads.
3. **Diff field-by-field.** Every Android key/value should be present with the same type. Missing keys mean broken funnels.
4. Confirm `afUserId`, `cleverTapId`, `timestamp` (when applicable), time-bucket fields, and `universal` list match.
5. Confirm Amplitude `session_id` is set inside `integrations.Amplitude`.

## Step 6. Lint check

```
flutter analyze
```

If you added a property string at the call site or skipped a constants entry, fix it — do not ship literal strings.

## Step 7. Update memory if you discovered something non-obvious

If during the port you found an Android quirk worth preserving (trailing space in `'profile_photo_uploaded '`, `position == 0 → position = 1` reindex, the `[time] ` prefix on time keys, etc.), save a feedback memory so future ports do not re-introduce the bug.