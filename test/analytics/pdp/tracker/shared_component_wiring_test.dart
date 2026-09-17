import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Pins that the shared homepage widgets **invoke** the logging overrides they
/// declare — not just accept them.
///
/// `pdp_shared_component_override_test.dart` covers the other half: that the
/// tracker produces the right events once called. It does that by invoking the
/// tracker directly, which is deliberate, but it leaves a gap — it cannot tell
/// whether the widget ever reaches the override at all.
///
/// **That gap let a real regression through.** A merge took an upstream
/// improvement to `ProductGridWidget.onTap` (not awaiting the log before
/// navigating) and in the process dropped the `onTileTapLog?.call(item) ??`
/// branch. The field stayed declared and PDP kept passing it, so every reco-tile
/// tap silently fired the homepage `tile_clicked` — writing homepage attribution
/// from a PDP screen, which corrupts the funnel for every event downstream.
/// Nothing failed, because nothing checked the wiring.
///
/// ## Why this reads the source instead of tapping the widget
///
/// A widget test was the first attempt. These tiles build `WishlistStatusBuilder`,
/// which needs a `WishlistCubit` above it — and that needs two use cases, their
/// repositories and datasources. The existing component tests in
/// `test/analytics/components/` avoid widget construction for exactly this
/// reason and drive the tracker directly.
///
/// Standing up that provider tree would buy little: it would additionally catch
/// "override called with the wrong argument", while the failure that actually
/// happened was "override never called". A source check catches that, cannot go
/// vacuous when a tile layout changes, and costs nothing to run.
///
/// The check counts occurrences **outside comments**, so a hook mentioned only in
/// a doc comment does not satisfy it. In the broken state each hook appeared
/// exactly twice in code — declaration and constructor parameter — which is what
/// this fails on.
const _widgetsWithOverrides = <String>[
  'lib/components/page_components/product_grid_widget.dart',
  'lib/components/page_components/page_carousel_widget.dart',
];

/// Strips `//` and `///` lines so a doc-comment mention cannot pass for a use.
String _codeOnly(String src) => src
    .split('\n')
    .where((l) => !l.trimLeft().startsWith('//'))
    .join('\n');

void main() {
  group('every declared override hook has a call site', () {
    for (final path in _widgetsWithOverrides) {
      test(path.split('/').last, () {
        final code = _codeOnly(File(path).readAsStringSync());

        final hooks = RegExp(r'Function\([^)]*\)\?\s+(on\w*Log)\s*;')
            .allMatches(code)
            .map((m) => m.group(1)!)
            .toSet();

        expect(
          hooks,
          isNotEmpty,
          reason:
              '$path declares no on*Log override. If the hook was renamed, '
              'update this test; if it was removed, PDP can no longer redirect '
              'this widget\'s analytics and its reco / recently-viewed events '
              'will fire homepage payloads.',
        );

        for (final hook in hooks) {
          final uses = RegExp('\\b$hook\\b').allMatches(code).length;
          expect(
            uses,
            greaterThanOrEqualTo(3),
            reason:
                '$path: `$hook` appears $uses times in code. Expected at least 3 '
                '— field declaration, constructor parameter, and a call site. '
                'Two means it is declared and accepted but never invoked, so a '
                'host passing it is silently ignored and the homepage default '
                'runs instead.',
          );
        }
      });
    }
  });

  group('the PDP hosts still pass an override', () {
    // The other end of the contract. If a host stops passing the override, the
    // widget falls through to homepage logging — same symptom, opposite cause.
    const hosts = <String, List<String>>{
      'lib/features/pdp/presentation/widgets/pdp_recommended_products.dart': [
        'onTileTapLog',
        'onWishlistLog',
      ],
      'lib/features/pdp/presentation/widgets/pdp_recently_viewed.dart': [
        'onTileTapLog',
        'onWishlistLog',
      ],
    };

    hosts.forEach((path, hooks) {
      for (final hook in hooks) {
        test('${path.split('/').last} passes $hook', () {
          expect(
            _codeOnly(File(path).readAsStringSync()),
            contains(hook),
            reason: hook == 'onTileTapLog'
                ? '$path no longer passes `$hook`, so this rail now fires '
                      'homepage `tile_clicked` and writes homepage attribution '
                      'from PDP.'
                : '$path no longer passes `$hook`. The shared widget has no '
                      'default wishlist analytics, so this rail\'s heart now '
                      'emits NOTHING — a silent gap rather than a wrong event.',
          );
        });
      }
    });
  });
}
