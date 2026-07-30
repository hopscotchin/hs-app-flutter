// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfferEntity {

/// Promo/coupon code, e.g. "10OFF".
 String? get couponCode;/// Bold headline text, e.g. "Get flat 10% off".
 String? get header;/// Body description, e.g. "Add this promo code to get flat 10% off upto ₹100".
 String? get description;/// Whether to show the coupon code chip.
 bool get displayCoupon;/// Whether the Copy button is active.
 bool get copyCoupon;
/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferEntityCopyWith<OfferEntity> get copyWith => _$OfferEntityCopyWithImpl<OfferEntity>(this as OfferEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferEntity&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.header, header) || other.header == header)&&(identical(other.description, description) || other.description == description)&&(identical(other.displayCoupon, displayCoupon) || other.displayCoupon == displayCoupon)&&(identical(other.copyCoupon, copyCoupon) || other.copyCoupon == copyCoupon));
}


@override
int get hashCode => Object.hash(runtimeType,couponCode,header,description,displayCoupon,copyCoupon);

@override
String toString() {
  return 'OfferEntity(couponCode: $couponCode, header: $header, description: $description, displayCoupon: $displayCoupon, copyCoupon: $copyCoupon)';
}


}

/// @nodoc
abstract mixin class $OfferEntityCopyWith<$Res>  {
  factory $OfferEntityCopyWith(OfferEntity value, $Res Function(OfferEntity) _then) = _$OfferEntityCopyWithImpl;
@useResult
$Res call({
 String? couponCode, String? header, String? description, bool displayCoupon, bool copyCoupon
});




}
/// @nodoc
class _$OfferEntityCopyWithImpl<$Res>
    implements $OfferEntityCopyWith<$Res> {
  _$OfferEntityCopyWithImpl(this._self, this._then);

  final OfferEntity _self;
  final $Res Function(OfferEntity) _then;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? couponCode = freezed,Object? header = freezed,Object? description = freezed,Object? displayCoupon = null,Object? copyCoupon = null,}) {
  return _then(_self.copyWith(
couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,displayCoupon: null == displayCoupon ? _self.displayCoupon : displayCoupon // ignore: cast_nullable_to_non_nullable
as bool,copyCoupon: null == copyCoupon ? _self.copyCoupon : copyCoupon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferEntity].
extension OfferEntityPatterns on OfferEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferEntity value)  $default,){
final _that = this;
switch (_that) {
case _OfferEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? couponCode,  String? header,  String? description,  bool displayCoupon,  bool copyCoupon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
return $default(_that.couponCode,_that.header,_that.description,_that.displayCoupon,_that.copyCoupon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? couponCode,  String? header,  String? description,  bool displayCoupon,  bool copyCoupon)  $default,) {final _that = this;
switch (_that) {
case _OfferEntity():
return $default(_that.couponCode,_that.header,_that.description,_that.displayCoupon,_that.copyCoupon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? couponCode,  String? header,  String? description,  bool displayCoupon,  bool copyCoupon)?  $default,) {final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
return $default(_that.couponCode,_that.header,_that.description,_that.displayCoupon,_that.copyCoupon);case _:
  return null;

}
}

}

/// @nodoc


class _OfferEntity implements OfferEntity {
  const _OfferEntity({this.couponCode, this.header, this.description, this.displayCoupon = true, this.copyCoupon = true});
  

/// Promo/coupon code, e.g. "10OFF".
@override final  String? couponCode;
/// Bold headline text, e.g. "Get flat 10% off".
@override final  String? header;
/// Body description, e.g. "Add this promo code to get flat 10% off upto ₹100".
@override final  String? description;
/// Whether to show the coupon code chip.
@override@JsonKey() final  bool displayCoupon;
/// Whether the Copy button is active.
@override@JsonKey() final  bool copyCoupon;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferEntityCopyWith<_OfferEntity> get copyWith => __$OfferEntityCopyWithImpl<_OfferEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferEntity&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.header, header) || other.header == header)&&(identical(other.description, description) || other.description == description)&&(identical(other.displayCoupon, displayCoupon) || other.displayCoupon == displayCoupon)&&(identical(other.copyCoupon, copyCoupon) || other.copyCoupon == copyCoupon));
}


@override
int get hashCode => Object.hash(runtimeType,couponCode,header,description,displayCoupon,copyCoupon);

@override
String toString() {
  return 'OfferEntity(couponCode: $couponCode, header: $header, description: $description, displayCoupon: $displayCoupon, copyCoupon: $copyCoupon)';
}


}

/// @nodoc
abstract mixin class _$OfferEntityCopyWith<$Res> implements $OfferEntityCopyWith<$Res> {
  factory _$OfferEntityCopyWith(_OfferEntity value, $Res Function(_OfferEntity) _then) = __$OfferEntityCopyWithImpl;
@override @useResult
$Res call({
 String? couponCode, String? header, String? description, bool displayCoupon, bool copyCoupon
});




}
/// @nodoc
class __$OfferEntityCopyWithImpl<$Res>
    implements _$OfferEntityCopyWith<$Res> {
  __$OfferEntityCopyWithImpl(this._self, this._then);

  final _OfferEntity _self;
  final $Res Function(_OfferEntity) _then;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? couponCode = freezed,Object? header = freezed,Object? description = freezed,Object? displayCoupon = null,Object? copyCoupon = null,}) {
  return _then(_OfferEntity(
couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,displayCoupon: null == displayCoupon ? _self.displayCoupon : displayCoupon // ignore: cast_nullable_to_non_nullable
as bool,copyCoupon: null == copyCoupon ? _self.copyCoupon : copyCoupon // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
