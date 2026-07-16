// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recently_viewed_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecentlyViewedViewConfigEntity {

 double get tileWidth; double get tileHeight; int get minTilesToShow; double get imageCornerRadius; bool get navigation; bool get snapping; bool get showPageIndicators; int get peepingFactor;
/// Create a copy of RecentlyViewedViewConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentlyViewedViewConfigEntityCopyWith<RecentlyViewedViewConfigEntity> get copyWith => _$RecentlyViewedViewConfigEntityCopyWithImpl<RecentlyViewedViewConfigEntity>(this as RecentlyViewedViewConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentlyViewedViewConfigEntity&&(identical(other.tileWidth, tileWidth) || other.tileWidth == tileWidth)&&(identical(other.tileHeight, tileHeight) || other.tileHeight == tileHeight)&&(identical(other.minTilesToShow, minTilesToShow) || other.minTilesToShow == minTilesToShow)&&(identical(other.imageCornerRadius, imageCornerRadius) || other.imageCornerRadius == imageCornerRadius)&&(identical(other.navigation, navigation) || other.navigation == navigation)&&(identical(other.snapping, snapping) || other.snapping == snapping)&&(identical(other.showPageIndicators, showPageIndicators) || other.showPageIndicators == showPageIndicators)&&(identical(other.peepingFactor, peepingFactor) || other.peepingFactor == peepingFactor));
}


@override
int get hashCode => Object.hash(runtimeType,tileWidth,tileHeight,minTilesToShow,imageCornerRadius,navigation,snapping,showPageIndicators,peepingFactor);

@override
String toString() {
  return 'RecentlyViewedViewConfigEntity(tileWidth: $tileWidth, tileHeight: $tileHeight, minTilesToShow: $minTilesToShow, imageCornerRadius: $imageCornerRadius, navigation: $navigation, snapping: $snapping, showPageIndicators: $showPageIndicators, peepingFactor: $peepingFactor)';
}


}

/// @nodoc
abstract mixin class $RecentlyViewedViewConfigEntityCopyWith<$Res>  {
  factory $RecentlyViewedViewConfigEntityCopyWith(RecentlyViewedViewConfigEntity value, $Res Function(RecentlyViewedViewConfigEntity) _then) = _$RecentlyViewedViewConfigEntityCopyWithImpl;
@useResult
$Res call({
 double tileWidth, double tileHeight, int minTilesToShow, double imageCornerRadius, bool navigation, bool snapping, bool showPageIndicators, int peepingFactor
});




}
/// @nodoc
class _$RecentlyViewedViewConfigEntityCopyWithImpl<$Res>
    implements $RecentlyViewedViewConfigEntityCopyWith<$Res> {
  _$RecentlyViewedViewConfigEntityCopyWithImpl(this._self, this._then);

  final RecentlyViewedViewConfigEntity _self;
  final $Res Function(RecentlyViewedViewConfigEntity) _then;

/// Create a copy of RecentlyViewedViewConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tileWidth = null,Object? tileHeight = null,Object? minTilesToShow = null,Object? imageCornerRadius = null,Object? navigation = null,Object? snapping = null,Object? showPageIndicators = null,Object? peepingFactor = null,}) {
  return _then(_self.copyWith(
tileWidth: null == tileWidth ? _self.tileWidth : tileWidth // ignore: cast_nullable_to_non_nullable
as double,tileHeight: null == tileHeight ? _self.tileHeight : tileHeight // ignore: cast_nullable_to_non_nullable
as double,minTilesToShow: null == minTilesToShow ? _self.minTilesToShow : minTilesToShow // ignore: cast_nullable_to_non_nullable
as int,imageCornerRadius: null == imageCornerRadius ? _self.imageCornerRadius : imageCornerRadius // ignore: cast_nullable_to_non_nullable
as double,navigation: null == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as bool,snapping: null == snapping ? _self.snapping : snapping // ignore: cast_nullable_to_non_nullable
as bool,showPageIndicators: null == showPageIndicators ? _self.showPageIndicators : showPageIndicators // ignore: cast_nullable_to_non_nullable
as bool,peepingFactor: null == peepingFactor ? _self.peepingFactor : peepingFactor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentlyViewedViewConfigEntity].
extension RecentlyViewedViewConfigEntityPatterns on RecentlyViewedViewConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentlyViewedViewConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentlyViewedViewConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentlyViewedViewConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double tileWidth,  double tileHeight,  int minTilesToShow,  double imageCornerRadius,  bool navigation,  bool snapping,  bool showPageIndicators,  int peepingFactor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity() when $default != null:
return $default(_that.tileWidth,_that.tileHeight,_that.minTilesToShow,_that.imageCornerRadius,_that.navigation,_that.snapping,_that.showPageIndicators,_that.peepingFactor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double tileWidth,  double tileHeight,  int minTilesToShow,  double imageCornerRadius,  bool navigation,  bool snapping,  bool showPageIndicators,  int peepingFactor)  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity():
return $default(_that.tileWidth,_that.tileHeight,_that.minTilesToShow,_that.imageCornerRadius,_that.navigation,_that.snapping,_that.showPageIndicators,_that.peepingFactor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double tileWidth,  double tileHeight,  int minTilesToShow,  double imageCornerRadius,  bool navigation,  bool snapping,  bool showPageIndicators,  int peepingFactor)?  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedViewConfigEntity() when $default != null:
return $default(_that.tileWidth,_that.tileHeight,_that.minTilesToShow,_that.imageCornerRadius,_that.navigation,_that.snapping,_that.showPageIndicators,_that.peepingFactor);case _:
  return null;

}
}

}

