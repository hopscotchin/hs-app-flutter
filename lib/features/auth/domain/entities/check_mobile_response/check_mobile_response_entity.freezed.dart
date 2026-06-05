// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_mobile_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckMobileResponseEntity {

 MobileInfoEntity? get mobile; bool get showMobileScreen; bool get hasEmail; bool get isPhoneVerifiedForCod;// OTP endpoint path to use for the next sendOtp call.
// Mirrors Android's AccountMobileResponse.pathUri.
 String? get pathUri;// OTP reason to forward to sendOtp. From ActionResponse.otpReason.
 String? get otpReason; String? get action; String? get popUpMessage; List<MessageBarEntity> get messageBars;
/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckMobileResponseEntityCopyWith<CheckMobileResponseEntity> get copyWith => _$CheckMobileResponseEntityCopyWithImpl<CheckMobileResponseEntity>(this as CheckMobileResponseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckMobileResponseEntity&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.showMobileScreen, showMobileScreen) || other.showMobileScreen == showMobileScreen)&&(identical(other.hasEmail, hasEmail) || other.hasEmail == hasEmail)&&(identical(other.isPhoneVerifiedForCod, isPhoneVerifiedForCod) || other.isPhoneVerifiedForCod == isPhoneVerifiedForCod)&&(identical(other.pathUri, pathUri) || other.pathUri == pathUri)&&(identical(other.otpReason, otpReason) || other.otpReason == otpReason)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,mobile,showMobileScreen,hasEmail,isPhoneVerifiedForCod,pathUri,otpReason,action,popUpMessage,const DeepCollectionEquality().hash(messageBars));

