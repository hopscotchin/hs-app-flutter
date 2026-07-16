// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BannerEntity {

 String? get actionUri; String? get id; MediaEntity? get media; int? get position;
/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerEntityCopyWith<BannerEntity> get copyWith => _$BannerEntityCopyWithImpl<BannerEntity>(this as BannerEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerEntity&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.id, id) || other.id == id)&&(identical(other.media, media) || other.media == media)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,actionUri,id,media,position);

@override
String toString() {
  return 'BannerEntity(actionUri: $actionUri, id: $id, media: $media, position: $position)';
}


}

/// @nodoc
abstract mixin class $BannerEntityCopyWith<$Res>  {
  factory $BannerEntityCopyWith(BannerEntity value, $Res Function(BannerEntity) _then) = _$BannerEntityCopyWithImpl;
@useResult
$Res call({
 String? actionUri, String? id, MediaEntity? media, int? position
});


$MediaEntityCopyWith<$Res>? get media;

}
/// @nodoc
class _$BannerEntityCopyWithImpl<$Res>
    implements $BannerEntityCopyWith<$Res> {
  _$BannerEntityCopyWithImpl(this._self, this._then);

  final BannerEntity _self;
  final $Res Function(BannerEntity) _then;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionUri = freezed,Object? id = freezed,Object? media = freezed,Object? position = freezed,}) {
  return _then(_self.copyWith(
actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaEntity?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEntityCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaEntityCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [BannerEntity].
extension BannerEntityPatterns on BannerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerEntity value)  $default,){
final _that = this;
switch (_that) {
case _BannerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? actionUri,  String? id,  MediaEntity? media,  int? position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
return $default(_that.actionUri,_that.id,_that.media,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? actionUri,  String? id,  MediaEntity? media,  int? position)  $default,) {final _that = this;
switch (_that) {
case _BannerEntity():
return $default(_that.actionUri,_that.id,_that.media,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? actionUri,  String? id,  MediaEntity? media,  int? position)?  $default,) {final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
return $default(_that.actionUri,_that.id,_that.media,_that.position);case _:
  return null;

}
}

}

/// @nodoc


class _BannerEntity implements BannerEntity {
  const _BannerEntity({this.actionUri, this.id, this.media, this.position});
  

@override final  String? actionUri;
@override final  String? id;
@override final  MediaEntity? media;
@override final  int? position;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerEntityCopyWith<_BannerEntity> get copyWith => __$BannerEntityCopyWithImpl<_BannerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerEntity&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.id, id) || other.id == id)&&(identical(other.media, media) || other.media == media)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,actionUri,id,media,position);

@override
String toString() {
  return 'BannerEntity(actionUri: $actionUri, id: $id, media: $media, position: $position)';
}


}

/// @nodoc
abstract mixin class _$BannerEntityCopyWith<$Res> implements $BannerEntityCopyWith<$Res> {
  factory _$BannerEntityCopyWith(_BannerEntity value, $Res Function(_BannerEntity) _then) = __$BannerEntityCopyWithImpl;
@override @useResult
$Res call({
 String? actionUri, String? id, MediaEntity? media, int? position
});


@override $MediaEntityCopyWith<$Res>? get media;

}
/// @nodoc
class __$BannerEntityCopyWithImpl<$Res>
    implements _$BannerEntityCopyWith<$Res> {
  __$BannerEntityCopyWithImpl(this._self, this._then);

  final _BannerEntity _self;
  final $Res Function(_BannerEntity) _then;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionUri = freezed,Object? id = freezed,Object? media = freezed,Object? position = freezed,}) {
  return _then(_BannerEntity(
actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaEntity?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEntityCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaEntityCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}

// dart format on
