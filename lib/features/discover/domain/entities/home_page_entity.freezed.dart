// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomePageEntity {

 String? get action; String? get popUpMessage; List<MessageBarEntity> get messageBars; String? get pageName; String? get pageBackgroundColor; String? get headerBgImageUrl; int get totalCollections; int get totalSections; List<PageComponent> get pageComponents;
/// Create a copy of HomePageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomePageEntityCopyWith<HomePageEntity> get copyWith => _$HomePageEntityCopyWithImpl<HomePageEntity>(this as HomePageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomePageEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other.messageBars, messageBars)&&(identical(other.pageName, pageName) || other.pageName == pageName)&&(identical(other.pageBackgroundColor, pageBackgroundColor) || other.pageBackgroundColor == pageBackgroundColor)&&(identical(other.headerBgImageUrl, headerBgImageUrl) || other.headerBgImageUrl == headerBgImageUrl)&&(identical(other.totalCollections, totalCollections) || other.totalCollections == totalCollections)&&(identical(other.totalSections, totalSections) || other.totalSections == totalSections)&&const DeepCollectionEquality().equals(other.pageComponents, pageComponents));
}


@override
int get hashCode => Object.hash(runtimeType,action,popUpMessage,const DeepCollectionEquality().hash(messageBars),pageName,pageBackgroundColor,headerBgImageUrl,totalCollections,totalSections,const DeepCollectionEquality().hash(pageComponents));

@override
String toString() {
  return 'HomePageEntity(action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars, pageName: $pageName, pageBackgroundColor: $pageBackgroundColor, headerBgImageUrl: $headerBgImageUrl, totalCollections: $totalCollections, totalSections: $totalSections, pageComponents: $pageComponents)';
}


}

/// @nodoc
abstract mixin class $HomePageEntityCopyWith<$Res>  {
  factory $HomePageEntityCopyWith(HomePageEntity value, $Res Function(HomePageEntity) _then) = _$HomePageEntityCopyWithImpl;
@useResult
$Res call({
 String? action, String? popUpMessage, List<MessageBarEntity> messageBars, String? pageName, String? pageBackgroundColor, String? headerBgImageUrl, int totalCollections, int totalSections, List<PageComponent> pageComponents
});




}
/// @nodoc
class _$HomePageEntityCopyWithImpl<$Res>
    implements $HomePageEntityCopyWith<$Res> {
  _$HomePageEntityCopyWithImpl(this._self, this._then);

  final HomePageEntity _self;
  final $Res Function(HomePageEntity) _then;

/// Create a copy of HomePageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,Object? pageName = freezed,Object? pageBackgroundColor = freezed,Object? headerBgImageUrl = freezed,Object? totalCollections = null,Object? totalSections = null,Object? pageComponents = null,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,pageName: freezed == pageName ? _self.pageName : pageName // ignore: cast_nullable_to_non_nullable
as String?,pageBackgroundColor: freezed == pageBackgroundColor ? _self.pageBackgroundColor : pageBackgroundColor // ignore: cast_nullable_to_non_nullable
as String?,headerBgImageUrl: freezed == headerBgImageUrl ? _self.headerBgImageUrl : headerBgImageUrl // ignore: cast_nullable_to_non_nullable
as String?,totalCollections: null == totalCollections ? _self.totalCollections : totalCollections // ignore: cast_nullable_to_non_nullable
as int,totalSections: null == totalSections ? _self.totalSections : totalSections // ignore: cast_nullable_to_non_nullable
as int,pageComponents: null == pageComponents ? _self.pageComponents : pageComponents // ignore: cast_nullable_to_non_nullable
as List<PageComponent>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomePageEntity].
extension HomePageEntityPatterns on HomePageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomePageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomePageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomePageEntity value)  $default,){
final _that = this;
switch (_that) {
case _HomePageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomePageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HomePageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars,  String? pageName,  String? pageBackgroundColor,  String? headerBgImageUrl,  int totalCollections,  int totalSections,  List<PageComponent> pageComponents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomePageEntity() when $default != null:
return $default(_that.action,_that.popUpMessage,_that.messageBars,_that.pageName,_that.pageBackgroundColor,_that.headerBgImageUrl,_that.totalCollections,_that.totalSections,_that.pageComponents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars,  String? pageName,  String? pageBackgroundColor,  String? headerBgImageUrl,  int totalCollections,  int totalSections,  List<PageComponent> pageComponents)  $default,) {final _that = this;
switch (_that) {
case _HomePageEntity():
return $default(_that.action,_that.popUpMessage,_that.messageBars,_that.pageName,_that.pageBackgroundColor,_that.headerBgImageUrl,_that.totalCollections,_that.totalSections,_that.pageComponents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  String? popUpMessage,  List<MessageBarEntity> messageBars,  String? pageName,  String? pageBackgroundColor,  String? headerBgImageUrl,  int totalCollections,  int totalSections,  List<PageComponent> pageComponents)?  $default,) {final _that = this;
switch (_that) {
case _HomePageEntity() when $default != null:
return $default(_that.action,_that.popUpMessage,_that.messageBars,_that.pageName,_that.pageBackgroundColor,_that.headerBgImageUrl,_that.totalCollections,_that.totalSections,_that.pageComponents);case _:
  return null;

}
}

}

/// @nodoc


class _HomePageEntity implements HomePageEntity {
  const _HomePageEntity({this.action, this.popUpMessage, final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[], this.pageName, this.pageBackgroundColor, this.headerBgImageUrl, this.totalCollections = 0, this.totalSections = 0, final  List<PageComponent> pageComponents = const <PageComponent>[]}): _messageBars = messageBars,_pageComponents = pageComponents;
  

@override final  String? action;
@override final  String? popUpMessage;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}

@override final  String? pageName;
@override final  String? pageBackgroundColor;
@override final  String? headerBgImageUrl;
@override@JsonKey() final  int totalCollections;
@override@JsonKey() final  int totalSections;
 final  List<PageComponent> _pageComponents;
@override@JsonKey() List<PageComponent> get pageComponents {
  if (_pageComponents is EqualUnmodifiableListView) return _pageComponents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pageComponents);
}


