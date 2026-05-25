// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landing_page_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LandingPageEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingPageEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LandingPageEvent()';
}


}

/// @nodoc
class $LandingPageEventCopyWith<$Res>  {
$LandingPageEventCopyWith(LandingPageEvent _, $Res Function(LandingPageEvent) __);
}


/// Adds pattern-matching-related methods to [LandingPageEvent].
extension LandingPageEventPatterns on LandingPageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadLandingPage value)?  load,TResult Function( RefreshLandingPage value)?  refresh,TResult Function( LoadNextLandingPage value)?  loadNext,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadLandingPage() when load != null:
return load(_that);case RefreshLandingPage() when refresh != null:
return refresh(_that);case LoadNextLandingPage() when loadNext != null:
return loadNext(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadLandingPage value)  load,required TResult Function( RefreshLandingPage value)  refresh,required TResult Function( LoadNextLandingPage value)  loadNext,}){
final _that = this;
switch (_that) {
case LoadLandingPage():
return load(_that);case RefreshLandingPage():
return refresh(_that);case LoadNextLandingPage():
return loadNext(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadLandingPage value)?  load,TResult? Function( RefreshLandingPage value)?  refresh,TResult? Function( LoadNextLandingPage value)?  loadNext,}){
final _that = this;
switch (_that) {
case LoadLandingPage() when load != null:
return load(_that);case RefreshLandingPage() when refresh != null:
return refresh(_that);case LoadNextLandingPage() when loadNext != null:
return loadNext(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String pageName)?  load,TResult Function()?  refresh,TResult Function()?  loadNext,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadLandingPage() when load != null:
return load(_that.pageName);case RefreshLandingPage() when refresh != null:
return refresh();case LoadNextLandingPage() when loadNext != null:
return loadNext();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String pageName)  load,required TResult Function()  refresh,required TResult Function()  loadNext,}) {final _that = this;
switch (_that) {
case LoadLandingPage():
return load(_that.pageName);case RefreshLandingPage():
return refresh();case LoadNextLandingPage():
return loadNext();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String pageName)?  load,TResult? Function()?  refresh,TResult? Function()?  loadNext,}) {final _that = this;
switch (_that) {
case LoadLandingPage() when load != null:
return load(_that.pageName);case RefreshLandingPage() when refresh != null:
return refresh();case LoadNextLandingPage() when loadNext != null:
return loadNext();case _:
  return null;

}
}

}

/// @nodoc


class LoadLandingPage implements LandingPageEvent {
  const LoadLandingPage({required this.pageName});
  

 final  String pageName;

/// Create a copy of LandingPageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadLandingPageCopyWith<LoadLandingPage> get copyWith => _$LoadLandingPageCopyWithImpl<LoadLandingPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadLandingPage&&(identical(other.pageName, pageName) || other.pageName == pageName));
}


@override
int get hashCode => Object.hash(runtimeType,pageName);

@override
String toString() {
  return 'LandingPageEvent.load(pageName: $pageName)';
}


}

