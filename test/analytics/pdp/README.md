# PDP analytics tests

Four folders, split by the question each answers. If you are adding a test and
can't tell which folder it belongs in, the answer is usually `events/`.

| Folder | Question | Fails when |
|---|---|---|
| `events/` | **what does this one event carry, and which node did each key come from** | a chain is built wrong — a node missing, or one chained that should not be |
| `contract/` | what holds across **all** events | the passthrough itself breaks — a rename, a type, a precedence rule |
| `parity/` | does Flutter match **Android** | the two platforms would split a metric |
| `tracker/` | **when** does an event fire, and how often | a firing rule changes — volume, not payload |

## `events/` — one file per event

21 files, named for the wire event. `size_selected_test.dart` tells you what
`size_selected` puts on the wire, without reading anything else.

Each file answers four things, in this order:

1. it fires exactly once, under its Android name
2. it carries the product node — `expectProductNode`
3. the keys **this** event adds — `expectAddsExactly`
4. the keys it must **not** carry — `expectAbsent`

`expectAddsExactly` is the one that earns its keep. A presence check passes when
an extra node gets chained; the strict form fails. That matters most on the rail
clicks, where chaining the tile's *product* node instead of the *tile* node would
overwrite `product_id` and report the wrong PDP — with no error and no missing
key.

**What these files must not do:** assert the whole payload key-for-key. That is
the golden's job. Duplicating it here turns every backend key change into a
21-file edit.

### The two wishlist events

`product_added_to_wishlist` / `product_removed_from_wishlist` fire from the PDP
but are built by `wishlist_events.dart`, so they are not in `events/`. Their
payload lives in `../wishlist/wishlist_events_test.dart`, and the PDP's wiring to
them in `tracker/shared_component_override_test.dart`. The golden covers all 23.

## `support/pdp_event_case.dart`

Harness, fixture, and the backend nodes each event chains. Every node is read out
of `pdp_product_945499.json` rather than written inline — under the passthrough
contract the client never reads inside a node, so a test that hand-builds one is
testing a map literal, not the response. Reading them from the fixture means
re-capturing the fixture moves these tests too, which is the point of
re-capturing.

## `contract/`

| File | Guards |
|---|---|
| `wire_format_golden_test.dart` | the exact payload of all 23 events — **key, value and type** — against `pdp_wire_format.golden.json` |
| `passthrough_test.dart` | node precedence, the passthrough channel, numeric types, per-SKU reads |
| `payload_builder_test.dart` | `buildAnalyticsPayload` itself — merge order, the drop rules |
| `tracking_meta_shape_test.dart` | every event fires identically from either input shape |
| `tracking_meta_consistency_test.dart` | the key ledger |
| `wire_key_hygiene_test.dart` | no key reaches the wire misspelled or mis-cased |

The golden regenerates with:

```
UPDATE_PDP_GOLDEN=1 flutter test test/analytics/pdp/contract/wire_format_golden_test.dart
```

Read the diff before committing it. A golden updated without being read is worse
than no golden.

## Fixtures

`test/analytics/fixtures/pdp_product_945499.json` drives everything here. It is
trimmed — 4 rail tiles and 1 offer against the backend's 20 and 4 — deliberately,
so the files stay readable. Its **values and types** track the deployed response;
its **sizes** do not.

When re-capturing it, expect the golden to move and read every line of the diff.
The last re-capture moved `delivery_days` and `image_url` and nothing else, and
caught two tests that had pinned a stale `delivery_days` by hand.

See `docs/analytics/pdp/` — the wire contract is `contract/passthrough-spec.md`,
the Android comparison is `parity/payload-comparison.md`.