/// @nodoc


class _RecentlyViewedViewConfigEntity implements RecentlyViewedViewConfigEntity {
  const _RecentlyViewedViewConfigEntity({this.tileWidth = 240.0, this.tileHeight = 214.0, this.minTilesToShow = 3, this.imageCornerRadius = 4.0, this.navigation = false, this.snapping = false, this.showPageIndicators = false, this.peepingFactor = 0});
  

@override@JsonKey() final  double tileWidth;
@override@JsonKey() final  double tileHeight;
@override@JsonKey() final  int minTilesToShow;
@override@JsonKey() final  double imageCornerRadius;
@override@JsonKey() final  bool navigation;
@override@JsonKey() final  bool snapping;
@override@JsonKey() final  bool showPageIndicators;
@override@JsonKey() final  int peepingFactor;

/// Create a copy of RecentlyViewedViewConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentlyViewedViewConfigEntityCopyWith<_RecentlyViewedViewConfigEntity> get copyWith => __$RecentlyViewedViewConfigEntityCopyWithImpl<_RecentlyViewedViewConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentlyViewedViewConfigEntity&&(identical(other.tileWidth, tileWidth) || other.tileWidth == tileWidth)&&(identical(other.tileHeight, tileHeight) || other.tileHeight == tileHeight)&&(identical(other.minTilesToShow, minTilesToShow) || other.minTilesToShow == minTilesToShow)&&(identical(other.imageCornerRadius, imageCornerRadius) || other.imageCornerRadius == imageCornerRadius)&&(identical(other.navigation, navigation) || other.navigation == navigation)&&(identical(other.snapping, snapping) || other.snapping == snapping)&&(identical(other.showPageIndicators, showPageIndicators) || other.showPageIndicators == showPageIndicators)&&(identical(other.peepingFactor, peepingFactor) || other.peepingFactor == peepingFactor));
}


@override
int get hashCode => Object.hash(runtimeType,tileWidth,tileHeight,minTilesToShow,imageCornerRadius,navigation,snapping,showPageIndicators,peepingFactor);

