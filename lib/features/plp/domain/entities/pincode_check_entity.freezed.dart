// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_check_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PincodeCheckEntity {

 bool get serviceable; bool get codAvailable; String? get edd; String? get eddPrefix; String? get eddSuffix; String? get eddSecondaryMsg; String? get eddColor; String? get eddTextColor; String? get noPinCodeMessage;
/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeCheckEntityCopyWith<PincodeCheckEntity> get copyWith => _$PincodeCheckEntityCopyWithImpl<PincodeCheckEntity>(this as PincodeCheckEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeCheckEntity&&(identical(other.serviceable, serviceable) || other.serviceable == serviceable)&&(identical(other.codAvailable, codAvailable) || other.codAvailable == codAvailable)&&(identical(other.edd, edd) || other.edd == edd)&&(identical(other.eddPrefix, eddPrefix) || other.eddPrefix == eddPrefix)&&(identical(other.eddSuffix, eddSuffix) || other.eddSuffix == eddSuffix)&&(identical(other.eddSecondaryMsg, eddSecondaryMsg) || other.eddSecondaryMsg == eddSecondaryMsg)&&(identical(other.eddColor, eddColor) || other.eddColor == eddColor)&&(identical(other.eddTextColor, eddTextColor) || other.eddTextColor == eddTextColor)&&(identical(other.noPinCodeMessage, noPinCodeMessage) || other.noPinCodeMessage == noPinCodeMessage));
}


@override
int get hashCode => Object.hash(runtimeType,serviceable,codAvailable,edd,eddPrefix,eddSuffix,eddSecondaryMsg,eddColor,eddTextColor,noPinCodeMessage);

@override
String toString() {
  return 'PincodeCheckEntity(serviceable: $serviceable, codAvailable: $codAvailable, edd: $edd, eddPrefix: $eddPrefix, eddSuffix: $eddSuffix, eddSecondaryMsg: $eddSecondaryMsg, eddColor: $eddColor, eddTextColor: $eddTextColor, noPinCodeMessage: $noPinCodeMessage)';
}


}

