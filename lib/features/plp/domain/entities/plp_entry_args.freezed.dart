// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plp_entry_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlpEntryArgs {

/// The screen the user came from — e.g. `FromScreens.discover`,
/// `FromScreens.categories`, or a landing-page name.
 String? get fromScreen;/// The control that was tapped — e.g. `FromLocations.customTile`,
/// `FromLocations.categoryTile`, `FromLocations.searchBox`.
 String? get fromLocation;/// Tile position in the originating list. Null when there was no tile.
///
/// Nullable rather than defaulting to 0, and that matters more than it
/// looks: this codebase keeps zeros on the wire (see `AnalyticsMap`), so a
/// 0 default would not be quietly swallowed — it would ship, claiming the
/// tile sat at position zero. Null is dropped; 0 is a claim.
 int? get position;/// Row index of the originating component.
 int? get row;/// Size of the feed the user came from. Null means unknown; 0 would be a
/// claim that the feed was empty.
 int? get fromFeedSize;/// Free-form navigation detail Android threads through as
/// `ADD_FROM_DETAILS` (tile action metadata).
 String? get addFromDetails;/// 1-indexed rank of the tapped autocomplete suggestion. Android sets it
/// as `IntentHelper.SUGGESTION_INDEX = position + 1`
/// (`SearchAutocompleteActivity.kt:256`) and PLPAnalytics emits it in the
/// search branch only.
 int? get suggestionIndex;/// The query the search was executed with. Android's search branch emits
/// it as `keyword`, plus its character count as `length`
/// (`PLPAnalytics.kt:876-877`) — both client-owned, because the backend
/// blob reports the *resolved* search parameters rather than what the user
/// actually typed.
 String? get keyword;/// The autocomplete suggestion's own `trackingData`, merged wholesale into
/// the search payload (`PLPAnalytics.kt:838-840`). Server-shaped, so it is
/// spread untouched and loses to any explicit client value on collision.
 Map<String, dynamic>? get suggestionTrackingData;
/// Create a copy of PlpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlpEntryArgsCopyWith<PlpEntryArgs> get copyWith => _$PlpEntryArgsCopyWithImpl<PlpEntryArgs>(this as PlpEntryArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromLocation, fromLocation) || other.fromLocation == fromLocation)&&(identical(other.position, position) || other.position == position)&&(identical(other.row, row) || other.row == row)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize)&&(identical(other.addFromDetails, addFromDetails) || other.addFromDetails == addFromDetails)&&(identical(other.suggestionIndex, suggestionIndex) || other.suggestionIndex == suggestionIndex)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&const DeepCollectionEquality().equals(other.suggestionTrackingData, suggestionTrackingData));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromLocation,position,row,fromFeedSize,addFromDetails,suggestionIndex,keyword,const DeepCollectionEquality().hash(suggestionTrackingData));

@override
String toString() {
  return 'PlpEntryArgs(fromScreen: $fromScreen, fromLocation: $fromLocation, position: $position, row: $row, fromFeedSize: $fromFeedSize, addFromDetails: $addFromDetails, suggestionIndex: $suggestionIndex, keyword: $keyword, suggestionTrackingData: $suggestionTrackingData)';
}


}

