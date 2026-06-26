// Safe JSON parsers for API responses that may return
// numeric values as strings (e.g. `"599"` instead of `599`).

int parseToInt(dynamic value) => switch (value) {
  final int v => v,
  final double v => v.toInt(),
  final String v => int.tryParse(v) ?? 0,
  _ => 0,
};

double parseToDouble(dynamic value) => switch (value) {
  final double v => v,
  final int v => v.toDouble(),
  final String v => double.tryParse(v) ?? 0.0,
  _ => 0.0,
};

bool parseToBool(dynamic value) => switch (value) {
  final bool v => v,
  final int v => v != 0,
  final String v => v.toLowerCase() == 'true' || v == '1',
  _ => false,
};

// Converts any non-null value to its string representation.
// Needed when the API may return a numeric id as an int or a string.
String? parseToStringOrNull(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

// Non-null variant — coerces any value to a string, defaulting to '' when the
// field is null/absent. For required String fields that must never be null.
String parseToString(dynamic value) => value?.toString() ?? '';

// Nullable int — keeps `null` (and unparseable values) as null instead of
// coercing to 0, for fields where "absent" and "zero" differ (ids, counts,
// positions). Tolerates ints, doubles, and numeric strings.
int? parseToIntOrNull(dynamic value) => switch (value) {
  final int v => v,
  final double v => v.toInt(),
  final String v => int.tryParse(v) ?? double.tryParse(v)?.toInt(),
  _ => null,
};

// Nullable num — tolerates num and numeric strings; null otherwise.
num? parseToNumOrNull(dynamic value) => switch (value) {
  final num v => v,
  final String v => num.tryParse(v),
  _ => null,
};
