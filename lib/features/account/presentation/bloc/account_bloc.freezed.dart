// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent()';
}


}

/// @nodoc
class $AccountEventCopyWith<$Res>  {
$AccountEventCopyWith(AccountEvent _, $Res Function(AccountEvent) __);
}


/// Adds pattern-matching-related methods to [AccountEvent].
extension AccountEventPatterns on AccountEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadAccount value)?  load,TResult Function( RefreshFromLocal value)?  refreshFromLocal,TResult Function( ForgetGuestUser value)?  forgetGuestUser,TResult Function( ClearForgetSignal value)?  clearForgetSignal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadAccount() when load != null:
return load(_that);case RefreshFromLocal() when refreshFromLocal != null:
return refreshFromLocal(_that);case ForgetGuestUser() when forgetGuestUser != null:
return forgetGuestUser(_that);case ClearForgetSignal() when clearForgetSignal != null:
return clearForgetSignal(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadAccount value)  load,required TResult Function( RefreshFromLocal value)  refreshFromLocal,required TResult Function( ForgetGuestUser value)  forgetGuestUser,required TResult Function( ClearForgetSignal value)  clearForgetSignal,}){
final _that = this;
switch (_that) {
case LoadAccount():
return load(_that);case RefreshFromLocal():
return refreshFromLocal(_that);case ForgetGuestUser():
return forgetGuestUser(_that);case ClearForgetSignal():
return clearForgetSignal(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadAccount value)?  load,TResult? Function( RefreshFromLocal value)?  refreshFromLocal,TResult? Function( ForgetGuestUser value)?  forgetGuestUser,TResult? Function( ClearForgetSignal value)?  clearForgetSignal,}){
final _that = this;
switch (_that) {
case LoadAccount() when load != null:
return load(_that);case RefreshFromLocal() when refreshFromLocal != null:
return refreshFromLocal(_that);case ForgetGuestUser() when forgetGuestUser != null:
return forgetGuestUser(_that);case ClearForgetSignal() when clearForgetSignal != null:
return clearForgetSignal(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  refreshFromLocal,TResult Function()?  forgetGuestUser,TResult Function()?  clearForgetSignal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadAccount() when load != null:
return load();case RefreshFromLocal() when refreshFromLocal != null:
return refreshFromLocal();case ForgetGuestUser() when forgetGuestUser != null:
return forgetGuestUser();case ClearForgetSignal() when clearForgetSignal != null:
return clearForgetSignal();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  refreshFromLocal,required TResult Function()  forgetGuestUser,required TResult Function()  clearForgetSignal,}) {final _that = this;
switch (_that) {
case LoadAccount():
return load();case RefreshFromLocal():
return refreshFromLocal();case ForgetGuestUser():
return forgetGuestUser();case ClearForgetSignal():
return clearForgetSignal();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  refreshFromLocal,TResult? Function()?  forgetGuestUser,TResult? Function()?  clearForgetSignal,}) {final _that = this;
switch (_that) {
case LoadAccount() when load != null:
return load();case RefreshFromLocal() when refreshFromLocal != null:
return refreshFromLocal();case ForgetGuestUser() when forgetGuestUser != null:
return forgetGuestUser();case ClearForgetSignal() when clearForgetSignal != null:
return clearForgetSignal();case _:
  return null;

}
}

}

/// @nodoc


class LoadAccount implements AccountEvent {
  const LoadAccount();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAccount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.load()';
}


}




/// @nodoc


class RefreshFromLocal implements AccountEvent {
  const RefreshFromLocal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshFromLocal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.refreshFromLocal()';
}


}




/// @nodoc


class ForgetGuestUser implements AccountEvent {
  const ForgetGuestUser();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgetGuestUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.forgetGuestUser()';
}


}




/// @nodoc


class ClearForgetSignal implements AccountEvent {
  const ClearForgetSignal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearForgetSignal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.clearForgetSignal()';
}


}




/// @nodoc
mixin _$AccountState {

 AccountStatus get status; AccountEntity get account; String? get errorMessage; bool get isForgetting; String? get forgetError; bool get forgetCompleted;
/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStateCopyWith<AccountState> get copyWith => _$AccountStateCopyWithImpl<AccountState>(this as AccountState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState&&(identical(other.status, status) || other.status == status)&&(identical(other.account, account) || other.account == account)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isForgetting, isForgetting) || other.isForgetting == isForgetting)&&(identical(other.forgetError, forgetError) || other.forgetError == forgetError)&&(identical(other.forgetCompleted, forgetCompleted) || other.forgetCompleted == forgetCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,account,errorMessage,isForgetting,forgetError,forgetCompleted);

@override
String toString() {
  return 'AccountState(status: $status, account: $account, errorMessage: $errorMessage, isForgetting: $isForgetting, forgetError: $forgetError, forgetCompleted: $forgetCompleted)';
}


}

