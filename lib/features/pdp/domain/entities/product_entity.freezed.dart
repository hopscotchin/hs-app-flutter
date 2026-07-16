// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEntity {

 int? get id; String? get name; ProductPriceEntity? get priceInfo; bool get soldOut; List<MediaEntity> get media; List<SkuEntity> get skus; List<DetailEntity> get details; EddInfoEntity? get eddInfo; bool? get hasSizeChart; bool? get isServiceable; bool? get isEddDifferentForSKUs; bool? get isReturnInfoDifferentForSKUs; List<ServiceGuaranteeEntity> get serviceGuarantee; VisualCueEntity? get visualCue; List<ColorVariantEntity> get colorVariants; WishlistInfoEntity? get wishlistInfo; bool get isGift;
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<ProductEntity> get copyWith => _$ProductEntityCopyWithImpl<ProductEntity>(this as ProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&const DeepCollectionEquality().equals(other.media, media)&&const DeepCollectionEquality().equals(other.skus, skus)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&(identical(other.hasSizeChart, hasSizeChart) || other.hasSizeChart == hasSizeChart)&&(identical(other.isServiceable, isServiceable) || other.isServiceable == isServiceable)&&(identical(other.isEddDifferentForSKUs, isEddDifferentForSKUs) || other.isEddDifferentForSKUs == isEddDifferentForSKUs)&&(identical(other.isReturnInfoDifferentForSKUs, isReturnInfoDifferentForSKUs) || other.isReturnInfoDifferentForSKUs == isReturnInfoDifferentForSKUs)&&const DeepCollectionEquality().equals(other.serviceGuarantee, serviceGuarantee)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue)&&const DeepCollectionEquality().equals(other.colorVariants, colorVariants)&&(identical(other.wishlistInfo, wishlistInfo) || other.wishlistInfo == wishlistInfo)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceInfo,soldOut,const DeepCollectionEquality().hash(media),const DeepCollectionEquality().hash(skus),const DeepCollectionEquality().hash(details),eddInfo,hasSizeChart,isServiceable,isEddDifferentForSKUs,isReturnInfoDifferentForSKUs,const DeepCollectionEquality().hash(serviceGuarantee),visualCue,const DeepCollectionEquality().hash(colorVariants),wishlistInfo,isGift);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, priceInfo: $priceInfo, soldOut: $soldOut, media: $media, skus: $skus, details: $details, eddInfo: $eddInfo, hasSizeChart: $hasSizeChart, isServiceable: $isServiceable, isEddDifferentForSKUs: $isEddDifferentForSKUs, isReturnInfoDifferentForSKUs: $isReturnInfoDifferentForSKUs, serviceGuarantee: $serviceGuarantee, visualCue: $visualCue, colorVariants: $colorVariants, wishlistInfo: $wishlistInfo, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class $ProductEntityCopyWith<$Res>  {
  factory $ProductEntityCopyWith(ProductEntity value, $Res Function(ProductEntity) _then) = _$ProductEntityCopyWithImpl;
@useResult
$Res call({
 int? id, String? name, ProductPriceEntity? priceInfo, bool soldOut, List<MediaEntity> media, List<SkuEntity> skus, List<DetailEntity> details, EddInfoEntity? eddInfo, bool? hasSizeChart, bool? isServiceable, bool? isEddDifferentForSKUs, bool? isReturnInfoDifferentForSKUs, List<ServiceGuaranteeEntity> serviceGuarantee, VisualCueEntity? visualCue, List<ColorVariantEntity> colorVariants, WishlistInfoEntity? wishlistInfo, bool isGift
});


$ProductPriceEntityCopyWith<$Res>? get priceInfo;$EddInfoEntityCopyWith<$Res>? get eddInfo;$WishlistInfoEntityCopyWith<$Res>? get wishlistInfo;

}
/// @nodoc
class _$ProductEntityCopyWithImpl<$Res>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._self, this._then);

  final ProductEntity _self;
  final $Res Function(ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? priceInfo = freezed,Object? soldOut = null,Object? media = null,Object? skus = null,Object? details = null,Object? eddInfo = freezed,Object? hasSizeChart = freezed,Object? isServiceable = freezed,Object? isEddDifferentForSKUs = freezed,Object? isReturnInfoDifferentForSKUs = freezed,Object? serviceGuarantee = null,Object? visualCue = freezed,Object? colorVariants = null,Object? wishlistInfo = freezed,Object? isGift = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MediaEntity>,skus: null == skus ? _self.skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as List<DetailEntity>,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,hasSizeChart: freezed == hasSizeChart ? _self.hasSizeChart : hasSizeChart // ignore: cast_nullable_to_non_nullable
as bool?,isServiceable: freezed == isServiceable ? _self.isServiceable : isServiceable // ignore: cast_nullable_to_non_nullable
as bool?,isEddDifferentForSKUs: freezed == isEddDifferentForSKUs ? _self.isEddDifferentForSKUs : isEddDifferentForSKUs // ignore: cast_nullable_to_non_nullable
as bool?,isReturnInfoDifferentForSKUs: freezed == isReturnInfoDifferentForSKUs ? _self.isReturnInfoDifferentForSKUs : isReturnInfoDifferentForSKUs // ignore: cast_nullable_to_non_nullable
as bool?,serviceGuarantee: null == serviceGuarantee ? _self.serviceGuarantee : serviceGuarantee // ignore: cast_nullable_to_non_nullable
as List<ServiceGuaranteeEntity>,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,colorVariants: null == colorVariants ? _self.colorVariants : colorVariants // ignore: cast_nullable_to_non_nullable
as List<ColorVariantEntity>,wishlistInfo: freezed == wishlistInfo ? _self.wishlistInfo : wishlistInfo // ignore: cast_nullable_to_non_nullable
as WishlistInfoEntity?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get priceInfo {
    if (_self.priceInfo == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.priceInfo!, (value) {
    return _then(_self.copyWith(priceInfo: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EddInfoEntityCopyWith<$Res>? get eddInfo {
    if (_self.eddInfo == null) {
    return null;
  }

  return $EddInfoEntityCopyWith<$Res>(_self.eddInfo!, (value) {
    return _then(_self.copyWith(eddInfo: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistInfoEntityCopyWith<$Res>? get wishlistInfo {
    if (_self.wishlistInfo == null) {
    return null;
  }

  return $WishlistInfoEntityCopyWith<$Res>(_self.wishlistInfo!, (value) {
    return _then(_self.copyWith(wishlistInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductEntity].
extension ProductEntityPatterns on ProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name,  ProductPriceEntity? priceInfo,  bool soldOut,  List<MediaEntity> media,  List<SkuEntity> skus,  List<DetailEntity> details,  EddInfoEntity? eddInfo,  bool? hasSizeChart,  bool? isServiceable,  bool? isEddDifferentForSKUs,  bool? isReturnInfoDifferentForSKUs,  List<ServiceGuaranteeEntity> serviceGuarantee,  VisualCueEntity? visualCue,  List<ColorVariantEntity> colorVariants,  WishlistInfoEntity? wishlistInfo,  bool isGift)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.priceInfo,_that.soldOut,_that.media,_that.skus,_that.details,_that.eddInfo,_that.hasSizeChart,_that.isServiceable,_that.isEddDifferentForSKUs,_that.isReturnInfoDifferentForSKUs,_that.serviceGuarantee,_that.visualCue,_that.colorVariants,_that.wishlistInfo,_that.isGift);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name,  ProductPriceEntity? priceInfo,  bool soldOut,  List<MediaEntity> media,  List<SkuEntity> skus,  List<DetailEntity> details,  EddInfoEntity? eddInfo,  bool? hasSizeChart,  bool? isServiceable,  bool? isEddDifferentForSKUs,  bool? isReturnInfoDifferentForSKUs,  List<ServiceGuaranteeEntity> serviceGuarantee,  VisualCueEntity? visualCue,  List<ColorVariantEntity> colorVariants,  WishlistInfoEntity? wishlistInfo,  bool isGift)  $default,) {final _that = this;
switch (_that) {
case _ProductEntity():
return $default(_that.id,_that.name,_that.priceInfo,_that.soldOut,_that.media,_that.skus,_that.details,_that.eddInfo,_that.hasSizeChart,_that.isServiceable,_that.isEddDifferentForSKUs,_that.isReturnInfoDifferentForSKUs,_that.serviceGuarantee,_that.visualCue,_that.colorVariants,_that.wishlistInfo,_that.isGift);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name,  ProductPriceEntity? priceInfo,  bool soldOut,  List<MediaEntity> media,  List<SkuEntity> skus,  List<DetailEntity> details,  EddInfoEntity? eddInfo,  bool? hasSizeChart,  bool? isServiceable,  bool? isEddDifferentForSKUs,  bool? isReturnInfoDifferentForSKUs,  List<ServiceGuaranteeEntity> serviceGuarantee,  VisualCueEntity? visualCue,  List<ColorVariantEntity> colorVariants,  WishlistInfoEntity? wishlistInfo,  bool isGift)?  $default,) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.priceInfo,_that.soldOut,_that.media,_that.skus,_that.details,_that.eddInfo,_that.hasSizeChart,_that.isServiceable,_that.isEddDifferentForSKUs,_that.isReturnInfoDifferentForSKUs,_that.serviceGuarantee,_that.visualCue,_that.colorVariants,_that.wishlistInfo,_that.isGift);case _:
  return null;

}
}

}

/// @nodoc


class _ProductEntity implements ProductEntity {
  const _ProductEntity({this.id, this.name, this.priceInfo, this.soldOut = false, final  List<MediaEntity> media = const [], final  List<SkuEntity> skus = const [], final  List<DetailEntity> details = const [], this.eddInfo, this.hasSizeChart, this.isServiceable, this.isEddDifferentForSKUs, this.isReturnInfoDifferentForSKUs, final  List<ServiceGuaranteeEntity> serviceGuarantee = const [], this.visualCue, final  List<ColorVariantEntity> colorVariants = const [], this.wishlistInfo, this.isGift = false}): _media = media,_skus = skus,_details = details,_serviceGuarantee = serviceGuarantee,_colorVariants = colorVariants;
  

@override final  int? id;
@override final  String? name;
@override final  ProductPriceEntity? priceInfo;
@override@JsonKey() final  bool soldOut;
 final  List<MediaEntity> _media;
@override@JsonKey() List<MediaEntity> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

 final  List<SkuEntity> _skus;
@override@JsonKey() List<SkuEntity> get skus {
  if (_skus is EqualUnmodifiableListView) return _skus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skus);
}

 final  List<DetailEntity> _details;
@override@JsonKey() List<DetailEntity> get details {
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_details);
}

@override final  EddInfoEntity? eddInfo;
@override final  bool? hasSizeChart;
@override final  bool? isServiceable;
@override final  bool? isEddDifferentForSKUs;
@override final  bool? isReturnInfoDifferentForSKUs;
 final  List<ServiceGuaranteeEntity> _serviceGuarantee;
@override@JsonKey() List<ServiceGuaranteeEntity> get serviceGuarantee {
  if (_serviceGuarantee is EqualUnmodifiableListView) return _serviceGuarantee;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceGuarantee);
}

@override final  VisualCueEntity? visualCue;
 final  List<ColorVariantEntity> _colorVariants;
@override@JsonKey() List<ColorVariantEntity> get colorVariants {
  if (_colorVariants is EqualUnmodifiableListView) return _colorVariants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colorVariants);
}

@override final  WishlistInfoEntity? wishlistInfo;
@override@JsonKey() final  bool isGift;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEntityCopyWith<_ProductEntity> get copyWith => __$ProductEntityCopyWithImpl<_ProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&const DeepCollectionEquality().equals(other._media, _media)&&const DeepCollectionEquality().equals(other._skus, _skus)&&const DeepCollectionEquality().equals(other._details, _details)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&(identical(other.hasSizeChart, hasSizeChart) || other.hasSizeChart == hasSizeChart)&&(identical(other.isServiceable, isServiceable) || other.isServiceable == isServiceable)&&(identical(other.isEddDifferentForSKUs, isEddDifferentForSKUs) || other.isEddDifferentForSKUs == isEddDifferentForSKUs)&&(identical(other.isReturnInfoDifferentForSKUs, isReturnInfoDifferentForSKUs) || other.isReturnInfoDifferentForSKUs == isReturnInfoDifferentForSKUs)&&const DeepCollectionEquality().equals(other._serviceGuarantee, _serviceGuarantee)&&(identical(other.visualCue, visualCue) || other.visualCue == visualCue)&&const DeepCollectionEquality().equals(other._colorVariants, _colorVariants)&&(identical(other.wishlistInfo, wishlistInfo) || other.wishlistInfo == wishlistInfo)&&(identical(other.isGift, isGift) || other.isGift == isGift));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceInfo,soldOut,const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_skus),const DeepCollectionEquality().hash(_details),eddInfo,hasSizeChart,isServiceable,isEddDifferentForSKUs,isReturnInfoDifferentForSKUs,const DeepCollectionEquality().hash(_serviceGuarantee),visualCue,const DeepCollectionEquality().hash(_colorVariants),wishlistInfo,isGift);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, priceInfo: $priceInfo, soldOut: $soldOut, media: $media, skus: $skus, details: $details, eddInfo: $eddInfo, hasSizeChart: $hasSizeChart, isServiceable: $isServiceable, isEddDifferentForSKUs: $isEddDifferentForSKUs, isReturnInfoDifferentForSKUs: $isReturnInfoDifferentForSKUs, serviceGuarantee: $serviceGuarantee, visualCue: $visualCue, colorVariants: $colorVariants, wishlistInfo: $wishlistInfo, isGift: $isGift)';
}


}