@override
String toString() {
  return 'RecentlyViewedViewConfigEntity(tileWidth: $tileWidth, tileHeight: $tileHeight, minTilesToShow: $minTilesToShow, imageCornerRadius: $imageCornerRadius, navigation: $navigation, snapping: $snapping, showPageIndicators: $showPageIndicators, peepingFactor: $peepingFactor)';
}


}

/// @nodoc
abstract mixin class _$RecentlyViewedViewConfigEntityCopyWith<$Res> implements $RecentlyViewedViewConfigEntityCopyWith<$Res> {
  factory _$RecentlyViewedViewConfigEntityCopyWith(_RecentlyViewedViewConfigEntity value, $Res Function(_RecentlyViewedViewConfigEntity) _then) = __$RecentlyViewedViewConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 double tileWidth, double tileHeight, int minTilesToShow, double imageCornerRadius, bool navigation, bool snapping, bool showPageIndicators, int peepingFactor
});




}
/// @nodoc
class __$RecentlyViewedViewConfigEntityCopyWithImpl<$Res>
    implements _$RecentlyViewedViewConfigEntityCopyWith<$Res> {
  __$RecentlyViewedViewConfigEntityCopyWithImpl(this._self, this._then);

  final _RecentlyViewedViewConfigEntity _self;
  final $Res Function(_RecentlyViewedViewConfigEntity) _then;

/// Create a copy of RecentlyViewedViewConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tileWidth = null,Object? tileHeight = null,Object? minTilesToShow = null,Object? imageCornerRadius = null,Object? navigation = null,Object? snapping = null,Object? showPageIndicators = null,Object? peepingFactor = null,}) {
  return _then(_RecentlyViewedViewConfigEntity(
tileWidth: null == tileWidth ? _self.tileWidth : tileWidth // ignore: cast_nullable_to_non_nullable
as double,tileHeight: null == tileHeight ? _self.tileHeight : tileHeight // ignore: cast_nullable_to_non_nullable
as double,minTilesToShow: null == minTilesToShow ? _self.minTilesToShow : minTilesToShow // ignore: cast_nullable_to_non_nullable
as int,imageCornerRadius: null == imageCornerRadius ? _self.imageCornerRadius : imageCornerRadius // ignore: cast_nullable_to_non_nullable
as double,navigation: null == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as bool,snapping: null == snapping ? _self.snapping : snapping // ignore: cast_nullable_to_non_nullable
as bool,showPageIndicators: null == showPageIndicators ? _self.showPageIndicators : showPageIndicators // ignore: cast_nullable_to_non_nullable
as bool,peepingFactor: null == peepingFactor ? _self.peepingFactor : peepingFactor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RecentlyViewedHeadingEntity {

 String? get url; int? get width; int? get height;
/// Create a copy of RecentlyViewedHeadingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentlyViewedHeadingEntityCopyWith<RecentlyViewedHeadingEntity> get copyWith => _$RecentlyViewedHeadingEntityCopyWithImpl<RecentlyViewedHeadingEntity>(this as RecentlyViewedHeadingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentlyViewedHeadingEntity&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,url,width,height);

@override
String toString() {
  return 'RecentlyViewedHeadingEntity(url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $RecentlyViewedHeadingEntityCopyWith<$Res>  {
  factory $RecentlyViewedHeadingEntityCopyWith(RecentlyViewedHeadingEntity value, $Res Function(RecentlyViewedHeadingEntity) _then) = _$RecentlyViewedHeadingEntityCopyWithImpl;
@useResult
$Res call({
 String? url, int? width, int? height
});




}
/// @nodoc
class _$RecentlyViewedHeadingEntityCopyWithImpl<$Res>
    implements $RecentlyViewedHeadingEntityCopyWith<$Res> {
  _$RecentlyViewedHeadingEntityCopyWithImpl(this._self, this._then);

  final RecentlyViewedHeadingEntity _self;
  final $Res Function(RecentlyViewedHeadingEntity) _then;

/// Create a copy of RecentlyViewedHeadingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentlyViewedHeadingEntity].
extension RecentlyViewedHeadingEntityPatterns on RecentlyViewedHeadingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentlyViewedHeadingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentlyViewedHeadingEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentlyViewedHeadingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url,  int? width,  int? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity() when $default != null:
return $default(_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url,  int? width,  int? height)  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity():
return $default(_that.url,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url,  int? width,  int? height)?  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedHeadingEntity() when $default != null:
return $default(_that.url,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _RecentlyViewedHeadingEntity implements RecentlyViewedHeadingEntity {
  const _RecentlyViewedHeadingEntity({this.url, this.width, this.height});
  

@override final  String? url;
@override final  int? width;
@override final  int? height;

/// Create a copy of RecentlyViewedHeadingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentlyViewedHeadingEntityCopyWith<_RecentlyViewedHeadingEntity> get copyWith => __$RecentlyViewedHeadingEntityCopyWithImpl<_RecentlyViewedHeadingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentlyViewedHeadingEntity&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,url,width,height);

@override
String toString() {
  return 'RecentlyViewedHeadingEntity(url: $url, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$RecentlyViewedHeadingEntityCopyWith<$Res> implements $RecentlyViewedHeadingEntityCopyWith<$Res> {
  factory _$RecentlyViewedHeadingEntityCopyWith(_RecentlyViewedHeadingEntity value, $Res Function(_RecentlyViewedHeadingEntity) _then) = __$RecentlyViewedHeadingEntityCopyWithImpl;
@override @useResult
$Res call({
 String? url, int? width, int? height
});




}
/// @nodoc
class __$RecentlyViewedHeadingEntityCopyWithImpl<$Res>
    implements _$RecentlyViewedHeadingEntityCopyWith<$Res> {
  __$RecentlyViewedHeadingEntityCopyWithImpl(this._self, this._then);

  final _RecentlyViewedHeadingEntity _self;
  final $Res Function(_RecentlyViewedHeadingEntity) _then;

/// Create a copy of RecentlyViewedHeadingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_RecentlyViewedHeadingEntity(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$RecentlyViewedMarginsEntity {

 double get top; double get bottom; double get horizontal; double get innerHorizontalMargin; double get titleBottomMargin; double get titleHorizontalMargin;
/// Create a copy of RecentlyViewedMarginsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentlyViewedMarginsEntityCopyWith<RecentlyViewedMarginsEntity> get copyWith => _$RecentlyViewedMarginsEntityCopyWithImpl<RecentlyViewedMarginsEntity>(this as RecentlyViewedMarginsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentlyViewedMarginsEntity&&(identical(other.top, top) || other.top == top)&&(identical(other.bottom, bottom) || other.bottom == bottom)&&(identical(other.horizontal, horizontal) || other.horizontal == horizontal)&&(identical(other.innerHorizontalMargin, innerHorizontalMargin) || other.innerHorizontalMargin == innerHorizontalMargin)&&(identical(other.titleBottomMargin, titleBottomMargin) || other.titleBottomMargin == titleBottomMargin)&&(identical(other.titleHorizontalMargin, titleHorizontalMargin) || other.titleHorizontalMargin == titleHorizontalMargin));
}


@override
int get hashCode => Object.hash(runtimeType,top,bottom,horizontal,innerHorizontalMargin,titleBottomMargin,titleHorizontalMargin);

@override
String toString() {
  return 'RecentlyViewedMarginsEntity(top: $top, bottom: $bottom, horizontal: $horizontal, innerHorizontalMargin: $innerHorizontalMargin, titleBottomMargin: $titleBottomMargin, titleHorizontalMargin: $titleHorizontalMargin)';
}


}

/// @nodoc
abstract mixin class $RecentlyViewedMarginsEntityCopyWith<$Res>  {
  factory $RecentlyViewedMarginsEntityCopyWith(RecentlyViewedMarginsEntity value, $Res Function(RecentlyViewedMarginsEntity) _then) = _$RecentlyViewedMarginsEntityCopyWithImpl;
@useResult
$Res call({
 double top, double bottom, double horizontal, double innerHorizontalMargin, double titleBottomMargin, double titleHorizontalMargin
});




}
/// @nodoc
class _$RecentlyViewedMarginsEntityCopyWithImpl<$Res>
    implements $RecentlyViewedMarginsEntityCopyWith<$Res> {
  _$RecentlyViewedMarginsEntityCopyWithImpl(this._self, this._then);

  final RecentlyViewedMarginsEntity _self;
  final $Res Function(RecentlyViewedMarginsEntity) _then;

/// Create a copy of RecentlyViewedMarginsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? top = null,Object? bottom = null,Object? horizontal = null,Object? innerHorizontalMargin = null,Object? titleBottomMargin = null,Object? titleHorizontalMargin = null,}) {
  return _then(_self.copyWith(
top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as double,horizontal: null == horizontal ? _self.horizontal : horizontal // ignore: cast_nullable_to_non_nullable
as double,innerHorizontalMargin: null == innerHorizontalMargin ? _self.innerHorizontalMargin : innerHorizontalMargin // ignore: cast_nullable_to_non_nullable
as double,titleBottomMargin: null == titleBottomMargin ? _self.titleBottomMargin : titleBottomMargin // ignore: cast_nullable_to_non_nullable
as double,titleHorizontalMargin: null == titleHorizontalMargin ? _self.titleHorizontalMargin : titleHorizontalMargin // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentlyViewedMarginsEntity].
extension RecentlyViewedMarginsEntityPatterns on RecentlyViewedMarginsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentlyViewedMarginsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentlyViewedMarginsEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentlyViewedMarginsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double top,  double bottom,  double horizontal,  double innerHorizontalMargin,  double titleBottomMargin,  double titleHorizontalMargin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity() when $default != null:
return $default(_that.top,_that.bottom,_that.horizontal,_that.innerHorizontalMargin,_that.titleBottomMargin,_that.titleHorizontalMargin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double top,  double bottom,  double horizontal,  double innerHorizontalMargin,  double titleBottomMargin,  double titleHorizontalMargin)  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity():
return $default(_that.top,_that.bottom,_that.horizontal,_that.innerHorizontalMargin,_that.titleBottomMargin,_that.titleHorizontalMargin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double top,  double bottom,  double horizontal,  double innerHorizontalMargin,  double titleBottomMargin,  double titleHorizontalMargin)?  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedMarginsEntity() when $default != null:
return $default(_that.top,_that.bottom,_that.horizontal,_that.innerHorizontalMargin,_that.titleBottomMargin,_that.titleHorizontalMargin);case _:
  return null;

}
}

}

/// @nodoc


class _RecentlyViewedMarginsEntity implements RecentlyViewedMarginsEntity {
  const _RecentlyViewedMarginsEntity({this.top = 12.0, this.bottom = 12.0, this.horizontal = 16.0, this.innerHorizontalMargin = 8.0, this.titleBottomMargin = 0.0, this.titleHorizontalMargin = 0.0});
  

@override@JsonKey() final  double top;
@override@JsonKey() final  double bottom;
@override@JsonKey() final  double horizontal;
@override@JsonKey() final  double innerHorizontalMargin;
@override@JsonKey() final  double titleBottomMargin;
@override@JsonKey() final  double titleHorizontalMargin;

/// Create a copy of RecentlyViewedMarginsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentlyViewedMarginsEntityCopyWith<_RecentlyViewedMarginsEntity> get copyWith => __$RecentlyViewedMarginsEntityCopyWithImpl<_RecentlyViewedMarginsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentlyViewedMarginsEntity&&(identical(other.top, top) || other.top == top)&&(identical(other.bottom, bottom) || other.bottom == bottom)&&(identical(other.horizontal, horizontal) || other.horizontal == horizontal)&&(identical(other.innerHorizontalMargin, innerHorizontalMargin) || other.innerHorizontalMargin == innerHorizontalMargin)&&(identical(other.titleBottomMargin, titleBottomMargin) || other.titleBottomMargin == titleBottomMargin)&&(identical(other.titleHorizontalMargin, titleHorizontalMargin) || other.titleHorizontalMargin == titleHorizontalMargin));
}


@override
int get hashCode => Object.hash(runtimeType,top,bottom,horizontal,innerHorizontalMargin,titleBottomMargin,titleHorizontalMargin);

@override
String toString() {
  return 'RecentlyViewedMarginsEntity(top: $top, bottom: $bottom, horizontal: $horizontal, innerHorizontalMargin: $innerHorizontalMargin, titleBottomMargin: $titleBottomMargin, titleHorizontalMargin: $titleHorizontalMargin)';
}


}

/// @nodoc
abstract mixin class _$RecentlyViewedMarginsEntityCopyWith<$Res> implements $RecentlyViewedMarginsEntityCopyWith<$Res> {
  factory _$RecentlyViewedMarginsEntityCopyWith(_RecentlyViewedMarginsEntity value, $Res Function(_RecentlyViewedMarginsEntity) _then) = __$RecentlyViewedMarginsEntityCopyWithImpl;
@override @useResult
$Res call({
 double top, double bottom, double horizontal, double innerHorizontalMargin, double titleBottomMargin, double titleHorizontalMargin
});




}
/// @nodoc
class __$RecentlyViewedMarginsEntityCopyWithImpl<$Res>
    implements _$RecentlyViewedMarginsEntityCopyWith<$Res> {
  __$RecentlyViewedMarginsEntityCopyWithImpl(this._self, this._then);

  final _RecentlyViewedMarginsEntity _self;
  final $Res Function(_RecentlyViewedMarginsEntity) _then;

/// Create a copy of RecentlyViewedMarginsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? top = null,Object? bottom = null,Object? horizontal = null,Object? innerHorizontalMargin = null,Object? titleBottomMargin = null,Object? titleHorizontalMargin = null,}) {
  return _then(_RecentlyViewedMarginsEntity(
top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as double,horizontal: null == horizontal ? _self.horizontal : horizontal // ignore: cast_nullable_to_non_nullable
as double,innerHorizontalMargin: null == innerHorizontalMargin ? _self.innerHorizontalMargin : innerHorizontalMargin // ignore: cast_nullable_to_non_nullable
as double,titleBottomMargin: null == titleBottomMargin ? _self.titleBottomMargin : titleBottomMargin // ignore: cast_nullable_to_non_nullable
as double,titleHorizontalMargin: null == titleHorizontalMargin ? _self.titleHorizontalMargin : titleHorizontalMargin // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$RecentlyViewedEntity {

 RecentlyViewedViewConfigEntity? get viewConfig; List<ListingProductEntity> get tiles; RecentlyViewedHeadingEntity? get heading; RecentlyViewedMarginsEntity? get margins;
/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentlyViewedEntityCopyWith<RecentlyViewedEntity> get copyWith => _$RecentlyViewedEntityCopyWithImpl<RecentlyViewedEntity>(this as RecentlyViewedEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentlyViewedEntity&&(identical(other.viewConfig, viewConfig) || other.viewConfig == viewConfig)&&const DeepCollectionEquality().equals(other.tiles, tiles)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.margins, margins) || other.margins == margins));
}


@override
int get hashCode => Object.hash(runtimeType,viewConfig,const DeepCollectionEquality().hash(tiles),heading,margins);

@override
String toString() {
  return 'RecentlyViewedEntity(viewConfig: $viewConfig, tiles: $tiles, heading: $heading, margins: $margins)';
}


}

/// @nodoc
abstract mixin class $RecentlyViewedEntityCopyWith<$Res>  {
  factory $RecentlyViewedEntityCopyWith(RecentlyViewedEntity value, $Res Function(RecentlyViewedEntity) _then) = _$RecentlyViewedEntityCopyWithImpl;
@useResult
$Res call({
 RecentlyViewedViewConfigEntity? viewConfig, List<ListingProductEntity> tiles, RecentlyViewedHeadingEntity? heading, RecentlyViewedMarginsEntity? margins
});


$RecentlyViewedViewConfigEntityCopyWith<$Res>? get viewConfig;$RecentlyViewedHeadingEntityCopyWith<$Res>? get heading;$RecentlyViewedMarginsEntityCopyWith<$Res>? get margins;

}
/// @nodoc
class _$RecentlyViewedEntityCopyWithImpl<$Res>
    implements $RecentlyViewedEntityCopyWith<$Res> {
  _$RecentlyViewedEntityCopyWithImpl(this._self, this._then);

  final RecentlyViewedEntity _self;
  final $Res Function(RecentlyViewedEntity) _then;

/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? viewConfig = freezed,Object? tiles = null,Object? heading = freezed,Object? margins = freezed,}) {
  return _then(_self.copyWith(
viewConfig: freezed == viewConfig ? _self.viewConfig : viewConfig // ignore: cast_nullable_to_non_nullable
as RecentlyViewedViewConfigEntity?,tiles: null == tiles ? _self.tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as RecentlyViewedHeadingEntity?,margins: freezed == margins ? _self.margins : margins // ignore: cast_nullable_to_non_nullable
as RecentlyViewedMarginsEntity?,
  ));
}
/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedViewConfigEntityCopyWith<$Res>? get viewConfig {
    if (_self.viewConfig == null) {
    return null;
  }

  return $RecentlyViewedViewConfigEntityCopyWith<$Res>(_self.viewConfig!, (value) {
    return _then(_self.copyWith(viewConfig: value));
  });
}/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedHeadingEntityCopyWith<$Res>? get heading {
    if (_self.heading == null) {
    return null;
  }

  return $RecentlyViewedHeadingEntityCopyWith<$Res>(_self.heading!, (value) {
    return _then(_self.copyWith(heading: value));
  });
}/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedMarginsEntityCopyWith<$Res>? get margins {
    if (_self.margins == null) {
    return null;
  }

  return $RecentlyViewedMarginsEntityCopyWith<$Res>(_self.margins!, (value) {
    return _then(_self.copyWith(margins: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecentlyViewedEntity].
extension RecentlyViewedEntityPatterns on RecentlyViewedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentlyViewedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentlyViewedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentlyViewedEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentlyViewedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecentlyViewedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecentlyViewedViewConfigEntity? viewConfig,  List<ListingProductEntity> tiles,  RecentlyViewedHeadingEntity? heading,  RecentlyViewedMarginsEntity? margins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentlyViewedEntity() when $default != null:
return $default(_that.viewConfig,_that.tiles,_that.heading,_that.margins);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecentlyViewedViewConfigEntity? viewConfig,  List<ListingProductEntity> tiles,  RecentlyViewedHeadingEntity? heading,  RecentlyViewedMarginsEntity? margins)  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedEntity():
return $default(_that.viewConfig,_that.tiles,_that.heading,_that.margins);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecentlyViewedViewConfigEntity? viewConfig,  List<ListingProductEntity> tiles,  RecentlyViewedHeadingEntity? heading,  RecentlyViewedMarginsEntity? margins)?  $default,) {final _that = this;
switch (_that) {
case _RecentlyViewedEntity() when $default != null:
return $default(_that.viewConfig,_that.tiles,_that.heading,_that.margins);case _:
  return null;

}
}

}

/// @nodoc


class _RecentlyViewedEntity implements RecentlyViewedEntity {
  const _RecentlyViewedEntity({this.viewConfig, final  List<ListingProductEntity> tiles = const [], this.heading, this.margins}): _tiles = tiles;
  

@override final  RecentlyViewedViewConfigEntity? viewConfig;
 final  List<ListingProductEntity> _tiles;
@override@JsonKey() List<ListingProductEntity> get tiles {
  if (_tiles is EqualUnmodifiableListView) return _tiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiles);
}

@override final  RecentlyViewedHeadingEntity? heading;
@override final  RecentlyViewedMarginsEntity? margins;

/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentlyViewedEntityCopyWith<_RecentlyViewedEntity> get copyWith => __$RecentlyViewedEntityCopyWithImpl<_RecentlyViewedEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentlyViewedEntity&&(identical(other.viewConfig, viewConfig) || other.viewConfig == viewConfig)&&const DeepCollectionEquality().equals(other._tiles, _tiles)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.margins, margins) || other.margins == margins));
}


