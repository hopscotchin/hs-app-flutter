// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_attribution_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductAttributionData {

 Map<String, dynamic> get trackingMeta;
/// Create a copy of ProductAttributionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductAttributionDataCopyWith<ProductAttributionData> get copyWith => _$ProductAttributionDataCopyWithImpl<ProductAttributionData>(this as ProductAttributionData, _$identity);

  /// Serializes this ProductAttributionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductAttributionData&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'ProductAttributionData(trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $ProductAttributionDataCopyWith<$Res>  {
  factory $ProductAttributionDataCopyWith(ProductAttributionData value, $Res Function(ProductAttributionData) _then) = _$ProductAttributionDataCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class _$ProductAttributionDataCopyWithImpl<$Res>
    implements $ProductAttributionDataCopyWith<$Res> {
  _$ProductAttributionDataCopyWithImpl(this._self, this._then);

  final ProductAttributionData _self;
  final $Res Function(ProductAttributionData) _then;

/// Create a copy of ProductAttributionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackingMeta = null,}) {
  return _then(_self.copyWith(
trackingMeta: null == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductAttributionData].
extension ProductAttributionDataPatterns on ProductAttributionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductAttributionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductAttributionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductAttributionData value)  $default,){
final _that = this;
switch (_that) {
case _ProductAttributionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductAttributionData value)?  $default,){
final _that = this;
switch (_that) {
case _ProductAttributionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductAttributionData() when $default != null:
return $default(_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _ProductAttributionData():
return $default(_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _ProductAttributionData() when $default != null:
return $default(_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductAttributionData implements ProductAttributionData {
  const _ProductAttributionData({final  Map<String, dynamic> trackingMeta = const <String, dynamic>{}}): _trackingMeta = trackingMeta;
  factory _ProductAttributionData.fromJson(Map<String, dynamic> json) => _$ProductAttributionDataFromJson(json);

 final  Map<String, dynamic> _trackingMeta;
@override@JsonKey() Map<String, dynamic> get trackingMeta {
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trackingMeta);
}


/// Create a copy of ProductAttributionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductAttributionDataCopyWith<_ProductAttributionData> get copyWith => __$ProductAttributionDataCopyWithImpl<_ProductAttributionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductAttributionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductAttributionData&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'ProductAttributionData(trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$ProductAttributionDataCopyWith<$Res> implements $ProductAttributionDataCopyWith<$Res> {
  factory _$ProductAttributionDataCopyWith(_ProductAttributionData value, $Res Function(_ProductAttributionData) _then) = __$ProductAttributionDataCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> trackingMeta
});




}
/// @nodoc
class __$ProductAttributionDataCopyWithImpl<$Res>
    implements _$ProductAttributionDataCopyWith<$Res> {
  __$ProductAttributionDataCopyWithImpl(this._self, this._then);

  final _ProductAttributionData _self;
  final $Res Function(_ProductAttributionData) _then;

/// Create a copy of ProductAttributionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackingMeta = null,}) {
  return _then(_ProductAttributionData(
trackingMeta: null == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
