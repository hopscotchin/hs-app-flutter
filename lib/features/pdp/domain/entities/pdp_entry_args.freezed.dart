// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdp_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PdpEntryArgs {

/// e.g. `FromScreens.plp`, `FromScreens.discover`.
 String? get fromScreen;/// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
 String? get fromPage;/// Size of the feed the user came from, or null when the PDP was not opened
/// from a feed.
///
/// Nullable rather than defaulting to 0: a default of 0 used to be invisible
/// because the `num <= 0` rule discarded it, and with that rule gone it would
/// assert "the feed had no items" on every PDP opened outside a feed. Null means
/// unknown and is dropped; 0 would be a claim.
 int? get fromFeedSize;/// Tile position in the originating list, or null when there was no tile.
///
/// Nullable for the same reason: this defaulted to the sentinel `-1`, which the
/// `num <= 0` rule hid. Emitting `-1` as a position is worse than omitting it, so
/// the absence is now expressed in the type.
///
/// ⚠️ Callers currently pass a 1-based value (`index + 1`) — a workaround for the
/// same rule, since a 0-based first tile was dropped. That workaround is no longer
/// needed, but switching to the true 0-based index changes every position value, so
/// it needs checking against Android's PDP first.
 int? get position;/// `xl` / `normal` / `other`. Android defaults to `other`.
 String get sourceTileType;/// Tabbed-page context, when the user came through one.
 PdpTabPageArgs? get tabPage;
/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdpEntryArgsCopyWith<PdpEntryArgs> get copyWith => _$PdpEntryArgsCopyWithImpl<PdpEntryArgs>(this as PdpEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromPage, fromPage) || other.fromPage == fromPage)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize)&&(identical(other.position, position) || other.position == position)&&(identical(other.sourceTileType, sourceTileType) || other.sourceTileType == sourceTileType)&&(identical(other.tabPage, tabPage) || other.tabPage == tabPage));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromPage,fromFeedSize,position,sourceTileType,tabPage);

@override
String toString() {
  return 'PdpEntryArgs(fromScreen: $fromScreen, fromPage: $fromPage, fromFeedSize: $fromFeedSize, position: $position, sourceTileType: $sourceTileType, tabPage: $tabPage)';
}


}

/// @nodoc
abstract mixin class $PdpEntryArgsCopyWith<$Res>  {
  factory $PdpEntryArgsCopyWith(PdpEntryArgs value, $Res Function(PdpEntryArgs) _then) = _$PdpEntryArgsCopyWithImpl;
@useResult
$Res call({
 String? fromScreen, String? fromPage, int? fromFeedSize, int? position, String sourceTileType, PdpTabPageArgs? tabPage
});


$PdpTabPageArgsCopyWith<$Res>? get tabPage;

}
/// @nodoc
class _$PdpEntryArgsCopyWithImpl<$Res>
    implements $PdpEntryArgsCopyWith<$Res> {
  _$PdpEntryArgsCopyWithImpl(this._self, this._then);

  final PdpEntryArgs _self;
  final $Res Function(PdpEntryArgs) _then;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromScreen = freezed,Object? fromPage = freezed,Object? fromFeedSize = freezed,Object? position = freezed,Object? sourceTileType = null,Object? tabPage = freezed,}) {
  return _then(_self.copyWith(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromPage: freezed == fromPage ? _self.fromPage : fromPage // ignore: cast_nullable_to_non_nullable
as String?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,sourceTileType: null == sourceTileType ? _self.sourceTileType : sourceTileType // ignore: cast_nullable_to_non_nullable
as String,tabPage: freezed == tabPage ? _self.tabPage : tabPage // ignore: cast_nullable_to_non_nullable
as PdpTabPageArgs?,
  ));
}
/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PdpTabPageArgsCopyWith<$Res>? get tabPage {
    if (_self.tabPage == null) {
    return null;
  }

  return $PdpTabPageArgsCopyWith<$Res>(_self.tabPage!, (value) {
    return _then(_self.copyWith(tabPage: value));
  });
}
}


/// Adds pattern-matching-related methods to [PdpEntryArgs].
extension PdpEntryArgsPatterns on PdpEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PdpEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PdpEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _PdpEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PdpEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromPage,  int? fromFeedSize,  int? position,  String sourceTileType,  PdpTabPageArgs? tabPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize,_that.position,_that.sourceTileType,_that.tabPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromPage,  int? fromFeedSize,  int? position,  String sourceTileType,  PdpTabPageArgs? tabPage)  $default,) {final _that = this;
switch (_that) {
case _PdpEntryArgs():
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize,_that.position,_that.sourceTileType,_that.tabPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fromScreen,  String? fromPage,  int? fromFeedSize,  int? position,  String sourceTileType,  PdpTabPageArgs? tabPage)?  $default,) {final _that = this;
switch (_that) {
case _PdpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromPage,_that.fromFeedSize,_that.position,_that.sourceTileType,_that.tabPage);case _:
  return null;

}
}

}

/// @nodoc


