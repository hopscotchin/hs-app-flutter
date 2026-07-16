// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailEntity {

 String? get tabName; List<DetailItemEntity> get items;
/// Create a copy of DetailEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailEntityCopyWith<DetailEntity> get copyWith => _$DetailEntityCopyWithImpl<DetailEntity>(this as DetailEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailEntity&&(identical(other.tabName, tabName) || other.tabName == tabName)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,tabName,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'DetailEntity(tabName: $tabName, items: $items)';
}


}

/// @nodoc
abstract mixin class $DetailEntityCopyWith<$Res>  {
  factory $DetailEntityCopyWith(DetailEntity value, $Res Function(DetailEntity) _then) = _$DetailEntityCopyWithImpl;
@useResult
$Res call({
 String? tabName, List<DetailItemEntity> items
});




}
/// @nodoc
class _$DetailEntityCopyWithImpl<$Res>
    implements $DetailEntityCopyWith<$Res> {
  _$DetailEntityCopyWithImpl(this._self, this._then);

  final DetailEntity _self;
  final $Res Function(DetailEntity) _then;

/// Create a copy of DetailEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tabName = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
tabName: freezed == tabName ? _self.tabName : tabName // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DetailItemEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [DetailEntity].
extension DetailEntityPatterns on DetailEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailEntity value)  $default,){
final _that = this;
switch (_that) {
case _DetailEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DetailEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? tabName,  List<DetailItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailEntity() when $default != null:
return $default(_that.tabName,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? tabName,  List<DetailItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _DetailEntity():
return $default(_that.tabName,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? tabName,  List<DetailItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _DetailEntity() when $default != null:
return $default(_that.tabName,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _DetailEntity implements DetailEntity {
  const _DetailEntity({this.tabName, final  List<DetailItemEntity> items = const []}): _items = items;
  

@override final  String? tabName;
 final  List<DetailItemEntity> _items;
@override@JsonKey() List<DetailItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailEntityCopyWith<_DetailEntity> get copyWith => __$DetailEntityCopyWithImpl<_DetailEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailEntity&&(identical(other.tabName, tabName) || other.tabName == tabName)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,tabName,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'DetailEntity(tabName: $tabName, items: $items)';
}


}

/// @nodoc
abstract mixin class _$DetailEntityCopyWith<$Res> implements $DetailEntityCopyWith<$Res> {
  factory _$DetailEntityCopyWith(_DetailEntity value, $Res Function(_DetailEntity) _then) = __$DetailEntityCopyWithImpl;
@override @useResult
$Res call({
 String? tabName, List<DetailItemEntity> items
});




}
/// @nodoc
class __$DetailEntityCopyWithImpl<$Res>
    implements _$DetailEntityCopyWith<$Res> {
  __$DetailEntityCopyWithImpl(this._self, this._then);

  final _DetailEntity _self;
  final $Res Function(_DetailEntity) _then;

/// Create a copy of DetailEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tabName = freezed,Object? items = null,}) {
  return _then(_DetailEntity(
tabName: freezed == tabName ? _self.tabName : tabName // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DetailItemEntity>,
  ));
}


}

// dart format on
