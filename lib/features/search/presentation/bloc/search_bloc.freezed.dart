// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent()';
}


}

/// @nodoc
class $SearchEventCopyWith<$Res>  {
$SearchEventCopyWith(SearchEvent _, $Res Function(SearchEvent) __);
}


/// Adds pattern-matching-related methods to [SearchEvent].
extension SearchEventPatterns on SearchEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QueryChanged value)?  queryChanged,TResult Function( _FetchSuggestions value)?  fetchSuggestions,TResult Function( ClearQuery value)?  clearQuery,TResult Function( LoadRecentSearches value)?  loadRecentSearches,TResult Function( RecordRecentSearch value)?  recordRecentSearch,TResult Function( RemoveRecentSearch value)?  removeRecentSearch,TResult Function( ClearRecentSearches value)?  clearRecentSearches,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QueryChanged() when queryChanged != null:
return queryChanged(_that);case _FetchSuggestions() when fetchSuggestions != null:
return fetchSuggestions(_that);case ClearQuery() when clearQuery != null:
return clearQuery(_that);case LoadRecentSearches() when loadRecentSearches != null:
return loadRecentSearches(_that);case RecordRecentSearch() when recordRecentSearch != null:
return recordRecentSearch(_that);case RemoveRecentSearch() when removeRecentSearch != null:
return removeRecentSearch(_that);case ClearRecentSearches() when clearRecentSearches != null:
return clearRecentSearches(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QueryChanged value)  queryChanged,required TResult Function( _FetchSuggestions value)  fetchSuggestions,required TResult Function( ClearQuery value)  clearQuery,required TResult Function( LoadRecentSearches value)  loadRecentSearches,required TResult Function( RecordRecentSearch value)  recordRecentSearch,required TResult Function( RemoveRecentSearch value)  removeRecentSearch,required TResult Function( ClearRecentSearches value)  clearRecentSearches,}){
final _that = this;
switch (_that) {
case QueryChanged():
return queryChanged(_that);case _FetchSuggestions():
return fetchSuggestions(_that);case ClearQuery():
return clearQuery(_that);case LoadRecentSearches():
return loadRecentSearches(_that);case RecordRecentSearch():
return recordRecentSearch(_that);case RemoveRecentSearch():
return removeRecentSearch(_that);case ClearRecentSearches():
return clearRecentSearches(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QueryChanged value)?  queryChanged,TResult? Function( _FetchSuggestions value)?  fetchSuggestions,TResult? Function( ClearQuery value)?  clearQuery,TResult? Function( LoadRecentSearches value)?  loadRecentSearches,TResult? Function( RecordRecentSearch value)?  recordRecentSearch,TResult? Function( RemoveRecentSearch value)?  removeRecentSearch,TResult? Function( ClearRecentSearches value)?  clearRecentSearches,}){
final _that = this;
switch (_that) {
case QueryChanged() when queryChanged != null:
return queryChanged(_that);case _FetchSuggestions() when fetchSuggestions != null:
return fetchSuggestions(_that);case ClearQuery() when clearQuery != null:
return clearQuery(_that);case LoadRecentSearches() when loadRecentSearches != null:
return loadRecentSearches(_that);case RecordRecentSearch() when recordRecentSearch != null:
return recordRecentSearch(_that);case RemoveRecentSearch() when removeRecentSearch != null:
return removeRecentSearch(_that);case ClearRecentSearches() when clearRecentSearches != null:
return clearRecentSearches(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String query)?  queryChanged,TResult Function( String query)?  fetchSuggestions,TResult Function()?  clearQuery,TResult Function()?  loadRecentSearches,TResult Function( String term)?  recordRecentSearch,TResult Function( String term)?  removeRecentSearch,TResult Function()?  clearRecentSearches,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _FetchSuggestions() when fetchSuggestions != null:
return fetchSuggestions(_that.query);case ClearQuery() when clearQuery != null:
return clearQuery();case LoadRecentSearches() when loadRecentSearches != null:
return loadRecentSearches();case RecordRecentSearch() when recordRecentSearch != null:
return recordRecentSearch(_that.term);case RemoveRecentSearch() when removeRecentSearch != null:
return removeRecentSearch(_that.term);case ClearRecentSearches() when clearRecentSearches != null:
return clearRecentSearches();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String query)  queryChanged,required TResult Function( String query)  fetchSuggestions,required TResult Function()  clearQuery,required TResult Function()  loadRecentSearches,required TResult Function( String term)  recordRecentSearch,required TResult Function( String term)  removeRecentSearch,required TResult Function()  clearRecentSearches,}) {final _that = this;
switch (_that) {
case QueryChanged():
return queryChanged(_that.query);case _FetchSuggestions():
return fetchSuggestions(_that.query);case ClearQuery():
return clearQuery();case LoadRecentSearches():
return loadRecentSearches();case RecordRecentSearch():
return recordRecentSearch(_that.term);case RemoveRecentSearch():
return removeRecentSearch(_that.term);case ClearRecentSearches():
return clearRecentSearches();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String query)?  queryChanged,TResult? Function( String query)?  fetchSuggestions,TResult? Function()?  clearQuery,TResult? Function()?  loadRecentSearches,TResult? Function( String term)?  recordRecentSearch,TResult? Function( String term)?  removeRecentSearch,TResult? Function()?  clearRecentSearches,}) {final _that = this;
switch (_that) {
case QueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _FetchSuggestions() when fetchSuggestions != null:
return fetchSuggestions(_that.query);case ClearQuery() when clearQuery != null:
return clearQuery();case LoadRecentSearches() when loadRecentSearches != null:
return loadRecentSearches();case RecordRecentSearch() when recordRecentSearch != null:
return recordRecentSearch(_that.term);case RemoveRecentSearch() when removeRecentSearch != null:
return removeRecentSearch(_that.term);case ClearRecentSearches() when clearRecentSearches != null:
return clearRecentSearches();case _:
  return null;

}
}

}

