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
mixin _$ProductImageConfigEntity {

 String? get aspectRatio; String? get imageLayout; String? get transformation;
/// Create a copy of ProductImageConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductImageConfigEntityCopyWith<ProductImageConfigEntity> get copyWith => _$ProductImageConfigEntityCopyWithImpl<ProductImageConfigEntity>(this as ProductImageConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductImageConfigEntity&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.imageLayout, imageLayout) || other.imageLayout == imageLayout)&&(identical(other.transformation, transformation) || other.transformation == transformation));
}


@override
int get hashCode => Object.hash(runtimeType,aspectRatio,imageLayout,transformation);

@override
String toString() {
  return 'ProductImageConfigEntity(aspectRatio: $aspectRatio, imageLayout: $imageLayout, transformation: $transformation)';
}


}

/// @nodoc
abstract mixin class $ProductImageConfigEntityCopyWith<$Res>  {
  factory $ProductImageConfigEntityCopyWith(ProductImageConfigEntity value, $Res Function(ProductImageConfigEntity) _then) = _$ProductImageConfigEntityCopyWithImpl;
@useResult
$Res call({
 String? aspectRatio, String? imageLayout, String? transformation
});




}
/// @nodoc
class _$ProductImageConfigEntityCopyWithImpl<$Res>
    implements $ProductImageConfigEntityCopyWith<$Res> {
  _$ProductImageConfigEntityCopyWithImpl(this._self, this._then);

  final ProductImageConfigEntity _self;
  final $Res Function(ProductImageConfigEntity) _then;

/// Create a copy of ProductImageConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aspectRatio = freezed,Object? imageLayout = freezed,Object? transformation = freezed,}) {
  return _then(_self.copyWith(
aspectRatio: freezed == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String?,imageLayout: freezed == imageLayout ? _self.imageLayout : imageLayout // ignore: cast_nullable_to_non_nullable
as String?,transformation: freezed == transformation ? _self.transformation : transformation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductImageConfigEntity].
extension ProductImageConfigEntityPatterns on ProductImageConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductImageConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductImageConfigEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductImageConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductImageConfigEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductImageConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductImageConfigEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? aspectRatio,  String? imageLayout,  String? transformation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductImageConfigEntity() when $default != null:
return $default(_that.aspectRatio,_that.imageLayout,_that.transformation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? aspectRatio,  String? imageLayout,  String? transformation)  $default,) {final _that = this;
switch (_that) {
case _ProductImageConfigEntity():
return $default(_that.aspectRatio,_that.imageLayout,_that.transformation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? aspectRatio,  String? imageLayout,  String? transformation)?  $default,) {final _that = this;
switch (_that) {
case _ProductImageConfigEntity() when $default != null:
return $default(_that.aspectRatio,_that.imageLayout,_that.transformation);case _:
  return null;

}
}

}

/// @nodoc


class _ProductImageConfigEntity implements ProductImageConfigEntity {
  const _ProductImageConfigEntity({this.aspectRatio, this.imageLayout, this.transformation});
  

@override final  String? aspectRatio;
@override final  String? imageLayout;
@override final  String? transformation;

/// Create a copy of ProductImageConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductImageConfigEntityCopyWith<_ProductImageConfigEntity> get copyWith => __$ProductImageConfigEntityCopyWithImpl<_ProductImageConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductImageConfigEntity&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.imageLayout, imageLayout) || other.imageLayout == imageLayout)&&(identical(other.transformation, transformation) || other.transformation == transformation));
}


@override
int get hashCode => Object.hash(runtimeType,aspectRatio,imageLayout,transformation);

@override
String toString() {
  return 'ProductImageConfigEntity(aspectRatio: $aspectRatio, imageLayout: $imageLayout, transformation: $transformation)';
}


}

