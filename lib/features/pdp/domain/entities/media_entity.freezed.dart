// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaEntity {

 int? get height; String? get mimeType; String? get url; int? get width;
/// Create a copy of MediaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaEntityCopyWith<MediaEntity> get copyWith => _$MediaEntityCopyWithImpl<MediaEntity>(this as MediaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaEntity&&(identical(other.height, height) || other.height == height)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width));
}


@override
int get hashCode => Object.hash(runtimeType,height,mimeType,url,width);

@override
String toString() {
  return 'MediaEntity(height: $height, mimeType: $mimeType, url: $url, width: $width)';
}


}

/// @nodoc
abstract mixin class $MediaEntityCopyWith<$Res>  {
  factory $MediaEntityCopyWith(MediaEntity value, $Res Function(MediaEntity) _then) = _$MediaEntityCopyWithImpl;
@useResult
$Res call({
 int? height, String? mimeType, String? url, int? width
});




}
/// @nodoc
class _$MediaEntityCopyWithImpl<$Res>
    implements $MediaEntityCopyWith<$Res> {
  _$MediaEntityCopyWithImpl(this._self, this._then);

  final MediaEntity _self;
  final $Res Function(MediaEntity) _then;

/// Create a copy of MediaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? height = freezed,Object? mimeType = freezed,Object? url = freezed,Object? width = freezed,}) {
  return _then(_self.copyWith(
height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaEntity].
extension MediaEntityPatterns on MediaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaEntity value)  $default,){
final _that = this;
switch (_that) {
case _MediaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MediaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? height,  String? mimeType,  String? url,  int? width)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaEntity() when $default != null:
return $default(_that.height,_that.mimeType,_that.url,_that.width);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? height,  String? mimeType,  String? url,  int? width)  $default,) {final _that = this;
switch (_that) {
case _MediaEntity():
return $default(_that.height,_that.mimeType,_that.url,_that.width);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? height,  String? mimeType,  String? url,  int? width)?  $default,) {final _that = this;
switch (_that) {
case _MediaEntity() when $default != null:
return $default(_that.height,_that.mimeType,_that.url,_that.width);case _:
  return null;

}
}

}

/// @nodoc


class _MediaEntity implements MediaEntity {
  const _MediaEntity({this.height, this.mimeType, this.url, this.width});
  

@override final  int? height;
@override final  String? mimeType;
@override final  String? url;
@override final  int? width;

/// Create a copy of MediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaEntityCopyWith<_MediaEntity> get copyWith => __$MediaEntityCopyWithImpl<_MediaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaEntity&&(identical(other.height, height) || other.height == height)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width));
}


@override
int get hashCode => Object.hash(runtimeType,height,mimeType,url,width);

@override
String toString() {
  return 'MediaEntity(height: $height, mimeType: $mimeType, url: $url, width: $width)';
}


}

/// @nodoc
abstract mixin class _$MediaEntityCopyWith<$Res> implements $MediaEntityCopyWith<$Res> {
  factory _$MediaEntityCopyWith(_MediaEntity value, $Res Function(_MediaEntity) _then) = __$MediaEntityCopyWithImpl;
@override @useResult
$Res call({
 int? height, String? mimeType, String? url, int? width
});




}
/// @nodoc
class __$MediaEntityCopyWithImpl<$Res>
    implements _$MediaEntityCopyWith<$Res> {
  __$MediaEntityCopyWithImpl(this._self, this._then);

  final _MediaEntity _self;
  final $Res Function(_MediaEntity) _then;

/// Create a copy of MediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? height = freezed,Object? mimeType = freezed,Object? url = freezed,Object? width = freezed,}) {
  return _then(_MediaEntity(
height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
