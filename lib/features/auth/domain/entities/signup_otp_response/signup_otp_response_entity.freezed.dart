// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_otp_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignupOtpResponseEntity {

 OtpConfigEntity get otp; String? get loginId; String? get mobile; String? get email; String? get action; String? get popUpMessage; List<MessageBarEntity> get messageBars;
/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupOtpResponseEntityCopyWith<SignupOtpResponseEntity> get copyWith => _$SignupOtpResponseEntityCopyWithImpl<SignupOtpResponseEntity>(this as SignupOtpResponseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupOtpResponseEntity&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,otp,loginId,mobile,email,action,popUpMessage,const DeepCollectionEquality().hash(messageBars));

@override
String toString() {
  return 'SignupOtpResponseEntity(otp: $otp, loginId: $loginId, mobile: $mobile, email: $email, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class $SignupOtpResponseEntityCopyWith<$Res>  {
  factory $SignupOtpResponseEntityCopyWith(SignupOtpResponseEntity value, $Res Function(SignupOtpResponseEntity) _then) = _$SignupOtpResponseEntityCopyWithImpl;
@useResult
$Res call({
 OtpConfigEntity otp, String? loginId, String? mobile, String? email, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


$OtpConfigEntityCopyWith<$Res> get otp;

}
/// @nodoc
class _$SignupOtpResponseEntityCopyWithImpl<$Res>
    implements $SignupOtpResponseEntityCopyWith<$Res> {
  _$SignupOtpResponseEntityCopyWithImpl(this._self, this._then);

  final SignupOtpResponseEntity _self;
  final $Res Function(SignupOtpResponseEntity) _then;

/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otp = null,Object? loginId = freezed,Object? mobile = freezed,Object? email = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_self.copyWith(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as OtpConfigEntity,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}
/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpConfigEntityCopyWith<$Res> get otp {
  
  return $OtpConfigEntityCopyWith<$Res>(_self.otp, (value) {
    return _then(_self.copyWith(otp: value));
  });
}
}


/// Adds pattern-matching-related methods to [SignupOtpResponseEntity].
extension SignupOtpResponseEntityPatterns on SignupOtpResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupOtpResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupOtpResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _SignupOtpResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupOtpResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SignupOtpResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OtpConfigEntity otp,  String? loginId,  String? mobile,  String? email,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupOtpResponseEntity() when $default != null:
return $default(_that.otp,_that.loginId,_that.mobile,_that.email,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OtpConfigEntity otp,  String? loginId,  String? mobile,  String? email,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)  $default,) {final _that = this;
switch (_that) {
case _SignupOtpResponseEntity():
return $default(_that.otp,_that.loginId,_that.mobile,_that.email,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OtpConfigEntity otp,  String? loginId,  String? mobile,  String? email,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,) {final _that = this;
switch (_that) {
case _SignupOtpResponseEntity() when $default != null:
return $default(_that.otp,_that.loginId,_that.mobile,_that.email,_that.action,_that.popUpMessage,_that.messageBars);case _:
  return null;

}
}

}

/// @nodoc


class _SignupOtpResponseEntity implements SignupOtpResponseEntity {
  const _SignupOtpResponseEntity({required this.otp, this.loginId, this.mobile, this.email, this.action, this.popUpMessage, final  List<MessageBarEntity> messageBars = const []}): _messageBars = messageBars;
  

@override final  OtpConfigEntity otp;
@override final  String? loginId;
@override final  String? mobile;
@override final  String? email;
@override final  String? action;
@override final  String? popUpMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}


/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupOtpResponseEntityCopyWith<_SignupOtpResponseEntity> get copyWith => __$SignupOtpResponseEntityCopyWithImpl<_SignupOtpResponseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupOtpResponseEntity&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.email, email) || other.email == email)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,otp,loginId,mobile,email,action,popUpMessage,const DeepCollectionEquality().hash(_messageBars));

@override
String toString() {
  return 'SignupOtpResponseEntity(otp: $otp, loginId: $loginId, mobile: $mobile, email: $email, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class _$SignupOtpResponseEntityCopyWith<$Res> implements $SignupOtpResponseEntityCopyWith<$Res> {
  factory _$SignupOtpResponseEntityCopyWith(_SignupOtpResponseEntity value, $Res Function(_SignupOtpResponseEntity) _then) = __$SignupOtpResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 OtpConfigEntity otp, String? loginId, String? mobile, String? email, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


@override $OtpConfigEntityCopyWith<$Res> get otp;

}
/// @nodoc
class __$SignupOtpResponseEntityCopyWithImpl<$Res>
    implements _$SignupOtpResponseEntityCopyWith<$Res> {
  __$SignupOtpResponseEntityCopyWithImpl(this._self, this._then);

  final _SignupOtpResponseEntity _self;
  final $Res Function(_SignupOtpResponseEntity) _then;

/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otp = null,Object? loginId = freezed,Object? mobile = freezed,Object? email = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_SignupOtpResponseEntity(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as OtpConfigEntity,loginId: freezed == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}

/// Create a copy of SignupOtpResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpConfigEntityCopyWith<$Res> get otp {
  
  return $OtpConfigEntityCopyWith<$Res>(_self.otp, (value) {
    return _then(_self.copyWith(otp: value));
  });
}
}

// dart format on
