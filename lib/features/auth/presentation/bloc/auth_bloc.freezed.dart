// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SendOtp value)?  sendOtp,TResult Function( VerifyOtp value)?  verifyOtp,TResult Function( Register value)?  register,TResult Function( CheckMobile value)?  checkMobile,TResult Function( ResetAuth value)?  reset,TResult Function( AuthSignOut value)?  signOut,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SendOtp() when sendOtp != null:
return sendOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case Register() when register != null:
return register(_that);case CheckMobile() when checkMobile != null:
return checkMobile(_that);case ResetAuth() when reset != null:
return reset(_that);case AuthSignOut() when signOut != null:
return signOut(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SendOtp value)  sendOtp,required TResult Function( VerifyOtp value)  verifyOtp,required TResult Function( Register value)  register,required TResult Function( CheckMobile value)  checkMobile,required TResult Function( ResetAuth value)  reset,required TResult Function( AuthSignOut value)  signOut,}){
final _that = this;
switch (_that) {
case SendOtp():
return sendOtp(_that);case VerifyOtp():
return verifyOtp(_that);case Register():
return register(_that);case CheckMobile():
return checkMobile(_that);case ResetAuth():
return reset(_that);case AuthSignOut():
return signOut(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SendOtp value)?  sendOtp,TResult? Function( VerifyOtp value)?  verifyOtp,TResult? Function( Register value)?  register,TResult? Function( CheckMobile value)?  checkMobile,TResult? Function( ResetAuth value)?  reset,TResult? Function( AuthSignOut value)?  signOut,}){
final _that = this;
switch (_that) {
case SendOtp() when sendOtp != null:
return sendOtp(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case Register() when register != null:
return register(_that);case CheckMobile() when checkMobile != null:
return checkMobile(_that);case ResetAuth() when reset != null:
return reset(_that);case AuthSignOut() when signOut != null:
return signOut(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String loginId,  String otpReason,  String? pathUri)?  sendOtp,TResult Function( String loginId,  String otp,  String otpReason)?  verifyOtp,TResult Function( String displayName,  String email,  String mobile)?  register,TResult Function( String mobile)?  checkMobile,TResult Function()?  reset,TResult Function()?  signOut,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SendOtp() when sendOtp != null:
return sendOtp(_that.loginId,_that.otpReason,_that.pathUri);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.loginId,_that.otp,_that.otpReason);case Register() when register != null:
return register(_that.displayName,_that.email,_that.mobile);case CheckMobile() when checkMobile != null:
return checkMobile(_that.mobile);case ResetAuth() when reset != null:
return reset();case AuthSignOut() when signOut != null:
return signOut();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String loginId,  String otpReason,  String? pathUri)  sendOtp,required TResult Function( String loginId,  String otp,  String otpReason)  verifyOtp,required TResult Function( String displayName,  String email,  String mobile)  register,required TResult Function( String mobile)  checkMobile,required TResult Function()  reset,required TResult Function()  signOut,}) {final _that = this;
switch (_that) {
case SendOtp():
return sendOtp(_that.loginId,_that.otpReason,_that.pathUri);case VerifyOtp():
return verifyOtp(_that.loginId,_that.otp,_that.otpReason);case Register():
return register(_that.displayName,_that.email,_that.mobile);case CheckMobile():
return checkMobile(_that.mobile);case ResetAuth():
return reset();case AuthSignOut():
return signOut();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String loginId,  String otpReason,  String? pathUri)?  sendOtp,TResult? Function( String loginId,  String otp,  String otpReason)?  verifyOtp,TResult? Function( String displayName,  String email,  String mobile)?  register,TResult? Function( String mobile)?  checkMobile,TResult? Function()?  reset,TResult? Function()?  signOut,}) {final _that = this;
switch (_that) {
case SendOtp() when sendOtp != null:
return sendOtp(_that.loginId,_that.otpReason,_that.pathUri);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.loginId,_that.otp,_that.otpReason);case Register() when register != null:
return register(_that.displayName,_that.email,_that.mobile);case CheckMobile() when checkMobile != null:
return checkMobile(_that.mobile);case ResetAuth() when reset != null:
return reset();case AuthSignOut() when signOut != null:
return signOut();case _:
  return null;

}
}

}

/// @nodoc


class SendOtp implements AuthEvent {
  const SendOtp({required this.loginId, this.otpReason = 'SIGN_IN', this.pathUri});
  

 final  String loginId;
@JsonKey() final  String otpReason;
 final  String? pathUri;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpCopyWith<SendOtp> get copyWith => _$SendOtpCopyWithImpl<SendOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtp&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.otpReason, otpReason) || other.otpReason == otpReason)&&(identical(other.pathUri, pathUri) || other.pathUri == pathUri));
}