/// @nodoc
abstract mixin class $LoadLandingPageCopyWith<$Res> implements $LandingPageEventCopyWith<$Res> {
  factory $LoadLandingPageCopyWith(LoadLandingPage value, $Res Function(LoadLandingPage) _then) = _$LoadLandingPageCopyWithImpl;
@useResult
$Res call({
 String pageName
});




}
/// @nodoc
class _$LoadLandingPageCopyWithImpl<$Res>
    implements $LoadLandingPageCopyWith<$Res> {
  _$LoadLandingPageCopyWithImpl(this._self, this._then);

  final LoadLandingPage _self;
  final $Res Function(LoadLandingPage) _then;

/// Create a copy of LandingPageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pageName = null,}) {
  return _then(LoadLandingPage(
pageName: null == pageName ? _self.pageName : pageName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RefreshLandingPage implements LandingPageEvent {
  const RefreshLandingPage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshLandingPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LandingPageEvent.refresh()';
}


}




/// @nodoc


class LoadNextLandingPage implements LandingPageEvent {
  const LoadNextLandingPage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadNextLandingPage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LandingPageEvent.loadNext()';
}


}




/// @nodoc
mixin _$LandingPageState {

 LandingPageStatus get status; HomePageEntity? get homePage; bool get isLoadingMore; String get errorMessage;
/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandingPageStateCopyWith<LandingPageState> get copyWith => _$LandingPageStateCopyWithImpl<LandingPageState>(this as LandingPageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandingPageState&&(identical(other.status, status) || other.status == status)&&(identical(other.homePage, homePage) || other.homePage == homePage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,homePage,isLoadingMore,errorMessage);

@override
String toString() {
  return 'LandingPageState(status: $status, homePage: $homePage, isLoadingMore: $isLoadingMore, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LandingPageStateCopyWith<$Res>  {
  factory $LandingPageStateCopyWith(LandingPageState value, $Res Function(LandingPageState) _then) = _$LandingPageStateCopyWithImpl;
@useResult
$Res call({
 LandingPageStatus status, HomePageEntity? homePage, bool isLoadingMore, String errorMessage
});


$HomePageEntityCopyWith<$Res>? get homePage;

}
/// @nodoc
class _$LandingPageStateCopyWithImpl<$Res>
    implements $LandingPageStateCopyWith<$Res> {
  _$LandingPageStateCopyWithImpl(this._self, this._then);

  final LandingPageState _self;
  final $Res Function(LandingPageState) _then;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? homePage = freezed,Object? isLoadingMore = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LandingPageStatus,homePage: freezed == homePage ? _self.homePage : homePage // ignore: cast_nullable_to_non_nullable
as HomePageEntity?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomePageEntityCopyWith<$Res>? get homePage {
    if (_self.homePage == null) {
    return null;
  }

  return $HomePageEntityCopyWith<$Res>(_self.homePage!, (value) {
    return _then(_self.copyWith(homePage: value));
  });
}
}


/// Adds pattern-matching-related methods to [LandingPageState].
extension LandingPageStatePatterns on LandingPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LandingPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LandingPageState value)  $default,){
final _that = this;
switch (_that) {
case _LandingPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LandingPageState value)?  $default,){
final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LandingPageStatus status,  HomePageEntity? homePage,  bool isLoadingMore,  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
return $default(_that.status,_that.homePage,_that.isLoadingMore,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LandingPageStatus status,  HomePageEntity? homePage,  bool isLoadingMore,  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LandingPageState():
return $default(_that.status,_that.homePage,_that.isLoadingMore,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LandingPageStatus status,  HomePageEntity? homePage,  bool isLoadingMore,  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LandingPageState() when $default != null:
return $default(_that.status,_that.homePage,_that.isLoadingMore,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LandingPageState implements LandingPageState {
  const _LandingPageState({this.status = LandingPageStatus.initial, this.homePage, this.isLoadingMore = false, this.errorMessage = ''});
  

@override@JsonKey() final  LandingPageStatus status;
@override final  HomePageEntity? homePage;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  String errorMessage;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LandingPageStateCopyWith<_LandingPageState> get copyWith => __$LandingPageStateCopyWithImpl<_LandingPageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandingPageState&&(identical(other.status, status) || other.status == status)&&(identical(other.homePage, homePage) || other.homePage == homePage)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,homePage,isLoadingMore,errorMessage);

@override
String toString() {
  return 'LandingPageState(status: $status, homePage: $homePage, isLoadingMore: $isLoadingMore, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LandingPageStateCopyWith<$Res> implements $LandingPageStateCopyWith<$Res> {
  factory _$LandingPageStateCopyWith(_LandingPageState value, $Res Function(_LandingPageState) _then) = __$LandingPageStateCopyWithImpl;
@override @useResult
$Res call({
 LandingPageStatus status, HomePageEntity? homePage, bool isLoadingMore, String errorMessage
});


@override $HomePageEntityCopyWith<$Res>? get homePage;

}
/// @nodoc
class __$LandingPageStateCopyWithImpl<$Res>
    implements _$LandingPageStateCopyWith<$Res> {
  __$LandingPageStateCopyWithImpl(this._self, this._then);

  final _LandingPageState _self;
  final $Res Function(_LandingPageState) _then;

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? homePage = freezed,Object? isLoadingMore = null,Object? errorMessage = null,}) {
  return _then(_LandingPageState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LandingPageStatus,homePage: freezed == homePage ? _self.homePage : homePage // ignore: cast_nullable_to_non_nullable
as HomePageEntity?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LandingPageState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomePageEntityCopyWith<$Res>? get homePage {
    if (_self.homePage == null) {
    return null;
  }

  return $HomePageEntityCopyWith<$Res>(_self.homePage!, (value) {
    return _then(_self.copyWith(homePage: value));
  });
}
}

// dart format on
