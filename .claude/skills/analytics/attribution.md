# Analytics — Attribution

Attribution is the chain of context that explains **how the user arrived at this action**. Hopscotch tracks four overlapping attribution domains, all merged into each user-funnel event. The Order attribution layer also flows into HTTP request bodies (ATC, wishlist add, cart update) so the server can echo per-item attribution back inside the cart response.

> **Source-of-truth files (Android):**
> - `hsapp/.../attribution/OrderAttributionHelper.java` — disk-backed via `AppRecordData.setCurrentAttributionData(String)` (SharedPreferences, Gson-serialised).
> - `hsapp/.../attribution/AttributionData.java` — the funnel struct, cascade-reset semantics, auto-persists on every setter.
> - `hsapp/.../attribution/AttributionConstants.java` — funnel/section/subsection magic strings (`Discover`, `Search`, `Categories`, `Moments`, `Cart`, `Account`, `Wishlist`, `New`, `RFYC`, `RFYP`, `UserRecoPDP`, `RecentCollection`, `RecentProduct`, `Keyword`, `RecentSearch`, `CategorySuggestion`, `BrandSuggestion`, `ProfileSuggestion`, `ShopLook`, `Default`, `SBC`, `SBA`, `FromCollection`, `Similar Reco`, `Product Attribute`, `Carousel`, `Hero`, `Collection`, `CT`, `CPT`, `Product`, `SimilarProducts`).
> - `core/.../attribution/LPAttributionHelper.kt` — bounded deque (max 5) of landing-page visits, indexed `lp1_*…lp5_*`.
> - `core/.../attribution/TabPageAttributionHelper.kt` — in-memory stack of tab pages, same-id replaces top.
> - `core/.../attribution/UTMAttributionHelper.kt` — translates `ProductTrackingData.productUTM*` into `product_utm_*` keys at order time.

## The four attribution helpers

| Helper | Persistence | Owns | Set when… | Cleared when… |
|---|---|---|---|---|
| `OrderAttributionHelper` | **SharedPreferences (`AppRecordData.currentAttributionData`)** as Gson JSON of `AttributionData` | `funnel`, `funnelTile`, `funnelRow`, `funnelSection`, `section`, `subsections` (max 3, oldest-evict), `plp`, `sortBy`, `sortBar`, `sortBarGroup`, `sliceId`, `cta`, `bannerName`, `propertyType`, `redirectedFromContinueBrowsingWidget`, `redirectedFromClusterEligiblePlp` | Tile click (PLP, PDP carousel, homepage tile, search), sort change, deeplink, search submit | **Cold start (Splash)** clears + re-inits empty. Not cleared on `order_placed` — next tile click overwrites. |
| `UtmHeaderUtil` | SharedPreferences | `utm_source/medium/campaign/content/term/gender`, `deeplink` | Deeplink open, AppsFlyer conversion, push tap | Reset on logout |
| `LPAttributionHelper` | SharedPreferences (`PrefUtils.lpAttributionData`) as Gson JSON of `ArrayDeque<LPAttributionData>` | Up to **5** recent landing pages, each with `sliceId`, `propertyType`, `bannerName`, `funnelRow`, `funnelTile`, `name`, `id`. Newest pushed to front, oldest evicted at index 4. Emitted as `lp1_*` … `lp5_*`. | Landing page entered (`addLPAttributionData(...)`) | Logout calls `clearAttributionData()` |
| `TabPageAttributionHelper` | **In-memory only** (no disk) — `ArrayDeque<TabPageAttributionData>` | `tabPageContainerId`, `tabPageContainerName`, `tabName`, `tabPosition` | Tab page opened — `addTabPageData(...)`. Same `containerId` on top replaces; otherwise pushed. | `removeTabPageData(pageId)` pops down to that page; process death wipes (no persistence). |

## `AttributionData` cascade semantics — read carefully

`AttributionData.setX()` calls are not commutative. The hierarchy is:

```
funnel
  └─ funnelTile
       └─ funnelSection
            └─ section
                 └─ subsections   (+ plp)
```

