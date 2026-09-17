// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TileEntity {

 ListingProductEntity get product;/// `tiles[].trackingMeta` — the prefixed click block, forwarded whole.
 Map<String, dynamic>? get trackingMeta;
/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileEntityCopyWith<TileEntity> get copyWith => _$TileEntityCopyWithImpl<TileEntity>(this as TileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TileEntity&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'TileEntity(product: $product, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $TileEntityCopyWith<$Res>  {
  factory $TileEntityCopyWith(TileEntity value, $Res Function(TileEntity) _then) = _$TileEntityCopyWithImpl;
@useResult
$Res call({
 ListingProductEntity product, Map<String, dynamic>? trackingMeta
});


$ListingProductEntityCopyWith<$Res> get product;

}
/// @nodoc
class _$TileEntityCopyWithImpl<$Res>
    implements $TileEntityCopyWith<$Res> {
  _$TileEntityCopyWithImpl(this._self, this._then);

  final TileEntity _self;
  final $Res Function(TileEntity) _then;

/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? trackingMeta = freezed,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res> get product {
  
  return $ListingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [TileEntity].
extension TileEntityPatterns on TileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TileEntity value)  $default,){
final _that = this;
switch (_that) {
case _TileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ListingProductEntity product,  Map<String, dynamic>? trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TileEntity() when $default != null:
return $default(_that.product,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ListingProductEntity product,  Map<String, dynamic>? trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _TileEntity():
return $default(_that.product,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ListingProductEntity product,  Map<String, dynamic>? trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _TileEntity() when $default != null:
return $default(_that.product,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _TileEntity implements TileEntity {
  const _TileEntity({required this.product, final  Map<String, dynamic>? trackingMeta}): _trackingMeta = trackingMeta;
  

@override final  ListingProductEntity product;
/// `tiles[].trackingMeta` — the prefixed click block, forwarded whole.
 final  Map<String, dynamic>? _trackingMeta;
/// `tiles[].trackingMeta` — the prefixed click block, forwarded whole.
@override Map<String, dynamic>? get trackingMeta {
  final value = _trackingMeta;
  if (value == null) return null;
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TileEntityCopyWith<_TileEntity> get copyWith => __$TileEntityCopyWithImpl<_TileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TileEntity&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'TileEntity(product: $product, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$TileEntityCopyWith<$Res> implements $TileEntityCopyWith<$Res> {
  factory _$TileEntityCopyWith(_TileEntity value, $Res Function(_TileEntity) _then) = __$TileEntityCopyWithImpl;
@override @useResult
$Res call({
 ListingProductEntity product, Map<String, dynamic>? trackingMeta
});


@override $ListingProductEntityCopyWith<$Res> get product;

}
/// @nodoc
class __$TileEntityCopyWithImpl<$Res>
    implements _$TileEntityCopyWith<$Res> {
  __$TileEntityCopyWithImpl(this._self, this._then);

  final _TileEntity _self;
  final $Res Function(_TileEntity) _then;

/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? trackingMeta = freezed,}) {
  return _then(_TileEntity(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,trackingMeta: freezed == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of TileEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res> get product {
  
  return $ListingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