@override
int get hashCode => Object.hash(runtimeType,loginId,otpReason,pathUri);

@override
String toString() {
  return 'AuthEvent.sendOtp(loginId: $loginId, otpReason: $otpReason, pathUri: $pathUri)';
}


}

/// @nodoc
abstract mixin class $SendOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SendOtpCopyWith(SendOtp value, $Res Function(SendOtp) _then) = _$SendOtpCopyWithImpl;
@useResult
$Res call({
 String loginId, String otpReason, String? pathUri
});




}
/// @nodoc
class _$SendOtpCopyWithImpl<$Res>
    implements $SendOtpCopyWith<$Res> {
  _$SendOtpCopyWithImpl(this._self, this._then);

  final SendOtp _self;
  final $Res Function(SendOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loginId = null,Object? otpReason = null,Object? pathUri = freezed,}) {
  return _then(SendOtp(
loginId: null == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String,otpReason: null == otpReason ? _self.otpReason : otpReason // ignore: cast_nullable_to_non_nullable
as String,pathUri: freezed == pathUri ? _self.pathUri : pathUri // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class VerifyOtp implements AuthEvent {
  const VerifyOtp({required this.loginId, required this.otp, this.otpReason = 'SIGN_IN'});
  

 final  String loginId;
 final  String otp;
@JsonKey() final  String otpReason;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpCopyWith<VerifyOtp> get copyWith => _$VerifyOtpCopyWithImpl<VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtp&&(identical(other.loginId, loginId) || other.loginId == loginId)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.otpReason, otpReason) || other.otpReason == otpReason));
}


@override
int get hashCode => Object.hash(runtimeType,loginId,otp,otpReason);

@override
String toString() {
  return 'AuthEvent.verifyOtp(loginId: $loginId, otp: $otp, otpReason: $otpReason)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $VerifyOtpCopyWith(VerifyOtp value, $Res Function(VerifyOtp) _then) = _$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String loginId, String otp, String otpReason
});




}
/// @nodoc
class _$VerifyOtpCopyWithImpl<$Res>
    implements $VerifyOtpCopyWith<$Res> {
  _$VerifyOtpCopyWithImpl(this._self, this._then);

  final VerifyOtp _self;
  final $Res Function(VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loginId = null,Object? otp = null,Object? otpReason = null,}) {
  return _then(VerifyOtp(
loginId: null == loginId ? _self.loginId : loginId // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,otpReason: null == otpReason ? _self.otpReason : otpReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Register implements AuthEvent {
  const Register({required this.displayName, required this.email, required this.mobile});
  

 final  String displayName;
 final  String email;
 final  String mobile;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterCopyWith<Register> get copyWith => _$RegisterCopyWithImpl<Register>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Register&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}


@override
int get hashCode => Object.hash(runtimeType,displayName,email,mobile);

@override
String toString() {
  return 'AuthEvent.register(displayName: $displayName, email: $email, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class $RegisterCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $RegisterCopyWith(Register value, $Res Function(Register) _then) = _$RegisterCopyWithImpl;
@useResult
$Res call({
 String displayName, String email, String mobile
});




}
/// @nodoc
class _$RegisterCopyWithImpl<$Res>
    implements $RegisterCopyWith<$Res> {
  _$RegisterCopyWithImpl(this._self, this._then);

  final Register _self;
  final $Res Function(Register) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? email = null,Object? mobile = null,}) {
  return _then(Register(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckMobile implements AuthEvent {
  const CheckMobile({required this.mobile});
  

 final  String mobile;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckMobileCopyWith<CheckMobile> get copyWith => _$CheckMobileCopyWithImpl<CheckMobile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckMobile&&(identical(other.mobile, mobile) || other.mobile == mobile));
}


@override
int get hashCode => Object.hash(runtimeType,mobile);

@override
String toString() {
  return 'AuthEvent.checkMobile(mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class $CheckMobileCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $CheckMobileCopyWith(CheckMobile value, $Res Function(CheckMobile) _then) = _$CheckMobileCopyWithImpl;
@useResult
$Res call({
 String mobile
});




}
/// @nodoc
class _$CheckMobileCopyWithImpl<$Res>
    implements $CheckMobileCopyWith<$Res> {
  _$CheckMobileCopyWithImpl(this._self, this._then);

  final CheckMobile _self;
  final $Res Function(CheckMobile) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mobile = null,}) {
  return _then(CheckMobile(
mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetAuth implements AuthEvent {
  const ResetAuth();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetAuth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.reset()';
}


}




/// @nodoc


class AuthSignOut implements AuthEvent {
  const AuthSignOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signOut()';
}


}




/// @nodoc
mixin _$AuthState {

 AuthStatus get status; OtpConfigEntity? get otpConfig; VerifyOtpResponseEntity? get verifyOtpResult; CheckMobileResponseEntity? get checkMobileResult; String get errorMessage; List<MessageBarEntity> get messageBars; List<MessageBarEntity> get otpMessageBars; String? get redirectLink;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.otpConfig, otpConfig) || other.otpConfig == otpConfig)&&(identical(other.verifyOtpResult, verifyOtpResult) || other.verifyOtpResult == verifyOtpResult)&&(identical(other.checkMobileResult, checkMobileResult) || other.checkMobileResult == checkMobileResult)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars)&&const DeepCollectionEquality().equals(other.otpMessageBars, otpMessageBars)&&(identical(other.redirectLink, redirectLink) || other.redirectLink == redirectLink));
}