Calling **`setFunnel(x)`** triggers `resetFunnel()` which clears **everything below**: `funnelTile`, `funnelSection`, `section`, `subsections`, `plp`, `sortBy`, `sortBar`, `sortBarGroup`, `sliceId`, `bannerName`, `propertyType`.

Calling **`setFunnelTile(x)`** clears `funnelSection` and everything below.
Calling **`setFunnelSection(x)`** clears `section` and below.
Calling **`setSection(x)`** clears `subsections` and `plp`.

**Every setter calls `setAttributionDataInCache()` immediately** — the JSON blob in SharedPreferences is updated on every field write.

### `addAttributionData(...)` does NOT cascade

`OrderAttributionHelper.addAttributionData(funnel, funnelTile, funnelRow, funnelSection, plp, section, subSection, sliceId, cta, bannerName, propertyType)` is the conditional setter — it only writes non-empty fields. But internally it works by:

1. Calling `getCurrentAttributionData().copy()` (or `new AttributionData()` if null).
2. Calling individual setters on the copy. **Each setter still cascades** — so if you pass `funnel="Search"`, every other field on the copy is wiped before the rest of the params are applied. **Order of writes matters.**
3. Returning the copy. **Caller must explicitly persist via `setCurrentOrderAttributionData(returned)`.** This is the gotcha — `addAttributionData` alone does not save unless the caller follows up. (In practice the caller is always `setAttributionData...` flow that does the save, or the cascade-triggered `setAttributionDataInCache()` from inside setters writes it anyway.)

Subsections: `addSubsection(s)` appends and, if size > 3, drops the oldest. Joined with `~` when serialised for API/Segment.

## Where the writers live (Android → Flutter port targets)