class _PdpEntryArgs implements PdpEntryArgs {
  const _PdpEntryArgs({this.fromScreen, this.fromPage, this.fromFeedSize, this.position, this.sourceTileType = SourceTileType.other, this.tabPage});
  

/// e.g. `FromScreens.plp`, `FromScreens.discover`.
@override final  String? fromScreen;
/// e.g. `FromPage.recommendation`, `FromPage.recentlyViewed`.
@override final  String? fromPage;
/// Size of the feed the user came from, or null when the PDP was not opened
/// from a feed.
///
/// Nullable rather than defaulting to 0: a default of 0 used to be invisible
/// because the `num <= 0` rule discarded it, and with that rule gone it would
/// assert "the feed had no items" on every PDP opened outside a feed. Null means
/// unknown and is dropped; 0 would be a claim.
@override final  int? fromFeedSize;
/// Tile position in the originating list, or null when there was no tile.
///
/// Nullable for the same reason: this defaulted to the sentinel `-1`, which the
/// `num <= 0` rule hid. Emitting `-1` as a position is worse than omitting it, so
/// the absence is now expressed in the type.
///
/// ⚠️ Callers currently pass a 1-based value (`index + 1`) — a workaround for the
/// same rule, since a 0-based first tile was dropped. That workaround is no longer
/// needed, but switching to the true 0-based index changes every position value, so
/// it needs checking against Android's PDP first.
@override final  int? position;
/// `xl` / `normal` / `other`. Android defaults to `other`.
@override@JsonKey() final  String sourceTileType;
/// Tabbed-page context, when the user came through one.
@override final  PdpTabPageArgs? tabPage;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PdpEntryArgsCopyWith<_PdpEntryArgs> get copyWith => __$PdpEntryArgsCopyWithImpl<_PdpEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PdpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromPage, fromPage) || other.fromPage == fromPage)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize)&&(identical(other.position, position) || other.position == position)&&(identical(other.sourceTileType, sourceTileType) || other.sourceTileType == sourceTileType)&&(identical(other.tabPage, tabPage) || other.tabPage == tabPage));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromPage,fromFeedSize,position,sourceTileType,tabPage);

@override
String toString() {
  return 'PdpEntryArgs(fromScreen: $fromScreen, fromPage: $fromPage, fromFeedSize: $fromFeedSize, position: $position, sourceTileType: $sourceTileType, tabPage: $tabPage)';
}


}

/// @nodoc
abstract mixin class _$PdpEntryArgsCopyWith<$Res> implements $PdpEntryArgsCopyWith<$Res> {
  factory _$PdpEntryArgsCopyWith(_PdpEntryArgs value, $Res Function(_PdpEntryArgs) _then) = __$PdpEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 String? fromScreen, String? fromPage, int? fromFeedSize, int? position, String sourceTileType, PdpTabPageArgs? tabPage
});


@override $PdpTabPageArgsCopyWith<$Res>? get tabPage;

}
/// @nodoc
class __$PdpEntryArgsCopyWithImpl<$Res>
    implements _$PdpEntryArgsCopyWith<$Res> {
  __$PdpEntryArgsCopyWithImpl(this._self, this._then);

  final _PdpEntryArgs _self;
  final $Res Function(_PdpEntryArgs) _then;

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,Object? fromPage = freezed,Object? fromFeedSize = freezed,Object? position = freezed,Object? sourceTileType = null,Object? tabPage = freezed,}) {
  return _then(_PdpEntryArgs(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromPage: freezed == fromPage ? _self.fromPage : fromPage // ignore: cast_nullable_to_non_nullable
as String?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,sourceTileType: null == sourceTileType ? _self.sourceTileType : sourceTileType // ignore: cast_nullable_to_non_nullable
as String,tabPage: freezed == tabPage ? _self.tabPage : tabPage // ignore: cast_nullable_to_non_nullable
as PdpTabPageArgs?,
  ));
}

/// Create a copy of PdpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PdpTabPageArgsCopyWith<$Res>? get tabPage {
    if (_self.tabPage == null) {
    return null;
  }

  return $PdpTabPageArgsCopyWith<$Res>(_self.tabPage!, (value) {
    return _then(_self.copyWith(tabPage: value));
  });
}
}

/// @nodoc
mixin _$PdpTabPageArgs {

 String? get containerName; String? get containerId; String? get tabName; String? get tabPosition;
/// Create a copy of PdpTabPageArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdpTabPageArgsCopyWith<PdpTabPageArgs> get copyWith => _$PdpTabPageArgsCopyWithImpl<PdpTabPageArgs>(this as PdpTabPageArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdpTabPageArgs&&(identical(other.containerName, containerName) || other.containerName == containerName)&&(identical(other.containerId, containerId) || other.containerId == containerId)&&(identical(other.tabName, tabName) || other.tabName == tabName)&&(identical(other.tabPosition, tabPosition) || other.tabPosition == tabPosition));
}


@override
int get hashCode => Object.hash(runtimeType,containerName,containerId,tabName,tabPosition);

