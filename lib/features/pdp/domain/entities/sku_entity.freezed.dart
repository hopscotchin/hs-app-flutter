// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sku_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SkuEntity {

 String? get skuId; String? get title; String? get subTitle; ProductPriceEntity? get priceInfo; bool? get enable; EddInfoEntity? get eddInfo; WarningEntity? get info; bool get isSelected; bool get isAddedToBag;/// Raw key→value map from API (e.g. {"skuMrp": "₹1,149"}).
/// Used to resolve `skuValue` type detail items via fieldPath.
 Map<String, dynamic>? get skuAttributes;
/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkuEntityCopyWith<SkuEntity> get copyWith => _$SkuEntityCopyWithImpl<SkuEntity>(this as SkuEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkuEntity&&(identical(other.skuId, skuId) || other.skuId == skuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&(identical(other.info, info) || other.info == info)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isAddedToBag, isAddedToBag) || other.isAddedToBag == isAddedToBag)&&const DeepCollectionEquality().equals(other.skuAttributes, skuAttributes));
}


@override
int get hashCode => Object.hash(runtimeType,skuId,title,subTitle,priceInfo,enable,eddInfo,info,isSelected,isAddedToBag,const DeepCollectionEquality().hash(skuAttributes));

@override
String toString() {
  return 'SkuEntity(skuId: $skuId, title: $title, subTitle: $subTitle, priceInfo: $priceInfo, enable: $enable, eddInfo: $eddInfo, info: $info, isSelected: $isSelected, isAddedToBag: $isAddedToBag, skuAttributes: $skuAttributes)';
}


}

/// @nodoc
abstract mixin class $SkuEntityCopyWith<$Res>  {
  factory $SkuEntityCopyWith(SkuEntity value, $Res Function(SkuEntity) _then) = _$SkuEntityCopyWithImpl;
@useResult
$Res call({
 String? skuId, String? title, String? subTitle, ProductPriceEntity? priceInfo, bool? enable, EddInfoEntity? eddInfo, WarningEntity? info, bool isSelected, bool isAddedToBag, Map<String, dynamic>? skuAttributes
});


$ProductPriceEntityCopyWith<$Res>? get priceInfo;$EddInfoEntityCopyWith<$Res>? get eddInfo;$WarningEntityCopyWith<$Res>? get info;

}
/// @nodoc
class _$SkuEntityCopyWithImpl<$Res>
    implements $SkuEntityCopyWith<$Res> {
  _$SkuEntityCopyWithImpl(this._self, this._then);

  final SkuEntity _self;
  final $Res Function(SkuEntity) _then;

/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? skuId = freezed,Object? title = freezed,Object? subTitle = freezed,Object? priceInfo = freezed,Object? enable = freezed,Object? eddInfo = freezed,Object? info = freezed,Object? isSelected = null,Object? isAddedToBag = null,Object? skuAttributes = freezed,}) {
  return _then(_self.copyWith(
skuId: freezed == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,enable: freezed == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool?,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as WarningEntity?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isAddedToBag: null == isAddedToBag ? _self.isAddedToBag : isAddedToBag // ignore: cast_nullable_to_non_nullable
as bool,skuAttributes: freezed == skuAttributes ? _self.skuAttributes : skuAttributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of SkuEntity
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
}/// Create a copy of SkuEntity
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
}/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarningEntityCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $WarningEntityCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}


