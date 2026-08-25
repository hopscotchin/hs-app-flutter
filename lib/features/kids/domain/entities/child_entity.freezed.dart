// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChildEntity {

 int get id; String get name; ChildGender get gender; DateTime? get dob; String? get imageUrl;
/// Create a copy of ChildEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildEntityCopyWith<ChildEntity> get copyWith => _$ChildEntityCopyWithImpl<ChildEntity>(this as ChildEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,gender,dob,imageUrl);

@override
String toString() {
  return 'ChildEntity(id: $id, name: $name, gender: $gender, dob: $dob, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ChildEntityCopyWith<$Res>  {
  factory $ChildEntityCopyWith(ChildEntity value, $Res Function(ChildEntity) _then) = _$ChildEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, ChildGender gender, DateTime? dob, String? imageUrl
});




}
/// @nodoc
class _$ChildEntityCopyWithImpl<$Res>
    implements $ChildEntityCopyWith<$Res> {
  _$ChildEntityCopyWithImpl(this._self, this._then);

  final ChildEntity _self;
  final $Res Function(ChildEntity) _then;

/// Create a copy of ChildEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? gender = null,Object? dob = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildEntity].
extension ChildEntityPatterns on ChildEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChildEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChildEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  ChildGender gender,  DateTime? dob,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildEntity() when $default != null:
return $default(_that.id,_that.name,_that.gender,_that.dob,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  ChildGender gender,  DateTime? dob,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ChildEntity():
return $default(_that.id,_that.name,_that.gender,_that.dob,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  ChildGender gender,  DateTime? dob,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChildEntity() when $default != null:
return $default(_that.id,_that.name,_that.gender,_that.dob,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ChildEntity implements ChildEntity {
  const _ChildEntity({this.id = 0, this.name = '', this.gender = ChildGender.boy, this.dob, this.imageUrl});
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  ChildGender gender;
@override final  DateTime? dob;
@override final  String? imageUrl;

/// Create a copy of ChildEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildEntityCopyWith<_ChildEntity> get copyWith => __$ChildEntityCopyWithImpl<_ChildEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,gender,dob,imageUrl);

@override
String toString() {
  return 'ChildEntity(id: $id, name: $name, gender: $gender, dob: $dob, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ChildEntityCopyWith<$Res> implements $ChildEntityCopyWith<$Res> {
  factory _$ChildEntityCopyWith(_ChildEntity value, $Res Function(_ChildEntity) _then) = __$ChildEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, ChildGender gender, DateTime? dob, String? imageUrl
});




}
/// @nodoc
class __$ChildEntityCopyWithImpl<$Res>
    implements _$ChildEntityCopyWith<$Res> {
  __$ChildEntityCopyWithImpl(this._self, this._then);

  final _ChildEntity _self;
  final $Res Function(_ChildEntity) _then;

/// Create a copy of ChildEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? gender = null,Object? dob = freezed,Object? imageUrl = freezed,}) {
  return _then(_ChildEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as ChildGender,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
