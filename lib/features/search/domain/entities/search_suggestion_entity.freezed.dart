// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_suggestion_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchSuggestionEntity {

 String? get term;/// May contain simple HTML — `<p><b>hel</b>met</p>` — where `<b>` marks
/// the substring matching the user's typed query. See the search page
/// for how this is rendered.
 String? get displayName; String? get actionUri; String? get actionUriWeb; String? get searchParams;/// Analytics payload from the autocomplete API — `id`/`type`/`section`.
/// Forwarded to the segment event when a suggestion is tapped. Shape is
/// server-defined.
 Map<String, dynamic>? get trackingMeta;
/// Create a copy of SearchSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSuggestionEntityCopyWith<SearchSuggestionEntity> get copyWith => _$SearchSuggestionEntityCopyWithImpl<SearchSuggestionEntity>(this as SearchSuggestionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSuggestionEntity&&(identical(other.term, term) || other.term == term)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.actionUriWeb, actionUriWeb) || other.actionUriWeb == actionUriWeb)&&(identical(other.searchParams, searchParams) || other.searchParams == searchParams)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,term,displayName,actionUri,actionUriWeb,searchParams,const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'SearchSuggestionEntity(term: $term, displayName: $displayName, actionUri: $actionUri, actionUriWeb: $actionUriWeb, searchParams: $searchParams, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $SearchSuggestionEntityCopyWith<$Res>  {
  factory $SearchSuggestionEntityCopyWith(SearchSuggestionEntity value, $Res Function(SearchSuggestionEntity) _then) = _$SearchSuggestionEntityCopyWithImpl;
@useResult
$Res call({
 String? term, String? displayName, String? actionUri, String? actionUriWeb, String? searchParams, Map<String, dynamic>? trackingMeta
});




}
/// @nodoc
class _$SearchSuggestionEntityCopyWithImpl<$Res>
    implements $SearchSuggestionEntityCopyWith<$Res> {
  _$SearchSuggestionEntityCopyWithImpl(this._self, this._then);

  final SearchSuggestionEntity _self;
  final $Res Function(SearchSuggestionEntity) _then;

/// Create a copy of SearchSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? term = freezed,Object? displayName = freezed,Object? actionUri = freezed,Object? actionUriWeb = freezed,Object? searchParams = freezed,Object? trackingMeta = freezed,}) {
  return _then(_self.copyWith(
term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,actionUriWeb: freezed == actionUriWeb ? _self.actionUriWeb : actionUriWeb // ignore: cast_nullable_to_non_nullable
as String?,searchParams: freezed == searchParams ? _self.searchParams : searchParams // ignore: cast_nullable_to_non_nullable
as String?,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchSuggestionEntity].
extension SearchSuggestionEntityPatterns on SearchSuggestionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchSuggestionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchSuggestionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchSuggestionEntity value)  $default,){
final _that = this;
switch (_that) {
case _SearchSuggestionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchSuggestionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SearchSuggestionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? term,  String? displayName,  String? actionUri,  String? actionUriWeb,  String? searchParams,  Map<String, dynamic>? trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchSuggestionEntity() when $default != null:
return $default(_that.term,_that.displayName,_that.actionUri,_that.actionUriWeb,_that.searchParams,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? term,  String? displayName,  String? actionUri,  String? actionUriWeb,  String? searchParams,  Map<String, dynamic>? trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _SearchSuggestionEntity():
return $default(_that.term,_that.displayName,_that.actionUri,_that.actionUriWeb,_that.searchParams,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? term,  String? displayName,  String? actionUri,  String? actionUriWeb,  String? searchParams,  Map<String, dynamic>? trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _SearchSuggestionEntity() when $default != null:
return $default(_that.term,_that.displayName,_that.actionUri,_that.actionUriWeb,_that.searchParams,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _SearchSuggestionEntity implements SearchSuggestionEntity {
  const _SearchSuggestionEntity({this.term, this.displayName, this.actionUri, this.actionUriWeb, this.searchParams, final  Map<String, dynamic>? trackingMeta}): _trackingMeta = trackingMeta;
  

@override final  String? term;
/// May contain simple HTML — `<p><b>hel</b>met</p>` — where `<b>` marks
/// the substring matching the user's typed query. See the search page
/// for how this is rendered.
@override final  String? displayName;
@override final  String? actionUri;
@override final  String? actionUriWeb;
@override final  String? searchParams;
/// Analytics payload from the autocomplete API — `id`/`type`/`section`.
/// Forwarded to the segment event when a suggestion is tapped. Shape is
/// server-defined.
 final  Map<String, dynamic>? _trackingMeta;
/// Analytics payload from the autocomplete API — `id`/`type`/`section`.
/// Forwarded to the segment event when a suggestion is tapped. Shape is
/// server-defined.
@override Map<String, dynamic>? get trackingMeta {
  final value = _trackingMeta;
  if (value == null) return null;
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SearchSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSuggestionEntityCopyWith<_SearchSuggestionEntity> get copyWith => __$SearchSuggestionEntityCopyWithImpl<_SearchSuggestionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSuggestionEntity&&(identical(other.term, term) || other.term == term)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.actionUriWeb, actionUriWeb) || other.actionUriWeb == actionUriWeb)&&(identical(other.searchParams, searchParams) || other.searchParams == searchParams)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,term,displayName,actionUri,actionUriWeb,searchParams,const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'SearchSuggestionEntity(term: $term, displayName: $displayName, actionUri: $actionUri, actionUriWeb: $actionUriWeb, searchParams: $searchParams, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$SearchSuggestionEntityCopyWith<$Res> implements $SearchSuggestionEntityCopyWith<$Res> {
  factory _$SearchSuggestionEntityCopyWith(_SearchSuggestionEntity value, $Res Function(_SearchSuggestionEntity) _then) = __$SearchSuggestionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? term, String? displayName, String? actionUri, String? actionUriWeb, String? searchParams, Map<String, dynamic>? trackingMeta
});




}
/// @nodoc
class __$SearchSuggestionEntityCopyWithImpl<$Res>
    implements _$SearchSuggestionEntityCopyWith<$Res> {
  __$SearchSuggestionEntityCopyWithImpl(this._self, this._then);

  final _SearchSuggestionEntity _self;
  final $Res Function(_SearchSuggestionEntity) _then;

/// Create a copy of SearchSuggestionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? term = freezed,Object? displayName = freezed,Object? actionUri = freezed,Object? actionUriWeb = freezed,Object? searchParams = freezed,Object? trackingMeta = freezed,}) {
  return _then(_SearchSuggestionEntity(
term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,actionUriWeb: freezed == actionUriWeb ? _self.actionUriWeb : actionUriWeb // ignore: cast_nullable_to_non_nullable
as String?,searchParams: freezed == searchParams ? _self.searchParams : searchParams // ignore: cast_nullable_to_non_nullable
as String?,trackingMeta: freezed == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
