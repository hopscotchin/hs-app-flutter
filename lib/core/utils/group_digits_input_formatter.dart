import 'package:flutter/services.dart';

/// Groups digits into fixed-size blocks separated by a single space
/// (e.g. `123456` -> `123 456`).
///
/// Strips any non-digit input, caps the total digit count at [maxDigits]
/// (null = no cap), and preserves the caret position relative to the digits
/// before it. Downstream consumers should strip spaces
/// (`value.replaceAll(' ', '')`) to recover the raw digits.
class GroupDigitsInputFormatter extends TextInputFormatter {
  const GroupDigitsInputFormatter({this.groupSize = 3, this.maxDigits});

  final int groupSize;
  final int? maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldDigits = oldValue.text.replaceAll(RegExp(r'\D'), '');
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Block insertion when already at max digits — prevents mid-field edits
    // from silently dropping the last digit.
    if (maxDigits != null && oldDigits.length >= maxDigits! && digits.length > oldDigits.length) {
      return oldValue;
    }

    if (maxDigits != null && digits.length > maxDigits!) {
      digits = digits.substring(0, maxDigits!);
    }

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % groupSize == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final text = buffer.toString();

    // Preserve cursor: count digits before the cursor in newValue, then find
    // the matching offset in the formatted text (which may have extra spaces).
    final rawCursor = newValue.selection.end.clamp(0, newValue.text.length);
    final digitsBeforeCursor =
        newValue.text.substring(0, rawCursor).replaceAll(RegExp(r'\D'), '').length;

    var cursorOffset = text.length;
    var digitCount = 0;
    for (var i = 0; i < text.length; i++) {
      if (digitCount == digitsBeforeCursor) {
        cursorOffset = i;
        break;
      }
      if (text[i] != ' ') digitCount++;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}