// Regenerates `lib/core/constants/strings/AUTOMATION_KEYS.md` (the QA-facing key
// reference) from `auto_test_strings.dart` — the single source of truth.
//
// Usage:
//   dart run tool/generate_automation_keys.dart          # write the doc
//   dart run tool/generate_automation_keys.dart --check   # exit 1 if stale (CI)
//
// How it works:
//   * Parses every `class <X>TestStrings` and its `static const String` members.
//   * Key string = the trailing `// ... `pattern`` comment if present (so dynamic
//     keys like `plp_tile_<i>` / suffix compositions are captured), else the raw
//     literal value.
//   * Examples are derived by substituting placeholders (`<i>` → 0/1, `<pos>` → 0).
//   * Type is inferred from the key's trailing role token.
//   * Widget file is found by grepping `<Class>.<member>` across `lib/`.
//   * Runtime-prefixed families (home/landing components, message bars) are
//     emitted from fixed templates because no literal key exists in the source.
//
// If a key has no widget usage, it is flagged `*(defined, not yet wired)*`.

import 'dart:io';

const stringsPath = 'lib/core/constants/strings/auto_test_strings.dart';
const outPath = 'lib/core/constants/strings/AUTOMATION_KEYS.md';

/// Classes emitted from templates instead of being parsed (runtime-composed keys).
const templatedClasses = {'HomeComponentTestStrings', 'MessageBarTestStrings'};

/// Members that are only key *prefixes*, never keys themselves.
bool isPrefixOnly(String member) =>
    member == 'screen' || member == 'formScreen';

/// Human section title per class name (fallback: de-camel-cased).
const titleOverrides = {
  'SplashTestStrings': 'Splash',
  'AccountTestStrings': 'Account',
  'JoinUsTestStrings': 'Join Us',
  'LoginTestStrings': 'Login',
  'OtpVerificationTestStrings': 'OTP Verification',
  'DashboardTestStrings': 'Dashboard (bottom nav)',
  'PincodeTestStrings': 'Pincode Check (bottom sheet)',
  'PlpTestStrings': 'PLP (Product Listing Page)',
  'AddressTestStrings': 'Address (list + add/edit form)',
};

void main(List<String> args) {
  final check = args.contains('--check');
  final root = _repoRoot();
  final src = File('$root/$stringsPath').readAsStringSync();

  // One grep over lib/ builds a `<Class>.<member>` → widget-file map, so each key
  // is a map lookup instead of its own grep (regen cost stays flat as keys grow).
  final usage = _buildUsageIndex(root);

  final buf = StringBuffer()..write(_header());

  for (final cls in _parseClasses(src)) {
    buf.writeln('## ${_title(cls.name)}');
    buf.writeln();
    if (templatedClasses.contains(cls.name)) {
      buf.writeln(_template(cls.name));
      buf.writeln();
      continue;
    }
    buf.writeln('| Type | Key | Examples | Widget file |');
    buf.writeln('|---|---|---|---|');
    for (final m in cls.members) {
      if (isPrefixOnly(m.name)) continue;
      // Bare suffix helpers (no comment pattern) are only composed into another
      // key's row — skip them as standalone rows.
      if (m.name.endsWith('Suffix') && m.patterns.isEmpty) continue;
      final file = _widgetFile(usage, cls.name, m.name);
      for (final key in _fullKeys(m.value, m.patterns)) {
        final type = _inferType(key);
        final examples = _examples(key);
        buf.writeln('| $type | `$key` | ${_code(examples)} | $file |');
      }
    }
    buf.writeln();
  }

  final generated = '${buf.toString().trimRight()}\n';
  final outFile = File('$root/$outPath');

  if (check) {
    final current = outFile.existsSync() ? outFile.readAsStringSync() : '';
    if (current != generated) {
      stderr.writeln(
          'AUTOMATION_KEYS.md is stale. Run: dart run tool/generate_automation_keys.dart');
      exit(1);
    }
    stdout.writeln('AUTOMATION_KEYS.md up to date.');
    return;
  }

  outFile.writeAsStringSync(generated);
  stdout.writeln('Wrote $outPath');
}

// ── Parsing ──────────────────────────────────────────────────────────────

class _Member {
  _Member(this.name, this.value, this.patterns);
  final String name;
  final String value;
  final List<String> patterns; // backtick-quoted patterns from trailing comment
}

class _Class {
  _Class(this.name, this.members);
  final String name;
  final List<_Member> members;
}

final _classRe = RegExp(r'class\s+(\w+TestStrings)\b');
final _memberRe = RegExp(
    r"static\s+const\s+String\s+(\w+)\s*=\s*'([^']+)'\s*;([^\n]*)");
final _backtickRe = RegExp(r'`([^`]+)`');

