import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_suggestion_entity.freezed.dart';

@freezed
abstract class SearchSuggestionEntity with _$SearchSuggestionEntity {
  const factory SearchSuggestionEntity({
    String? id,
    String? type,
    String? term,
    /// May contain simple HTML — `<p><b>hel</b>met</p>` — where `<b>` marks
    /// the substring matching the user's typed query. See the search page
    /// for how this is rendered.
    String? displayName,
    String? actionUri,
    String? searchParams,
    /// Analytics payload from the autocomplete API. Forwarded to the
    /// segment event when a suggestion is tapped. Shape is server-defined.
    Map<String, dynamic>? trackingData,
  }) = _SearchSuggestionEntity;
}