/// @nodoc
abstract mixin class $PlpEntryArgsCopyWith<$Res>  {
  factory $PlpEntryArgsCopyWith(PlpEntryArgs value, $Res Function(PlpEntryArgs) _then) = _$PlpEntryArgsCopyWithImpl;
@useResult
$Res call({
 String? fromScreen, String? fromLocation, int? position, int? row, int? fromFeedSize, String? addFromDetails, int? suggestionIndex, String? keyword, Map<String, dynamic>? suggestionTrackingData
});




}
/// @nodoc
class _$PlpEntryArgsCopyWithImpl<$Res>
    implements $PlpEntryArgsCopyWith<$Res> {
  _$PlpEntryArgsCopyWithImpl(this._self, this._then);

  final PlpEntryArgs _self;
  final $Res Function(PlpEntryArgs) _then;

/// Create a copy of PlpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromScreen = freezed,Object? fromLocation = freezed,Object? position = freezed,Object? row = freezed,Object? fromFeedSize = freezed,Object? addFromDetails = freezed,Object? suggestionIndex = freezed,Object? keyword = freezed,Object? suggestionTrackingData = freezed,}) {
  return _then(_self.copyWith(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromLocation: freezed == fromLocation ? _self.fromLocation : fromLocation // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,row: freezed == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,addFromDetails: freezed == addFromDetails ? _self.addFromDetails : addFromDetails // ignore: cast_nullable_to_non_nullable
as String?,suggestionIndex: freezed == suggestionIndex ? _self.suggestionIndex : suggestionIndex // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,suggestionTrackingData: freezed == suggestionTrackingData ? _self.suggestionTrackingData : suggestionTrackingData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlpEntryArgs].
extension PlpEntryArgsPatterns on PlpEntryArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlpEntryArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlpEntryArgs value)  $default,){
final _that = this;
switch (_that) {
case _PlpEntryArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlpEntryArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PlpEntryArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromLocation,  int? position,  int? row,  int? fromFeedSize,  String? addFromDetails,  int? suggestionIndex,  String? keyword,  Map<String, dynamic>? suggestionTrackingData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromLocation,_that.position,_that.row,_that.fromFeedSize,_that.addFromDetails,_that.suggestionIndex,_that.keyword,_that.suggestionTrackingData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fromScreen,  String? fromLocation,  int? position,  int? row,  int? fromFeedSize,  String? addFromDetails,  int? suggestionIndex,  String? keyword,  Map<String, dynamic>? suggestionTrackingData)  $default,) {final _that = this;
switch (_that) {
case _PlpEntryArgs():
return $default(_that.fromScreen,_that.fromLocation,_that.position,_that.row,_that.fromFeedSize,_that.addFromDetails,_that.suggestionIndex,_that.keyword,_that.suggestionTrackingData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fromScreen,  String? fromLocation,  int? position,  int? row,  int? fromFeedSize,  String? addFromDetails,  int? suggestionIndex,  String? keyword,  Map<String, dynamic>? suggestionTrackingData)?  $default,) {final _that = this;
switch (_that) {
case _PlpEntryArgs() when $default != null:
return $default(_that.fromScreen,_that.fromLocation,_that.position,_that.row,_that.fromFeedSize,_that.addFromDetails,_that.suggestionIndex,_that.keyword,_that.suggestionTrackingData);case _:
  return null;

}
}

}

/// @nodoc


class _PlpEntryArgs implements PlpEntryArgs {
  const _PlpEntryArgs({this.fromScreen, this.fromLocation, this.position, this.row, this.fromFeedSize, this.addFromDetails, this.suggestionIndex, this.keyword, final  Map<String, dynamic>? suggestionTrackingData}): _suggestionTrackingData = suggestionTrackingData;
  

/// The screen the user came from — e.g. `FromScreens.discover`,
/// `FromScreens.categories`, or a landing-page name.
@override final  String? fromScreen;
/// The control that was tapped — e.g. `FromLocations.customTile`,
/// `FromLocations.categoryTile`, `FromLocations.searchBox`.
@override final  String? fromLocation;
/// Tile position in the originating list. Null when there was no tile.
///
/// Nullable rather than defaulting to 0, and that matters more than it
/// looks: this codebase keeps zeros on the wire (see `AnalyticsMap`), so a
/// 0 default would not be quietly swallowed — it would ship, claiming the
/// tile sat at position zero. Null is dropped; 0 is a claim.
@override final  int? position;
/// Row index of the originating component.
@override final  int? row;
/// Size of the feed the user came from. Null means unknown; 0 would be a
/// claim that the feed was empty.
@override final  int? fromFeedSize;
/// Free-form navigation detail Android threads through as
/// `ADD_FROM_DETAILS` (tile action metadata).
@override final  String? addFromDetails;
/// 1-indexed rank of the tapped autocomplete suggestion. Android sets it
/// as `IntentHelper.SUGGESTION_INDEX = position + 1`
/// (`SearchAutocompleteActivity.kt:256`) and PLPAnalytics emits it in the
/// search branch only.
@override final  int? suggestionIndex;
/// The query the search was executed with. Android's search branch emits
/// it as `keyword`, plus its character count as `length`
/// (`PLPAnalytics.kt:876-877`) — both client-owned, because the backend
/// blob reports the *resolved* search parameters rather than what the user
/// actually typed.
@override final  String? keyword;
/// The autocomplete suggestion's own `trackingData`, merged wholesale into
/// the search payload (`PLPAnalytics.kt:838-840`). Server-shaped, so it is
/// spread untouched and loses to any explicit client value on collision.
 final  Map<String, dynamic>? _suggestionTrackingData;
/// The autocomplete suggestion's own `trackingData`, merged wholesale into
/// the search payload (`PLPAnalytics.kt:838-840`). Server-shaped, so it is
/// spread untouched and loses to any explicit client value on collision.
@override Map<String, dynamic>? get suggestionTrackingData {
  final value = _suggestionTrackingData;
  if (value == null) return null;
  if (_suggestionTrackingData is EqualUnmodifiableMapView) return _suggestionTrackingData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PlpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlpEntryArgsCopyWith<_PlpEntryArgs> get copyWith => __$PlpEntryArgsCopyWithImpl<_PlpEntryArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlpEntryArgs&&(identical(other.fromScreen, fromScreen) || other.fromScreen == fromScreen)&&(identical(other.fromLocation, fromLocation) || other.fromLocation == fromLocation)&&(identical(other.position, position) || other.position == position)&&(identical(other.row, row) || other.row == row)&&(identical(other.fromFeedSize, fromFeedSize) || other.fromFeedSize == fromFeedSize)&&(identical(other.addFromDetails, addFromDetails) || other.addFromDetails == addFromDetails)&&(identical(other.suggestionIndex, suggestionIndex) || other.suggestionIndex == suggestionIndex)&&(identical(other.keyword, keyword) || other.keyword == keyword)&&const DeepCollectionEquality().equals(other._suggestionTrackingData, _suggestionTrackingData));
}


@override
int get hashCode => Object.hash(runtimeType,fromScreen,fromLocation,position,row,fromFeedSize,addFromDetails,suggestionIndex,keyword,const DeepCollectionEquality().hash(_suggestionTrackingData));

@override
String toString() {
  return 'PlpEntryArgs(fromScreen: $fromScreen, fromLocation: $fromLocation, position: $position, row: $row, fromFeedSize: $fromFeedSize, addFromDetails: $addFromDetails, suggestionIndex: $suggestionIndex, keyword: $keyword, suggestionTrackingData: $suggestionTrackingData)';
}


}

