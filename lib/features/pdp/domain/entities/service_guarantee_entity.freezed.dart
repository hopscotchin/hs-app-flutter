// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_guarantee_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServiceGuaranteeEntity {

 String? get icon; String? get label;
/// Create a copy of ServiceGuaranteeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceGuaranteeEntityCopyWith<ServiceGuaranteeEntity> get copyWith => _$ServiceGuaranteeEntityCopyWithImpl<ServiceGuaranteeEntity>(this as ServiceGuaranteeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceGuaranteeEntity&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,icon,label);

@override
String toString() {
  return 'ServiceGuaranteeEntity(icon: $icon, label: $label)';
}


}

/// @nodoc
abstract mixin class $ServiceGuaranteeEntityCopyWith<$Res>  {
  factory $ServiceGuaranteeEntityCopyWith(ServiceGuaranteeEntity value, $Res Function(ServiceGuaranteeEntity) _then) = _$ServiceGuaranteeEntityCopyWithImpl;
@useResult
$Res call({
 String? icon, String? label
});




}
/// @nodoc
class _$ServiceGuaranteeEntityCopyWithImpl<$Res>
    implements $ServiceGuaranteeEntityCopyWith<$Res> {
  _$ServiceGuaranteeEntityCopyWithImpl(this._self, this._then);

  final ServiceGuaranteeEntity _self;
  final $Res Function(ServiceGuaranteeEntity) _then;

/// Create a copy of ServiceGuaranteeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = freezed,Object? label = freezed,}) {
  return _then(_self.copyWith(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceGuaranteeEntity].
extension ServiceGuaranteeEntityPatterns on ServiceGuaranteeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceGuaranteeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceGuaranteeEntity value)  $default,){
final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceGuaranteeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? icon,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity() when $default != null:
return $default(_that.icon,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? icon,  String? label)  $default,) {final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity():
return $default(_that.icon,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? icon,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _ServiceGuaranteeEntity() when $default != null:
return $default(_that.icon,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceGuaranteeEntity implements ServiceGuaranteeEntity {
  const _ServiceGuaranteeEntity({this.icon, this.label});
  

@override final  String? icon;
@override final  String? label;

/// Create a copy of ServiceGuaranteeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceGuaranteeEntityCopyWith<_ServiceGuaranteeEntity> get copyWith => __$ServiceGuaranteeEntityCopyWithImpl<_ServiceGuaranteeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceGuaranteeEntity&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,icon,label);

@override
String toString() {
  return 'ServiceGuaranteeEntity(icon: $icon, label: $label)';
}


}

/// @nodoc
abstract mixin class _$ServiceGuaranteeEntityCopyWith<$Res> implements $ServiceGuaranteeEntityCopyWith<$Res> {
  factory _$ServiceGuaranteeEntityCopyWith(_ServiceGuaranteeEntity value, $Res Function(_ServiceGuaranteeEntity) _then) = __$ServiceGuaranteeEntityCopyWithImpl;
@override @useResult
$Res call({
 String? icon, String? label
});




}
/// @nodoc
class __$ServiceGuaranteeEntityCopyWithImpl<$Res>
    implements _$ServiceGuaranteeEntityCopyWith<$Res> {
  __$ServiceGuaranteeEntityCopyWithImpl(this._self, this._then);

  final _ServiceGuaranteeEntity _self;
  final $Res Function(_ServiceGuaranteeEntity) _then;

/// Create a copy of ServiceGuaranteeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = freezed,Object? label = freezed,}) {
  return _then(_ServiceGuaranteeEntity(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
