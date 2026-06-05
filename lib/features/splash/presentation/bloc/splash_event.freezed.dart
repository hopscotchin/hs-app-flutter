// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplashEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashEvent()';
}


}

/// @nodoc
class $SplashEventCopyWith<$Res>  {
$SplashEventCopyWith(SplashEvent _, $Res Function(SplashEvent) __);
}


/// Adds pattern-matching-related methods to [SplashEvent].
extension SplashEventPatterns on SplashEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitializeApp value)?  initializeApp,TResult Function( SelectEnvironment value)?  selectEnvironment,TResult Function( HandleDeeplink value)?  handleDeeplink,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitializeApp() when initializeApp != null:
return initializeApp(_that);case SelectEnvironment() when selectEnvironment != null:
return selectEnvironment(_that);case HandleDeeplink() when handleDeeplink != null:
return handleDeeplink(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitializeApp value)  initializeApp,required TResult Function( SelectEnvironment value)  selectEnvironment,required TResult Function( HandleDeeplink value)  handleDeeplink,}){
final _that = this;
switch (_that) {
case InitializeApp():
return initializeApp(_that);case SelectEnvironment():
return selectEnvironment(_that);case HandleDeeplink():
return handleDeeplink(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitializeApp value)?  initializeApp,TResult? Function( SelectEnvironment value)?  selectEnvironment,TResult? Function( HandleDeeplink value)?  handleDeeplink,}){
final _that = this;
switch (_that) {
case InitializeApp() when initializeApp != null:
return initializeApp(_that);case SelectEnvironment() when selectEnvironment != null:
return selectEnvironment(_that);case HandleDeeplink() when handleDeeplink != null:
return handleDeeplink(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initializeApp,TResult Function( Environment environment)?  selectEnvironment,TResult Function( String deeplink)?  handleDeeplink,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitializeApp() when initializeApp != null:
return initializeApp();case SelectEnvironment() when selectEnvironment != null:
return selectEnvironment(_that.environment);case HandleDeeplink() when handleDeeplink != null:
return handleDeeplink(_that.deeplink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initializeApp,required TResult Function( Environment environment)  selectEnvironment,required TResult Function( String deeplink)  handleDeeplink,}) {final _that = this;
switch (_that) {
case InitializeApp():
return initializeApp();case SelectEnvironment():
return selectEnvironment(_that.environment);case HandleDeeplink():
return handleDeeplink(_that.deeplink);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initializeApp,TResult? Function( Environment environment)?  selectEnvironment,TResult? Function( String deeplink)?  handleDeeplink,}) {final _that = this;
switch (_that) {
case InitializeApp() when initializeApp != null:
return initializeApp();case SelectEnvironment() when selectEnvironment != null:
return selectEnvironment(_that.environment);case HandleDeeplink() when handleDeeplink != null:
return handleDeeplink(_that.deeplink);case _:
  return null;

}
}

}

/// @nodoc


class InitializeApp implements SplashEvent {
  const InitializeApp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitializeApp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashEvent.initializeApp()';
}


}




/// @nodoc


class SelectEnvironment implements SplashEvent {
  const SelectEnvironment(this.environment);
  

 final  Environment environment;

/// Create a copy of SplashEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectEnvironmentCopyWith<SelectEnvironment> get copyWith => _$SelectEnvironmentCopyWithImpl<SelectEnvironment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectEnvironment&&(identical(other.environment, environment) || other.environment == environment));
}


@override
int get hashCode => Object.hash(runtimeType,environment);

@override
String toString() {
  return 'SplashEvent.selectEnvironment(environment: $environment)';
}


}

/// @nodoc
abstract mixin class $SelectEnvironmentCopyWith<$Res> implements $SplashEventCopyWith<$Res> {
  factory $SelectEnvironmentCopyWith(SelectEnvironment value, $Res Function(SelectEnvironment) _then) = _$SelectEnvironmentCopyWithImpl;
@useResult
$Res call({
 Environment environment
});




}
/// @nodoc
class _$SelectEnvironmentCopyWithImpl<$Res>
    implements $SelectEnvironmentCopyWith<$Res> {
  _$SelectEnvironmentCopyWithImpl(this._self, this._then);

  final SelectEnvironment _self;
  final $Res Function(SelectEnvironment) _then;

/// Create a copy of SplashEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? environment = null,}) {
  return _then(SelectEnvironment(
null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,
  ));
}


}

/// @nodoc


class HandleDeeplink implements SplashEvent {
  const HandleDeeplink(this.deeplink);
  

 final  String deeplink;

/// Create a copy of SplashEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandleDeeplinkCopyWith<HandleDeeplink> get copyWith => _$HandleDeeplinkCopyWithImpl<HandleDeeplink>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandleDeeplink&&(identical(other.deeplink, deeplink) || other.deeplink == deeplink));
}


@override
int get hashCode => Object.hash(runtimeType,deeplink);

@override
String toString() {
  return 'SplashEvent.handleDeeplink(deeplink: $deeplink)';
}


}

/// @nodoc
abstract mixin class $HandleDeeplinkCopyWith<$Res> implements $SplashEventCopyWith<$Res> {
  factory $HandleDeeplinkCopyWith(HandleDeeplink value, $Res Function(HandleDeeplink) _then) = _$HandleDeeplinkCopyWithImpl;
@useResult
$Res call({
 String deeplink
});




}
/// @nodoc
class _$HandleDeeplinkCopyWithImpl<$Res>
    implements $HandleDeeplinkCopyWith<$Res> {
  _$HandleDeeplinkCopyWithImpl(this._self, this._then);

  final HandleDeeplink _self;
  final $Res Function(HandleDeeplink) _then;

/// Create a copy of SplashEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deeplink = null,}) {
  return _then(HandleDeeplink(
null == deeplink ? _self.deeplink : deeplink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
