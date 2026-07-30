// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attribution_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttributionData {

/// HP click-chain attribution blob. Unprefixed keys only
/// (`banner_name`, `funnel_row`, `funnel_tile`, `slice_id`,
/// `property_type`, …). LP `lp{n}_*` chains live in
/// `LpAttributionHelper`, not here.
 Map<String, dynamic> get trackingMeta;/// Screen-level funnel identity (`Discover`, `Search`, `Cart`, …).
/// Set on funnel-screen entry / tab switch.
 String? get funnel;/// Sort chip state — user picks it in the client, so it stays typed.
 String? get sortBar;
/// Create a copy of AttributionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttributionDataCopyWith<AttributionData> get copyWith => _$AttributionDataCopyWithImpl<AttributionData>(this as AttributionData, _$identity);

  /// Serializes this AttributionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttributionData&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta)&&(identical(other.funnel, funnel) || other.funnel == funnel)&&(identical(other.sortBar, sortBar) || other.sortBar == sortBar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(trackingMeta),funnel,sortBar);

@override
String toString() {
  return 'AttributionData(trackingMeta: $trackingMeta, funnel: $funnel, sortBar: $sortBar)';
}


}

/// @nodoc
abstract mixin class $AttributionDataCopyWith<$Res>  {
  factory $AttributionDataCopyWith(AttributionData value, $Res Function(AttributionData) _then) = _$AttributionDataCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> trackingMeta, String? funnel, String? sortBar
});




}
/// @nodoc
class _$AttributionDataCopyWithImpl<$Res>
    implements $AttributionDataCopyWith<$Res> {
  _$AttributionDataCopyWithImpl(this._self, this._then);

  final AttributionData _self;
  final $Res Function(AttributionData) _then;

/// Create a copy of AttributionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackingMeta = null,Object? funnel = freezed,Object? sortBar = freezed,}) {
  return _then(_self.copyWith(
trackingMeta: null == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,funnel: freezed == funnel ? _self.funnel : funnel // ignore: cast_nullable_to_non_nullable
as String?,sortBar: freezed == sortBar ? _self.sortBar : sortBar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttributionData].
extension AttributionDataPatterns on AttributionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttributionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttributionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttributionData value)  $default,){
final _that = this;
switch (_that) {
case _AttributionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttributionData value)?  $default,){
final _that = this;
switch (_that) {
case _AttributionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> trackingMeta,  String? funnel,  String? sortBar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttributionData() when $default != null:
return $default(_that.trackingMeta,_that.funnel,_that.sortBar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> trackingMeta,  String? funnel,  String? sortBar)  $default,) {final _that = this;
switch (_that) {
case _AttributionData():
return $default(_that.trackingMeta,_that.funnel,_that.sortBar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> trackingMeta,  String? funnel,  String? sortBar)?  $default,) {final _that = this;
switch (_that) {
case _AttributionData() when $default != null:
return $default(_that.trackingMeta,_that.funnel,_that.sortBar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttributionData extends AttributionData {
  const _AttributionData({final  Map<String, dynamic> trackingMeta = const <String, dynamic>{}, this.funnel, this.sortBar}): _trackingMeta = trackingMeta,super._();
  factory _AttributionData.fromJson(Map<String, dynamic> json) => _$AttributionDataFromJson(json);

/// HP click-chain attribution blob. Unprefixed keys only
/// (`banner_name`, `funnel_row`, `funnel_tile`, `slice_id`,
/// `property_type`, …). LP `lp{n}_*` chains live in
/// `LpAttributionHelper`, not here.
 final  Map<String, dynamic> _trackingMeta;
/// HP click-chain attribution blob. Unprefixed keys only
/// (`banner_name`, `funnel_row`, `funnel_tile`, `slice_id`,
/// `property_type`, …). LP `lp{n}_*` chains live in
/// `LpAttributionHelper`, not here.
@override@JsonKey() Map<String, dynamic> get trackingMeta {
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trackingMeta);
}

/// Screen-level funnel identity (`Discover`, `Search`, `Cart`, …).
/// Set on funnel-screen entry / tab switch.
@override final  String? funnel;
/// Sort chip state — user picks it in the client, so it stays typed.
@override final  String? sortBar;

/// Create a copy of AttributionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttributionDataCopyWith<_AttributionData> get copyWith => __$AttributionDataCopyWithImpl<_AttributionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttributionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttributionData&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta)&&(identical(other.funnel, funnel) || other.funnel == funnel)&&(identical(other.sortBar, sortBar) || other.sortBar == sortBar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_trackingMeta),funnel,sortBar);

@override
String toString() {
  return 'AttributionData(trackingMeta: $trackingMeta, funnel: $funnel, sortBar: $sortBar)';
}


}

/// @nodoc
abstract mixin class _$AttributionDataCopyWith<$Res> implements $AttributionDataCopyWith<$Res> {
  factory _$AttributionDataCopyWith(_AttributionData value, $Res Function(_AttributionData) _then) = __$AttributionDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> trackingMeta, String? funnel, String? sortBar
});




}
/// @nodoc
class __$AttributionDataCopyWithImpl<$Res>
    implements _$AttributionDataCopyWith<$Res> {
  __$AttributionDataCopyWithImpl(this._self, this._then);

  final _AttributionData _self;
  final $Res Function(_AttributionData) _then;

/// Create a copy of AttributionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackingMeta = null,Object? funnel = freezed,Object? sortBar = freezed,}) {
  return _then(_AttributionData(
trackingMeta: null == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,funnel: freezed == funnel ? _self.funnel : funnel // ignore: cast_nullable_to_non_nullable
as String?,sortBar: freezed == sortBar ? _self.sortBar : sortBar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
