# Orders

The Orders and Gift Cards listings, built against the `v6` contract in
[`docs/orders/flutter_api_refactor/`](../../../docs/orders/flutter_api_refactor).

The previous module — wired to `orders/v5` with placeholder UI — is at
`lib/features/orders_old/` and is being deleted. Nothing here is derived from it; several
of its habits were rules broken (Freezed data models, `toEntity()` in the class body,
`Image.network`, a raw path in `@GET`, no `RequestCancelledFailure` guard) and are not
repeated.

## The contract in one line

**All business logic is the backend's.** Status icons arrive as URLs, every enum and message
arrives resolved, and status colours are not on the wire at all. Android decides all three on
the client — a ~90-line `if/else` mapping nineteen status codes to drawables, duplicated
across two adapters that have already drifted, plus a five-field message precedence and a
colour chain keyed on an integer. None of it exists here. What that replaces is inventoried
in [`android-business-logic.md`](../../../docs/orders/android-business-logic.md).

The practical consequence: **this module branches on nothing but null.** A free gift is an
ordinary record whose title is already "Free Gift" and whose `size` is simply absent; a
gift-card row is an order row minus `size`. There is no `isGift` flag and no `recordType`.

## Layout

Listing is the first of roughly seven screens coming here — details, return, exchange,
track, cancel, gift-card details — so the sub-domain split is in from the start.

```
data/
  datasources/remote/   one @RestApi per endpoint group
  mock/                 delete when BE ships — see below
  models/common/        status · emptyState · support — every surface reuses these
  models/listing/
  repositories/         one per sub-domain
domain/
  entities/common/ · entities/listing/
  entities/orders_tab.dart · orders_entry_args.dart   shared across surfaces
  repositories/ · usecases/listing/
presentation/
  orders_route.dart     getRoutes() — every orders screen registers here
  shared/widgets/       status row, support footer — details reuses both
  listing/bloc|pages|widgets/
```

`common/` and `shared/` are the load-bearing part: the status block appears on the listing
card, the details item and the return item. Modelling it once is what stops three
near-identical copies appearing as those screens land.

## One bloc, two tabs

`BlocProvider` may only live in the route file, which rules out a provider per tab inside the
`TabBarView`. So `OrdersListingBloc` owns both tabs — a `TabListingState` each — and every
event names the tab it acts on. Each tab body reads its own slice with `BlocSelector`, so a
change on one does not rebuild the other.

Gift Cards loads on **first visit**, not on entry: firing both requests up front would put a
call on the wire for a tab the user may never open.

The nudge shows on **both** tabs, matching Android, which binds it above the tab pager. The
support footer is Orders-only. Neither is a tab check in the code — both render if the
response carries the block, so the difference lives entirely in the contract.

## Three things that are easy to get wrong

**The failure envelope.** The BFF answers HTTP 200 for logical failures, and a Retrofit call
bypasses `ApiClient._validateActionResponse` — that only runs for the `ApiClient`-based
datasources. Without the `isFailure` check in the repository, `{"action":"error"}` parses
into zero records and the screen says "no orders". The check tests `!= 'success'`, not
`== 'failure'`: the captured responses use `"error"`.

**Refresh is silent.** `RefreshListing` emits no loading status, so the list stays on screen
under the spinner, and it bumps `refreshTick` on success *and* failure — that tick is the
only thing `RefreshIndicator` can await, since a failed refresh deliberately changes nothing
else.

**Cancelled requests are not errors.** Every fold returns early on
`RequestCancelledFailure`. Without it, switching tabs mid-load renders a spurious error
state.

## The mock

`USE_ORDER_LISTING_MOCK=true` in `.env` serves both listings from `data/mock/` while the
endpoints are being built.

The switch is a single early return at the top of
`OrdersListingRepositoryImpl.getListing`; everything below reads as ordinary production code
and is untouched by the flag. `OrdersMockSource` is static — nothing injected, nothing
registered — so the dependency graph is identical either way.

The payloads are copied verbatim from the two `.jsonc` contracts and decoded through the
**real** `fromJson`, so a key renamed in the contract fails here exactly as it would against
the live API. They are raw strings (`r'''`) because the empty-state copy contains `\n`, which
Dart would otherwise turn into a literal newline and invalid JSON.

**To delete when BE ships:** the `data/mock/` folder, the `if` block in the repository, the
getter in `EnvConfig`, and the two `.env` lines.

## Analytics

`order_listing_viewed` fires from the bloc on first-page loads only — initial, refresh, and
switching to an already-loaded tab.

Android fires it on every successful response *including paginated ones*, which is why its
`active_orders` climbs as the user scrolls. Here both counts come from the server node and no
longer change per page, so per-page firing would inflate the event count without adding a
dimension. That is a deliberate divergence, flagged for the analytics owner in
[`orders-tracking-meta.md`](../../../docs/orders/orders-tracking-meta.md).

`order_count`, `active_orders` and `tab` all arrive inside the response's `trackingMeta`
blob and are forwarded whole — never read a key out of it. The app contributes only
`from_screen`, which merges last so a server key cannot overwrite it.

The nudge fires the three `notification_permission_*` events, which existed in
`lifecycle_events.dart` but had no caller until now. Accept/reject reflect the **OS prompt's**
outcome, not the tap — a user can accept the card and then decline the system dialog.

## Automation keys

Both tabs index their rows from zero, so every list key carries a tab prefix —
`orders_item_0_title_text_field`, `gift_cards_item_0_title_text_field`. Without it a driver
could not tell which listing it was asserting against. Keys live in `OrdersTestStrings`; run
`dart run tool/generate_automation_keys.dart` after adding any.

## Still open

- The support footer's `CALL_US` uses the number from app config; `HELP_CENTER` goes through
  the existing `HelpCenterLauncher`. The contract also sends a `support` block, which is
  parsed and currently ignored — it is marked *app-config, not this endpoint*.
- The nudge's frequency rules (`showNudgeFrequency`, `dismissedFrequency`,
  `deniedFrequency`) arrive on the wire but nothing counts them down yet, so the card shows
  whenever the backend sends it.
- No tests. The module is the reference implementation and should have
  repository, use-case and bloc coverage.
