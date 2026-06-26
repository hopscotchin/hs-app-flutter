// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingProductEntity {

 int get id; String get name; String? get brandName; WishlistInfoEntity get wishlistInfo; int get quantity; bool get soldOut; bool get isXLTile; bool get isCPT; List<String> get imageUrls; ProductPriceEntity? get price; String? get colorVariants; String? get actionUri; List<VisualCueEntity> get visualCues; Map<String, dynamic>? get trackingMeta;
/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingProductEntityCopyWith<ListingProductEntity> get copyWith => _$ListingProductEntityCopyWithImpl<ListingProductEntity>(this as ListingProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.wishlistInfo, wishlistInfo) || other.wishlistInfo == wishlistInfo)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.isXLTile, isXLTile) || other.isXLTile == isXLTile)&&(identical(other.isCPT, isCPT) || other.isCPT == isCPT)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.price, price) || other.price == price)&&(identical(other.colorVariants, colorVariants) || other.colorVariants == colorVariants)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&const DeepCollectionEquality().equals(other.visualCues, visualCues)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,brandName,wishlistInfo,quantity,soldOut,isXLTile,isCPT,const DeepCollectionEquality().hash(imageUrls),price,colorVariants,actionUri,const DeepCollectionEquality().hash(visualCues),const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'ListingProductEntity(id: $id, name: $name, brandName: $brandName, wishlistInfo: $wishlistInfo, quantity: $quantity, soldOut: $soldOut, isXLTile: $isXLTile, isCPT: $isCPT, imageUrls: $imageUrls, price: $price, colorVariants: $colorVariants, actionUri: $actionUri, visualCues: $visualCues, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $ListingProductEntityCopyWith<$Res>  {
  factory $ListingProductEntityCopyWith(ListingProductEntity value, $Res Function(ListingProductEntity) _then) = _$ListingProductEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? brandName, WishlistInfoEntity wishlistInfo, int quantity, bool soldOut, bool isXLTile, bool isCPT, List<String> imageUrls, ProductPriceEntity? price, String? colorVariants, String? actionUri, List<VisualCueEntity> visualCues, Map<String, dynamic>? trackingMeta
});


