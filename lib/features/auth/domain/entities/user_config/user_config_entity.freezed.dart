// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_config_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserConfigEntity {

 bool get continueBrowsingEligibleVisitor;
/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserConfigEntityCopyWith<UserConfigEntity> get copyWith => _$UserConfigEntityCopyWithImpl<UserConfigEntity>(this as UserConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserConfigEntity&&(identical(other.continueBrowsingEligibleVisitor, continueBrowsingEligibleVisitor) || other.continueBrowsingEligibleVisitor == continueBrowsingEligibleVisitor));
}


@override
int get hashCode => Object.hash(runtimeType,continueBrowsingEligibleVisitor);

@override
String toString() {
  return 'UserConfigEntity(continueBrowsingEligibleVisitor: $continueBrowsingEligibleVisitor)';
}


}

/// @nodoc
abstract mixin class $UserConfigEntityCopyWith<$Res>  {
  factory $UserConfigEntityCopyWith(UserConfigEntity value, $Res Function(UserConfigEntity) _then) = _$UserConfigEntityCopyWithImpl;
@useResult
$Res call({
 bool continueBrowsingEligibleVisitor
});




}
/// @nodoc
class _$UserConfigEntityCopyWithImpl<$Res>
    implements $UserConfigEntityCopyWith<$Res> {
  _$UserConfigEntityCopyWithImpl(this._self, this._then);

  final UserConfigEntity _self;
  final $Res Function(UserConfigEntity) _then;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? continueBrowsingEligibleVisitor = null,}) {
  return _then(_self.copyWith(
continueBrowsingEligibleVisitor: null == continueBrowsingEligibleVisitor ? _self.continueBrowsingEligibleVisitor : continueBrowsingEligibleVisitor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserConfigEntity].
extension UserConfigEntityPatterns on UserConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserConfigEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool continueBrowsingEligibleVisitor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
return $default(_that.continueBrowsingEligibleVisitor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool continueBrowsingEligibleVisitor)  $default,) {final _that = this;
switch (_that) {
case _UserConfigEntity():
return $default(_that.continueBrowsingEligibleVisitor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool continueBrowsingEligibleVisitor)?  $default,) {final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
return $default(_that.continueBrowsingEligibleVisitor);case _:
  return null;

}
}

}

/// @nodoc


class _UserConfigEntity implements UserConfigEntity {
  const _UserConfigEntity({this.continueBrowsingEligibleVisitor = false});
  

@override@JsonKey() final  bool continueBrowsingEligibleVisitor;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserConfigEntityCopyWith<_UserConfigEntity> get copyWith => __$UserConfigEntityCopyWithImpl<_UserConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserConfigEntity&&(identical(other.continueBrowsingEligibleVisitor, continueBrowsingEligibleVisitor) || other.continueBrowsingEligibleVisitor == continueBrowsingEligibleVisitor));
}


@override
int get hashCode => Object.hash(runtimeType,continueBrowsingEligibleVisitor);

@override
String toString() {
  return 'UserConfigEntity(continueBrowsingEligibleVisitor: $continueBrowsingEligibleVisitor)';
}


}

/// @nodoc
abstract mixin class _$UserConfigEntityCopyWith<$Res> implements $UserConfigEntityCopyWith<$Res> {
  factory _$UserConfigEntityCopyWith(_UserConfigEntity value, $Res Function(_UserConfigEntity) _then) = __$UserConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 bool continueBrowsingEligibleVisitor
});




}
/// @nodoc
class __$UserConfigEntityCopyWithImpl<$Res>
    implements _$UserConfigEntityCopyWith<$Res> {
  __$UserConfigEntityCopyWithImpl(this._self, this._then);

  final _UserConfigEntity _self;
  final $Res Function(_UserConfigEntity) _then;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? continueBrowsingEligibleVisitor = null,}) {
  return _then(_UserConfigEntity(
continueBrowsingEligibleVisitor: null == continueBrowsingEligibleVisitor ? _self.continueBrowsingEligibleVisitor : continueBrowsingEligibleVisitor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