| Trigger | Android site | Call |
|---|---|---|
| App cold start | `SplashActivity.java:151` | `clearAttributionData()` then init empty |
| Homepage tile click | `DepartmentPageViewModel` | `addAttributionData(null, funnelTile, 0, section, null, section, null, null, null, null, null)` |
| PLP tile click | `PLPProductViewModel:185` | `addAttributionData(null, "Product"+productId, rowPos+1, funnelSection, null, section, null, null, null, null, null)` |
| PLP sort change | PLP sort UI | `addSortData(sortBar)` (doesn't trigger funnel cascade) |
| Cluster PLP entry | `PLPProductViewModel:169` / `ProductListPageActivity:822` | `addRedirectedFromClusterEligiblePlp(true)` |
| Continue-browsing tile | `BottombarNavigationActivity` | `addRedirectedFromContinueBrowsingWidget(true)` |
| PDP collection tap | `ProductDetailPageActivityNew:3719/3753/3896/3900/3906` | `addAttributionData(...)` — incremental, no funnel reset |
| Search submit | `SearchResultsShowingBoutiquesActivity:667` | `addAttributionData("Search", null, 0, null, null, null, null, null, null, null, null)` |
| Search-within boutiques | `SearchResultsShowingBoutiquesActivity:531` | `addAttributionData(null, null, 0, null, null, null, "SP"+id, null, null, null, null)` (subsection only) |
| Sale plan / deeplinked landing | `SalePlanDetailViewModel:394–511` | Multiple `addAttributionData` with prefixed IDs `CT+id`, `SP+id`, `B+id` |
| Wishlist deeplink | `AppLinkUtil:529`, `TileAction:643` | `addAttributionData(null, null, 0, "Wishlist", "Wishlist", "Wishlist", null, null, null, null, null)` |
| Tab page open | (Bloc / Activity) | `TabPageAttributionHelper.addTabPageData(...)` |
| LP open | (Bloc / Activity) | `LPAttributionHelper.addLPAttributionData(...)` |

## The two readers — request params vs Segment params

`OrderAttributionHelper` exposes the **same data shape twice**, with different field names:

### `getOrderAttributionRequestParams()` — used in HTTP request bodies

Merged into the body of:
- `/shopping-cart/add` (`ShoppingCartApiFactory.addGUShoppingCart`, `addInstantShoppingCart`, `addProductsToBag`)
- `updateHigherSku` (variant upgrade)
- `/wishlist/add` (`WishListApiFactory.moveToWishList`)
- Cart ATC v5 / cart move calls

Keys (from `ApiParam.OrderAttributionParam`): `funnel`, `funnelTile`, `funnelRow`, `funnelSection`, `section`, `plp`, `subsection` (joined by `~`), `sortBy`, `sortBar`, `sortBarGroup`, `propertyType`, `sliceId`, `cta`, `bannerName`.

**These are the strings the server expects** — do not rename when porting to Flutter Retrofit clients.

### `getOrderAttributionSegmentParams()` — merged into Segment event payloads

Used inside `AnalyticsHelper.getCommonEventProperties` whenever `attribution=true`. Keys match `AnalyticsProperties.*` (e.g. `funnel`, `funnel_tile`, `funnel_row`, `funnel_section`, `section`, `subsection` (joined by `~`), `plp`, `sort_by`, `sortbar`, `sortbar_group`, `property_type`, `slice_id`, `cta`, `banner_name`, `redirected_from_continue_browsing_widget`, `redirected_from_cluster_eligible_plp`).

Plus `LPAttributionHelper.getLPAttributionSegmentData()` (`lp1_*…lp5_*`) and `TabPageAttributionHelper.getTabPageSegmentParams()` (tab keys + `redirected_from_tab_page`).

## Per-item enrichment: how attribution lands on `order_placed`

This is the part most easy to get wrong. **Attribution is NOT client-merged at order time.** The flow is:

1. **Tile click** → `OrderAttributionHelper.addAttributionData(...)` + caller persists.
2. **Add-to-cart** → ATC HTTP request body includes `getOrderAttributionRequestParams()`.
3. **Server enriches** → response `ShoppingBagResponse.trackingData.itemLevelTrackingData[sku]` returns the canonical `ProductTrackingData` per cart line. The server may add fields (`atcDate`, `atcUser`, `atcSite`, `hbt`, `taste`, `style`, `merchType`, `country`, `isPidAplus`, `aPlusUspList`, `styleCode`, `redirectedFromColourWidget`, `redirectedFromShopTheLook`, `redirectedFromTabPage`, all `lp1…lp5_*`, all `product_utm_*`, etc.) that the client cannot compute.
4. **Cart load** → cart is fetched (`/shopping-cart/v5`); response includes `trackingData.itemLevelTrackingData` keyed by SKU.
5. **Order placed** → for each cart item, fire one `product_ordered` event enriched via `AnalyticsHelper.setProductOrderedData(sku)`, which reads from the **cached cart response** (`Util.getShoppingBagResponse()`) — NOT from `OrderAttributionHelper`.

This means **Flutter must:**

a. Send `OrderAttributionHelper` params in the ATC/wishlist/cart-update request bodies via the appropriate Retrofit DTOs.
b. Cache the most recent `ShoppingBagResponse` somewhere (an `@lazySingleton` cart state holder — likely the cart repository) so `productOrderedProperties(sku)` can read it at order-confirmation time.
c. Map `ProductTrackingData` fully — see Android `setProductOrderedData(sku)` at `AnalyticsHelper.java:1171–1311`. Every non-empty field becomes an event property.

## The `useSavedAttribution` (scroll snapshot) branch

`AnalyticsHelper.logScrollEvent(..., useSavedAttributionData: true)` does **not** read live `OrderAttributionHelper`. It reads `AppRecordData.getOrderAttributionDataForScrollEvent()` — a separate disk-backed snapshot.

When written: on `BottombarNavigationActivity` init (i.e. main shell mount, tab change, activity resume). The init calls `setAttributionDataForScrollEvent(getOrderAttributionSegmentParams())`.

When read: every scroll event that opts into the snapshot (e.g. background-fired scrolls, scrolls that span multiple navigations).

Flutter port: a separate `PrefManager` key (`attributionSnapshotForScroll`) refreshed by the shell route on mount / tab switch / app resume. The `logScrollEvent(useSavedAttribution: true)` branch reads from there, not from `OrderAttributionHelper`.

## Clear-points — what doesn't happen

Important things `OrderAttributionHelper` does **NOT** do:

- It is **not cleared on `order_placed`**. The blob persists across orders. Subsequent purchases without an intervening tile click will retain stale funnel data — which is by design (the server records the original funnel for the actual order via `trackingData.itemLevelTrackingData` snapshotted at ATC time).
- It is **not cleared on checkout cancel or back navigation**. Only the next tile-click-driven `addAttributionData()` overwrites.
- It is **not cleared on logout**. (LP attribution does clear on logout.)
- It **is cleared on cold start** (Splash) and re-initialised to an empty `AttributionData`. Process kill + relaunch resets the funnel.

Mirror these rules exactly. Adding "helpful" auto-clears (e.g. on `order_placed`) will silently break attribution funnels for any user whose ATC happened before the order-attempt timed out.

## Flutter port — concrete shape

```dart
// lib/core/analytics/attribution/order_attribution_helper.dart
@lazySingleton
class OrderAttributionHelper {
  OrderAttributionHelper(this._prefs);
  final PrefManager _prefs;

  AttributionData? getCurrent() {
    final raw = _prefs.currentAttributionData;
    if (raw == null || raw.isEmpty) return null;
    return AttributionData.fromJson(jsonDecode(raw));
  }

  Future<void> _persist(AttributionData data) =>
      _prefs.setCurrentAttributionData(jsonEncode(data.toJson()));

  Future<void> clear() => _prefs.setCurrentAttributionData('');

  /// Conditional setter. Cascades downstream fields when a higher one is set
  /// (matches Android AttributionData.setFunnel/setFunnelTile/setFunnelSection/setSection chain).
  Future<AttributionData> add({
    String? funnel,
    String? funnelTile,
    int funnelRow = 0,
    String? funnelSection,
    String? plp,
    String? section,
    String? subSection,
    String? sliceId,
    String? cta,
    String? bannerName,
    String? propertyType,
  }) async {
    var data = getCurrent()?.copy() ?? AttributionData.empty();
    if (funnel != null && funnel.isNotEmpty)       data = data.setFunnel(funnel);          // cascades
    if (funnelTile != null && funnelTile.isNotEmpty) data = data.setFunnelTile(funnelTile); // cascades
    if (funnelRow != 0)                              data = data.setFunnelRow(funnelRow);   // cascades funnelSection→...
    if (funnelSection != null && funnelSection.isNotEmpty) data = data.setFunnelSection(funnelSection);
    if (section != null && section.isNotEmpty)       data = data.setSection(section);       // clears subsections+plp
    if (subSection != null && subSection.isNotEmpty) data = data.addSubsection(subSection); // max 3
    if (plp != null && plp.isNotEmpty)               data = data.setPlp(plp);
    if (sliceId != null && sliceId.isNotEmpty)       data = data.setSliceId(sliceId);
    if (cta != null && cta.isNotEmpty)               data = data.setCta(cta);
    if (propertyType != null && propertyType.isNotEmpty) data = data.setPropertyType(propertyType);
    if (bannerName != null && bannerName.isNotEmpty) data = data.setBannerName(bannerName);
    await _persist(data);
    return data;
  }

  Future<void> setSortBar(String sortBar) async {
    final data = (getCurrent()?.copy() ?? AttributionData.empty()).setSortBar(sortBar);
    await _persist(data);
  }

  Future<void> setRedirectedFromContinueBrowsing(bool flag) async { ... }
  Future<void> setRedirectedFromClusterEligiblePlp(bool flag) async { ... }

  /// Used as HTTP request body params for ATC, wishlist add, cart update.
  Map<String, Object?> get requestParams { ... }

  /// Merged into Segment event payloads when attribution=true.
  Map<String, Object?> get segmentParams { ... }
}
```

`AttributionData` itself is a Freezed immutable struct with cascade-aware copyWith helpers (`setFunnel`, `setFunnelTile`, `setSection`, `addSubsection`) — NOT mutable like Android. The persistence write happens in the helper, not in the struct.