/// @nodoc
abstract mixin class $AccountStateCopyWith<$Res>  {
  factory $AccountStateCopyWith(AccountState value, $Res Function(AccountState) _then) = _$AccountStateCopyWithImpl;
@useResult
$Res call({
 AccountStatus status, AccountEntity account, String? errorMessage, bool isForgetting, String? forgetError, bool forgetCompleted
});


$AccountEntityCopyWith<$Res> get account;

}
/// @nodoc
class _$AccountStateCopyWithImpl<$Res>
    implements $AccountStateCopyWith<$Res> {
  _$AccountStateCopyWithImpl(this._self, this._then);

  final AccountState _self;
  final $Res Function(AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? account = null,Object? errorMessage = freezed,Object? isForgetting = null,Object? forgetError = freezed,Object? forgetCompleted = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountEntity,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isForgetting: null == isForgetting ? _self.isForgetting : isForgetting // ignore: cast_nullable_to_non_nullable
as bool,forgetError: freezed == forgetError ? _self.forgetError : forgetError // ignore: cast_nullable_to_non_nullable
as String?,forgetCompleted: null == forgetCompleted ? _self.forgetCompleted : forgetCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountEntityCopyWith<$Res> get account {
  
  return $AccountEntityCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountState].
extension AccountStatePatterns on AccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountState value)  $default,){
final _that = this;
switch (_that) {
case _AccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountStatus status,  AccountEntity account,  String? errorMessage,  bool isForgetting,  String? forgetError,  bool forgetCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.status,_that.account,_that.errorMessage,_that.isForgetting,_that.forgetError,_that.forgetCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountStatus status,  AccountEntity account,  String? errorMessage,  bool isForgetting,  String? forgetError,  bool forgetCompleted)  $default,) {final _that = this;
switch (_that) {
case _AccountState():
return $default(_that.status,_that.account,_that.errorMessage,_that.isForgetting,_that.forgetError,_that.forgetCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountStatus status,  AccountEntity account,  String? errorMessage,  bool isForgetting,  String? forgetError,  bool forgetCompleted)?  $default,) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.status,_that.account,_that.errorMessage,_that.isForgetting,_that.forgetError,_that.forgetCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _AccountState implements AccountState {
  const _AccountState({this.status = AccountStatus.success, this.account = const AccountEntity(), this.errorMessage, this.isForgetting = false, this.forgetError, this.forgetCompleted = false});
  

@override@JsonKey() final  AccountStatus status;
@override@JsonKey() final  AccountEntity account;
@override final  String? errorMessage;
@override@JsonKey() final  bool isForgetting;
@override final  String? forgetError;
@override@JsonKey() final  bool forgetCompleted;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStateCopyWith<_AccountState> get copyWith => __$AccountStateCopyWithImpl<_AccountState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountState&&(identical(other.status, status) || other.status == status)&&(identical(other.account, account) || other.account == account)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isForgetting, isForgetting) || other.isForgetting == isForgetting)&&(identical(other.forgetError, forgetError) || other.forgetError == forgetError)&&(identical(other.forgetCompleted, forgetCompleted) || other.forgetCompleted == forgetCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,account,errorMessage,isForgetting,forgetError,forgetCompleted);

@override
String toString() {
  return 'AccountState(status: $status, account: $account, errorMessage: $errorMessage, isForgetting: $isForgetting, forgetError: $forgetError, forgetCompleted: $forgetCompleted)';
}


}

/// @nodoc
abstract mixin class _$AccountStateCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory _$AccountStateCopyWith(_AccountState value, $Res Function(_AccountState) _then) = __$AccountStateCopyWithImpl;
@override @useResult
$Res call({
 AccountStatus status, AccountEntity account, String? errorMessage, bool isForgetting, String? forgetError, bool forgetCompleted
});


@override $AccountEntityCopyWith<$Res> get account;

}
/// @nodoc
class __$AccountStateCopyWithImpl<$Res>
    implements _$AccountStateCopyWith<$Res> {
  __$AccountStateCopyWithImpl(this._self, this._then);

  final _AccountState _self;
  final $Res Function(_AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? account = null,Object? errorMessage = freezed,Object? isForgetting = null,Object? forgetError = freezed,Object? forgetCompleted = null,}) {
  return _then(_AccountState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountEntity,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isForgetting: null == isForgetting ? _self.isForgetting : isForgetting // ignore: cast_nullable_to_non_nullable
as bool,forgetError: freezed == forgetError ? _self.forgetError : forgetError // ignore: cast_nullable_to_non_nullable
as String?,forgetCompleted: null == forgetCompleted ? _self.forgetCompleted : forgetCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountEntityCopyWith<$Res> get account {
  
  return $AccountEntityCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}

// dart format on
