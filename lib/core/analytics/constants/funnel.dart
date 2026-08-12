/// All funnel identities the app tracks. Every event fired with
/// `attribution: true` carries one of these as its `funnel` field.
///
/// **Shell tabs** (persistent bottom-nav):
/// - [discover] — Homepage (nav index 0).
/// - [categories] — Categories screen (nav index 1; index 2 currently maps
///   to Categories too — a placeholder slot for a future [wishlist] tab).
/// - [account] — Account (nav index 3).
///
/// **Pushed routes** (funnel-owning, opened via `context.pushNamed`):
/// - [search] — pushed from the search bar inside Categories.
/// - [cart] — pushed from a Cart nav button anywhere.
/// - [wishlist] — yet to be built.
///
/// Every [Funnel]'s [wire] value matches the Android app's funnel-string
/// constants exactly — the wire format is a cross-platform dashboard
/// contract, so renaming here would break analytics parity.
enum Funnel {
  discover('Discover'),
  categories('Categories'),
  search('Search results'),
  account('Account'),
  cart('Cart'),
  wishlist('Wishlist');

  const Funnel(this.wire);

  /// String stamped onto Segment events' `funnel` field. Do NOT rename —
  /// downstream dashboards depend on the exact value.
  final String wire;

  /// Reverse-lookup — resolve a wire string back to a [Funnel].
  /// Returns null when the value doesn't match any known funnel.
  static Funnel? fromWire(String? value) {
    if (value == null) return null;
    for (final f in Funnel.values) {
      if (f.wire == value) return f;
    }
    return null;
  }
}