/// @nodoc


class QueryChanged implements SearchEvent {
  const QueryChanged(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryChangedCopyWith<QueryChanged> get copyWith => _$QueryChangedCopyWithImpl<QueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $QueryChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $QueryChangedCopyWith(QueryChanged value, $Res Function(QueryChanged) _then) = _$QueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$QueryChangedCopyWithImpl<$Res>
    implements $QueryChangedCopyWith<$Res> {
  _$QueryChangedCopyWithImpl(this._self, this._then);

  final QueryChanged _self;
  final $Res Function(QueryChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(QueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FetchSuggestions implements SearchEvent {
  const _FetchSuggestions(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FetchSuggestionsCopyWith<_FetchSuggestions> get copyWith => __$FetchSuggestionsCopyWithImpl<_FetchSuggestions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchSuggestions&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchEvent.fetchSuggestions(query: $query)';
}


}

/// @nodoc
abstract mixin class _$FetchSuggestionsCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory _$FetchSuggestionsCopyWith(_FetchSuggestions value, $Res Function(_FetchSuggestions) _then) = __$FetchSuggestionsCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$FetchSuggestionsCopyWithImpl<$Res>
    implements _$FetchSuggestionsCopyWith<$Res> {
  __$FetchSuggestionsCopyWithImpl(this._self, this._then);

  final _FetchSuggestions _self;
  final $Res Function(_FetchSuggestions) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_FetchSuggestions(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearQuery implements SearchEvent {
  const ClearQuery();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearQuery);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.clearQuery()';
}


}




/// @nodoc


class LoadRecentSearches implements SearchEvent {
  const LoadRecentSearches();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadRecentSearches);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.loadRecentSearches()';
}


}




/// @nodoc


class RecordRecentSearch implements SearchEvent {
  const RecordRecentSearch(this.term);
  

 final  String term;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordRecentSearchCopyWith<RecordRecentSearch> get copyWith => _$RecordRecentSearchCopyWithImpl<RecordRecentSearch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordRecentSearch&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'SearchEvent.recordRecentSearch(term: $term)';
}


}

/// @nodoc
abstract mixin class $RecordRecentSearchCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $RecordRecentSearchCopyWith(RecordRecentSearch value, $Res Function(RecordRecentSearch) _then) = _$RecordRecentSearchCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$RecordRecentSearchCopyWithImpl<$Res>
    implements $RecordRecentSearchCopyWith<$Res> {
  _$RecordRecentSearchCopyWithImpl(this._self, this._then);

  final RecordRecentSearch _self;
  final $Res Function(RecordRecentSearch) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(RecordRecentSearch(
null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RemoveRecentSearch implements SearchEvent {
  const RemoveRecentSearch(this.term);
  

 final  String term;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveRecentSearchCopyWith<RemoveRecentSearch> get copyWith => _$RemoveRecentSearchCopyWithImpl<RemoveRecentSearch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveRecentSearch&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'SearchEvent.removeRecentSearch(term: $term)';
}


}

/// @nodoc
abstract mixin class $RemoveRecentSearchCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $RemoveRecentSearchCopyWith(RemoveRecentSearch value, $Res Function(RemoveRecentSearch) _then) = _$RemoveRecentSearchCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$RemoveRecentSearchCopyWithImpl<$Res>
    implements $RemoveRecentSearchCopyWith<$Res> {
  _$RemoveRecentSearchCopyWithImpl(this._self, this._then);

  final RemoveRecentSearch _self;
  final $Res Function(RemoveRecentSearch) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(RemoveRecentSearch(
null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearRecentSearches implements SearchEvent {
  const ClearRecentSearches();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearRecentSearches);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.clearRecentSearches()';
}


}




/// @nodoc
mixin _$SearchState {

 SearchStatus get status; String get query; List<SearchSuggestionEntity> get suggestions; List<String> get recentSearches; String? get errorMessage;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&const DeepCollectionEquality().equals(other.recentSearches, recentSearches)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,query,const DeepCollectionEquality().hash(suggestions),const DeepCollectionEquality().hash(recentSearches),errorMessage);

@override
String toString() {
  return 'SearchState(status: $status, query: $query, suggestions: $suggestions, recentSearches: $recentSearches, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 SearchStatus status, String query, List<SearchSuggestionEntity> suggestions, List<String> recentSearches, String? errorMessage
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? query = null,Object? suggestions = null,Object? recentSearches = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<SearchSuggestionEntity>,recentSearches: null == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchStatus status,  String query,  List<SearchSuggestionEntity> suggestions,  List<String> recentSearches,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.status,_that.query,_that.suggestions,_that.recentSearches,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchStatus status,  String query,  List<SearchSuggestionEntity> suggestions,  List<String> recentSearches,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.status,_that.query,_that.suggestions,_that.recentSearches,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchStatus status,  String query,  List<SearchSuggestionEntity> suggestions,  List<String> recentSearches,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.status,_that.query,_that.suggestions,_that.recentSearches,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.status = SearchStatus.idle, this.query = '', final  List<SearchSuggestionEntity> suggestions = const <SearchSuggestionEntity>[], final  List<String> recentSearches = const <String>[], this.errorMessage}): _suggestions = suggestions,_recentSearches = recentSearches;
  

@override@JsonKey() final  SearchStatus status;
@override@JsonKey() final  String query;
 final  List<SearchSuggestionEntity> _suggestions;
@override@JsonKey() List<SearchSuggestionEntity> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

 final  List<String> _recentSearches;
@override@JsonKey() List<String> get recentSearches {
  if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSearches);
}

@override final  String? errorMessage;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.status, status) || other.status == status)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&const DeepCollectionEquality().equals(other._recentSearches, _recentSearches)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,query,const DeepCollectionEquality().hash(_suggestions),const DeepCollectionEquality().hash(_recentSearches),errorMessage);

@override
String toString() {
  return 'SearchState(status: $status, query: $query, suggestions: $suggestions, recentSearches: $recentSearches, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 SearchStatus status, String query, List<SearchSuggestionEntity> suggestions, List<String> recentSearches, String? errorMessage
});




}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? query = null,Object? suggestions = null,Object? recentSearches = null,Object? errorMessage = freezed,}) {
  return _then(_SearchState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<SearchSuggestionEntity>,recentSearches: null == recentSearches ? _self._recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
