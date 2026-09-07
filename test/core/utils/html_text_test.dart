import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/models/message_bar_model.dart';
import 'package:hs_app_flutter/core/utils/html_text.dart';

/// Flattens spans to the text a user would read, so assertions stay about
/// content rather than span structure.
String _text(List<InlineSpan> spans) =>
    spans.map((s) => s is TextSpan ? (s.text ?? '') : '').join();

/// The spans that came out bold, in order.
List<String> _bold(List<InlineSpan> spans) => spans
    .whereType<TextSpan>()
    .where((s) => s.style?.fontWeight == FontWeight.w700)
    .map((s) => s.text ?? '')
    .toList();

void main() {
  group('HtmlText.spans', () {
    test('plain text passes through as a single unstyled span', () {
      final spans = HtmlText.spans('Get 5% off on your next order');
      expect(spans, hasLength(1));
      expect(_text(spans), 'Get 5% off on your next order');
      expect(spans.first.style, isNull);
    });

    test('the live cart credits payload bolds only the amount', () {
      // Verbatim from /shopping-cart — the case that motivated this helper.
      const raw =
          '<span style="font-size: 10px; font-weight: 400;">'
          '<strong>₹259</strong> credits are available in your account. '
          'Use them at checkout</span>';

      final spans = HtmlText.spans(raw);
      expect(_bold(spans), ['₹259']);
      expect(
        _text(spans),
        '₹259 credits are available in your account. Use them at checkout',
      );
    });

    test('inline CSS is ignored so the app keeps control of type', () {
      // font-size/colour on the server's span must not reach the TextStyle.
      final spans = HtmlText.spans(
        '<span style="font-size: 40px; color: #FF0000;">Hello</span>',
      );
      final style = spans.whereType<TextSpan>().first.style;
      expect(style?.fontSize, isNull);
      expect(style?.color, isNull);
    });

    test('b/i/u map onto weight, slant and decoration', () {
      expect(_bold(HtmlText.spans('<b>bold</b>')), ['bold']);
      expect(
        HtmlText.spans('<i>x</i>').whereType<TextSpan>().first.style?.fontStyle,
        FontStyle.italic,
      );
      expect(
        HtmlText.spans('<u>x</u>').whereType<TextSpan>().first.style?.decoration,
        TextDecoration.underline,
      );
    });

    test('nested emphasis keeps both attributes', () {
      final span = HtmlText.spans('<strong><em>x</em></strong>')
          .whereType<TextSpan>()
          .first;
      expect(span.style?.fontWeight, FontWeight.w700);
      expect(span.style?.fontStyle, FontStyle.italic);
    });

    test('<br> becomes a newline', () {
      expect(_text(HtmlText.spans('a<br>b')), 'a\nb');
    });

    test('entities are decoded — a plain Text would show these raw', () {
      expect(_text(HtmlText.spans('<span>Tom &amp; Jerry</span>')), 'Tom & Jerry');
      expect(_text(HtmlText.spans('<span>&#8377;500</span>')), '₹500');
    });

    test('null and empty yield no spans', () {
      expect(HtmlText.spans(null), isEmpty);
      expect(HtmlText.spans(''), isEmpty);
    });

    test('markup that parses to nothing still renders its text', () {
      // A lone <br> would otherwise leave the bar blank.
      expect(HtmlText.spans('<br>'), isNotEmpty);
    });
  });

  group('HtmlText.plain', () {
    test('strips tags and decodes entities', () {
      expect(HtmlText.plain('<b>Hi</b> &amp; bye'), 'Hi & bye');
    });

    test('leaves plain text untouched', () {
      expect(HtmlText.plain('no markup'), 'no markup');
    });
  });

  group('MessageBarModel title', () {
    test('a real heading is kept', () {
      final bar = MessageBarModel.fromJson({'title': "We'll remember their details"});
      expect(bar.title, "We'll remember their details");
    });

    test('title is passed through as-is, including a type echo', () {
      // Live cart payload echoes the type into `title`. The parser does not
      // filter it, so a bar configured this way renders "custom" as its
      // heading — filter at the widget if a design ever hits this.
      final bar = MessageBarModel.fromJson({
        'title': 'custom',
        'messageType': 'custom',
        'message': '₹259 credits are available',
      });
      expect(bar.title, 'custom');
      expect(bar.message, '₹259 credits are available');
    });

    test('an absent title stays null', () {
      expect(MessageBarModel.fromJson(const {}).title, isNull);
    });
  });
}
