import 'dart:convert';
import 'dart:io';

/// Loads a PLP `/loadPageWiseListingWithFilters` response fixture and exposes
/// the sub-blobs each event under test spreads: root `orderAttribution`,
/// root `trackingMeta`, filter-response `trackingMeta`, per-record blobs.
///
/// The fixture path defaults to the captured product-listing response;
/// pass an explicit path to swap for boutique / search / reco fixtures.
class PlpFixture {
  PlpFixture._(this._raw);

  final Map<String, dynamic> _raw;

  static PlpFixture load([
    String path = 'test/analytics/fixtures/plp/product_listing_page.json',
  ]) {
    final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    return PlpFixture._(raw);
  }

  Map<String, dynamic> get raw => _raw;

  /// Root `orderAttribution` blob — opaque, spread onto every PLP event.
  Map<String, dynamic> get orderAttribution =>
      (_raw['orderAttribution'] as Map?)?.cast<String, dynamic>() ??
      const <String, dynamic>{};

  /// Root `trackingMeta` blob — page identity keys.
  Map<String, dynamic> get trackingMeta =>
      (_raw['trackingMeta'] as Map?)?.cast<String, dynamic>() ??
      const <String, dynamic>{};

  /// Merged page-level meta the state getter (`plpAnalyticsMeta`) produces —
  /// `orderAttribution` first, `trackingMeta` wins on collision. Every PLP
  /// event downstream spreads this shape.
  Map<String, dynamic> get plpAnalyticsMeta => <String, dynamic>{
        ...orderAttribution,
        ...trackingMeta,
      };

  /// Filter-response `trackingMeta` blob (e.g. `non_preorder_filter`,
  /// `<section>_filter` dynamic keys). Merged on top of [plpAnalyticsMeta]
  /// for `filter_applied` — the /v2/filter response is the newer source.
  Map<String, dynamic> get filtersTrackingMeta =>
      (((_raw['filters'] as Map?)?['trackingMeta'] as Map?)?.cast<String, dynamic>()) ??
      const <String, dynamic>{};

  /// Per-record trackingMeta at flat position [index] (0-based).
  Map<String, dynamic> recordTrackingMeta(int index) {
    final records = (_raw['records'] as List).cast<Map<String, dynamic>>();
    return (records[index]['trackingMeta'] as Map).cast<String, dynamic>();
  }

  /// Page name (`pageMeta.pageTitle`) — feeds `from_screen` on
  /// `filter_applied`/`filter_cleared` and `product_listing_name` derivation.
  String get pageTitle => (_raw['pageMeta'] as Map)['pageTitle'] as String;
}