List<_Class> _parseClasses(String src) {
  final starts = _classRe.allMatches(src).toList();
  final out = <_Class>[];
  for (var i = 0; i < starts.length; i++) {
    final name = starts[i].group(1)!;
    final begin = starts[i].end;
    final end = i + 1 < starts.length ? starts[i + 1].start : src.length;
    final body = src.substring(begin, end);
    final members = <_Member>[];
    for (final mm in _memberRe.allMatches(body)) {
      final member = mm.group(1)!;
      final value = mm.group(2)!;
      final comment = mm.group(3) ?? '';
      final patterns =
          _backtickRe.allMatches(comment).map((e) => e.group(1)!).toList();
      members.add(_Member(member, value, patterns));
    }
    out.add(_Class(name, members));
  }
  return out;
}

// ── Derivation ───────────────────────────────────────────────────────────

String _title(String className) =>
    titleOverrides[className] ??
    className
        .replaceFirst('TestStrings', '')
        .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (_) => ' ');

/// Resolve a member into its full key string(s). Trailing `// `pattern`` comments
/// that start with `_` are fragments appended to the literal value (e.g. value
/// `plp_tile` + `_<i>` → `plp_tile_<i>`); patterns that are already full keys are
/// used verbatim. No comment → the literal value is the key. One entry per key.
List<String> _fullKeys(String value, List<String> patterns) {
  if (patterns.isEmpty) return [value];
  return patterns.map((p) => p.startsWith('_') ? '$value$p' : p).toList();
}

/// Replace placeholders for a concrete example. [i] is the list index value.
String _fill(String pattern, String i) => pattern
    .replaceAll('<i>', i)
    .replaceAll('<pos>', '0')
    .replaceAll('<pageName>', 'summer-sale');

String _examples(String key) {
  if (key.contains('<i>')) {
    return '${_fill(key, '0')}, ${_fill(key, '1')}';
  }
  if (key.contains('<')) {
    return _fill(key, '0');
  }
  return '';
}

/// Map a key's trailing role token to a QA-friendly widget type.
String _inferType(String pattern) {
  // Strip placeholder segments so the real trailing token is exposed.
  final k = pattern.replaceAll(RegExp(r'_<[^>]+>'), '');
  bool ends(String s) => k.endsWith(s);
  if (ends('_hint')) return 'Hint';
  if (ends('_suffix') || ends('_suffix_icon')) return 'Suffix';
  if (ends('_button')) return 'Button';
  if (ends('_input') || ends('_input_field')) return 'Text field';
  if (ends('_text_field')) return 'Text';
  if (ends('_app_bar_title') || ends('_title')) return 'Title';
  if (ends('_subtitle') || ends('_description') || ends('_initials')) {
    return 'Text';
  }
  if (ends('_image')) return 'Image';
  if (ends('_checkbox')) return 'Checkbox';
  if (ends('_radio')) return 'Radio';
  if (ends('_nav_item')) return 'Nav item';
  if (ends('_menu_item') || ends('_item') || ends('_tile')) return 'List item';
  if (ends('_chip')) return 'Chip';
  if (ends('_option') || ends('_section')) return 'Option';
  if (ends('_leaf') || ends('_drilldown') || ends('_breadcrumb')) {
    return 'List item';
  }
  if (ends('_row')) return 'Row';
  if (ends('_tab')) return 'Tab';
  if (ends('_wishlist') ||
      ends('_add_to_cart') ||
      ends('_edit') ||
      ends('_remove')) {
    return 'Button';
  }
  if (k.contains('_text')) return 'Text';
  return 'Element';
}

/// One grep over `lib/` → map of `<Class>.<member>` → set of widget-file
/// basenames it's referenced in. Built once; every key is then a map lookup, so
/// regeneration cost stays flat regardless of how many keys exist.
Map<String, Set<String>> _buildUsageIndex(String root) {
  final res = Process.runSync(
    'grep',
    ['-rEo', r'[A-Za-z_]+TestStrings\.[A-Za-z0-9_]+', 'lib', '--include=*.dart'],
    workingDirectory: root,
  );
  final index = <String, Set<String>>{};
  for (final line in (res.stdout as String).split('\n')) {
    if (line.trim().isEmpty) continue;
    final sep = line.indexOf(':'); // grep output: `path:match`
    if (sep < 0) continue;
    final path = line.substring(0, sep);
    final ref = line.substring(sep + 1);
    if (path.endsWith('auto_test_strings.dart')) continue; // definitions, not use
    index.putIfAbsent(ref, () => <String>{}).add(path.split('/').last);
  }
  return index;
}

/// Look up the widget file(s) a key is attached in → comma-joined basenames, or a
/// "not wired" flag when nothing references it.
String _widgetFile(
    Map<String, Set<String>> usage, String className, String member) {
  final files = (usage['$className.$member'] ?? const <String>{}).toList()..sort();
  if (files.isEmpty) return '*(defined, not yet wired)*';
  return files.map((f) => '`$f`').join(', ');
}