/// @nodoc
abstract mixin class _$PlpEntryArgsCopyWith<$Res> implements $PlpEntryArgsCopyWith<$Res> {
  factory _$PlpEntryArgsCopyWith(_PlpEntryArgs value, $Res Function(_PlpEntryArgs) _then) = __$PlpEntryArgsCopyWithImpl;
@override @useResult
$Res call({
 String? fromScreen, String? fromLocation, int? position, int? row, int? fromFeedSize, String? addFromDetails, int? suggestionIndex, String? keyword, Map<String, dynamic>? suggestionTrackingData
});




}
/// @nodoc
class __$PlpEntryArgsCopyWithImpl<$Res>
    implements _$PlpEntryArgsCopyWith<$Res> {
  __$PlpEntryArgsCopyWithImpl(this._self, this._then);

  final _PlpEntryArgs _self;
  final $Res Function(_PlpEntryArgs) _then;

/// Create a copy of PlpEntryArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromScreen = freezed,Object? fromLocation = freezed,Object? position = freezed,Object? row = freezed,Object? fromFeedSize = freezed,Object? addFromDetails = freezed,Object? suggestionIndex = freezed,Object? keyword = freezed,Object? suggestionTrackingData = freezed,}) {
  return _then(_PlpEntryArgs(
fromScreen: freezed == fromScreen ? _self.fromScreen : fromScreen // ignore: cast_nullable_to_non_nullable
as String?,fromLocation: freezed == fromLocation ? _self.fromLocation : fromLocation // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,row: freezed == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int?,fromFeedSize: freezed == fromFeedSize ? _self.fromFeedSize : fromFeedSize // ignore: cast_nullable_to_non_nullable
as int?,addFromDetails: freezed == addFromDetails ? _self.addFromDetails : addFromDetails // ignore: cast_nullable_to_non_nullable
as String?,suggestionIndex: freezed == suggestionIndex ? _self.suggestionIndex : suggestionIndex // ignore: cast_nullable_to_non_nullable
as int?,keyword: freezed == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String?,suggestionTrackingData: freezed == suggestionTrackingData ? _self._suggestionTrackingData : suggestionTrackingData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
