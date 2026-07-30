// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lp_attribution_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LpAttributionEntry {

 Map<String, dynamic> get meta; String? get landingPageName; String? get landingPageId;
/// Create a copy of LpAttributionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LpAttributionEntryCopyWith<LpAttributionEntry> get copyWith => _$LpAttributionEntryCopyWithImpl<LpAttributionEntry>(this as LpAttributionEntry, _$identity);

  /// Serializes this LpAttributionEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LpAttributionEntry&&const DeepCollectionEquality().equals(other.meta, meta)&&(identical(other.landingPageName, landingPageName) || other.landingPageName == landingPageName)&&(identical(other.landingPageId, landingPageId) || other.landingPageId == landingPageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(meta),landingPageName,landingPageId);

@override
String toString() {
  return 'LpAttributionEntry(meta: $meta, landingPageName: $landingPageName, landingPageId: $landingPageId)';
}


}

/// @nodoc
abstract mixin class $LpAttributionEntryCopyWith<$Res>  {
  factory $LpAttributionEntryCopyWith(LpAttributionEntry value, $Res Function(LpAttributionEntry) _then) = _$LpAttributionEntryCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> meta, String? landingPageName, String? landingPageId
});




}
/// @nodoc
class _$LpAttributionEntryCopyWithImpl<$Res>
    implements $LpAttributionEntryCopyWith<$Res> {
  _$LpAttributionEntryCopyWithImpl(this._self, this._then);

  final LpAttributionEntry _self;
  final $Res Function(LpAttributionEntry) _then;

/// Create a copy of LpAttributionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meta = null,Object? landingPageName = freezed,Object? landingPageId = freezed,}) {
  return _then(_self.copyWith(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,landingPageName: freezed == landingPageName ? _self.landingPageName : landingPageName // ignore: cast_nullable_to_non_nullable
as String?,landingPageId: freezed == landingPageId ? _self.landingPageId : landingPageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LpAttributionEntry].
extension LpAttributionEntryPatterns on LpAttributionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LpAttributionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LpAttributionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LpAttributionEntry value)  $default,){
final _that = this;
switch (_that) {
case _LpAttributionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LpAttributionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LpAttributionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> meta,  String? landingPageName,  String? landingPageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LpAttributionEntry() when $default != null:
return $default(_that.meta,_that.landingPageName,_that.landingPageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> meta,  String? landingPageName,  String? landingPageId)  $default,) {final _that = this;
switch (_that) {
case _LpAttributionEntry():
return $default(_that.meta,_that.landingPageName,_that.landingPageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> meta,  String? landingPageName,  String? landingPageId)?  $default,) {final _that = this;
switch (_that) {
case _LpAttributionEntry() when $default != null:
return $default(_that.meta,_that.landingPageName,_that.landingPageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LpAttributionEntry implements LpAttributionEntry {
  const _LpAttributionEntry({final  Map<String, dynamic> meta = const <String, dynamic>{}, this.landingPageName, this.landingPageId}): _meta = meta;
  factory _LpAttributionEntry.fromJson(Map<String, dynamic> json) => _$LpAttributionEntryFromJson(json);

 final  Map<String, dynamic> _meta;
@override@JsonKey() Map<String, dynamic> get meta {
  if (_meta is EqualUnmodifiableMapView) return _meta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_meta);
}

@override final  String? landingPageName;
@override final  String? landingPageId;

/// Create a copy of LpAttributionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LpAttributionEntryCopyWith<_LpAttributionEntry> get copyWith => __$LpAttributionEntryCopyWithImpl<_LpAttributionEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LpAttributionEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LpAttributionEntry&&const DeepCollectionEquality().equals(other._meta, _meta)&&(identical(other.landingPageName, landingPageName) || other.landingPageName == landingPageName)&&(identical(other.landingPageId, landingPageId) || other.landingPageId == landingPageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_meta),landingPageName,landingPageId);

@override
String toString() {
  return 'LpAttributionEntry(meta: $meta, landingPageName: $landingPageName, landingPageId: $landingPageId)';
}


}

/// @nodoc
abstract mixin class _$LpAttributionEntryCopyWith<$Res> implements $LpAttributionEntryCopyWith<$Res> {
  factory _$LpAttributionEntryCopyWith(_LpAttributionEntry value, $Res Function(_LpAttributionEntry) _then) = __$LpAttributionEntryCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> meta, String? landingPageName, String? landingPageId
});




}
/// @nodoc
class __$LpAttributionEntryCopyWithImpl<$Res>
    implements _$LpAttributionEntryCopyWith<$Res> {
  __$LpAttributionEntryCopyWithImpl(this._self, this._then);

  final _LpAttributionEntry _self;
  final $Res Function(_LpAttributionEntry) _then;

/// Create a copy of LpAttributionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? landingPageName = freezed,Object? landingPageId = freezed,}) {
  return _then(_LpAttributionEntry(
meta: null == meta ? _self._meta : meta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,landingPageName: freezed == landingPageName ? _self.landingPageName : landingPageName // ignore: cast_nullable_to_non_nullable
as String?,landingPageId: freezed == landingPageId ? _self.landingPageId : landingPageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
