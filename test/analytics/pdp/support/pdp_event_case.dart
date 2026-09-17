import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/color_variants_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/offer_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/sku_entity.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';

import '../../support/analytics_test_harness.dart';

/// Shared setup for the one-file-per-event tests in `../events/`.
///
/// Each of those files answers a single question — **what does this event put on
/// the wire, and where did each key come from** — so they all need the same
/// three things: the harness, the fixture, and the backend nodes the event
/// chains. That is all this class is.
///
/// ## Why the nodes come from the fixture
///
/// Every node below is read out of `pdp_product_945499.json` rather than written
/// inline. Under the passthrough contract the client never reads inside a node,
/// so a test that hand-builds one is testing a map literal, not the response.
/// Reading them here means re-capturing the fixture moves these tests too — which
/// is the point of re-capturing.
///
/// ## What a per-event file should assert
///
/// 1. the event fires exactly once, under its Android name
/// 2. it carries the product node — [expectProductNode]
/// 3. the keys **this** event adds, with their values and types
/// 4. the keys it must NOT carry — usually another event's node
///
/// What they should NOT assert: the full payload key-for-key. That is the
/// golden's job (`../contract/wire_format_golden_test.dart`), and duplicating it
/// here means every backend key change breaks 21 files instead of one.
class PdpEventCase {
  PdpEventCase._(this.h, this.detail);

  final AnalyticsTestHarness h;
  final ProductDetailEntity detail;

  static Future<PdpEventCase> build() async {
    final h = await AnalyticsTestHarness.build();
    final raw = File('test/analytics/fixtures/pdp_product_945499.json').readAsStringSync();
    final detail = ProductDetailModel.fromJson(jsonDecode(raw) as Map<String, dynamic>).toEntity();
    return PdpEventCase._(h, detail);
  }

  void tearDown() => h.tearDown();

  // ─── The nodes, straight from the fixture ────────────────────────────

  ProductEntity get product => detail.product!;

  /// `offersList.trackingMeta` — supplies `coupon_applicable`.
  Map<String, dynamic>? get offersMeta => detail.offersTrackingMeta;

  /// The first offer's node — supplies `coupon_code`.
  OfferEntity get offer => detail.offersList.first;

  /// `recentlyViewed.trackingMeta` — supplies `feed_size`.
  Map<String, dynamic>? get railMeta => detail.recentlyViewed?.trackingMeta;

  /// A rail tile, carrying the prefixed `clicked_product_*` block.
  TileEntity get railTile => detail.recentlyViewed!.tiles.first;

  /// A details tab node — supplies `tab_name`.
  DetailEntity get tab => product.details.first;

  /// A colour variant node — supplies `new_product_id_selected`.
  ColorVariantEntity get variant => product.colorVariants.first;

  /// An in-stock SKU. `low_inventory` is `"Yes"`.
  SkuEntity get inStockSku => product.skus[1];

  /// A sold-out SKU. Its `low_inventory` is `"Sold out"` — the bucket the
  /// client cannot derive, so it only ever comes from this node.
  SkuEntity get soldOutSku => product.skus.first;

  /// Fixed entry context. Exercises every entry-arg key so an event that drops
  /// one is visible. `position`, `source_tile_type` and the tab-page block are
  /// no longer client-owned — the backend nodes carry them.
  static const entry = PdpEntryArgs(
    fromScreen: FromScreens.plp,
    fromPage: FromPage.recommendation,
    fromFeedSize: 40,
  );

  // ─── Assertions ──────────────────────────────────────────────────────

  /// The event fired exactly once. Returns its payload.
  Map<String, Object?> single(String event) => h.singleEvent(event);
}

/// Keys `product.trackingMeta` + `product.orderAttribution` put on **every** PDP
/// event, because both nodes are chained on all of them.
///
/// Android sends only 11 of these on its base-only events; the widening is
/// deliberate and recorded in `docs/analytics/pdp/parity/payload-comparison.md` §3.
const productNodeKeys = <String>{
  'product_id',
  'name',
  'image_url',
  'image_count',
  'category',
  'subcategory',
  'product_type',
  'subproduct_type',
  'brand',
  'gender',
  'from_age',
  'to_age',
  'price',
  'mrp',
  'discount_percentage',
  'sizes',
  'sku',
  'delivery_days',
  'style_code',
  'count_of_pids_in_style_code',
  'preorder',
  'sale',
  'from_pincode',
  'HBT',
  'Season',
  // product.orderAttribution — the journey node, chained alongside.
  'redirected_from_colour_widget',
};

/// Asserts the product node reached the wire intact.
///
/// Checked by presence, not by value: the values are pinned once in the golden,
/// and re-asserting them in 21 files makes a fixture re-capture a 21-file edit.
void expectProductNode(Map<String, Object?> e) {
  final missing = productNodeKeys.where((k) => !e.containsKey(k)).toList()..sort();
  expect(
    missing,
    isEmpty,
    reason:
        'the product node is chained on every PDP event, so these keys must be '
        'present. Missing: $missing',
  );
}

/// Keys `AnalyticsHelper` stamps on every event regardless of module — the
/// session/time enrichment. They are not part of any PDP chain, so the
/// per-event files subtract them before asking "what did this event add".
///
/// Their presence is guarded once, in `../contract/wire_format_golden_test.dart`.
const enrichmentKeys = <String>{
  'timestamp',
  'nav_screens',
  '[time] hour_of_day',
  '[time] day_of_week',
  '[time] day_of_month',
  '[time] month_of_year',
  '[time] week_of_year',
};

/// What this event put on the wire beyond the product node and the enrichment
/// every event gets — i.e. the keys that came from the nodes it chained, plus
/// anything the app computed.
Set<String> ownKeys(Map<String, Object?> e) =>
    e.keys.toSet().difference(productNodeKeys).difference(enrichmentKeys);

/// Asserts this event added exactly [keys] on top of the product node.
///
/// The strict form matters more than a presence check: it catches a node being
/// chained that should not be, which is how a rail tile's identity would end up
/// overwriting the product being viewed.
void expectAddsExactly(Map<String, Object?> e, Set<String> keys) {
  expect(
    ownKeys(e),
    equals(keys),
    reason:
        'an unexpected key means another node was chained; a missing one means '
        'a node the event needs was not',
  );
}

/// Asserts none of [keys] reached the wire.
///
/// Use it for the node this event does NOT chain — that is what stops, say, a
/// rail tile's identity from overwriting the product being viewed.
void expectAbsent(Map<String, Object?> e, Set<String> keys) {
  final present = keys.where(e.containsKey).toList()..sort();
  expect(present, isEmpty, reason: 'these keys must not be on this event');
}

/// The prefixed block a rail tile carries as a click target.
const clickedProductKeys = <String>{
  'clicked_product_pid',
  'clicked_product_type',
  'clicked_product_category',
  'clicked_product_subcategory',
};

/// The keys a per-SKU node contributes.
const skuNodeKeys = <String>{'sku', 'sku_size', 'pdt_size', 'available_quantity', 'low_inventory'};