@override
int get hashCode => Object.hash(runtimeType,status,otpConfig,verifyOtpResult,checkMobileResult,errorMessage,const DeepCollectionEquality().hash(messageBars),const DeepCollectionEquality().hash(otpMessageBars),redirectLink);

@override
String toString() {
  return 'AuthState(status: $status, otpConfig: $otpConfig, verifyOtpResult: $verifyOtpResult, checkMobileResult: $checkMobileResult, errorMessage: $errorMessage, messageBars: $messageBars, otpMessageBars: $otpMessageBars, redirectLink: $redirectLink)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthStatus status, OtpConfigEntity? otpConfig, VerifyOtpResponseEntity? verifyOtpResult, CheckMobileResponseEntity? checkMobileResult, String errorMessage, List<MessageBarEntity> messageBars, List<MessageBarEntity> otpMessageBars, String? redirectLink
});


$OtpConfigEntityCopyWith<$Res>? get otpConfig;$VerifyOtpResponseEntityCopyWith<$Res>? get verifyOtpResult;$CheckMobileResponseEntityCopyWith<$Res>? get checkMobileResult;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? otpConfig = freezed,Object? verifyOtpResult = freezed,Object? checkMobileResult = freezed,Object? errorMessage = null,Object? messageBars = null,Object? otpMessageBars = null,Object? redirectLink = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,otpConfig: freezed == otpConfig ? _self.otpConfig : otpConfig // ignore: cast_nullable_to_non_nullable
as OtpConfigEntity?,verifyOtpResult: freezed == verifyOtpResult ? _self.verifyOtpResult : verifyOtpResult // ignore: cast_nullable_to_non_nullable
as VerifyOtpResponseEntity?,checkMobileResult: freezed == checkMobileResult ? _self.checkMobileResult : checkMobileResult // ignore: cast_nullable_to_non_nullable
as CheckMobileResponseEntity?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,otpMessageBars: null == otpMessageBars ? _self.otpMessageBars : otpMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,redirectLink: freezed == redirectLink ? _self.redirectLink : redirectLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpConfigEntityCopyWith<$Res>? get otpConfig {
    if (_self.otpConfig == null) {
    return null;
  }

  return $OtpConfigEntityCopyWith<$Res>(_self.otpConfig!, (value) {
    return _then(_self.copyWith(otpConfig: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerifyOtpResponseEntityCopyWith<$Res>? get verifyOtpResult {
    if (_self.verifyOtpResult == null) {
    return null;
  }

  return $VerifyOtpResponseEntityCopyWith<$Res>(_self.verifyOtpResult!, (value) {
    return _then(_self.copyWith(verifyOtpResult: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckMobileResponseEntityCopyWith<$Res>? get checkMobileResult {
    if (_self.checkMobileResult == null) {
    return null;
  }

  return $CheckMobileResponseEntityCopyWith<$Res>(_self.checkMobileResult!, (value) {
    return _then(_self.copyWith(checkMobileResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthStatus status,  OtpConfigEntity? otpConfig,  VerifyOtpResponseEntity? verifyOtpResult,  CheckMobileResponseEntity? checkMobileResult,  String errorMessage,  List<MessageBarEntity> messageBars,  List<MessageBarEntity> otpMessageBars,  String? redirectLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.otpConfig,_that.verifyOtpResult,_that.checkMobileResult,_that.errorMessage,_that.messageBars,_that.otpMessageBars,_that.redirectLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthStatus status,  OtpConfigEntity? otpConfig,  VerifyOtpResponseEntity? verifyOtpResult,  CheckMobileResponseEntity? checkMobileResult,  String errorMessage,  List<MessageBarEntity> messageBars,  List<MessageBarEntity> otpMessageBars,  String? redirectLink)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.status,_that.otpConfig,_that.verifyOtpResult,_that.checkMobileResult,_that.errorMessage,_that.messageBars,_that.otpMessageBars,_that.redirectLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthStatus status,  OtpConfigEntity? otpConfig,  VerifyOtpResponseEntity? verifyOtpResult,  CheckMobileResponseEntity? checkMobileResult,  String errorMessage,  List<MessageBarEntity> messageBars,  List<MessageBarEntity> otpMessageBars,  String? redirectLink)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.otpConfig,_that.verifyOtpResult,_that.checkMobileResult,_that.errorMessage,_that.messageBars,_that.otpMessageBars,_that.redirectLink);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.status = AuthStatus.initial, this.otpConfig, this.verifyOtpResult, this.checkMobileResult, this.errorMessage = '', final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[], final  List<MessageBarEntity> otpMessageBars = const <MessageBarEntity>[], this.redirectLink}): _messageBars = messageBars,_otpMessageBars = otpMessageBars;
  

@override@JsonKey() final  AuthStatus status;
@override final  OtpConfigEntity? otpConfig;
@override final  VerifyOtpResponseEntity? verifyOtpResult;
@override final  CheckMobileResponseEntity? checkMobileResult;
@override@JsonKey() final  String errorMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}

 final  List<MessageBarEntity> _otpMessageBars;
@override@JsonKey() List<MessageBarEntity> get otpMessageBars {
  if (_otpMessageBars is EqualUnmodifiableListView) return _otpMessageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_otpMessageBars);
}

@override final  String? redirectLink;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.otpConfig, otpConfig) || other.otpConfig == otpConfig)&&(identical(other.verifyOtpResult, verifyOtpResult) || other.verifyOtpResult == verifyOtpResult)&&(identical(other.checkMobileResult, checkMobileResult) || other.checkMobileResult == checkMobileResult)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars)&&const DeepCollectionEquality().equals(other._otpMessageBars, _otpMessageBars)&&(identical(other.redirectLink, redirectLink) || other.redirectLink == redirectLink));
}


@override
int get hashCode => Object.hash(runtimeType,status,otpConfig,verifyOtpResult,checkMobileResult,errorMessage,const DeepCollectionEquality().hash(_messageBars),const DeepCollectionEquality().hash(_otpMessageBars),redirectLink);

@override
String toString() {
  return 'AuthState(status: $status, otpConfig: $otpConfig, verifyOtpResult: $verifyOtpResult, checkMobileResult: $checkMobileResult, errorMessage: $errorMessage, messageBars: $messageBars, otpMessageBars: $otpMessageBars, redirectLink: $redirectLink)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 AuthStatus status, OtpConfigEntity? otpConfig, VerifyOtpResponseEntity? verifyOtpResult, CheckMobileResponseEntity? checkMobileResult, String errorMessage, List<MessageBarEntity> messageBars, List<MessageBarEntity> otpMessageBars, String? redirectLink
});


@override $OtpConfigEntityCopyWith<$Res>? get otpConfig;@override $VerifyOtpResponseEntityCopyWith<$Res>? get verifyOtpResult;@override $CheckMobileResponseEntityCopyWith<$Res>? get checkMobileResult;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? otpConfig = freezed,Object? verifyOtpResult = freezed,Object? checkMobileResult = freezed,Object? errorMessage = null,Object? messageBars = null,Object? otpMessageBars = null,Object? redirectLink = freezed,}) {
  return _then(_AuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,otpConfig: freezed == otpConfig ? _self.otpConfig : otpConfig // ignore: cast_nullable_to_non_nullable
as OtpConfigEntity?,verifyOtpResult: freezed == verifyOtpResult ? _self.verifyOtpResult : verifyOtpResult // ignore: cast_nullable_to_non_nullable
as VerifyOtpResponseEntity?,checkMobileResult: freezed == checkMobileResult ? _self.checkMobileResult : checkMobileResult // ignore: cast_nullable_to_non_nullable
as CheckMobileResponseEntity?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,otpMessageBars: null == otpMessageBars ? _self._otpMessageBars : otpMessageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,redirectLink: freezed == redirectLink ? _self.redirectLink : redirectLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtpConfigEntityCopyWith<$Res>? get otpConfig {
    if (_self.otpConfig == null) {
    return null;
  }

  return $OtpConfigEntityCopyWith<$Res>(_self.otpConfig!, (value) {
    return _then(_self.copyWith(otpConfig: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerifyOtpResponseEntityCopyWith<$Res>? get verifyOtpResult {
    if (_self.verifyOtpResult == null) {
    return null;
  }

  return $VerifyOtpResponseEntityCopyWith<$Res>(_self.verifyOtpResult!, (value) {
    return _then(_self.copyWith(verifyOtpResult: value));
  });
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckMobileResponseEntityCopyWith<$Res>? get checkMobileResult {
    if (_self.checkMobileResult == null) {
    return null;
  }

  return $CheckMobileResponseEntityCopyWith<$Res>(_self.checkMobileResult!, (value) {
    return _then(_self.copyWith(checkMobileResult: value));
  });
}
}

// dart format on