@override
int get hashCode => Object.hash(runtimeType,viewConfig,const DeepCollectionEquality().hash(_tiles),heading,margins);

@override
String toString() {
  return 'RecentlyViewedEntity(viewConfig: $viewConfig, tiles: $tiles, heading: $heading, margins: $margins)';
}


}

/// @nodoc
abstract mixin class _$RecentlyViewedEntityCopyWith<$Res> implements $RecentlyViewedEntityCopyWith<$Res> {
  factory _$RecentlyViewedEntityCopyWith(_RecentlyViewedEntity value, $Res Function(_RecentlyViewedEntity) _then) = __$RecentlyViewedEntityCopyWithImpl;
@override @useResult
$Res call({
 RecentlyViewedViewConfigEntity? viewConfig, List<ListingProductEntity> tiles, RecentlyViewedHeadingEntity? heading, RecentlyViewedMarginsEntity? margins
});


@override $RecentlyViewedViewConfigEntityCopyWith<$Res>? get viewConfig;@override $RecentlyViewedHeadingEntityCopyWith<$Res>? get heading;@override $RecentlyViewedMarginsEntityCopyWith<$Res>? get margins;

}
/// @nodoc
class __$RecentlyViewedEntityCopyWithImpl<$Res>
    implements _$RecentlyViewedEntityCopyWith<$Res> {
  __$RecentlyViewedEntityCopyWithImpl(this._self, this._then);

  final _RecentlyViewedEntity _self;
  final $Res Function(_RecentlyViewedEntity) _then;

/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? viewConfig = freezed,Object? tiles = null,Object? heading = freezed,Object? margins = freezed,}) {
  return _then(_RecentlyViewedEntity(
viewConfig: freezed == viewConfig ? _self.viewConfig : viewConfig // ignore: cast_nullable_to_non_nullable
as RecentlyViewedViewConfigEntity?,tiles: null == tiles ? _self._tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as RecentlyViewedHeadingEntity?,margins: freezed == margins ? _self.margins : margins // ignore: cast_nullable_to_non_nullable
as RecentlyViewedMarginsEntity?,
  ));
}

/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedViewConfigEntityCopyWith<$Res>? get viewConfig {
    if (_self.viewConfig == null) {
    return null;
  }

  return $RecentlyViewedViewConfigEntityCopyWith<$Res>(_self.viewConfig!, (value) {
    return _then(_self.copyWith(viewConfig: value));
  });
}/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedHeadingEntityCopyWith<$Res>? get heading {
    if (_self.heading == null) {
    return null;
  }

  return $RecentlyViewedHeadingEntityCopyWith<$Res>(_self.heading!, (value) {
    return _then(_self.copyWith(heading: value));
  });
}/// Create a copy of RecentlyViewedEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecentlyViewedMarginsEntityCopyWith<$Res>? get margins {
    if (_self.margins == null) {
    return null;
  }

  return $RecentlyViewedMarginsEntityCopyWith<$Res>(_self.margins!, (value) {
    return _then(_self.copyWith(margins: value));
  });
}
}

// dart format on