@override
String toString() {
  return 'PdpTabPageArgs(containerName: $containerName, containerId: $containerId, tabName: $tabName, tabPosition: $tabPosition)';
}


}

/// @nodoc
abstract mixin class $PdpTabPageArgsCopyWith<$Res>  {
  factory $PdpTabPageArgsCopyWith(PdpTabPageArgs value, $Res Function(PdpTabPageArgs) _then) = _$PdpTabPageArgsCopyWithImpl;
@useResult
$Res call({
 String? containerName, String? containerId, String? tabName, String? tabPosition
});




}
/// @nodoc
class _$PdpTabPageArgsCopyWithImpl<$Res>
    implements $PdpTabPageArgsCopyWith<$Res> {
  _$PdpTabPageArgsCopyWithImpl(this._self, this._then);

  final PdpTabPageArgs _self;
  final $Res Function(PdpTabPageArgs) _then;

/// Create a copy of PdpTabPageArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? containerName = freezed,Object? containerId = freezed,Object? tabName = freezed,Object? tabPosition = freezed,}) {
  return _then(_self.copyWith(
containerName: freezed == containerName ? _self.containerName : containerName // ignore: cast_nullable_to_non_nullable
as String?,containerId: freezed == containerId ? _self.containerId : containerId // ignore: cast_nullable_to_non_nullable
as String?,tabName: freezed == tabName ? _self.tabName : tabName // ignore: cast_nullable_to_non_nullable
as String?,tabPosition: freezed == tabPosition ? _self.tabPosition : tabPosition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PdpTabPageArgs].
extension PdpTabPageArgsPatterns on PdpTabPageArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PdpTabPageArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PdpTabPageArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PdpTabPageArgs value)  $default,){
final _that = this;
switch (_that) {
case _PdpTabPageArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PdpTabPageArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PdpTabPageArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? containerName,  String? containerId,  String? tabName,  String? tabPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PdpTabPageArgs() when $default != null:
return $default(_that.containerName,_that.containerId,_that.tabName,_that.tabPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? containerName,  String? containerId,  String? tabName,  String? tabPosition)  $default,) {final _that = this;
switch (_that) {
case _PdpTabPageArgs():
return $default(_that.containerName,_that.containerId,_that.tabName,_that.tabPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? containerName,  String? containerId,  String? tabName,  String? tabPosition)?  $default,) {final _that = this;
switch (_that) {
case _PdpTabPageArgs() when $default != null:
return $default(_that.containerName,_that.containerId,_that.tabName,_that.tabPosition);case _:
  return null;

}
}

}

/// @nodoc


class _PdpTabPageArgs implements PdpTabPageArgs {
  const _PdpTabPageArgs({this.containerName, this.containerId, this.tabName, this.tabPosition});
  

@override final  String? containerName;
@override final  String? containerId;
@override final  String? tabName;
@override final  String? tabPosition;

/// Create a copy of PdpTabPageArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PdpTabPageArgsCopyWith<_PdpTabPageArgs> get copyWith => __$PdpTabPageArgsCopyWithImpl<_PdpTabPageArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PdpTabPageArgs&&(identical(other.containerName, containerName) || other.containerName == containerName)&&(identical(other.containerId, containerId) || other.containerId == containerId)&&(identical(other.tabName, tabName) || other.tabName == tabName)&&(identical(other.tabPosition, tabPosition) || other.tabPosition == tabPosition));
}


@override
int get hashCode => Object.hash(runtimeType,containerName,containerId,tabName,tabPosition);

@override
String toString() {
  return 'PdpTabPageArgs(containerName: $containerName, containerId: $containerId, tabName: $tabName, tabPosition: $tabPosition)';
}


}

/// @nodoc
abstract mixin class _$PdpTabPageArgsCopyWith<$Res> implements $PdpTabPageArgsCopyWith<$Res> {
  factory _$PdpTabPageArgsCopyWith(_PdpTabPageArgs value, $Res Function(_PdpTabPageArgs) _then) = __$PdpTabPageArgsCopyWithImpl;
@override @useResult
$Res call({
 String? containerName, String? containerId, String? tabName, String? tabPosition
});




}
/// @nodoc
class __$PdpTabPageArgsCopyWithImpl<$Res>
    implements _$PdpTabPageArgsCopyWith<$Res> {
  __$PdpTabPageArgsCopyWithImpl(this._self, this._then);

  final _PdpTabPageArgs _self;
  final $Res Function(_PdpTabPageArgs) _then;

/// Create a copy of PdpTabPageArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? containerName = freezed,Object? containerId = freezed,Object? tabName = freezed,Object? tabPosition = freezed,}) {
  return _then(_PdpTabPageArgs(
containerName: freezed == containerName ? _self.containerName : containerName // ignore: cast_nullable_to_non_nullable
as String?,containerId: freezed == containerId ? _self.containerId : containerId // ignore: cast_nullable_to_non_nullable
as String?,tabName: freezed == tabName ? _self.tabName : tabName // ignore: cast_nullable_to_non_nullable
as String?,tabPosition: freezed == tabPosition ? _self.tabPosition : tabPosition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