/// @nodoc
abstract mixin class _$ProductEntityCopyWith<$Res> implements $ProductEntityCopyWith<$Res> {
  factory _$ProductEntityCopyWith(_ProductEntity value, $Res Function(_ProductEntity) _then) = __$ProductEntityCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name, ProductPriceEntity? priceInfo, bool soldOut, List<MediaEntity> media, List<SkuEntity> skus, List<DetailEntity> details, EddInfoEntity? eddInfo, bool? hasSizeChart, bool? isServiceable, bool? isEddDifferentForSKUs, bool? isReturnInfoDifferentForSKUs, List<ServiceGuaranteeEntity> serviceGuarantee, VisualCueEntity? visualCue, List<ColorVariantEntity> colorVariants, WishlistInfoEntity? wishlistInfo, bool isGift
});


@override $ProductPriceEntityCopyWith<$Res>? get priceInfo;@override $EddInfoEntityCopyWith<$Res>? get eddInfo;@override $WishlistInfoEntityCopyWith<$Res>? get wishlistInfo;

}
/// @nodoc
class __$ProductEntityCopyWithImpl<$Res>
    implements _$ProductEntityCopyWith<$Res> {
  __$ProductEntityCopyWithImpl(this._self, this._then);

  final _ProductEntity _self;
  final $Res Function(_ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? priceInfo = freezed,Object? soldOut = null,Object? media = null,Object? skus = null,Object? details = null,Object? eddInfo = freezed,Object? hasSizeChart = freezed,Object? isServiceable = freezed,Object? isEddDifferentForSKUs = freezed,Object? isReturnInfoDifferentForSKUs = freezed,Object? serviceGuarantee = null,Object? visualCue = freezed,Object? colorVariants = null,Object? wishlistInfo = freezed,Object? isGift = null,}) {
  return _then(_ProductEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaEntity>,skus: null == skus ? _self._skus : skus // ignore: cast_nullable_to_non_nullable
as List<SkuEntity>,details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<DetailEntity>,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,hasSizeChart: freezed == hasSizeChart ? _self.hasSizeChart : hasSizeChart // ignore: cast_nullable_to_non_nullable
as bool?,isServiceable: freezed == isServiceable ? _self.isServiceable : isServiceable // ignore: cast_nullable_to_non_nullable
as bool?,isEddDifferentForSKUs: freezed == isEddDifferentForSKUs ? _self.isEddDifferentForSKUs : isEddDifferentForSKUs // ignore: cast_nullable_to_non_nullable
as bool?,isReturnInfoDifferentForSKUs: freezed == isReturnInfoDifferentForSKUs ? _self.isReturnInfoDifferentForSKUs : isReturnInfoDifferentForSKUs // ignore: cast_nullable_to_non_nullable
as bool?,serviceGuarantee: null == serviceGuarantee ? _self._serviceGuarantee : serviceGuarantee // ignore: cast_nullable_to_non_nullable
as List<ServiceGuaranteeEntity>,visualCue: freezed == visualCue ? _self.visualCue : visualCue // ignore: cast_nullable_to_non_nullable
as VisualCueEntity?,colorVariants: null == colorVariants ? _self._colorVariants : colorVariants // ignore: cast_nullable_to_non_nullable
as List<ColorVariantEntity>,wishlistInfo: freezed == wishlistInfo ? _self.wishlistInfo : wishlistInfo // ignore: cast_nullable_to_non_nullable
as WishlistInfoEntity?,isGift: null == isGift ? _self.isGift : isGift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get priceInfo {
    if (_self.priceInfo == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.priceInfo!, (value) {
    return _then(_self.copyWith(priceInfo: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EddInfoEntityCopyWith<$Res>? get eddInfo {
    if (_self.eddInfo == null) {
    return null;
  }

  return $EddInfoEntityCopyWith<$Res>(_self.eddInfo!, (value) {
    return _then(_self.copyWith(eddInfo: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WishlistInfoEntityCopyWith<$Res>? get wishlistInfo {
    if (_self.wishlistInfo == null) {
    return null;
  }

  return $WishlistInfoEntityCopyWith<$Res>(_self.wishlistInfo!, (value) {
    return _then(_self.copyWith(wishlistInfo: value));
  });
}
}

// dart format on
