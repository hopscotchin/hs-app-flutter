// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplashState {

 SplashStatus get status; SplashLoadingStep get loadingStep; Environment? get pendingEnvironment; CustomerInfoEntity? get customerInfo; String get errorMessage; SplashErrorType get errorType; String? get processedDeeplink;
/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplashStateCopyWith<SplashState> get copyWith => _$SplashStateCopyWithImpl<SplashState>(this as SplashState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashState&&(identical(other.status, status) || other.status == status)&&(identical(other.loadingStep, loadingStep) || other.loadingStep == loadingStep)&&(identical(other.pendingEnvironment, pendingEnvironment) || other.pendingEnvironment == pendingEnvironment)&&(identical(other.customerInfo, customerInfo) || other.customerInfo == customerInfo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.processedDeeplink, processedDeeplink) || other.processedDeeplink == processedDeeplink));
}


@override
int get hashCode => Object.hash(runtimeType,status,loadingStep,pendingEnvironment,customerInfo,errorMessage,errorType,processedDeeplink);

@override
String toString() {
  return 'SplashState(status: $status, loadingStep: $loadingStep, pendingEnvironment: $pendingEnvironment, customerInfo: $customerInfo, errorMessage: $errorMessage, errorType: $errorType, processedDeeplink: $processedDeeplink)';
}


}

