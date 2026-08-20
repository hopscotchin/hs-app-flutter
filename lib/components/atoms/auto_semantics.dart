import 'package:flutter/widgets.dart';

import '../../core/config/build_config.dart';

/// Publishes an automation id onto the platform accessibility node, so
/// UIAutomator-based drivers (Maestro, Appium) can address the widget by
/// Android `resource-id` — the same way they address a native Android view.
///
/// The `ValueKey`s in `auto_test_strings.dart` are a Flutter-only concept: they
/// reach widget tests and `flutter_driver`, but never cross into the platform
/// a11y tree, so Maestro cannot see them. Wrapping mirrors the *same* id string
/// onto the native node, which keeps one vocabulary for both drivers.
///
/// Pass the identical constant used for the widget's `ValueKey` so the two stay
/// in lockstep:
///
/// ```dart
/// AutoSemantics(
///   id: PdpTestStrings.addToBagButton,
///   child: CtaButtonComponent(key: const ValueKey(PdpTestStrings.addToBagButton), ...),
/// )
/// ```
///
/// Inert outside automation builds (`--dart-define=AUTOMATION=true`) so neither
/// production a11y output nor the widget tree shape changes for real users.
///
/// Only takes effect while semantics is actually being collected, which on
/// Android requires an accessibility service to be enabled on the device —
/// Flutter publishes no platform a11y tree otherwise, and the whole app is
/// invisible to the driver. Enabling one is part of the driver's device setup,
/// not something the app can do for itself.
class AutoSemantics extends StatelessWidget {
  const AutoSemantics({
    required this.id,
    required this.child,
    this.container = false,
    super.key,
  });

  /// Automation id, e.g. `PdpTestStrings.addToBagButton`.
  final String id;

  /// Forces a dedicated semantics node for [id] instead of annotating the
  /// child's own node.
  ///
  /// Needed when the tap target owns a subtree of several labelled descendants —
  /// a product tile with badge, name and price. Android merges those into one
  /// accessibility node and the annotated `identifier` is lost, so the tile ends
  /// up with no `resource-id` at all. A container node keeps the id addressable;
  /// it is a separate node from the clickable one, but it carries the same
  /// bounds, so a Maestro `tapOn` still lands on the tile.
  ///
  /// Leave false for buttons and icon buttons, where annotating keeps the id on
  /// the very node that carries the tap action.
  final bool container;

  final Widget child;

  /// Derives the id from an existing `ValueKey<String>`, for widgets that
  /// receive their automation key as a parameter instead of constructing it
  /// inline (`PdpAddToBagBar.addToBagKey`, `ProductGrid._tileKey`). Keeps the
  /// id from being spelled twice at the call site.
  ///
  /// Callers that may be keyed either way pass `tileKey ?? key`: the home
  /// grid/carousel put the automation id on `ProductTile.key` while PLP puts it
  /// on `tileKey`. Reusing the existing key rather than adding a second
  /// `ValueKey` with the same string keeps `flutter_driver`'s `byValueKey`
  /// unambiguous.
  ///
  /// Inert when [key] is anything other than a `ValueKey<String>`.
  static Widget fromKey(
    Key? key, {
    required Widget child,
    bool container = false,
  }) {
    if (!kIsAutomation || key is! ValueKey<String>) return child;
    return AutoSemantics(id: key.value, container: container, child: child);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsAutomation) return child;
    // Annotating (container: false) keeps the id on the node that carries the
    // tap action, which is what makes `tapOn: id:` hit the button itself.
    return Semantics(identifier: id, container: container, child: child);
  }
}
