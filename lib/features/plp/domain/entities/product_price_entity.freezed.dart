// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_price_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductPriceEntity {

 String? get sellingPrice; String? get mrp; String? get discountLabel; double? get absoluteValue; String? get callout;
/// Create a copy of ProductPriceEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<ProductPriceEntity> get copyWith => _$ProductPriceEntityCopyWithImpl<ProductPriceEntity>(this as ProductPriceEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductPriceEntity&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.discountLabel, discountLabel) || other.discountLabel == discountLabel)&&(identical(other.absoluteValue, absoluteValue) || other.absoluteValue == absoluteValue)&&(identical(other.callout, callout) || other.callout == callout));
}


@override
int get hashCode => Object.hash(runtimeType,sellingPrice,mrp,discountLabel,absoluteValue,callout);

@override
String toString() {
  return 'ProductPriceEntity(sellingPrice: $sellingPrice, mrp: $mrp, discountLabel: $discountLabel, absoluteValue: $absoluteValue, callout: $callout)';
}


}

/// @nodoc
abstract mixin class $ProductPriceEntityCopyWith<$Res>  {
  factory $ProductPriceEntityCopyWith(ProductPriceEntity value, $Res Function(ProductPriceEntity) _then) = _$ProductPriceEntityCopyWithImpl;
@useResult
$Res call({
 String? sellingPrice, String? mrp, String? discountLabel, double? absoluteValue, String? callout
});




}
/// @nodoc
class _$ProductPriceEntityCopyWithImpl<$Res>
    implements $ProductPriceEntityCopyWith<$Res> {
  _$ProductPriceEntityCopyWithImpl(this._self, this._then);

  final ProductPriceEntity _self;
  final $Res Function(ProductPriceEntity) _then;

/// Create a copy of ProductPriceEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sellingPrice = freezed,Object? mrp = freezed,Object? discountLabel = freezed,Object? absoluteValue = freezed,Object? callout = freezed,}) {
  return _then(_self.copyWith(
sellingPrice: freezed == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String?,mrp: freezed == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as String?,discountLabel: freezed == discountLabel ? _self.discountLabel : discountLabel // ignore: cast_nullable_to_non_nullable
as String?,absoluteValue: freezed == absoluteValue ? _self.absoluteValue : absoluteValue // ignore: cast_nullable_to_non_nullable
as double?,callout: freezed == callout ? _self.callout : callout // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductPriceEntity].
extension ProductPriceEntityPatterns on ProductPriceEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductPriceEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductPriceEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductPriceEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductPriceEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductPriceEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductPriceEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sellingPrice,  String? mrp,  String? discountLabel,  double? absoluteValue,  String? callout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductPriceEntity() when $default != null:
return $default(_that.sellingPrice,_that.mrp,_that.discountLabel,_that.absoluteValue,_that.callout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sellingPrice,  String? mrp,  String? discountLabel,  double? absoluteValue,  String? callout)  $default,) {final _that = this;
switch (_that) {
case _ProductPriceEntity():
return $default(_that.sellingPrice,_that.mrp,_that.discountLabel,_that.absoluteValue,_that.callout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sellingPrice,  String? mrp,  String? discountLabel,  double? absoluteValue,  String? callout)?  $default,) {final _that = this;
switch (_that) {
case _ProductPriceEntity() when $default != null:
return $default(_that.sellingPrice,_that.mrp,_that.discountLabel,_that.absoluteValue,_that.callout);case _:
  return null;

}
}

}

/// @nodoc


class _ProductPriceEntity implements ProductPriceEntity {
  const _ProductPriceEntity({this.sellingPrice, this.mrp, this.discountLabel, this.absoluteValue, this.callout});
  

@override final  String? sellingPrice;
@override final  String? mrp;
@override final  String? discountLabel;
@override final  double? absoluteValue;
@override final  String? callout;

/// Create a copy of ProductPriceEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductPriceEntityCopyWith<_ProductPriceEntity> get copyWith => __$ProductPriceEntityCopyWithImpl<_ProductPriceEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductPriceEntity&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.discountLabel, discountLabel) || other.discountLabel == discountLabel)&&(identical(other.absoluteValue, absoluteValue) || other.absoluteValue == absoluteValue)&&(identical(other.callout, callout) || other.callout == callout));
}


@override
int get hashCode => Object.hash(runtimeType,sellingPrice,mrp,discountLabel,absoluteValue,callout);

@override
String toString() {
  return 'ProductPriceEntity(sellingPrice: $sellingPrice, mrp: $mrp, discountLabel: $discountLabel, absoluteValue: $absoluteValue, callout: $callout)';
}


}

/// @nodoc
abstract mixin class _$ProductPriceEntityCopyWith<$Res> implements $ProductPriceEntityCopyWith<$Res> {
  factory _$ProductPriceEntityCopyWith(_ProductPriceEntity value, $Res Function(_ProductPriceEntity) _then) = __$ProductPriceEntityCopyWithImpl;
@override @useResult
$Res call({
 String? sellingPrice, String? mrp, String? discountLabel, double? absoluteValue, String? callout
});




}
/// @nodoc
class __$ProductPriceEntityCopyWithImpl<$Res>
    implements _$ProductPriceEntityCopyWith<$Res> {
  __$ProductPriceEntityCopyWithImpl(this._self, this._then);

  final _ProductPriceEntity _self;
  final $Res Function(_ProductPriceEntity) _then;

/// Create a copy of ProductPriceEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellingPrice = freezed,Object? mrp = freezed,Object? discountLabel = freezed,Object? absoluteValue = freezed,Object? callout = freezed,}) {
  return _then(_ProductPriceEntity(
sellingPrice: freezed == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String?,mrp: freezed == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as String?,discountLabel: freezed == discountLabel ? _self.discountLabel : discountLabel // ignore: cast_nullable_to_non_nullable
as String?,absoluteValue: freezed == absoluteValue ? _self.absoluteValue : absoluteValue // ignore: cast_nullable_to_non_nullable
as double?,callout: freezed == callout ? _self.callout : callout // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