/// @nodoc
abstract mixin class _$ProductImageConfigEntityCopyWith<$Res> implements $ProductImageConfigEntityCopyWith<$Res> {
  factory _$ProductImageConfigEntityCopyWith(_ProductImageConfigEntity value, $Res Function(_ProductImageConfigEntity) _then) = __$ProductImageConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 String? aspectRatio, String? imageLayout, String? transformation
});




}
/// @nodoc
class __$ProductImageConfigEntityCopyWithImpl<$Res>
    implements _$ProductImageConfigEntityCopyWith<$Res> {
  __$ProductImageConfigEntityCopyWithImpl(this._self, this._then);

  final _ProductImageConfigEntity _self;
  final $Res Function(_ProductImageConfigEntity) _then;

/// Create a copy of ProductImageConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aspectRatio = freezed,Object? imageLayout = freezed,Object? transformation = freezed,}) {
  return _then(_ProductImageConfigEntity(
aspectRatio: freezed == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String?,imageLayout: freezed == imageLayout ? _self.imageLayout : imageLayout // ignore: cast_nullable_to_non_nullable
as String?,transformation: freezed == transformation ? _self.transformation : transformation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UserConfigEntity {

 ProductImageConfigEntity? get productImageConfig;
/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserConfigEntityCopyWith<UserConfigEntity> get copyWith => _$UserConfigEntityCopyWithImpl<UserConfigEntity>(this as UserConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserConfigEntity&&(identical(other.productImageConfig, productImageConfig) || other.productImageConfig == productImageConfig));
}


@override
int get hashCode => Object.hash(runtimeType,productImageConfig);

@override
String toString() {
  return 'UserConfigEntity(productImageConfig: $productImageConfig)';
}


}

/// @nodoc
abstract mixin class $UserConfigEntityCopyWith<$Res>  {
  factory $UserConfigEntityCopyWith(UserConfigEntity value, $Res Function(UserConfigEntity) _then) = _$UserConfigEntityCopyWithImpl;
@useResult
$Res call({
 ProductImageConfigEntity? productImageConfig
});


$ProductImageConfigEntityCopyWith<$Res>? get productImageConfig;

}
/// @nodoc
class _$UserConfigEntityCopyWithImpl<$Res>
    implements $UserConfigEntityCopyWith<$Res> {
  _$UserConfigEntityCopyWithImpl(this._self, this._then);

  final UserConfigEntity _self;
  final $Res Function(UserConfigEntity) _then;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productImageConfig = freezed,}) {
  return _then(_self.copyWith(
productImageConfig: freezed == productImageConfig ? _self.productImageConfig : productImageConfig // ignore: cast_nullable_to_non_nullable
as ProductImageConfigEntity?,
  ));
}
/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductImageConfigEntityCopyWith<$Res>? get productImageConfig {
    if (_self.productImageConfig == null) {
    return null;
  }

  return $ProductImageConfigEntityCopyWith<$Res>(_self.productImageConfig!, (value) {
    return _then(_self.copyWith(productImageConfig: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductImageConfigEntity? productImageConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
return $default(_that.productImageConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductImageConfigEntity? productImageConfig)  $default,) {final _that = this;
switch (_that) {
case _UserConfigEntity():
return $default(_that.productImageConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductImageConfigEntity? productImageConfig)?  $default,) {final _that = this;
switch (_that) {
case _UserConfigEntity() when $default != null:
return $default(_that.productImageConfig);case _:
  return null;

}
}

}

/// @nodoc


class _UserConfigEntity implements UserConfigEntity {
  const _UserConfigEntity({this.productImageConfig});
  

@override final  ProductImageConfigEntity? productImageConfig;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserConfigEntityCopyWith<_UserConfigEntity> get copyWith => __$UserConfigEntityCopyWithImpl<_UserConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserConfigEntity&&(identical(other.productImageConfig, productImageConfig) || other.productImageConfig == productImageConfig));
}


@override
int get hashCode => Object.hash(runtimeType,productImageConfig);

@override
String toString() {
  return 'UserConfigEntity(productImageConfig: $productImageConfig)';
}


}

/// @nodoc
abstract mixin class _$UserConfigEntityCopyWith<$Res> implements $UserConfigEntityCopyWith<$Res> {
  factory _$UserConfigEntityCopyWith(_UserConfigEntity value, $Res Function(_UserConfigEntity) _then) = __$UserConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 ProductImageConfigEntity? productImageConfig
});


@override $ProductImageConfigEntityCopyWith<$Res>? get productImageConfig;

}
/// @nodoc
class __$UserConfigEntityCopyWithImpl<$Res>
    implements _$UserConfigEntityCopyWith<$Res> {
  __$UserConfigEntityCopyWithImpl(this._self, this._then);

  final _UserConfigEntity _self;
  final $Res Function(_UserConfigEntity) _then;

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productImageConfig = freezed,}) {
  return _then(_UserConfigEntity(
productImageConfig: freezed == productImageConfig ? _self.productImageConfig : productImageConfig // ignore: cast_nullable_to_non_nullable
as ProductImageConfigEntity?,
  ));
}

/// Create a copy of UserConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductImageConfigEntityCopyWith<$Res>? get productImageConfig {
    if (_self.productImageConfig == null) {
    return null;
  }

  return $ProductImageConfigEntityCopyWith<$Res>(_self.productImageConfig!, (value) {
    return _then(_self.copyWith(productImageConfig: value));
  });
}
}

// dart format on
