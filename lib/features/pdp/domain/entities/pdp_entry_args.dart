import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';

part 'pdp_entry_args.freezed.dart';

/// How the user arrived at the PDP. Mirrors the Intent-bundle fields Android
/// reads in `PDPAnalytics.setIntentData` (`PDPAnalytics.kt:51-62`).
///
/// Set once when the route is pushed and **preserved across colour-variant
/// switches** — the funnel that brought the user in still applies to the new
/// PID.
///
/// Two of Android's bundle fields are deliberately absent: `doorwayData` and
/// `redirectedFromShopTheLook`. Neither feature exists in the Flutter PDP
/// so their wire keys are emitted as constants
/// (`redirected_from_doorway: false`, `redirected_from_shop_the_look: "No"`)
/// rather than being carried in.
@freezed
abstract class PdpEntryArgs with _$PdpEntryArgs {
  const factory PdpEntryArgs({
    /// e.g. `FromScreens.plp`, `FromScreens.discover`.
    String? fromScreen,

    /// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
    String? fromPage,

    /// Size of the feed the user came from, or null when the PDP was not opened
    /// from a feed.
    ///
    /// Nullable rather than defaulting to 0: a default of 0 used to be invisible
    /// because the `num <= 0` rule discarded it, and with that rule gone it would
    /// assert "the feed had no items" on every PDP opened outside a feed. Null means
    /// unknown and is dropped; 0 would be a claim.
    int? fromFeedSize,

    /// Tile position in the originating list, or null when there was no tile.
    ///
    /// Nullable for the same reason: this defaulted to the sentinel `-1`, which the
    /// `num <= 0` rule hid. Emitting `-1` as a position is worse than omitting it, so
    /// the absence is now expressed in the type.
    ///
    /// ⚠️ Callers currently pass a 1-based value (`index + 1`) — a workaround for the
    /// same rule, since a 0-based first tile was dropped. That workaround is no longer
    /// needed, but switching to the true 0-based index changes every position value, so
    /// it needs checking against Android's PDP first.
    int? position,

    /// `xl` / `normal` / `other`. Android defaults to `other`.
    @Default(SourceTileType.other) String sourceTileType,

    /// Tabbed-page context, when the user came through one.
    PdpTabPageArgs? tabPage,
  }) = _PdpEntryArgs;
}

/// Tabbed-page block, attached to `product_viewed` and `product_added_to_cart`.
/// All four values are Strings on the wire (`PDPAnalytics.kt:81-101`).
@freezed
abstract class PdpTabPageArgs with _$PdpTabPageArgs {
  const factory PdpTabPageArgs({
    String? containerName,
    String? containerId,
    String? tabName,
    String? tabPosition,
  }) = _PdpTabPageArgs;
}
