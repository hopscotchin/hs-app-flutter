# Automation Test Keys — Binding Conventions

Every user-facing Flutter widget in this repo gets a `ValueKey` for automated
(integration/widget) testing. **Add keys inline while building or editing a
feature — do not wait to be asked.** If you touch a page, widget, dialog, bottom
sheet, list tile, button, input, or a visible text/image, key it in the same
change.

The single source of truth for key strings is
`lib/core/constants/strings/auto_test_strings.dart`.

---

## 0. What to key

Key anything a test needs to find or drive:

- **Interactive:** buttons, icon buttons, tappable rows/cards, `GestureDetector`/
  `InkWell`, chips, tabs, checkboxes/radios, text fields, dropdowns.
- **Identifying content:** screen/app-bar titles, subtitles, section titles,
  banner/hero/product images, price/name text a test asserts on, empty-state text.
- **Containers of dynamic lists:** each item (index-suffixed), plus each sub-CTA
  inside the item.

Skip: pure spacing/decoration, indicators that carry no assertion value (dots/
line indicators) unless explicitly requested, and anything with **no render path**
(a callback field that isn't wired to a widget — nothing to attach a key to; note
it and move on).

---

## 1. Where keys are defined — screen-wise classes

One class per screen/surface in `auto_test_strings.dart`. Class name =
`<Screen>TestStrings`. Values are `snake_case`, prefixed with the screen slug.

```dart
class AddressTestStrings {
  AddressTestStrings();

  static const String listAppBarTitle = 'address_list_app_bar_title';
  static const String formNameInput   = 'address_form_name_input';
}
```

Existing classes to follow as reference: `AccountTestStrings`, `JoinUsTestStrings`,
`LoginTestStrings`, `OtpVerificationTestStrings`, `DashboardTestStrings`,
`PlpTestStrings`, `AddressTestStrings`, `SplashTestStrings`, and the shared
`MessageBarTestStrings` / `HomeComponentTestStrings`.

---

## 2. Naming scheme

```
<screen>_<element>[_<sub>][_<index>]
```

- **screen** — short slug: `account`, `login`, `join_us`, `otp_verification`,
  `dashboard`, `plp`, `address_list`, `address_form`, `hp`, `lp_<pageName>`, `splash`.
- **element role suffix** — pick the conventional one:
  | Suffix | For |
  |---|---|
  | `_button` | any tappable action / CTA |
  | `_input` / `_input_field` | text fields |
  | `_text_field` | a `Text` a test reads/asserts |
  | `_app_bar_title`, `_title`, `_subtitle` | titles |
  | `_back_button` | app-bar back |
  | `_image` | keyed images (avatar, banner, hero) |
  | `_checkbox` / `_radio` | form toggles |
  | `_item` / `_tile` | list rows |
- **index** — dynamic list position, `_<i>`, 0-based, flat across the logical list.
- **sub** — a CTA nested inside a keyed item nests under it:
  `plp_tile_3` (main tap) → `plp_tile_3_wishlist`, `plp_tile_3_add_to_cart`.

Mutually-exclusive variants of the same element **share one key** (e.g. standard
vs boutique PLP app bar — only one renders at a time), so tests don't branch.

---

## 3. Applying the key

Prefer `const ValueKey`. Interpolating **const** strings stays const:

```dart
// static
Text(title, key: const ValueKey(PlpTestStrings.appBarTitle));

// dynamic index — not const
GestureDetector(key: ValueKey('${PlpTestStrings.tile}_$i'), ...);
```

`AppBottomSheet` / `AppBottomSheetAction` use interpolation of const bases too.

---

## 4. Shared / reusable widgets — add optional `Key?` params

Never hardcode a screen-specific key inside a shared widget. Instead expose an
**optional** `Key?` parameter and let the caller pass it. This keeps every other
call site untouched (null → unkeyed).

Widgets already wired this way — reuse them, don't reinvent:

- **`HsAppbar`** — `titleKey`, `backButtonKey` (both `HsAppbar(...)` and
  `HsAppbar.titleOnly(...)`).
- **`AppBottomSheet.show(...)`** — `titleKey`, `descriptionKey`; and
  **`AppBottomSheetAction`** — `buttonKey`. Use for every confirm sheet; name the
  keys `<screen>_<x>_bottomsheet_<title|description|role_button>`.
- **`ProductTile` / `ProductTile.fromProduct`** — `tileKey`, `wishlistKey`.
- **`XLTileWidget` / `.fromListingProduct`** — `tileKey`, `wishlistKey`.
- **`AddressItemCard`** — `editKey`, `removeKey` (+ its own `super.key`).
- **`AuthTermsDisclaimer`** — `termsKey`, `privacyKey`.
- **`NavBarItem`** (spring bottom nav) — `tileKey`.
- Named button family (`PrimaryButton`/`SecondaryButton`/`TertiaryButton`/
  `AppButton`), `OutlinedTextField`, `AppRadio`/`AppCheckbox`, `BadgeIcon`,
  `CircleIconButton`, `CustomImage`, `CachedImageWidget` — all already take
  `super.key`; pass `key:` directly.

If a shared widget you need to key lacks a param, **add an optional `Key?`** the
same way (additive, defaults null) rather than keying it at only one site.

Private helper widgets (`_Foo`) that render a keyable leaf: give them `super.key`
and pass the key from the call site.

---

## 5. Dynamic lists — index-suffixed keys

Give each item a flat index. If the list mixes item types (e.g. rows of 2 +
singles), precompute a cumulative index once per build so keys stay stable and the
builder stays O(n):

```dart
final starts = <int>[];
var running = 0;
for (final it in items) { starts.add(running); running += it.productCount; }
// in the builder: use starts[index]
```

Sub-CTAs inside an item nest under the item's index (`_<i>_wishlist`).

For a list widget that repeats on a page, disambiguate by a stable position field
(e.g. `plp_floating_filter_<section.position>_chip_<i>`).

---

## 6. Reusable components rendered on many screens — `keyPrefix`

A component reused across screens (e.g. `MessageBarsWidget`, home page-component
widgets) takes a **`keyPrefix`/screen prefix** and builds keys
`<prefix>_<base>_<index>`. The host passes its screen slug:

```dart
MessageBarsWidget(messageBars: bars, keyPrefix: PlpTestStrings.screen); // 'plp'
// → plp_message_bar_message_text_field_0
```

Home/landing page components go through `PageComponentRenderer`, which composes
`<page>_<component>_<renderIndex>` (e.g. `hp_pg_2`) and passes it down; each
component keys its parts `<prefix>_<element>[_<i>]` (`hp_pg_2_title`,
`hp_pg_2_tiles_0`, `hp_pg_2_cta`). Page prefix = `hp` (home) or
`lp_<pageName>` (landing).

---

## 7. Workflow

1. Reuse an existing key param/pattern before adding a new one.
2. Add the `<Screen>TestStrings` entries (new class if the screen has none).
3. Attach keys in the widget; thread indices/`keyPrefix` as needed.
4. Run `flutter analyze` on touched files — must be clean. Interpolated-const keys
   are valid `const`; a non-const `ValueKey('..._$i')` is expected for dynamic ones.
5. Don't restate keys the user must request — this is default behaviour.