/// Adds pattern-matching-related methods to [SkuEntity].
extension SkuEntityPatterns on SkuEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkuEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkuEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkuEntity value)  $default,){
final _that = this;
switch (_that) {
case _SkuEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkuEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SkuEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? skuId,  String? title,  String? subTitle,  ProductPriceEntity? priceInfo,  bool? enable,  EddInfoEntity? eddInfo,  WarningEntity? info,  bool isSelected,  bool isAddedToBag,  Map<String, dynamic>? skuAttributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkuEntity() when $default != null:
return $default(_that.skuId,_that.title,_that.subTitle,_that.priceInfo,_that.enable,_that.eddInfo,_that.info,_that.isSelected,_that.isAddedToBag,_that.skuAttributes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? skuId,  String? title,  String? subTitle,  ProductPriceEntity? priceInfo,  bool? enable,  EddInfoEntity? eddInfo,  WarningEntity? info,  bool isSelected,  bool isAddedToBag,  Map<String, dynamic>? skuAttributes)  $default,) {final _that = this;
switch (_that) {
case _SkuEntity():
return $default(_that.skuId,_that.title,_that.subTitle,_that.priceInfo,_that.enable,_that.eddInfo,_that.info,_that.isSelected,_that.isAddedToBag,_that.skuAttributes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? skuId,  String? title,  String? subTitle,  ProductPriceEntity? priceInfo,  bool? enable,  EddInfoEntity? eddInfo,  WarningEntity? info,  bool isSelected,  bool isAddedToBag,  Map<String, dynamic>? skuAttributes)?  $default,) {final _that = this;
switch (_that) {
case _SkuEntity() when $default != null:
return $default(_that.skuId,_that.title,_that.subTitle,_that.priceInfo,_that.enable,_that.eddInfo,_that.info,_that.isSelected,_that.isAddedToBag,_that.skuAttributes);case _:
  return null;

}
}

}

/// @nodoc


class _SkuEntity implements SkuEntity {
  const _SkuEntity({this.skuId, this.title, this.subTitle, this.priceInfo, this.enable, this.eddInfo, this.info, this.isSelected = false, this.isAddedToBag = false, final  Map<String, dynamic>? skuAttributes}): _skuAttributes = skuAttributes;
  

@override final  String? skuId;
@override final  String? title;
@override final  String? subTitle;
@override final  ProductPriceEntity? priceInfo;
@override final  bool? enable;
@override final  EddInfoEntity? eddInfo;
@override final  WarningEntity? info;
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool isAddedToBag;
/// Raw key→value map from API (e.g. {"skuMrp": "₹1,149"}).
/// Used to resolve `skuValue` type detail items via fieldPath.
 final  Map<String, dynamic>? _skuAttributes;
/// Raw key→value map from API (e.g. {"skuMrp": "₹1,149"}).
/// Used to resolve `skuValue` type detail items via fieldPath.
@override Map<String, dynamic>? get skuAttributes {
  final value = _skuAttributes;
  if (value == null) return null;
  if (_skuAttributes is EqualUnmodifiableMapView) return _skuAttributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkuEntityCopyWith<_SkuEntity> get copyWith => __$SkuEntityCopyWithImpl<_SkuEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkuEntity&&(identical(other.skuId, skuId) || other.skuId == skuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.eddInfo, eddInfo) || other.eddInfo == eddInfo)&&(identical(other.info, info) || other.info == info)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isAddedToBag, isAddedToBag) || other.isAddedToBag == isAddedToBag)&&const DeepCollectionEquality().equals(other._skuAttributes, _skuAttributes));
}


@override
int get hashCode => Object.hash(runtimeType,skuId,title,subTitle,priceInfo,enable,eddInfo,info,isSelected,isAddedToBag,const DeepCollectionEquality().hash(_skuAttributes));

@override
String toString() {
  return 'SkuEntity(skuId: $skuId, title: $title, subTitle: $subTitle, priceInfo: $priceInfo, enable: $enable, eddInfo: $eddInfo, info: $info, isSelected: $isSelected, isAddedToBag: $isAddedToBag, skuAttributes: $skuAttributes)';
}


}

/// @nodoc
abstract mixin class _$SkuEntityCopyWith<$Res> implements $SkuEntityCopyWith<$Res> {
  factory _$SkuEntityCopyWith(_SkuEntity value, $Res Function(_SkuEntity) _then) = __$SkuEntityCopyWithImpl;
@override @useResult
$Res call({
 String? skuId, String? title, String? subTitle, ProductPriceEntity? priceInfo, bool? enable, EddInfoEntity? eddInfo, WarningEntity? info, bool isSelected, bool isAddedToBag, Map<String, dynamic>? skuAttributes
});


@override $ProductPriceEntityCopyWith<$Res>? get priceInfo;@override $EddInfoEntityCopyWith<$Res>? get eddInfo;@override $WarningEntityCopyWith<$Res>? get info;

}
/// @nodoc
class __$SkuEntityCopyWithImpl<$Res>
    implements _$SkuEntityCopyWith<$Res> {
  __$SkuEntityCopyWithImpl(this._self, this._then);

  final _SkuEntity _self;
  final $Res Function(_SkuEntity) _then;

/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? skuId = freezed,Object? title = freezed,Object? subTitle = freezed,Object? priceInfo = freezed,Object? enable = freezed,Object? eddInfo = freezed,Object? info = freezed,Object? isSelected = null,Object? isAddedToBag = null,Object? skuAttributes = freezed,}) {
  return _then(_SkuEntity(
skuId: freezed == skuId ? _self.skuId : skuId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subTitle: freezed == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,enable: freezed == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool?,eddInfo: freezed == eddInfo ? _self.eddInfo : eddInfo // ignore: cast_nullable_to_non_nullable
as EddInfoEntity?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as WarningEntity?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isAddedToBag: null == isAddedToBag ? _self.isAddedToBag : isAddedToBag // ignore: cast_nullable_to_non_nullable
as bool,skuAttributes: freezed == skuAttributes ? _self._skuAttributes : skuAttributes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of SkuEntity
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
}/// Create a copy of SkuEntity
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
}/// Create a copy of SkuEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarningEntityCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $WarningEntityCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

// dart format on