/// Create a copy of HomePageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomePageEntityCopyWith<_HomePageEntity> get copyWith => __$HomePageEntityCopyWithImpl<_HomePageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomePageEntity&&(identical(other.action, action) || other.action == action)&&(identical(other.popUpMessage, popUpMessage) || other.popUpMessage == popUpMessage)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars)&&(identical(other.pageName, pageName) || other.pageName == pageName)&&(identical(other.pageBackgroundColor, pageBackgroundColor) || other.pageBackgroundColor == pageBackgroundColor)&&(identical(other.headerBgImageUrl, headerBgImageUrl) || other.headerBgImageUrl == headerBgImageUrl)&&(identical(other.totalCollections, totalCollections) || other.totalCollections == totalCollections)&&(identical(other.totalSections, totalSections) || other.totalSections == totalSections)&&const DeepCollectionEquality().equals(other._pageComponents, _pageComponents));
}


@override
int get hashCode => Object.hash(runtimeType,action,popUpMessage,const DeepCollectionEquality().hash(_messageBars),pageName,pageBackgroundColor,headerBgImageUrl,totalCollections,totalSections,const DeepCollectionEquality().hash(_pageComponents));

@override
String toString() {
  return 'HomePageEntity(action: $action, popUpMessage: $popUpMessage, messageBars: $messageBars, pageName: $pageName, pageBackgroundColor: $pageBackgroundColor, headerBgImageUrl: $headerBgImageUrl, totalCollections: $totalCollections, totalSections: $totalSections, pageComponents: $pageComponents)';
}


}

/// @nodoc
abstract mixin class _$HomePageEntityCopyWith<$Res> implements $HomePageEntityCopyWith<$Res> {
  factory _$HomePageEntityCopyWith(_HomePageEntity value, $Res Function(_HomePageEntity) _then) = __$HomePageEntityCopyWithImpl;
@override @useResult
$Res call({
 String? action, String? popUpMessage, List<MessageBarEntity> messageBars, String? pageName, String? pageBackgroundColor, String? headerBgImageUrl, int totalCollections, int totalSections, List<PageComponent> pageComponents
});




}
/// @nodoc
class __$HomePageEntityCopyWithImpl<$Res>
    implements _$HomePageEntityCopyWith<$Res> {
  __$HomePageEntityCopyWithImpl(this._self, this._then);

  final _HomePageEntity _self;
  final $Res Function(_HomePageEntity) _then;

/// Create a copy of HomePageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? popUpMessage = freezed,Object? messageBars = null,Object? pageName = freezed,Object? pageBackgroundColor = freezed,Object? headerBgImageUrl = freezed,Object? totalCollections = null,Object? totalSections = null,Object? pageComponents = null,}) {
  return _then(_HomePageEntity(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,popUpMessage: freezed == popUpMessage ? _self.popUpMessage : popUpMessage // ignore: cast_nullable_to_non_nullable
as String?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,pageName: freezed == pageName ? _self.pageName : pageName // ignore: cast_nullable_to_non_nullable
as String?,pageBackgroundColor: freezed == pageBackgroundColor ? _self.pageBackgroundColor : pageBackgroundColor // ignore: cast_nullable_to_non_nullable
as String?,headerBgImageUrl: freezed == headerBgImageUrl ? _self.headerBgImageUrl : headerBgImageUrl // ignore: cast_nullable_to_non_nullable
as String?,totalCollections: null == totalCollections ? _self.totalCollections : totalCollections // ignore: cast_nullable_to_non_nullable
as int,totalSections: null == totalSections ? _self.totalSections : totalSections // ignore: cast_nullable_to_non_nullable
as int,pageComponents: null == pageComponents ? _self._pageComponents : pageComponents // ignore: cast_nullable_to_non_nullable
as List<PageComponent>,
  ));
}


}

// dart format on
