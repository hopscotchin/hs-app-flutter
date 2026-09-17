// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WishlistProductEntity {

 ListingProductEntity get product; String? get moveToBagSku;/// The size the user wishlisted, when the response carries one. Unlike
/// [moveToBagSku] this is never a fallback — it is null when the API sent
/// no `wishlistInfo.wishlistedSku`.
 String? get wishlistedSku; bool get hasSizeChart; List<SkuEntity> get skus;
/// Create a copy of WishlistProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistProductEntityCopyWith<WishlistProductEntity> get copyWith => _$WishlistProductEntityCopyWithImpl<WishlistProductEntity>(this as WishlistProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistProductEntity&&(identical(other.product, product) || other.product == product)&&(identical(other.moveToBagSku, moveToBagSku) || other.moveToBagSku == moveToBagSku)&&(identical(other.wishlistedSku, wishlistedSku) || other.wishlistedSku == wishlistedSku)&&(identical(other.hasSizeChart, hasSizeChart) || other.hasSizeChart == hasSizeChart)&&const DeepCollectionEquality().equals(other.skus, skus));
}


@override
int get hashCode => Object.hash(runtimeType,product,moveToBagSku,wishlistedSku,hasSizeChart,const DeepCollectionEquality().hash(skus));

@override
String toString() {
  return 'WishlistProductEntity(product: $product, moveToBagSku: $moveToBagSku, wishlistedSku: $wishlistedSku, hasSizeChart: $hasSizeChart, skus: $skus)';
}


}

/// @nodoc
abstract mixin class $WishlistProductEntityCopyWith<$Res>  {
  factory $WishlistProductEntityCopyWith(WishlistProductEntity value, $Res Function(WishlistProductEntity) _then) = _$WishlistProductEntityCopyWithImpl;
@useResult
$Res call({
 ListingProductEntity product, String? moveToBagSku, String? wishlistedSku, bool hasSizeChart, List<SkuEntity> skus
});


$ListingProductEntityCopyWith<$Res> get product;

}
/// @nodoc
class _$WishlistProductEntityCopyWithImpl<$Res>
    implements $WishlistProductEntityCopyWith<$Res> {
  _$WishlistProductEntityCopyWithImpl(this._self, this._then);

  final WishlistProductEntity _self;
  final $Res Function(WishlistProductEntity) _then;

/// Create a copy of WishlistProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? moveToBagSku = freezed,Object? wishlistedSku = freezed,Object? hasSizeChart = null,Object? skus = null,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,moveToBagSku: freezed == moveToBagSku ? _self.moveToBagSku : moveToBagSku // ignore: cast_nullable_to_non_nullable
as String?,wishlistedSku: freezed == wishlistedSku ? _self.wishlistedSku : wishlistedSku // ignore: cast_nullable_to_non_nullable
as String?,hasSizeChart: null == hasSizeChart ? _self.hasSizeChart : hasSizeChart // ignore: cast_nullable_to_non_nullable
as bool,skus: null == skus ? _self.skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,
  ));
}
/// Create a copy of WishlistProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<$Res> get product {
  
  return $ListingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [WishlistProductEntity].
extension WishlistProductEntityPatterns on WishlistProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _WishlistProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ListingProductEntity product,  String? moveToBagSku,  String? wishlistedSku,  bool hasSizeChart,  List<SkuEntity> skus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistProductEntity() when $default != null:
return $default(_that.product,_that.moveToBagSku,_that.wishlistedSku,_that.hasSizeChart,_that.skus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ListingProductEntity product,  String? moveToBagSku,  String? wishlistedSku,  bool hasSizeChart,  List<SkuEntity> skus)  $default,) {final _that = this;
switch (_that) {
case _WishlistProductEntity():
return $default(_that.product,_that.moveToBagSku,_that.wishlistedSku,_that.hasSizeChart,_that.skus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ListingProductEntity product,  String? moveToBagSku,  String? wishlistedSku,  bool hasSizeChart,  List<SkuEntity> skus)?  $default,) {final _that = this;
switch (_that) {
case _WishlistProductEntity() when $default != null:
return $default(_that.product,_that.moveToBagSku,_that.wishlistedSku,_that.hasSizeChart,_that.skus);case _:
  return null;

}
}

}

