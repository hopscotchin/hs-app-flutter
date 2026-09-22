// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoriesPageEntity {

 String? get action; PageMeta? get pageMeta; String? get searchPlaceHolder; List<PageComponent> get pageComponents;
/// Create a copy of CategoriesPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesPageEntityCopyWith<CategoriesPageEntity> get copyWith => _$CategoriesPageEntityCopyWithImpl<CategoriesPageEntity>(this as CategoriesPageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesPageEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.searchPlaceHolder, searchPlaceHolder) || other.searchPlaceHolder == searchPlaceHolder)&&const DeepCollectionEquality().equals(other.pageComponents, pageComponents));
}


@override
int get hashCode => Object.hash(runtimeType,action,pageMeta,searchPlaceHolder,const DeepCollectionEquality().hash(pageComponents));

@override
String toString() {
  return 'CategoriesPageEntity(action: $action, pageMeta: $pageMeta, searchPlaceHolder: $searchPlaceHolder, pageComponents: $pageComponents)';
}


}

/// @nodoc
abstract mixin class $CategoriesPageEntityCopyWith<$Res>  {
  factory $CategoriesPageEntityCopyWith(CategoriesPageEntity value, $Res Function(CategoriesPageEntity) _then) = _$CategoriesPageEntityCopyWithImpl;
@useResult
$Res call({
 String? action, PageMeta? pageMeta, String? searchPlaceHolder, List<PageComponent> pageComponents
});




}
/// @nodoc
class _$CategoriesPageEntityCopyWithImpl<$Res>
    implements $CategoriesPageEntityCopyWith<$Res> {
  _$CategoriesPageEntityCopyWithImpl(this._self, this._then);

  final CategoriesPageEntity _self;
  final $Res Function(CategoriesPageEntity) _then;

/// Create a copy of CategoriesPageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? pageMeta = freezed,Object? searchPlaceHolder = freezed,Object? pageComponents = null,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMeta?,searchPlaceHolder: freezed == searchPlaceHolder ? _self.searchPlaceHolder : searchPlaceHolder // ignore: cast_nullable_to_non_nullable
as String?,pageComponents: null == pageComponents ? _self.pageComponents : pageComponents // ignore: cast_nullable_to_non_nullable
as List<PageComponent>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoriesPageEntity].
extension CategoriesPageEntityPatterns on CategoriesPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoriesPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoriesPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoriesPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _CategoriesPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoriesPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CategoriesPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  PageMeta? pageMeta,  String? searchPlaceHolder,  List<PageComponent> pageComponents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoriesPageEntity() when $default != null:
return $default(_that.action,_that.pageMeta,_that.searchPlaceHolder,_that.pageComponents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  PageMeta? pageMeta,  String? searchPlaceHolder,  List<PageComponent> pageComponents)  $default,) {final _that = this;
switch (_that) {
case _CategoriesPageEntity():
return $default(_that.action,_that.pageMeta,_that.searchPlaceHolder,_that.pageComponents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  PageMeta? pageMeta,  String? searchPlaceHolder,  List<PageComponent> pageComponents)?  $default,) {final _that = this;
switch (_that) {
case _CategoriesPageEntity() when $default != null:
return $default(_that.action,_that.pageMeta,_that.searchPlaceHolder,_that.pageComponents);case _:
  return null;

}
}

}

/// @nodoc


class _CategoriesPageEntity implements CategoriesPageEntity {
  const _CategoriesPageEntity({this.action, this.pageMeta, this.searchPlaceHolder, final  List<PageComponent> pageComponents = const <PageComponent>[]}): _pageComponents = pageComponents;
  

@override final  String? action;
@override final  PageMeta? pageMeta;
@override final  String? searchPlaceHolder;
 final  List<PageComponent> _pageComponents;
@override@JsonKey() List<PageComponent> get pageComponents {
  if (_pageComponents is EqualUnmodifiableListView) return _pageComponents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pageComponents);
}


/// Create a copy of CategoriesPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesPageEntityCopyWith<_CategoriesPageEntity> get copyWith => __$CategoriesPageEntityCopyWithImpl<_CategoriesPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesPageEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.searchPlaceHolder, searchPlaceHolder) || other.searchPlaceHolder == searchPlaceHolder)&&const DeepCollectionEquality().equals(other._pageComponents, _pageComponents));
}


@override
int get hashCode => Object.hash(runtimeType,action,pageMeta,searchPlaceHolder,const DeepCollectionEquality().hash(_pageComponents));

@override
String toString() {
  return 'CategoriesPageEntity(action: $action, pageMeta: $pageMeta, searchPlaceHolder: $searchPlaceHolder, pageComponents: $pageComponents)';
}


}

/// @nodoc
abstract mixin class _$CategoriesPageEntityCopyWith<$Res> implements $CategoriesPageEntityCopyWith<$Res> {
  factory _$CategoriesPageEntityCopyWith(_CategoriesPageEntity value, $Res Function(_CategoriesPageEntity) _then) = __$CategoriesPageEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, PageMeta? pageMeta, String? searchPlaceHolder, List<PageComponent> pageComponents
});




}
/// @nodoc
class __$CategoriesPageEntityCopyWithImpl<$Res>
    implements _$CategoriesPageEntityCopyWith<$Res> {
  __$CategoriesPageEntityCopyWithImpl(this._self, this._then);

  final _CategoriesPageEntity _self;
  final $Res Function(_CategoriesPageEntity) _then;

/// Create a copy of CategoriesPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? pageMeta = freezed,Object? searchPlaceHolder = freezed,Object? pageComponents = null,}) {
  return _then(_CategoriesPageEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMeta?,searchPlaceHolder: freezed == searchPlaceHolder ? _self.searchPlaceHolder : searchPlaceHolder // ignore: cast_nullable_to_non_nullable
as String?,pageComponents: null == pageComponents ? _self._pageComponents : pageComponents // ignore: cast_nullable_to_non_nullable
as List<PageComponent>,
  ));
}


}

// dart format on
