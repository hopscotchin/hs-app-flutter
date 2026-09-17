/// Payload assembly for tracking-meta passthrough events.
library;

/// Merges [nodes] root → leaf, then [payload] on top.
///
/// Order is the contract: the deeper node wins a collision, and [payload]
/// merges last so a server key cannot overwrite a value the app computed.
/// A `null` node contributes nothing.
///
/// Nothing is filtered — every key reaches Segment under the name and value it
/// arrived with. Keeping one off the wire is a backend change.
Map<String, Object?> buildAnalyticsPayload({
  required List<Map<String, dynamic>?> nodes,
  Map<String, Object?> payload = const <String, Object?>{},
}) => <String, Object?>{for (final node in nodes) ...?node, ...payload};
