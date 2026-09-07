import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

/// Renders backend copy that may arrive as either plain text or a small subset
/// of HTML.
///
/// Several endpoints send the same field both ways — the cart's credits bar is
/// `"<span ...><strong>₹259</strong> credits are available…</span>"` while most
/// bars are a bare string. Passing either through [spans] gives a
/// correctly-formatted result, so call sites never have to sniff the format.
///
/// **Structure is honoured; inline CSS is deliberately not.** `<strong>`/`<b>`,
/// `<em>`/`<i>`, `<u>` and `<br>` map onto the caller's [TextStyle]; a
/// `style="font-size: 10px"` on the server's `<span>` is ignored. That is the
/// point rather than a shortcut — the app's own typography has to win, or a
/// backend copy change could silently break a screen's type scale. Entities
/// (`&amp;`, `&nbsp;`, `&#8377;`) are decoded either way, which is the other
/// reason to route plain-looking strings through here too.
abstract final class HtmlText {
  /// Cheap check for whether [raw] contains markup worth parsing. Not a
  /// validator — just avoids the parser on the common plain-text case.
  static bool looksLikeHtml(String raw) =>
      raw.contains('<') && raw.contains('>');

  /// Plain, tag-free text — for `Semantics` labels, ellipsis measurement, or
  /// anywhere a `String` is required rather than spans.
  static String plain(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    if (!looksLikeHtml(raw)) return raw;
    return (html_parser.parseFragment(raw).text ?? '').trim();
  }

  /// [raw] as inline spans, styled relative to the surrounding [Text.rich] /
  /// [RichText] style. Emphasis is applied by *overlaying* weight and slant, so
  /// the caller's colour, size and family carry through untouched.
  ///
  /// Returns a single unstyled span for plain text, so the caller can use this
  /// unconditionally.
  static List<InlineSpan> spans(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    if (!looksLikeHtml(raw)) return [TextSpan(text: raw)];

    final out = <InlineSpan>[];
    _walk(html_parser.parseFragment(raw).nodes, out, bold: false, italic: false, underline: false);
    // Markup that parsed to nothing usable (a lone `<br>`, or a malformed tag
    // soup) still has to render *something* — fall back to the tag-free text
    // rather than an empty bar.
    if (out.isEmpty) return [TextSpan(text: plain(raw))];
    return out;
  }

  static void _walk(
    List<dom.Node> nodes,
    List<InlineSpan> out, {
    required bool bold,
    required bool italic,
    required bool underline,
  }) {
    for (final node in nodes) {
      if (node is dom.Text) {
        if (node.text.isEmpty) continue;
        out.add(
          TextSpan(
            text: node.text,
            style: (bold || italic || underline)
                ? TextStyle(
                    fontWeight: bold ? FontWeight.w700 : null,
                    fontStyle: italic ? FontStyle.italic : null,
                    decoration: underline ? TextDecoration.underline : null,
                  )
                : null,
          ),
        );
        continue;
      }
      if (node is! dom.Element) continue;

      switch (node.localName) {
        case 'br':
          out.add(const TextSpan(text: '\n'));
        case 'strong' || 'b':
          _walk(node.nodes, out, bold: true, italic: italic, underline: underline);
        case 'em' || 'i':
          _walk(node.nodes, out, bold: bold, italic: true, underline: underline);
        case 'u':
          _walk(node.nodes, out, bold: bold, italic: italic, underline: true);
        default:
          // Unknown tags (span, div, p, font…) contribute no styling of their
          // own but their children still render.
          _walk(node.nodes, out, bold: bold, italic: italic, underline: underline);
      }
    }
  }
}