/// @nodoc
abstract mixin class $PincodeCheckEntityCopyWith<$Res>  {
  factory $PincodeCheckEntityCopyWith(PincodeCheckEntity value, $Res Function(PincodeCheckEntity) _then) = _$PincodeCheckEntityCopyWithImpl;
@useResult
$Res call({
 bool serviceable, bool codAvailable, String? edd, String? eddPrefix, String? eddSuffix, String? eddSecondaryMsg, String? eddColor, String? eddTextColor, String? noPinCodeMessage
});




}
/// @nodoc
class _$PincodeCheckEntityCopyWithImpl<$Res>
    implements $PincodeCheckEntityCopyWith<$Res> {
  _$PincodeCheckEntityCopyWithImpl(this._self, this._then);

  final PincodeCheckEntity _self;
  final $Res Function(PincodeCheckEntity) _then;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceable = null,Object? codAvailable = null,Object? edd = freezed,Object? eddPrefix = freezed,Object? eddSuffix = freezed,Object? eddSecondaryMsg = freezed,Object? eddColor = freezed,Object? eddTextColor = freezed,Object? noPinCodeMessage = freezed,}) {
  return _then(_self.copyWith(
serviceable: null == serviceable ? _self.serviceable : serviceable // ignore: cast_nullable_to_non_nullable
as bool,codAvailable: null == codAvailable ? _self.codAvailable : codAvailable // ignore: cast_nullable_to_non_nullable
as bool,edd: freezed == edd ? _self.edd : edd // ignore: cast_nullable_to_non_nullable
as String?,eddPrefix: freezed == eddPrefix ? _self.eddPrefix : eddPrefix // ignore: cast_nullable_to_non_nullable
as String?,eddSuffix: freezed == eddSuffix ? _self.eddSuffix : eddSuffix // ignore: cast_nullable_to_non_nullable
as String?,eddSecondaryMsg: freezed == eddSecondaryMsg ? _self.eddSecondaryMsg : eddSecondaryMsg // ignore: cast_nullable_to_non_nullable
as String?,eddColor: freezed == eddColor ? _self.eddColor : eddColor // ignore: cast_nullable_to_non_nullable
as String?,eddTextColor: freezed == eddTextColor ? _self.eddTextColor : eddTextColor // ignore: cast_nullable_to_non_nullable
as String?,noPinCodeMessage: freezed == noPinCodeMessage ? _self.noPinCodeMessage : noPinCodeMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PincodeCheckEntity].
extension PincodeCheckEntityPatterns on PincodeCheckEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PincodeCheckEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PincodeCheckEntity value)  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PincodeCheckEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool serviceable,  bool codAvailable,  String? edd,  String? eddPrefix,  String? eddSuffix,  String? eddSecondaryMsg,  String? eddColor,  String? eddTextColor,  String? noPinCodeMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
return $default(_that.serviceable,_that.codAvailable,_that.edd,_that.eddPrefix,_that.eddSuffix,_that.eddSecondaryMsg,_that.eddColor,_that.eddTextColor,_that.noPinCodeMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool serviceable,  bool codAvailable,  String? edd,  String? eddPrefix,  String? eddSuffix,  String? eddSecondaryMsg,  String? eddColor,  String? eddTextColor,  String? noPinCodeMessage)  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckEntity():
return $default(_that.serviceable,_that.codAvailable,_that.edd,_that.eddPrefix,_that.eddSuffix,_that.eddSecondaryMsg,_that.eddColor,_that.eddTextColor,_that.noPinCodeMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool serviceable,  bool codAvailable,  String? edd,  String? eddPrefix,  String? eddSuffix,  String? eddSecondaryMsg,  String? eddColor,  String? eddTextColor,  String? noPinCodeMessage)?  $default,) {final _that = this;
switch (_that) {
case _PincodeCheckEntity() when $default != null:
return $default(_that.serviceable,_that.codAvailable,_that.edd,_that.eddPrefix,_that.eddSuffix,_that.eddSecondaryMsg,_that.eddColor,_that.eddTextColor,_that.noPinCodeMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PincodeCheckEntity implements PincodeCheckEntity {
  const _PincodeCheckEntity({this.serviceable = false, this.codAvailable = false, this.edd, this.eddPrefix, this.eddSuffix, this.eddSecondaryMsg, this.eddColor, this.eddTextColor, this.noPinCodeMessage});
  

@override@JsonKey() final  bool serviceable;
@override@JsonKey() final  bool codAvailable;
@override final  String? edd;
@override final  String? eddPrefix;
@override final  String? eddSuffix;
@override final  String? eddSecondaryMsg;
@override final  String? eddColor;
@override final  String? eddTextColor;
@override final  String? noPinCodeMessage;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PincodeCheckEntityCopyWith<_PincodeCheckEntity> get copyWith => __$PincodeCheckEntityCopyWithImpl<_PincodeCheckEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PincodeCheckEntity&&(identical(other.serviceable, serviceable) || other.serviceable == serviceable)&&(identical(other.codAvailable, codAvailable) || other.codAvailable == codAvailable)&&(identical(other.edd, edd) || other.edd == edd)&&(identical(other.eddPrefix, eddPrefix) || other.eddPrefix == eddPrefix)&&(identical(other.eddSuffix, eddSuffix) || other.eddSuffix == eddSuffix)&&(identical(other.eddSecondaryMsg, eddSecondaryMsg) || other.eddSecondaryMsg == eddSecondaryMsg)&&(identical(other.eddColor, eddColor) || other.eddColor == eddColor)&&(identical(other.eddTextColor, eddTextColor) || other.eddTextColor == eddTextColor)&&(identical(other.noPinCodeMessage, noPinCodeMessage) || other.noPinCodeMessage == noPinCodeMessage));
}


@override
int get hashCode => Object.hash(runtimeType,serviceable,codAvailable,edd,eddPrefix,eddSuffix,eddSecondaryMsg,eddColor,eddTextColor,noPinCodeMessage);

@override
String toString() {
  return 'PincodeCheckEntity(serviceable: $serviceable, codAvailable: $codAvailable, edd: $edd, eddPrefix: $eddPrefix, eddSuffix: $eddSuffix, eddSecondaryMsg: $eddSecondaryMsg, eddColor: $eddColor, eddTextColor: $eddTextColor, noPinCodeMessage: $noPinCodeMessage)';
}


}

/// @nodoc
abstract mixin class _$PincodeCheckEntityCopyWith<$Res> implements $PincodeCheckEntityCopyWith<$Res> {
  factory _$PincodeCheckEntityCopyWith(_PincodeCheckEntity value, $Res Function(_PincodeCheckEntity) _then) = __$PincodeCheckEntityCopyWithImpl;
@override @useResult
$Res call({
 bool serviceable, bool codAvailable, String? edd, String? eddPrefix, String? eddSuffix, String? eddSecondaryMsg, String? eddColor, String? eddTextColor, String? noPinCodeMessage
});




}
/// @nodoc
class __$PincodeCheckEntityCopyWithImpl<$Res>
    implements _$PincodeCheckEntityCopyWith<$Res> {
  __$PincodeCheckEntityCopyWithImpl(this._self, this._then);

  final _PincodeCheckEntity _self;
  final $Res Function(_PincodeCheckEntity) _then;

/// Create a copy of PincodeCheckEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceable = null,Object? codAvailable = null,Object? edd = freezed,Object? eddPrefix = freezed,Object? eddSuffix = freezed,Object? eddSecondaryMsg = freezed,Object? eddColor = freezed,Object? eddTextColor = freezed,Object? noPinCodeMessage = freezed,}) {
  return _then(_PincodeCheckEntity(
serviceable: null == serviceable ? _self.serviceable : serviceable // ignore: cast_nullable_to_non_nullable
as bool,codAvailable: null == codAvailable ? _self.codAvailable : codAvailable // ignore: cast_nullable_to_non_nullable
as bool,edd: freezed == edd ? _self.edd : edd // ignore: cast_nullable_to_non_nullable
as String?,eddPrefix: freezed == eddPrefix ? _self.eddPrefix : eddPrefix // ignore: cast_nullable_to_non_nullable
as String?,eddSuffix: freezed == eddSuffix ? _self.eddSuffix : eddSuffix // ignore: cast_nullable_to_non_nullable
as String?,eddSecondaryMsg: freezed == eddSecondaryMsg ? _self.eddSecondaryMsg : eddSecondaryMsg // ignore: cast_nullable_to_non_nullable
as String?,eddColor: freezed == eddColor ? _self.eddColor : eddColor // ignore: cast_nullable_to_non_nullable
as String?,eddTextColor: freezed == eddTextColor ? _self.eddTextColor : eddTextColor // ignore: cast_nullable_to_non_nullable
as String?,noPinCodeMessage: freezed == noPinCodeMessage ? _self.noPinCodeMessage : noPinCodeMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
