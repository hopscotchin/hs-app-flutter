// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailEntity {

 String? get action; String? get message; List<BannerEntity> get banners; ProductEntity? get product; List<OfferEntity> get offersList; RecentlyViewedEntity? get recentlyViewed;
/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailEntityCopyWith<ProductDetailEntity> get copyWith => _$ProductDetailEntityCopyWithImpl<ProductDetailEntity>(this as ProductDetailEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.banners, banners)&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other.offersList, offersList)&&(identical(other.recentlyViewed, recentlyViewed) || other.recentlyViewed == recentlyViewed));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,const DeepCollectionEquality().hash(banners),product,const DeepCollectionEquality().hash(offersList),recentlyViewed);

@override
String toString() {
  return 'ProductDetailEntity(action: $action, message: $message, banners: $banners, product: $product, offersList: $offersList, recentlyViewed: $recentlyViewed)';
}


}

/// @nodoc
abstract mixin class $ProductDetailEntityCopyWith<$Res>  {
  factory $ProductDetailEntityCopyWith(ProductDetailEntity value, $Res Function(ProductDetailEntity) _then) = _$ProductDetailEntityCopyWithImpl;
@useResult
$Res call({
 String? action, String? message, List<BannerEntity> banners, ProductEntity? product, List<OfferEntity> offersList, RecentlyViewedEntity? recentlyViewed
});


$ProductEntityCopyWith<$Res>? get product;$RecentlyViewedEntityCopyWith<$Res>? get recentlyViewed;

}
/// @nodoc
class _$ProductDetailEntityCopyWithImpl<$Res>
    implements $ProductDetailEntityCopyWith<$Res> {
  _$ProductDetailEntityCopyWithImpl(this._self, this._then);

  final ProductDetailEntity _self;
  final $Res Function(ProductDetailEntity) _then;

/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? message = freezed,Object? banners = null,Object? product = freezed,Object? offersList = null,Object? recentlyViewed = freezed,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity?,offersList: null == offersList ? _self.offersList : offersList // ignore: cast_nullable_to_non_nullable
as List<OfferEntity>,recentlyViewed: freezed == recentlyViewed ? _self.recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as RecentlyViewedEntity?,
  ));
}
/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductEntityCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedEntityCopyWith<$Res>? get recentlyViewed {
    if (_self.recentlyViewed == null) {
    return null;
  }

  return $RecentlyViewedEntityCopyWith<$Res>(_self.recentlyViewed!, (value) {
    return _then(_self.copyWith(recentlyViewed: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetailEntity].
extension ProductDetailEntityPatterns on ProductDetailEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetailEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetailEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetailEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetailEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetailEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetailEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? message,  List<BannerEntity> banners,  ProductEntity? product,  List<OfferEntity> offersList,  RecentlyViewedEntity? recentlyViewed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetailEntity() when $default != null:
return $default(_that.action,_that.message,_that.banners,_that.product,_that.offersList,_that.recentlyViewed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? message,  List<BannerEntity> banners,  ProductEntity? product,  List<OfferEntity> offersList,  RecentlyViewedEntity? recentlyViewed)  $default,) {final _that = this;
switch (_that) {
case _ProductDetailEntity():
return $default(_that.action,_that.message,_that.banners,_that.product,_that.offersList,_that.recentlyViewed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? message,  List<BannerEntity> banners,  ProductEntity? product,  List<OfferEntity> offersList,  RecentlyViewedEntity? recentlyViewed)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetailEntity() when $default != null:
return $default(_that.action,_that.message,_that.banners,_that.product,_that.offersList,_that.recentlyViewed);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDetailEntity implements ProductDetailEntity {
  const _ProductDetailEntity({this.action, this.message, final  List<BannerEntity> banners = const [], this.product, final  List<OfferEntity> offersList = const [], this.recentlyViewed}): _banners = banners,_offersList = offersList;
  

@override final  String? action;
@override final  String? message;
 final  List<BannerEntity> _banners;
@override@JsonKey() List<BannerEntity> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

@override final  ProductEntity? product;
 final  List<OfferEntity> _offersList;
@override@JsonKey() List<OfferEntity> get offersList {
  if (_offersList is EqualUnmodifiableListView) return _offersList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offersList);
}

@override final  RecentlyViewedEntity? recentlyViewed;

/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailEntityCopyWith<_ProductDetailEntity> get copyWith => __$ProductDetailEntityCopyWithImpl<_ProductDetailEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetailEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._banners, _banners)&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._offersList, _offersList)&&(identical(other.recentlyViewed, recentlyViewed) || other.recentlyViewed == recentlyViewed));
}


@override
int get hashCode => Object.hash(runtimeType,action,message,const DeepCollectionEquality().hash(_banners),product,const DeepCollectionEquality().hash(_offersList),recentlyViewed);

@override
String toString() {
  return 'ProductDetailEntity(action: $action, message: $message, banners: $banners, product: $product, offersList: $offersList, recentlyViewed: $recentlyViewed)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailEntityCopyWith<$Res> implements $ProductDetailEntityCopyWith<$Res> {
  factory _$ProductDetailEntityCopyWith(_ProductDetailEntity value, $Res Function(_ProductDetailEntity) _then) = __$ProductDetailEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? message, List<BannerEntity> banners, ProductEntity? product, List<OfferEntity> offersList, RecentlyViewedEntity? recentlyViewed
});


@override $ProductEntityCopyWith<$Res>? get product;@override $RecentlyViewedEntityCopyWith<$Res>? get recentlyViewed;

}
/// @nodoc
class __$ProductDetailEntityCopyWithImpl<$Res>
    implements _$ProductDetailEntityCopyWith<$Res> {
  __$ProductDetailEntityCopyWithImpl(this._self, this._then);

  final _ProductDetailEntity _self;
  final $Res Function(_ProductDetailEntity) _then;

/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? message = freezed,Object? banners = null,Object? product = freezed,Object? offersList = null,Object? recentlyViewed = freezed,}) {
  return _then(_ProductDetailEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity?,offersList: null == offersList ? _self._offersList : offersList // ignore: cast_nullable_to_non_nullable
as List<OfferEntity>,recentlyViewed: freezed == recentlyViewed ? _self.recentlyViewed : recentlyViewed // ignore: cast_nullable_to_non_nullable
as RecentlyViewedEntity?,
  ));
}

/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductEntityCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetailEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedEntityCopyWith<$Res>? get recentlyViewed {
    if (_self.recentlyViewed == null) {
    return null;
  }

  return $RecentlyViewedEntityCopyWith<$Res>(_self.recentlyViewed!, (value) {
    return _then(_self.copyWith(recentlyViewed: value));
  });
}
}

// dart format on