/// @nodoc
abstract mixin class $SplashStateCopyWith<$Res>  {
  factory $SplashStateCopyWith(SplashState value, $Res Function(SplashState) _then) = _$SplashStateCopyWithImpl;
@useResult
$Res call({
 SplashStatus status, SplashLoadingStep loadingStep, Environment? pendingEnvironment, CustomerInfoEntity? customerInfo, String errorMessage, SplashErrorType errorType, String? processedDeeplink
});


$CustomerInfoEntityCopyWith<$Res>? get customerInfo;

}
/// @nodoc
class _$SplashStateCopyWithImpl<$Res>
    implements $SplashStateCopyWith<$Res> {
  _$SplashStateCopyWithImpl(this._self, this._then);

  final SplashState _self;
  final $Res Function(SplashState) _then;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? loadingStep = null,Object? pendingEnvironment = freezed,Object? customerInfo = freezed,Object? errorMessage = null,Object? errorType = null,Object? processedDeeplink = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SplashStatus,loadingStep: null == loadingStep ? _self.loadingStep : loadingStep // ignore: cast_nullable_to_non_nullable
as SplashLoadingStep,pendingEnvironment: freezed == pendingEnvironment ? _self.pendingEnvironment : pendingEnvironment // ignore: cast_nullable_to_non_nullable
as Environment?,customerInfo: freezed == customerInfo ? _self.customerInfo : customerInfo // ignore: cast_nullable_to_non_nullable
as CustomerInfoEntity?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as SplashErrorType,processedDeeplink: freezed == processedDeeplink ? _self.processedDeeplink : processedDeeplink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoEntityCopyWith<$Res>? get customerInfo {
    if (_self.customerInfo == null) {
    return null;
  }

  return $CustomerInfoEntityCopyWith<$Res>(_self.customerInfo!, (value) {
    return _then(_self.copyWith(customerInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [SplashState].
extension SplashStatePatterns on SplashState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplashState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplashState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplashState value)  $default,){
final _that = this;
switch (_that) {
case _SplashState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplashState value)?  $default,){
final _that = this;
switch (_that) {
case _SplashState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SplashStatus status,  SplashLoadingStep loadingStep,  Environment? pendingEnvironment,  CustomerInfoEntity? customerInfo,  String errorMessage,  SplashErrorType errorType,  String? processedDeeplink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.status,_that.loadingStep,_that.pendingEnvironment,_that.customerInfo,_that.errorMessage,_that.errorType,_that.processedDeeplink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SplashStatus status,  SplashLoadingStep loadingStep,  Environment? pendingEnvironment,  CustomerInfoEntity? customerInfo,  String errorMessage,  SplashErrorType errorType,  String? processedDeeplink)  $default,) {final _that = this;
switch (_that) {
case _SplashState():
return $default(_that.status,_that.loadingStep,_that.pendingEnvironment,_that.customerInfo,_that.errorMessage,_that.errorType,_that.processedDeeplink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SplashStatus status,  SplashLoadingStep loadingStep,  Environment? pendingEnvironment,  CustomerInfoEntity? customerInfo,  String errorMessage,  SplashErrorType errorType,  String? processedDeeplink)?  $default,) {final _that = this;
switch (_that) {
case _SplashState() when $default != null:
return $default(_that.status,_that.loadingStep,_that.pendingEnvironment,_that.customerInfo,_that.errorMessage,_that.errorType,_that.processedDeeplink);case _:
  return null;

}
}

}

/// @nodoc


class _SplashState implements SplashState {
  const _SplashState({this.status = SplashStatus.initial, this.loadingStep = SplashLoadingStep.starting, this.pendingEnvironment, this.customerInfo, this.errorMessage = '', this.errorType = SplashErrorType.unknown, this.processedDeeplink});
  

@override@JsonKey() final  SplashStatus status;
@override@JsonKey() final  SplashLoadingStep loadingStep;
@override final  Environment? pendingEnvironment;
@override final  CustomerInfoEntity? customerInfo;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  SplashErrorType errorType;
@override final  String? processedDeeplink;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplashStateCopyWith<_SplashState> get copyWith => __$SplashStateCopyWithImpl<_SplashState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplashState&&(identical(other.status, status) || other.status == status)&&(identical(other.loadingStep, loadingStep) || other.loadingStep == loadingStep)&&(identical(other.pendingEnvironment, pendingEnvironment) || other.pendingEnvironment == pendingEnvironment)&&(identical(other.customerInfo, customerInfo) || other.customerInfo == customerInfo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.processedDeeplink, processedDeeplink) || other.processedDeeplink == processedDeeplink));
}


@override
int get hashCode => Object.hash(runtimeType,status,loadingStep,pendingEnvironment,customerInfo,errorMessage,errorType,processedDeeplink);

@override
String toString() {
  return 'SplashState(status: $status, loadingStep: $loadingStep, pendingEnvironment: $pendingEnvironment, customerInfo: $customerInfo, errorMessage: $errorMessage, errorType: $errorType, processedDeeplink: $processedDeeplink)';
}


}

/// @nodoc
abstract mixin class _$SplashStateCopyWith<$Res> implements $SplashStateCopyWith<$Res> {
  factory _$SplashStateCopyWith(_SplashState value, $Res Function(_SplashState) _then) = __$SplashStateCopyWithImpl;
@override @useResult
$Res call({
 SplashStatus status, SplashLoadingStep loadingStep, Environment? pendingEnvironment, CustomerInfoEntity? customerInfo, String errorMessage, SplashErrorType errorType, String? processedDeeplink
});


@override $CustomerInfoEntityCopyWith<$Res>? get customerInfo;

}
/// @nodoc
class __$SplashStateCopyWithImpl<$Res>
    implements _$SplashStateCopyWith<$Res> {
  __$SplashStateCopyWithImpl(this._self, this._then);

  final _SplashState _self;
  final $Res Function(_SplashState) _then;

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? loadingStep = null,Object? pendingEnvironment = freezed,Object? customerInfo = freezed,Object? errorMessage = null,Object? errorType = null,Object? processedDeeplink = freezed,}) {
  return _then(_SplashState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SplashStatus,loadingStep: null == loadingStep ? _self.loadingStep : loadingStep // ignore: cast_nullable_to_non_nullable
as SplashLoadingStep,pendingEnvironment: freezed == pendingEnvironment ? _self.pendingEnvironment : pendingEnvironment // ignore: cast_nullable_to_non_nullable
as Environment?,customerInfo: freezed == customerInfo ? _self.customerInfo : customerInfo // ignore: cast_nullable_to_non_nullable
as CustomerInfoEntity?,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as SplashErrorType,processedDeeplink: freezed == processedDeeplink ? _self.processedDeeplink : processedDeeplink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SplashState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoEntityCopyWith<$Res>? get customerInfo {
    if (_self.customerInfo == null) {
    return null;
  }

  return $CustomerInfoEntityCopyWith<$Res>(_self.customerInfo!, (value) {
    return _then(_self.copyWith(customerInfo: value));
  });
}
}

// dart format on