$WishlistInfoEntityCopyWith<$Res> get wishlistInfo;$ProductPriceEntityCopyWith<$Res>? get price;

}
/// @nodoc
class _$ListingProductEntityCopyWithImpl<$Res>
    implements $ListingProductEntityCopyWith<$Res> {
  _$ListingProductEntityCopyWithImpl(this._self, this._then);

  final ListingProductEntity _self;
  final $Res Function(ListingProductEntity) _then;

/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brandName = freezed,Object? wishlistInfo = null,Object? quantity = null,Object? soldOut = null,Object? isXLTile = null,Object? isCPT = null,Object? imageUrls = null,Object? price = freezed,Object? colorVariants = freezed,Object? actionUri = freezed,Object? visualCues = null,Object? trackingMeta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,wishlistInfo: null == wishlistInfo ? _self.wishlistInfo : wishlistInfo // ignore: cast_nullable_to_non_nullable
as WishlistInfoEntity,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,isXLTile: null == isXLTile ? _self.isXLTile : isXLTile // ignore: cast_nullable_to_non_nullable
as bool,isCPT: null == isCPT ? _self.isCPT : isCPT // ignore: cast_nullable_to_non_nullable
as bool,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,colorVariants: freezed == colorVariants ? _self.colorVariants : colorVariants // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,visualCues: null == visualCues ? _self.visualCues : visualCues // ignore: cast_nullable_to_non_nullable
as List<VisualCueEntity>,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistInfoEntityCopyWith<$Res> get wishlistInfo {
  
  return $WishlistInfoEntityCopyWith<$Res>(_self.wishlistInfo, (value) {
    return _then(_self.copyWith(wishlistInfo: value));
  });
}/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListingProductEntity].
extension ListingProductEntityPatterns on ListingProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ListingProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ListingProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? brandName,  WishlistInfoEntity wishlistInfo,  int quantity,  bool soldOut,  bool isXLTile,  bool isCPT,  List<String> imageUrls,  ProductPriceEntity? price,  String? colorVariants,  String? actionUri,  List<VisualCueEntity> visualCues,  Map<String, dynamic>? trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.brandName,_that.wishlistInfo,_that.quantity,_that.soldOut,_that.isXLTile,_that.isCPT,_that.imageUrls,_that.price,_that.colorVariants,_that.actionUri,_that.visualCues,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? brandName,  WishlistInfoEntity wishlistInfo,  int quantity,  bool soldOut,  bool isXLTile,  bool isCPT,  List<String> imageUrls,  ProductPriceEntity? price,  String? colorVariants,  String? actionUri,  List<VisualCueEntity> visualCues,  Map<String, dynamic>? trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _ListingProductEntity():
return $default(_that.id,_that.name,_that.brandName,_that.wishlistInfo,_that.quantity,_that.soldOut,_that.isXLTile,_that.isCPT,_that.imageUrls,_that.price,_that.colorVariants,_that.actionUri,_that.visualCues,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? brandName,  WishlistInfoEntity wishlistInfo,  int quantity,  bool soldOut,  bool isXLTile,  bool isCPT,  List<String> imageUrls,  ProductPriceEntity? price,  String? colorVariants,  String? actionUri,  List<VisualCueEntity> visualCues,  Map<String, dynamic>? trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _ListingProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.brandName,_that.wishlistInfo,_that.quantity,_that.soldOut,_that.isXLTile,_that.isCPT,_that.imageUrls,_that.price,_that.colorVariants,_that.actionUri,_that.visualCues,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _ListingProductEntity implements ListingProductEntity {
  const _ListingProductEntity({required this.id, required this.name, this.brandName, this.wishlistInfo = const WishlistInfoEntity(), this.quantity = 0, this.soldOut = false, this.isXLTile = false, this.isCPT = false, final  List<String> imageUrls = const [], this.price, this.colorVariants, this.actionUri, final  List<VisualCueEntity> visualCues = const [], final  Map<String, dynamic>? trackingMeta}): _imageUrls = imageUrls,_visualCues = visualCues,_trackingMeta = trackingMeta;
  

@override final  int id;
@override final  String name;
@override final  String? brandName;
@override@JsonKey() final  WishlistInfoEntity wishlistInfo;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  bool soldOut;
@override@JsonKey() final  bool isXLTile;
@override@JsonKey() final  bool isCPT;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  ProductPriceEntity? price;
@override final  String? colorVariants;
@override final  String? actionUri;
 final  List<VisualCueEntity> _visualCues;
@override@JsonKey() List<VisualCueEntity> get visualCues {
  if (_visualCues is EqualUnmodifiableListView) return _visualCues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visualCues);
}

 final  Map<String, dynamic>? _trackingMeta;
@override Map<String, dynamic>? get trackingMeta {
  final value = _trackingMeta;
  if (value == null) return null;
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingProductEntityCopyWith<_ListingProductEntity> get copyWith => __$ListingProductEntityCopyWithImpl<_ListingProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.wishlistInfo, wishlistInfo) || other.wishlistInfo == wishlistInfo)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.isXLTile, isXLTile) || other.isXLTile == isXLTile)&&(identical(other.isCPT, isCPT) || other.isCPT == isCPT)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.price, price) || other.price == price)&&(identical(other.colorVariants, colorVariants) || other.colorVariants == colorVariants)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&const DeepCollectionEquality().equals(other._visualCues, _visualCues)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,brandName,wishlistInfo,quantity,soldOut,isXLTile,isCPT,const DeepCollectionEquality().hash(_imageUrls),price,colorVariants,actionUri,const DeepCollectionEquality().hash(_visualCues),const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'ListingProductEntity(id: $id, name: $name, brandName: $brandName, wishlistInfo: $wishlistInfo, quantity: $quantity, soldOut: $soldOut, isXLTile: $isXLTile, isCPT: $isCPT, imageUrls: $imageUrls, price: $price, colorVariants: $colorVariants, actionUri: $actionUri, visualCues: $visualCues, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$ListingProductEntityCopyWith<$Res> implements $ListingProductEntityCopyWith<$Res> {
  factory _$ListingProductEntityCopyWith(_ListingProductEntity value, $Res Function(_ListingProductEntity) _then) = __$ListingProductEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? brandName, WishlistInfoEntity wishlistInfo, int quantity, bool soldOut, bool isXLTile, bool isCPT, List<String> imageUrls, ProductPriceEntity? price, String? colorVariants, String? actionUri, List<VisualCueEntity> visualCues, Map<String, dynamic>? trackingMeta
});


@override $WishlistInfoEntityCopyWith<$Res> get wishlistInfo;@override $ProductPriceEntityCopyWith<$Res>? get price;

}
/// @nodoc
class __$ListingProductEntityCopyWithImpl<$Res>
    implements _$ListingProductEntityCopyWith<$Res> {
  __$ListingProductEntityCopyWithImpl(this._self, this._then);

  final _ListingProductEntity _self;
  final $Res Function(_ListingProductEntity) _then;

/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brandName = freezed,Object? wishlistInfo = null,Object? quantity = null,Object? soldOut = null,Object? isXLTile = null,Object? isCPT = null,Object? imageUrls = null,Object? price = freezed,Object? colorVariants = freezed,Object? actionUri = freezed,Object? visualCues = null,Object? trackingMeta = freezed,}) {
  return _then(_ListingProductEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,wishlistInfo: null == wishlistInfo ? _self.wishlistInfo : wishlistInfo // ignore: cast_nullable_to_non_nullable
as WishlistInfoEntity,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,isXLTile: null == isXLTile ? _self.isXLTile : isXLTile // ignore: cast_nullable_to_non_nullable
as bool,isCPT: null == isCPT ? _self.isCPT : isCPT // ignore: cast_nullable_to_non_nullable
as bool,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,colorVariants: freezed == colorVariants ? _self.colorVariants : colorVariants // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,visualCues: null == visualCues ? _self._visualCues : visualCues // ignore: cast_nullable_to_non_nullable
as List<VisualCueEntity>,trackingMeta: freezed == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistInfoEntityCopyWith<$Res> get wishlistInfo {
  
  return $WishlistInfoEntityCopyWith<$Res>(_self.wishlistInfo, (value) {
    return _then(_self.copyWith(wishlistInfo: value));
  });
}/// Create a copy of ListingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}

// dart format on
