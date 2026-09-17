import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the property the passthrough rests on: **no PDP event reads a key out
/// of a `trackingMeta` node.**
///
/// The old shape of this file guarded a hand-maintained "consumed keys" set —
/// the fields `pdp_events.dart` read by name and therefore had to exclude from
/// the passthrough, so they were not emitted twice. That set is gone, along with
/// the by-name reads: every node is forwarded whole and merged in order.
///
/// What can still regress is someone reaching back into a node to grab one
/// value. It compiles, it passes every payload test, and it quietly re-couples a
/// backend key to an app release — which is the single thing this design exists
/// to prevent. So it is asserted against the source.
///
/// Contract: `docs/analytics/pdp/contract/passthrough-spec.md`.
void main() {
  const source = 'lib/core/analytics/events/modules/pdp_events.dart';

  /// Indexing a node by a literal key: `meta['product_id']`, `tm["sku"]`.
  /// Deliberately narrow — it catches the mistake without flagging ordinary map
  /// construction.
  final literalIndex = RegExp(r'''\w+(\?)?\[['"][a-zA-Z_][\w ]*['"]\]''');

  test('no event reads a key out of a trackingMeta node', () {
    final lines = File(source).readAsLinesSync();
    final offenders = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      if (literalIndex.hasMatch(line)) offenders.add('$source:${i + 1}  $line');
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'A node is being read by key. Forward the node instead — a by-name read '
          'puts the backend back behind an app release:\n${offenders.join('\n')}',
    );
  });

  test('every event builds its payload through the shared builder', () {
    final src = File(source).readAsStringSync();
    // Each emission is `logEvent(AnalyticsEvents.x, <props>, ...)` on its own
    // line, and each must be followed by a builder call.
    final emissions = RegExp(
      r'^\s+(event|AnalyticsEvents\.\w+),$',
      multiLine: true,
    ).allMatches(src).length;
    final builds = RegExp(r'buildAnalyticsPayload\(').allMatches(src).length;
    // A rename that missed this file would leave the count at zero and read as
    // "nothing uses the builder", so the guard fails loudly rather than passing
    // vacuously on a pattern that no longer matches anything.
    expect(
      builds,
      greaterThan(0),
      reason: 'the builder pattern matched nothing',
    );
    expect(
      builds,
      emissions,
      reason:
          'An event is assembling properties by hand rather than through '
          'buildAnalyticsPayload — \$emissions emissions, \$builds builds',
    );
  });
}