@override
String toString() {
  return 'CheckMobileResponseEntity(mobile: $mobile, showMobileScreen: $showMobileScreen, hasEmail: $hasEmail, isPhoneVerifiedForCod: $isPhoneVerifiedForCod, pathUri: $pathUri, otpReason: $otpReason, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class $CheckMobileResponseEntityCopyWith<$Res>  {
  factory $CheckMobileResponseEntityCopyWith(CheckMobileResponseEntity value, $Res Function(CheckMobileResponseEntity) _then) = _$CheckMobileResponseEntityCopyWithImpl;
@useResult
$Res call({
 MobileInfoEntity? mobile, bool showMobileScreen, bool hasEmail, bool isPhoneVerifiedForCod, String? pathUri, String? otpReason, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


$MobileInfoEntityCopyWith<$Res>? get mobile;

}
/// @nodoc
class _$CheckMobileResponseEntityCopyWithImpl<$Res>
    implements $CheckMobileResponseEntityCopyWith<$Res> {
  _$CheckMobileResponseEntityCopyWithImpl(this._self, this._then);

  final CheckMobileResponseEntity _self;
  final $Res Function(CheckMobileResponseEntity) _then;

/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mobile = freezed,Object? showMobileScreen = null,Object? hasEmail = null,Object? isPhoneVerifiedForCod = null,Object? pathUri = freezed,Object? otpReason = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_self.copyWith(
mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as MobileInfoEntity?,showMobileScreen: null == showMobileScreen ? _self.showMobileScreen : showMobileScreen // ignore: cast_nullable_to_non_nullable
as bool,hasEmail: null == hasEmail ? _self.hasEmail : hasEmail // ignore: cast_nullable_to_non_nullable
as bool,isPhoneVerifiedForCod: null == isPhoneVerifiedForCod ? _self.isPhoneVerifiedForCod : isPhoneVerifiedForCod // ignore: cast_nullable_to_non_nullable
as bool,pathUri: freezed == pathUri ? _self.pathUri : pathUri // ignore: cast_nullable_to_non_nullable
as String?,otpReason: freezed == otpReason ? _self.otpReason : otpReason // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}
/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MobileInfoEntityCopyWith<$Res>? get mobile {
    if (_self.mobile == null) {
    return null;
  }

  return $MobileInfoEntityCopyWith<$Res>(_self.mobile!, (value) {
    return _then(_self.copyWith(mobile: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckMobileResponseEntity].
extension CheckMobileResponseEntityPatterns on CheckMobileResponseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckMobileResponseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckMobileResponseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckMobileResponseEntity value)  $default,){
final _that = this;
switch (_that) {
case _CheckMobileResponseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckMobileResponseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CheckMobileResponseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MobileInfoEntity? mobile,  bool showMobileScreen,  bool hasEmail,  bool isPhoneVerifiedForCod,  String? pathUri,  String? otpReason,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckMobileResponseEntity() when $default != null:
return $default(_that.mobile,_that.showMobileScreen,_that.hasEmail,_that.isPhoneVerifiedForCod,_that.pathUri,_that.otpReason,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MobileInfoEntity? mobile,  bool showMobileScreen,  bool hasEmail,  bool isPhoneVerifiedForCod,  String? pathUri,  String? otpReason,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)  $default,) {final _that = this;
switch (_that) {
case _CheckMobileResponseEntity():
return $default(_that.mobile,_that.showMobileScreen,_that.hasEmail,_that.isPhoneVerifiedForCod,_that.pathUri,_that.otpReason,_that.action,_that.popUpMessage,_that.messageBars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MobileInfoEntity? mobile,  bool showMobileScreen,  bool hasEmail,  bool isPhoneVerifiedForCod,  String? pathUri,  String? otpReason,  String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars)?  $default,) {final _that = this;
switch (_that) {
case _CheckMobileResponseEntity() when $default != null:
return $default(_that.mobile,_that.showMobileScreen,_that.hasEmail,_that.isPhoneVerifiedForCod,_that.pathUri,_that.otpReason,_that.action,_that.popUpMessage,_that.messageBars);case _:
  return null;

}
}

}

/// @nodoc


class _CheckMobileResponseEntity implements CheckMobileResponseEntity {
  const _CheckMobileResponseEntity({this.mobile, this.showMobileScreen = false, this.hasEmail = false, this.isPhoneVerifiedForCod = false, this.pathUri, this.otpReason, this.action, this.popUpMessage, final  List<MessageBarEntity> messageBars = const []}): _messageBars = messageBars;
  

@override final  MobileInfoEntity? mobile;
@override@JsonKey() final  bool showMobileScreen;
@override@JsonKey() final  bool hasEmail;
@override@JsonKey() final  bool isPhoneVerifiedForCod;
// OTP endpoint path to use for the next sendOtp call.
// Mirrors Android's AccountMobileResponse.pathUri.
@override final  String? pathUri;
// OTP reason to forward to sendOtp. From ActionResponse.otpReason.
@override final  String? otpReason;
@override final  String? action;
@override final  String? popUpMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}


/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckMobileResponseEntityCopyWith<_CheckMobileResponseEntity> get copyWith => __$CheckMobileResponseEntityCopyWithImpl<_CheckMobileResponseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckMobileResponseEntity&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.showMobileScreen, showMobileScreen) || other.showMobileScreen == showMobileScreen)&&(identical(other.hasEmail, hasEmail) || other.hasEmail == hasEmail)&&(identical(other.isPhoneVerifiedForCod, isPhoneVerifiedForCod) || other.isPhoneVerifiedForCod == isPhoneVerifiedForCod)&&(identical(other.pathUri, pathUri) || other.pathUri == pathUri)&&(identical(other.otpReason, otpReason) || other.otpReason == otpReason)&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,mobile,showMobileScreen,hasEmail,isPhoneVerifiedForCod,pathUri,otpReason,action,popUpMessage,const DeepCollectionEquality().hash(_messageBars));

@override
String toString() {
  return 'CheckMobileResponseEntity(mobile: $mobile, showMobileScreen: $showMobileScreen, hasEmail: $hasEmail, isPhoneVerifiedForCod: $isPhoneVerifiedForCod, pathUri: $pathUri, otpReason: $otpReason, action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class _$CheckMobileResponseEntityCopyWith<$Res> implements $CheckMobileResponseEntityCopyWith<$Res> {
  factory _$CheckMobileResponseEntityCopyWith(_CheckMobileResponseEntity value, $Res Function(_CheckMobileResponseEntity) _then) = __$CheckMobileResponseEntityCopyWithImpl;
@override @useResult
$Res call({
 MobileInfoEntity? mobile, bool showMobileScreen, bool hasEmail, bool isPhoneVerifiedForCod, String? pathUri, String? otpReason, String? action, String? popUpMessage, List<MessageBarEntity> messageBars
});


@override $MobileInfoEntityCopyWith<$Res>? get mobile;

}
/// @nodoc
class __$CheckMobileResponseEntityCopyWithImpl<$Res>
    implements _$CheckMobileResponseEntityCopyWith<$Res> {
  __$CheckMobileResponseEntityCopyWithImpl(this._self, this._then);

  final _CheckMobileResponseEntity _self;
  final $Res Function(_CheckMobileResponseEntity) _then;

/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mobile = freezed,Object? showMobileScreen = null,Object? hasEmail = null,Object? isPhoneVerifiedForCod = null,Object? pathUri = freezed,Object? otpReason = freezed,Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,}) {
  return _then(_CheckMobileResponseEntity(
mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as MobileInfoEntity?,showMobileScreen: null == showMobileScreen ? _self.showMobileScreen : showMobileScreen // ignore: cast_nullable_to_non_nullable
as bool,hasEmail: null == hasEmail ? _self.hasEmail : hasEmail // ignore: cast_nullable_to_non_nullable
as bool,isPhoneVerifiedForCod: null == isPhoneVerifiedForCod ? _self.isPhoneVerifiedForCod : isPhoneVerifiedForCod // ignore: cast_nullable_to_non_nullable
as bool,pathUri: freezed == pathUri ? _self.pathUri : pathUri // ignore: cast_nullable_to_non_nullable
as String?,otpReason: freezed == otpReason ? _self.otpReason : otpReason // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}

/// Create a copy of CheckMobileResponseEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MobileInfoEntityCopyWith<$Res>? get mobile {
    if (_self.mobile == null) {
    return null;
  }

  return $MobileInfoEntityCopyWith<$Res>(_self.mobile!, (value) {
    return _then(_self.copyWith(mobile: value));
  });
}
}

// dart format on