String _code(String s) => s.isEmpty ? '—' : '`${s.replaceAll(', ', '`, `')}`';

String _repoRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) return Directory.current.path;
    dir = parent;
  }
}

// ── Static content ─────────────────────────────────────────────────────────

String _header() => '''
<!-- GENERATED by tool/generate_automation_keys.dart — DO NOT EDIT BY HAND.
     Add/change keys in auto_test_strings.dart, then rerun the generator. -->

# Automation Test Keys — QA Reference

Master list of every `ValueKey` wired into the app for automated (integration/
widget) testing. Source of truth is
[`auto_test_strings.dart`](./auto_test_strings.dart). This file is **generated** —
run `dart run tool/generate_automation_keys.dart` after changing keys.

## How to read a key

Key string format: `<screen>_<element>[_<sub>][_<index>]`

- **screen** — surface slug (`account`, `login`, `plp`, `address_form`, …).
- **element** — role: `button`, `input`/`input_field`, `input_hint`,
  `input_suffix`/`suffix_icon`, `text_field` (asserted text), `app_bar_title` /
  `title` / `subtitle`, `back_button`, `image`, `checkbox` / `radio`,
  `item` / `tile`.
- **index** — 0-based position in a dynamic list, appended as `_<i>`.
- **sub** — a CTA nested in a list item nests under it, e.g. `plp_tile_3` →
  `plp_tile_3_wishlist`.

**Type** = widget role. **Key** = literal key, or the `_<i>` pattern for dynamic
lists. **Examples** = concrete keys for dynamic patterns. **Widget file** = the
`.dart` file the key is attached in.

---

''';

String _template(String className) {
  switch (className) {
    case 'HomeComponentTestStrings':
      return '''
Server-driven. Composed at runtime as
`<page>_<component>_<compIndex>[_<element>[_<itemIndex>]]`. Page prefix = `hp`
(home) or `lp_<pageName>` (landing); `<compIndex>` is the render position.

| Type | Key (pattern) | Examples | Widget file |
|---|---|---|---|
| Tab | `hp_tab_<i>` | `hp_tab_0`, `hp_tab_1` | `combined_header_delegate.dart` |
| Button | `hp_wishlist_button` | — | `combined_header_delegate.dart` |
| Button | `hp_cart_button` | — | `combined_header_delegate.dart` |
| Tiles | `<page>_hero_<c>_tiles_<i>` | `hp_hero_0_tiles_0` | `hero_carousel_widget.dart` |
| Title | `<page>_pg_<c>_title` | `hp_pg_2_title` | `product_grid_widget.dart` |
| CTA | `<page>_pg_<c>_cta` | `hp_pg_2_cta` | `product_grid_widget.dart` |
| Tiles | `<page>_pg_<c>_tiles_<i>` | `hp_pg_2_tiles_0`, `hp_pg_2_tiles_1` | `product_grid_widget.dart` |
| Title | `<page>_ct_<c>_title` | `hp_ct_1_title` | `custom_tiles_widget.dart` |
| CTA | `<page>_ct_<c>_cta` | `hp_ct_1_cta` | `custom_tiles_widget.dart` |
| Tiles | `<page>_ct_<c>_tiles_<i>` | `hp_ct_1_tiles_0` | `custom_tiles_widget.dart` |
| Title | `<page>_pc_<c>_title` | `lp_summer-sale_pc_1_title` | `page_carousel_widget.dart` |
| Tiles | `<page>_pc_<c>_tiles_<i>` | `lp_summer-sale_pc_1_tiles_3` | `page_carousel_widget.dart` |

Prefix composition (`hp_pg_2`, `lp_<pageName>_...`) happens in
`page_component_renderer.dart`; component abbreviations: `hero`, `ct`, `pg`, `pc`.''';
    case 'MessageBarTestStrings':
      return '''
Reusable. `MessageBarsWidget` prefixes each key with the host screen's slug
(`keyPrefix`) and appends the bar's list index.

| Type | Key (pattern) | Examples | Widget file |
|---|---|---|---|
| Text | `<screen>_message_bar_message_text_field_<i>` | `login_message_bar_message_text_field_0`, `plp_message_bar_message_text_field_0` | `message_bars_widget.dart` |
| Button | `<screen>_message_bar_action_button_<i>` | `login_message_bar_action_button_0` | `message_bars_widget.dart` |
| Button | `<screen>_message_bar_left_button_<i>` | `plp_message_bar_left_button_0` | `message_bars_widget.dart` |
| Button | `<screen>_message_bar_right_button_<i>` | `plp_message_bar_right_button_0` | `message_bars_widget.dart` |''';
    default:
      return '';
  }
}