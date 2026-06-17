// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_meta_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PageMetaEntity {

 int get page; int get pageSize; int get totalCount; bool get hasNextPage; String? get pageTitle; String? get pageSubtitle; int? get plpId; int get orderRule;
/// Create a copy of PageMetaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageMetaEntityCopyWith<PageMetaEntity> get copyWith => _$PageMetaEntityCopyWithImpl<PageMetaEntity>(this as PageMetaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageMetaEntity&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.pageTitle, pageTitle) || other.pageTitle == pageTitle)&&(identical(other.pageSubtitle, pageSubtitle) || other.pageSubtitle == pageSubtitle)&&(identical(other.plpId, plpId) || other.plpId == plpId)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule));
}


@override
int get hashCode => Object.hash(runtimeType,page,pageSize,totalCount,hasNextPage,pageTitle,pageSubtitle,plpId,orderRule);

@override
String toString() {
  return 'PageMetaEntity(page: $page, pageSize: $pageSize, totalCount: $totalCount, hasNextPage: $hasNextPage, pageTitle: $pageTitle, pageSubtitle: $pageSubtitle, plpId: $plpId, orderRule: $orderRule)';
}


}

/// @nodoc
abstract mixin class $PageMetaEntityCopyWith<$Res>  {
  factory $PageMetaEntityCopyWith(PageMetaEntity value, $Res Function(PageMetaEntity) _then) = _$PageMetaEntityCopyWithImpl;
@useResult
$Res call({
 int page, int pageSize, int totalCount, bool hasNextPage, String? pageTitle, String? pageSubtitle, int? plpId, int orderRule
});




}
/// @nodoc
class _$PageMetaEntityCopyWithImpl<$Res>
    implements $PageMetaEntityCopyWith<$Res> {
  _$PageMetaEntityCopyWithImpl(this._self, this._then);

  final PageMetaEntity _self;
  final $Res Function(PageMetaEntity) _then;

/// Create a copy of PageMetaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? pageSize = null,Object? totalCount = null,Object? hasNextPage = null,Object? pageTitle = freezed,Object? pageSubtitle = freezed,Object? plpId = freezed,Object? orderRule = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,pageTitle: freezed == pageTitle ? _self.pageTitle : pageTitle // ignore: cast_nullable_to_non_nullable
as String?,pageSubtitle: freezed == pageSubtitle ? _self.pageSubtitle : pageSubtitle // ignore: cast_nullable_to_non_nullable
as String?,plpId: freezed == plpId ? _self.plpId : plpId // ignore: cast_nullable_to_non_nullable
as int?,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PageMetaEntity].
extension PageMetaEntityPatterns on PageMetaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageMetaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageMetaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageMetaEntity value)  $default,){
final _that = this;
switch (_that) {
case _PageMetaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageMetaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PageMetaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int pageSize,  int totalCount,  bool hasNextPage,  String? pageTitle,  String? pageSubtitle,  int? plpId,  int orderRule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageMetaEntity() when $default != null:
return $default(_that.page,_that.pageSize,_that.totalCount,_that.hasNextPage,_that.pageTitle,_that.pageSubtitle,_that.plpId,_that.orderRule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int pageSize,  int totalCount,  bool hasNextPage,  String? pageTitle,  String? pageSubtitle,  int? plpId,  int orderRule)  $default,) {final _that = this;
switch (_that) {
case _PageMetaEntity():
return $default(_that.page,_that.pageSize,_that.totalCount,_that.hasNextPage,_that.pageTitle,_that.pageSubtitle,_that.plpId,_that.orderRule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int pageSize,  int totalCount,  bool hasNextPage,  String? pageTitle,  String? pageSubtitle,  int? plpId,  int orderRule)?  $default,) {final _that = this;
switch (_that) {
case _PageMetaEntity() when $default != null:
return $default(_that.page,_that.pageSize,_that.totalCount,_that.hasNextPage,_that.pageTitle,_that.pageSubtitle,_that.plpId,_that.orderRule);case _:
  return null;

}
}

}

/// @nodoc


class _PageMetaEntity implements PageMetaEntity {
  const _PageMetaEntity({this.page = 1, this.pageSize = 20, this.totalCount = 0, this.hasNextPage = false, this.pageTitle, this.pageSubtitle, this.plpId, this.orderRule = -1});
  

@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int totalCount;
@override@JsonKey() final  bool hasNextPage;
@override final  String? pageTitle;
@override final  String? pageSubtitle;
@override final  int? plpId;
@override@JsonKey() final  int orderRule;

/// Create a copy of PageMetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageMetaEntityCopyWith<_PageMetaEntity> get copyWith => __$PageMetaEntityCopyWithImpl<_PageMetaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageMetaEntity&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.pageTitle, pageTitle) || other.pageTitle == pageTitle)&&(identical(other.pageSubtitle, pageSubtitle) || other.pageSubtitle == pageSubtitle)&&(identical(other.plpId, plpId) || other.plpId == plpId)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule));
}


@override
int get hashCode => Object.hash(runtimeType,page,pageSize,totalCount,hasNextPage,pageTitle,pageSubtitle,plpId,orderRule);

@override
String toString() {
  return 'PageMetaEntity(page: $page, pageSize: $pageSize, totalCount: $totalCount, hasNextPage: $hasNextPage, pageTitle: $pageTitle, pageSubtitle: $pageSubtitle, plpId: $plpId, orderRule: $orderRule)';
}


}

/// @nodoc
abstract mixin class _$PageMetaEntityCopyWith<$Res> implements $PageMetaEntityCopyWith<$Res> {
  factory _$PageMetaEntityCopyWith(_PageMetaEntity value, $Res Function(_PageMetaEntity) _then) = __$PageMetaEntityCopyWithImpl;
@override @useResult
$Res call({
 int page, int pageSize, int totalCount, bool hasNextPage, String? pageTitle, String? pageSubtitle, int? plpId, int orderRule
});




}
/// @nodoc
class __$PageMetaEntityCopyWithImpl<$Res>
    implements _$PageMetaEntityCopyWith<$Res> {
  __$PageMetaEntityCopyWithImpl(this._self, this._then);

  final _PageMetaEntity _self;
  final $Res Function(_PageMetaEntity) _then;

/// Create a copy of PageMetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? pageSize = null,Object? totalCount = null,Object? hasNextPage = null,Object? pageTitle = freezed,Object? pageSubtitle = freezed,Object? plpId = freezed,Object? orderRule = null,}) {
  return _then(_PageMetaEntity(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,pageTitle: freezed == pageTitle ? _self.pageTitle : pageTitle // ignore: cast_nullable_to_non_nullable
as String?,pageSubtitle: freezed == pageSubtitle ? _self.pageSubtitle : pageSubtitle // ignore: cast_nullable_to_non_nullable
as String?,plpId: freezed == plpId ? _self.plpId : plpId // ignore: cast_nullable_to_non_nullable
as int?,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
