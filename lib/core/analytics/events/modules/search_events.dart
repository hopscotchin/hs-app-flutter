import '../../attribution/order_attribution_helper.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Search attribution.
///
/// Search is the one click path with no backend `trackingMeta` blob — the
/// suggestion is classified server-side but the funnel context is composed by
/// the client, exactly as Android does. Everywhere else the blob is stored
/// opaque and the client never writes attribution keys by hand, so this lives
/// here rather than in the page.
extension SearchEvents on AnalyticsHelper {
  /// Installs the funnel context a tapped suggestion establishes, so the PLP —
  /// and the PDP, ATC and order after it — attribute back to this search.
  ///
  /// Mirrors `OrderAttributionHelper.addAttributionData(null, funnelTile, 0,
  /// funnelSection, null, section, …)`, which all three Android search paths
  /// call (`SearchAutocompleteActivity:262`, `:405`, `:494`).
  ///
  /// [funnelTile] is the suggestion's term, falling back to the typed query
  /// (`:236`, `:463`, `:407`). It is the only key written: `section` and
  /// `funnel_section` are both deprecated, so the classification Android also
  /// records here — the suggestion's own section, degraded to `NS` when search
  /// was not opened from Discover (`:253`, `:400`, `:493`) — is no longer
  /// resolved or sent.
  ///
  /// Uses [OrderAttributionHelper.replaceTrackingMeta] rather than a merge
  /// because Android's `setFunnelTile` cascades — it clears `funnel_section`,
  /// `section`, `subsection`, `plp`, `slice_id`, `banner_name` and the rest
  /// before the remaining arguments are re-applied. Replacing reproduces that
  /// net effect while keeping `funnel` (already `Search`, set by the route
  /// push) and `sortBar`.
  ///
  /// Call synchronously before navigating — the PLP reads attribution during
  /// its own build.
  void setSearchAttribution({required String funnelTile}) {
    orderAttribution.replaceTrackingMeta(<String, dynamic>{
      AnalyticsProperties.funnelTile: funnelTile,
    });
  }
}
