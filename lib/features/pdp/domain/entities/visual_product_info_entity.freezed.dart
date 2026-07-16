// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visual_product_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisualProductInfoEntity {

 String? get groupName; List<VisualProductItemEntity> get items; String? get title;
/// Create a copy of VisualProductInfoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisualProductInfoEntityCopyWith<VisualProductInfoEntity> get copyWith => _$VisualProductInfoEntityCopyWithImpl<VisualProductInfoEntity>(this as VisualProductInfoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisualProductInfoEntity&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(items),title);

@override
String toString() {
  return 'VisualProductInfoEntity(groupName: $groupName, items: $items, title: $title)';
}


}

/// @nodoc
abstract mixin class $VisualProductInfoEntityCopyWith<$Res>  {
  factory $VisualProductInfoEntityCopyWith(VisualProductInfoEntity value, $Res Function(VisualProductInfoEntity) _then) = _$VisualProductInfoEntityCopyWithImpl;
@useResult
$Res call({
 String? groupName, List<VisualProductItemEntity> items, String? title
});




}
/// @nodoc
class _$VisualProductInfoEntityCopyWithImpl<$Res>
    implements $VisualProductInfoEntityCopyWith<$Res> {
  _$VisualProductInfoEntityCopyWithImpl(this._self, this._then);

  final VisualProductInfoEntity _self;
  final $Res Function(VisualProductInfoEntity) _then;

/// Create a copy of VisualProductInfoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupName = freezed,Object? items = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<VisualProductItemEntity>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisualProductInfoEntity].
extension VisualProductInfoEntityPatterns on VisualProductInfoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisualProductInfoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisualProductInfoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisualProductInfoEntity value)  $default,){
final _that = this;
switch (_that) {
case _VisualProductInfoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisualProductInfoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VisualProductInfoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? groupName,  List<VisualProductItemEntity> items,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisualProductInfoEntity() when $default != null:
return $default(_that.groupName,_that.items,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? groupName,  List<VisualProductItemEntity> items,  String? title)  $default,) {final _that = this;
switch (_that) {
case _VisualProductInfoEntity():
return $default(_that.groupName,_that.items,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? groupName,  List<VisualProductItemEntity> items,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _VisualProductInfoEntity() when $default != null:
return $default(_that.groupName,_that.items,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _VisualProductInfoEntity implements VisualProductInfoEntity {
  const _VisualProductInfoEntity({this.groupName, final  List<VisualProductItemEntity> items = const [], this.title}): _items = items;
  

@override final  String? groupName;
 final  List<VisualProductItemEntity> _items;
@override@JsonKey() List<VisualProductItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? title;

/// Create a copy of VisualProductInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisualProductInfoEntityCopyWith<_VisualProductInfoEntity> get copyWith => __$VisualProductInfoEntityCopyWithImpl<_VisualProductInfoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisualProductInfoEntity&&(identical(other.groupName, groupName) || other.groupName == groupName)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,const DeepCollectionEquality().hash(_items),title);

@override
String toString() {
  return 'VisualProductInfoEntity(groupName: $groupName, items: $items, title: $title)';
}


}

/// @nodoc
abstract mixin class _$VisualProductInfoEntityCopyWith<$Res> implements $VisualProductInfoEntityCopyWith<$Res> {
  factory _$VisualProductInfoEntityCopyWith(_VisualProductInfoEntity value, $Res Function(_VisualProductInfoEntity) _then) = __$VisualProductInfoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? groupName, List<VisualProductItemEntity> items, String? title
});




}
/// @nodoc
class __$VisualProductInfoEntityCopyWithImpl<$Res>
    implements _$VisualProductInfoEntityCopyWith<$Res> {
  __$VisualProductInfoEntityCopyWithImpl(this._self, this._then);

  final _VisualProductInfoEntity _self;
  final $Res Function(_VisualProductInfoEntity) _then;

/// Create a copy of VisualProductInfoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupName = freezed,Object? items = null,Object? title = freezed,}) {
  return _then(_VisualProductInfoEntity(
groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<VisualProductItemEntity>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$VisualProductItemEntity {

 String? get id; String? get name; String? get type; String? get url;
/// Create a copy of VisualProductItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisualProductItemEntityCopyWith<VisualProductItemEntity> get copyWith => _$VisualProductItemEntityCopyWithImpl<VisualProductItemEntity>(this as VisualProductItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisualProductItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,url);

@override
String toString() {
  return 'VisualProductItemEntity(id: $id, name: $name, type: $type, url: $url)';
}


}

/// @nodoc
abstract mixin class $VisualProductItemEntityCopyWith<$Res>  {
  factory $VisualProductItemEntityCopyWith(VisualProductItemEntity value, $Res Function(VisualProductItemEntity) _then) = _$VisualProductItemEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? type, String? url
});




}
/// @nodoc
class _$VisualProductItemEntityCopyWithImpl<$Res>
    implements $VisualProductItemEntityCopyWith<$Res> {
  _$VisualProductItemEntityCopyWithImpl(this._self, this._then);

  final VisualProductItemEntity _self;
  final $Res Function(VisualProductItemEntity) _then;

/// Create a copy of VisualProductItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? type = freezed,Object? url = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisualProductItemEntity].
extension VisualProductItemEntityPatterns on VisualProductItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisualProductItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisualProductItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisualProductItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _VisualProductItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisualProductItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VisualProductItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? type,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisualProductItemEntity() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? type,  String? url)  $default,) {final _that = this;
switch (_that) {
case _VisualProductItemEntity():
return $default(_that.id,_that.name,_that.type,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? type,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _VisualProductItemEntity() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _VisualProductItemEntity implements VisualProductItemEntity {
  const _VisualProductItemEntity({this.id, this.name, this.type, this.url});
  

@override final  String? id;
@override final  String? name;
@override final  String? type;
@override final  String? url;

/// Create a copy of VisualProductItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisualProductItemEntityCopyWith<_VisualProductItemEntity> get copyWith => __$VisualProductItemEntityCopyWithImpl<_VisualProductItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisualProductItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,url);

@override
String toString() {
  return 'VisualProductItemEntity(id: $id, name: $name, type: $type, url: $url)';
}


}

/// @nodoc
abstract mixin class _$VisualProductItemEntityCopyWith<$Res> implements $VisualProductItemEntityCopyWith<$Res> {
  factory _$VisualProductItemEntityCopyWith(_VisualProductItemEntity value, $Res Function(_VisualProductItemEntity) _then) = __$VisualProductItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? type, String? url
});




}
/// @nodoc
class __$VisualProductItemEntityCopyWithImpl<$Res>
    implements _$VisualProductItemEntityCopyWith<$Res> {
  __$VisualProductItemEntityCopyWithImpl(this._self, this._then);

  final _VisualProductItemEntity _self;
  final $Res Function(_VisualProductItemEntity) _then;

/// Create a copy of VisualProductItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? type = freezed,Object? url = freezed,}) {
  return _then(_VisualProductItemEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
