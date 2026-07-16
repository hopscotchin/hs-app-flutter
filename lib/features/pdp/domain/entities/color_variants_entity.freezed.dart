// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_variants_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ColorVariantEntity {

 int? get productId; String? get mediaUrl; bool get isSelected; bool get isStockAvailable;
/// Create a copy of ColorVariantEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorVariantEntityCopyWith<ColorVariantEntity> get copyWith => _$ColorVariantEntityCopyWithImpl<ColorVariantEntity>(this as ColorVariantEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorVariantEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isStockAvailable, isStockAvailable) || other.isStockAvailable == isStockAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,productId,mediaUrl,isSelected,isStockAvailable);

@override
String toString() {
  return 'ColorVariantEntity(productId: $productId, mediaUrl: $mediaUrl, isSelected: $isSelected, isStockAvailable: $isStockAvailable)';
}


}

/// @nodoc
abstract mixin class $ColorVariantEntityCopyWith<$Res>  {
  factory $ColorVariantEntityCopyWith(ColorVariantEntity value, $Res Function(ColorVariantEntity) _then) = _$ColorVariantEntityCopyWithImpl;
@useResult
$Res call({
 int? productId, String? mediaUrl, bool isSelected, bool isStockAvailable
});




}
/// @nodoc
class _$ColorVariantEntityCopyWithImpl<$Res>
    implements $ColorVariantEntityCopyWith<$Res> {
  _$ColorVariantEntityCopyWithImpl(this._self, this._then);

  final ColorVariantEntity _self;
  final $Res Function(ColorVariantEntity) _then;

/// Create a copy of ColorVariantEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = freezed,Object? mediaUrl = freezed,Object? isSelected = null,Object? isStockAvailable = null,}) {
  return _then(_self.copyWith(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isStockAvailable: null == isStockAvailable ? _self.isStockAvailable : isStockAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorVariantEntity].
extension ColorVariantEntityPatterns on ColorVariantEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorVariantEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorVariantEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorVariantEntity value)  $default,){
final _that = this;
switch (_that) {
case _ColorVariantEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorVariantEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ColorVariantEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? productId,  String? mediaUrl,  bool isSelected,  bool isStockAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorVariantEntity() when $default != null:
return $default(_that.productId,_that.mediaUrl,_that.isSelected,_that.isStockAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? productId,  String? mediaUrl,  bool isSelected,  bool isStockAvailable)  $default,) {final _that = this;
switch (_that) {
case _ColorVariantEntity():
return $default(_that.productId,_that.mediaUrl,_that.isSelected,_that.isStockAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? productId,  String? mediaUrl,  bool isSelected,  bool isStockAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ColorVariantEntity() when $default != null:
return $default(_that.productId,_that.mediaUrl,_that.isSelected,_that.isStockAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _ColorVariantEntity implements ColorVariantEntity {
  const _ColorVariantEntity({this.productId, this.mediaUrl, this.isSelected = false, this.isStockAvailable = false});
  

@override final  int? productId;
@override final  String? mediaUrl;
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool isStockAvailable;

/// Create a copy of ColorVariantEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorVariantEntityCopyWith<_ColorVariantEntity> get copyWith => __$ColorVariantEntityCopyWithImpl<_ColorVariantEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorVariantEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isStockAvailable, isStockAvailable) || other.isStockAvailable == isStockAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,productId,mediaUrl,isSelected,isStockAvailable);

@override
String toString() {
  return 'ColorVariantEntity(productId: $productId, mediaUrl: $mediaUrl, isSelected: $isSelected, isStockAvailable: $isStockAvailable)';
}


}

/// @nodoc
abstract mixin class _$ColorVariantEntityCopyWith<$Res> implements $ColorVariantEntityCopyWith<$Res> {
  factory _$ColorVariantEntityCopyWith(_ColorVariantEntity value, $Res Function(_ColorVariantEntity) _then) = __$ColorVariantEntityCopyWithImpl;
@override @useResult
$Res call({
 int? productId, String? mediaUrl, bool isSelected, bool isStockAvailable
});




}
/// @nodoc
class __$ColorVariantEntityCopyWithImpl<$Res>
    implements _$ColorVariantEntityCopyWith<$Res> {
  __$ColorVariantEntityCopyWithImpl(this._self, this._then);

  final _ColorVariantEntity _self;
  final $Res Function(_ColorVariantEntity) _then;

/// Create a copy of ColorVariantEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? mediaUrl = freezed,Object? isSelected = null,Object? isStockAvailable = null,}) {
  return _then(_ColorVariantEntity(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isStockAvailable: null == isStockAvailable ? _self.isStockAvailable : isStockAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