/// @nodoc


class _WishlistProductEntity implements WishlistProductEntity {
  const _WishlistProductEntity({required this.product, this.moveToBagSku, this.wishlistedSku, this.hasSizeChart = false, final  List<SkuEntity> skus = const <SkuEntity>[]}): _skus = skus;
  

@override final  ListingProductEntity product;
@override final  String? moveToBagSku;
/// The size the user wishlisted, when the response carries one. Unlike
/// [moveToBagSku] this is never a fallback — it is null when the API sent
/// no `wishlistInfo.wishlistedSku`.
@override final  String? wishlistedSku;
@override@JsonKey() final  bool hasSizeChart;
 final  List<SkuEntity> _skus;
@override@JsonKey() List<SkuEntity> get skus {
  if (_skus is EqualUnmodifiableListView) return _skus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skus);
}


/// Create a copy of WishlistProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistProductEntityCopyWith<_WishlistProductEntity> get copyWith => __$WishlistProductEntityCopyWithImpl<_WishlistProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistProductEntity&&(identical(other.product, product) || other.product == product)&&(identical(other.moveToBagSku, moveToBagSku) || other.moveToBagSku == moveToBagSku)&&(identical(other.wishlistedSku, wishlistedSku) || other.wishlistedSku == wishlistedSku)&&(identical(other.hasSizeChart, hasSizeChart) || other.hasSizeChart == hasSizeChart)&&const DeepCollectionEquality().equals(other._skus, _skus));
}


@override
int get hashCode => Object.hash(runtimeType,product,moveToBagSku,wishlistedSku,hasSizeChart,const DeepCollectionEquality().hash(_skus));

@override
String toString() {
  return 'WishlistProductEntity(product: $product, moveToBagSku: $moveToBagSku, wishlistedSku: $wishlistedSku, hasSizeChart: $hasSizeChart, skus: $skus)';
}


}

/// @nodoc
abstract mixin class _$WishlistProductEntityCopyWith<$Res> implements $WishlistProductEntityCopyWith<$Res> {
  factory _$WishlistProductEntityCopyWith(_WishlistProductEntity value, $Res Function(_WishlistProductEntity) _then) = __$WishlistProductEntityCopyWithImpl;
@override @useResult
$Res call({
 ListingProductEntity product, String? moveToBagSku, String? wishlistedSku, bool hasSizeChart, List<SkuEntity> skus
});


@override $ListingProductEntityCopyWith<$Res> get product;

}
/// @nodoc
class __$WishlistProductEntityCopyWithImpl<$Res>
    implements _$WishlistProductEntityCopyWith<$Res> {
  __$WishlistProductEntityCopyWithImpl(this._self, this._then);

  final _WishlistProductEntity _self;
  final $Res Function(_WishlistProductEntity) _then;

/// Create a copy of WishlistProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? moveToBagSku = freezed,Object? wishlistedSku = freezed,Object? hasSizeChart = null,Object? skus = null,}) {
  return _then(_WishlistProductEntity(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ListingProductEntity,moveToBagSku: freezed == moveToBagSku ? _self.moveToBagSku : moveToBagSku // ignore: cast_nullable_to_non_nullable
as String?,wishlistedSku: freezed == wishlistedSku ? _self.wishlistedSku : wishlistedSku // ignore: cast_nullable_to_non_nullable
as String?,hasSizeChart: null == hasSizeChart ? _self.hasSizeChart : hasSizeChart // ignore: cast_nullable_to_non_nullable
as bool,skus: null == skus ? _self._skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,
  ));
}

/// Create a copy of WishlistProductEntity
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
