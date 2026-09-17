import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/features/plp/domain/helpers/plp_scroll_payload.dart';
import 'package:hs_app_flutter/features/plp/presentation/helpers/plp_scroll_probe.dart';

/// Android folds the collapsing header's height into `scrolled_height`, once,
/// when it collapses — the `COLLAPSED` branch of
/// `ProductsListingActivity:1862`, which has no `EXPANDED` counterpart. It is
/// normalised the same way rows are.
void main() {
  late PlpScrollProbe probe;
  late BuildContext ctx;

  setUp(() {
    probe = PlpScrollProbe(sliverKey: GlobalKey())
      ..configure(
        displayWidth: 400,
        collapsingHeader: 300,
        headerCollapseOffset: 244,
      );
  });

  ScrollUpdateNotification at(double pixels) => ScrollUpdateNotification(
    metrics: FixedScrollMetrics(
      minScrollExtent: 0,
      maxScrollExtent: 5000,
      pixels: pixels,
      viewportDimension: 800,
      axisDirection: AxisDirection.down,
      devicePixelRatio: 3,
    ),
    context: ctx,
  );

  testWidgets('contributes nothing while the header is still expanded', (tester) async {
    await tester.pumpWidget(Builder(builder: (c) { ctx = c; return const SizedBox(); }));
    probe.onScrollNotification(at(100));
    expect(probe.tracker.scrolledHeight, 0);
  });

  testWidgets('folds in the normalised header height once collapsed', (tester) async {
    await tester.pumpWidget(Builder(builder: (c) { ctx = c; return const SizedBox(); }));
    probe.onScrollNotification(at(300));
    expect(probe.tracker.scrolledHeight, plpScaledRowHeight(300, 400));
  });

  testWidgets('counts once — re-expanding and re-collapsing does not double it', (tester) async {
    await tester.pumpWidget(Builder(builder: (c) { ctx = c; return const SizedBox(); }));
    probe.onScrollNotification(at(300));
    final afterFirst = probe.tracker.scrolledHeight;
    probe.onScrollNotification(at(0));
    probe.onScrollNotification(at(600));
    expect(probe.tracker.scrolledHeight, afterFirst);
  });

  testWidgets('a page with no collapsing header never adds the term', (tester) async {
    await tester.pumpWidget(Builder(builder: (c) { ctx = c; return const SizedBox(); }));
    final standard = PlpScrollProbe(sliverKey: GlobalKey())
      ..configure(displayWidth: 400);
    standard.onScrollNotification(at(2000));
    expect(standard.tracker.scrolledHeight, 0);
  });

  testWidgets('the term reaches the payload under scrolled_height', (tester) async {
    await tester.pumpWidget(Builder(builder: (c) { ctx = c; return const SizedBox(); }));
    probe.onScrollNotification(at(300));
    final params = probe.tracker.consumeScrollDepthParams();
    expect(params?[AnalyticsProperties.scrolledHeight],
        plpScaledRowHeight(300, 400));
  });
}
