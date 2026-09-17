/// Helpers for assembling Segment property maps.
///
/// Every property write goes through [AnalyticsMap.putAnalyticsKey], which is
/// **not** a plain map put — it drops values that carry no dimension, so a key
/// behaves identically wherever it is written.
///
/// Derived from Android's `MutableMap<String, Any?>.putAnalyticsKey`
/// (`common/.../common/helper/Extentions.kt:146`):
///
/// ```kotlin
/// fun MutableMap<String, Any?>.putAnalyticsKey(key: String?, value: Any?) {
///     if (key.isNullOrEmpty() || value == null) return
///     when (value) {
///         is Number -> if (value.toDouble() <= 0) return
///         is String -> if (value.isEmpty()) return
///         is List<*> -> if (value.isEmpty()) return
///     }
///     put(key, value)
/// }
/// ```
///
/// ## Dropped
///
/// A null or empty key; `null`; empty `String`; empty `Iterable`; empty `Map`.
/// A `null` reaching Segment creates a bucket that reads as a real value called
/// "unknown", and an empty collection reports a dimension the product does not
/// have — with nothing a dashboard can group by.
///
/// `Map` is beyond Android's three branches. A backend `trackingMeta` node can
/// carry `{}`, which a call site never writes, so Kotlin never had to consider it.
///
/// ## Kept
///
/// Everything else, including **`0` and negatives**, and `bool`.
///
/// Android discards any number `<= 0` (`Extentions.kt:150`). That rule is not
/// reproduced, because it loses legitimate zeros: `from_age` for a newborn
/// product, `position` for the first tile, `discount_percentage` for anything not
/// discounted, `feed_size` for a listing with no results. The property does not
/// arrive as `0` — it does not arrive at all, so "zero" and "unknown" collapse
/// into one value on a dashboard.
///
/// ⚠️ **Android still applies it.** Until `Extentions.kt:150` drops the rule,
/// Flutter reports zeros Android omits and a property's presence differs by
/// platform — a visible divergence, against a permanent hole in the data on both.
///
/// Booleans reach the wire on purpose: `Boolean` matches none of Kotlin's three
/// branches either, which is why `redirected_from_doorway: false` and
/// `from_collection: false` are sent rather than dropped.
library;

extension AnalyticsMap on Map<String, Object?> {
  /// Sets [key] to [value], dropping only values that carry no dimension.
  ///
  /// See the library doc for the full rule and why `num <= 0` is not reproduced.
  void putAnalyticsKey(String? key, Object? value) {
    if (key == null || key.isEmpty) return;
    if (_carriesNoDimension(value)) return;
    this[key] = value;
  }

  /// Bulk [putAnalyticsKey]. Each entry is filtered independently.
  ///
  /// A droppable value writes nothing, so it cannot clobber a key already set —
  /// chaining two blobs keeps the earlier value where the later one has none.
  void putAllAnalyticsKeys(Map<String, Object?>? other) {
    if (other == null || other.isEmpty) return;
    for (final entry in other.entries) {
      putAnalyticsKey(entry.key, entry.value);
    }
  }
}

/// Builds a payload map by applying [AnalyticsMap.putAnalyticsKey] to every
/// entry of [source] — the functional form, for call sites that would rather
/// declare a literal than mutate.
Map<String, Object?> analyticsProps(Map<String, Object?> source) {
  final out = <String, Object?>{};
  out.putAllAnalyticsKeys(source);
  return out;
}

/// Whether [value] reports no dimension and should not reach the wire.
///
/// Shared with `buildAnalyticsPayload`, so a key behaves the same whether the app
/// writes it by name or a `trackingMeta` node forwards it.
bool _carriesNoDimension(Object? value) =>
    value == null ||
    (value is String && value.isEmpty) ||
    (value is Iterable && value.isEmpty) ||
    (value is Map && value.isEmpty);

/// Renders a number the way Android's JSON would: collapses integral doubles back
/// to `int`, so a field Flutter parses as `double` emits `349` rather than `349.0`
/// where Android's `Int` field emits `349`.
///
/// No call site today, and it must not become a blanket price treatment: Android's
/// three price keys come from differently typed fields, so `mrp` and
/// `discount_percentage` are `Double` on the wire (`449.0`) while `price` is `Int`.
/// Applying this to all three emits `449` where Android emits `449.0` — pinned by
/// `test/analytics/pdp/contract/passthrough_test.dart`.
num? analyticsNumber(num? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) {
    if (value.isNaN || value.isInfinite) return null;
    if (value == value.roundToDouble()) return value.toInt();
  }
  return value;
}
