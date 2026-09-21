// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kids_list_content_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KidsListContentEntity {

// Empty-state (no children yet) heading/subheading.
 String get emptyStateTitle; String get emptyStateSubtitle;// Backend-sent illustration for the empty state. Currently captured for
// completeness only — the empty state still renders its local default
// illustration; wiring this through needs `EmptyStateWidget`'s `icon`
// override to actually be read by `_resolvedIcon`, which it isn't today.
 String? get emptyStateIcon;// Info banner shown above a populated list — the backend sends this as
// a full message-bar object (title/message/bgColor/...), the same shape
// used everywhere else in the app, not separate title/subtitle strings.
// Null means "don't show a banner" — the fallback has no hardcoded copy
// to show in its place (unlike every other field here), so the screen
// renders with no banner at all until backend actually sends one.
 MessageBarEntity? get messageBar;// Persistent "Add child" footer row. Backend-resolved single title.
 String get addChildTitle; String get addChildSubtitle;// Single leading/trailing icons, replacing the old two-avatar preview
// stack and hardcoded "+" glyph. Null renders the local placeholder.
 String? get addChildLeadingIcon; String? get addChildTrailingIcon;
/// Create a copy of KidsListContentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KidsListContentEntityCopyWith<KidsListContentEntity> get copyWith => _$KidsListContentEntityCopyWithImpl<KidsListContentEntity>(this as KidsListContentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidsListContentEntity&&(identical(other.emptyStateTitle, emptyStateTitle) || other.emptyStateTitle == emptyStateTitle)&&(identical(other.emptyStateSubtitle, emptyStateSubtitle) || other.emptyStateSubtitle == emptyStateSubtitle)&&(identical(other.emptyStateIcon, emptyStateIcon) || other.emptyStateIcon == emptyStateIcon)&&(identical(other.messageBar, messageBar) || other.messageBar == messageBar)&&(identical(other.addChildTitle, addChildTitle) || other.addChildTitle == addChildTitle)&&(identical(other.addChildSubtitle, addChildSubtitle) || other.addChildSubtitle == addChildSubtitle)&&(identical(other.addChildLeadingIcon, addChildLeadingIcon) || other.addChildLeadingIcon == addChildLeadingIcon)&&(identical(other.addChildTrailingIcon, addChildTrailingIcon) || other.addChildTrailingIcon == addChildTrailingIcon));
}


@override
int get hashCode => Object.hash(runtimeType,emptyStateTitle,emptyStateSubtitle,emptyStateIcon,messageBar,addChildTitle,addChildSubtitle,addChildLeadingIcon,addChildTrailingIcon);

@override
String toString() {
  return 'KidsListContentEntity(emptyStateTitle: $emptyStateTitle, emptyStateSubtitle: $emptyStateSubtitle, emptyStateIcon: $emptyStateIcon, messageBar: $messageBar, addChildTitle: $addChildTitle, addChildSubtitle: $addChildSubtitle, addChildLeadingIcon: $addChildLeadingIcon, addChildTrailingIcon: $addChildTrailingIcon)';
}


}

/// @nodoc
abstract mixin class $KidsListContentEntityCopyWith<$Res>  {
  factory $KidsListContentEntityCopyWith(KidsListContentEntity value, $Res Function(KidsListContentEntity) _then) = _$KidsListContentEntityCopyWithImpl;
@useResult
$Res call({
 String emptyStateTitle, String emptyStateSubtitle, String? emptyStateIcon, MessageBarEntity? messageBar, String addChildTitle, String addChildSubtitle, String? addChildLeadingIcon, String? addChildTrailingIcon
});




}
/// @nodoc
class _$KidsListContentEntityCopyWithImpl<$Res>
    implements $KidsListContentEntityCopyWith<$Res> {
  _$KidsListContentEntityCopyWithImpl(this._self, this._then);

  final KidsListContentEntity _self;
  final $Res Function(KidsListContentEntity) _then;

/// Create a copy of KidsListContentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emptyStateTitle = null,Object? emptyStateSubtitle = null,Object? emptyStateIcon = freezed,Object? messageBar = freezed,Object? addChildTitle = null,Object? addChildSubtitle = null,Object? addChildLeadingIcon = freezed,Object? addChildTrailingIcon = freezed,}) {
  return _then(_self.copyWith(
emptyStateTitle: null == emptyStateTitle ? _self.emptyStateTitle : emptyStateTitle // ignore: cast_nullable_to_non_nullable
as String,emptyStateSubtitle: null == emptyStateSubtitle ? _self.emptyStateSubtitle : emptyStateSubtitle // ignore: cast_nullable_to_non_nullable
as String,emptyStateIcon: freezed == emptyStateIcon ? _self.emptyStateIcon : emptyStateIcon // ignore: cast_nullable_to_non_nullable
as String?,messageBar: freezed == messageBar ? _self.messageBar : messageBar // ignore: cast_nullable_to_non_nullable
as MessageBarEntity?,addChildTitle: null == addChildTitle ? _self.addChildTitle : addChildTitle // ignore: cast_nullable_to_non_nullable
as String,addChildSubtitle: null == addChildSubtitle ? _self.addChildSubtitle : addChildSubtitle // ignore: cast_nullable_to_non_nullable
as String,addChildLeadingIcon: freezed == addChildLeadingIcon ? _self.addChildLeadingIcon : addChildLeadingIcon // ignore: cast_nullable_to_non_nullable
as String?,addChildTrailingIcon: freezed == addChildTrailingIcon ? _self.addChildTrailingIcon : addChildTrailingIcon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KidsListContentEntity].
extension KidsListContentEntityPatterns on KidsListContentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KidsListContentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KidsListContentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KidsListContentEntity value)  $default,){
final _that = this;
switch (_that) {
case _KidsListContentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KidsListContentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KidsListContentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emptyStateTitle,  String emptyStateSubtitle,  String? emptyStateIcon,  MessageBarEntity? messageBar,  String addChildTitle,  String addChildSubtitle,  String? addChildLeadingIcon,  String? addChildTrailingIcon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KidsListContentEntity() when $default != null:
return $default(_that.emptyStateTitle,_that.emptyStateSubtitle,_that.emptyStateIcon,_that.messageBar,_that.addChildTitle,_that.addChildSubtitle,_that.addChildLeadingIcon,_that.addChildTrailingIcon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emptyStateTitle,  String emptyStateSubtitle,  String? emptyStateIcon,  MessageBarEntity? messageBar,  String addChildTitle,  String addChildSubtitle,  String? addChildLeadingIcon,  String? addChildTrailingIcon)  $default,) {final _that = this;
switch (_that) {
case _KidsListContentEntity():
return $default(_that.emptyStateTitle,_that.emptyStateSubtitle,_that.emptyStateIcon,_that.messageBar,_that.addChildTitle,_that.addChildSubtitle,_that.addChildLeadingIcon,_that.addChildTrailingIcon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emptyStateTitle,  String emptyStateSubtitle,  String? emptyStateIcon,  MessageBarEntity? messageBar,  String addChildTitle,  String addChildSubtitle,  String? addChildLeadingIcon,  String? addChildTrailingIcon)?  $default,) {final _that = this;
switch (_that) {
case _KidsListContentEntity() when $default != null:
return $default(_that.emptyStateTitle,_that.emptyStateSubtitle,_that.emptyStateIcon,_that.messageBar,_that.addChildTitle,_that.addChildSubtitle,_that.addChildLeadingIcon,_that.addChildTrailingIcon);case _:
  return null;

}
}

}

/// @nodoc


class _KidsListContentEntity implements KidsListContentEntity {
  const _KidsListContentEntity({required this.emptyStateTitle, required this.emptyStateSubtitle, this.emptyStateIcon, required this.messageBar, required this.addChildTitle, required this.addChildSubtitle, this.addChildLeadingIcon, this.addChildTrailingIcon});
  

// Empty-state (no children yet) heading/subheading.
@override final  String emptyStateTitle;
@override final  String emptyStateSubtitle;
// Backend-sent illustration for the empty state. Currently captured for
// completeness only — the empty state still renders its local default
// illustration; wiring this through needs `EmptyStateWidget`'s `icon`
// override to actually be read by `_resolvedIcon`, which it isn't today.
@override final  String? emptyStateIcon;
// Info banner shown above a populated list — the backend sends this as
// a full message-bar object (title/message/bgColor/...), the same shape
// used everywhere else in the app, not separate title/subtitle strings.
// Null means "don't show a banner" — the fallback has no hardcoded copy
// to show in its place (unlike every other field here), so the screen
// renders with no banner at all until backend actually sends one.
@override final  MessageBarEntity? messageBar;
// Persistent "Add child" footer row. Backend-resolved single title.
@override final  String addChildTitle;
@override final  String addChildSubtitle;
// Single leading/trailing icons, replacing the old two-avatar preview
// stack and hardcoded "+" glyph. Null renders the local placeholder.
@override final  String? addChildLeadingIcon;
@override final  String? addChildTrailingIcon;

/// Create a copy of KidsListContentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KidsListContentEntityCopyWith<_KidsListContentEntity> get copyWith => __$KidsListContentEntityCopyWithImpl<_KidsListContentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KidsListContentEntity&&(identical(other.emptyStateTitle, emptyStateTitle) || other.emptyStateTitle == emptyStateTitle)&&(identical(other.emptyStateSubtitle, emptyStateSubtitle) || other.emptyStateSubtitle == emptyStateSubtitle)&&(identical(other.emptyStateIcon, emptyStateIcon) || other.emptyStateIcon == emptyStateIcon)&&(identical(other.messageBar, messageBar) || other.messageBar == messageBar)&&(identical(other.addChildTitle, addChildTitle) || other.addChildTitle == addChildTitle)&&(identical(other.addChildSubtitle, addChildSubtitle) || other.addChildSubtitle == addChildSubtitle)&&(identical(other.addChildLeadingIcon, addChildLeadingIcon) || other.addChildLeadingIcon == addChildLeadingIcon)&&(identical(other.addChildTrailingIcon, addChildTrailingIcon) || other.addChildTrailingIcon == addChildTrailingIcon));
}


@override
int get hashCode => Object.hash(runtimeType,emptyStateTitle,emptyStateSubtitle,emptyStateIcon,messageBar,addChildTitle,addChildSubtitle,addChildLeadingIcon,addChildTrailingIcon);

@override
String toString() {
  return 'KidsListContentEntity(emptyStateTitle: $emptyStateTitle, emptyStateSubtitle: $emptyStateSubtitle, emptyStateIcon: $emptyStateIcon, messageBar: $messageBar, addChildTitle: $addChildTitle, addChildSubtitle: $addChildSubtitle, addChildLeadingIcon: $addChildLeadingIcon, addChildTrailingIcon: $addChildTrailingIcon)';
}


}

/// @nodoc
abstract mixin class _$KidsListContentEntityCopyWith<$Res> implements $KidsListContentEntityCopyWith<$Res> {
  factory _$KidsListContentEntityCopyWith(_KidsListContentEntity value, $Res Function(_KidsListContentEntity) _then) = __$KidsListContentEntityCopyWithImpl;
@override @useResult
$Res call({
 String emptyStateTitle, String emptyStateSubtitle, String? emptyStateIcon, MessageBarEntity? messageBar, String addChildTitle, String addChildSubtitle, String? addChildLeadingIcon, String? addChildTrailingIcon
});




}
/// @nodoc
class __$KidsListContentEntityCopyWithImpl<$Res>
    implements _$KidsListContentEntityCopyWith<$Res> {
  __$KidsListContentEntityCopyWithImpl(this._self, this._then);

  final _KidsListContentEntity _self;
  final $Res Function(_KidsListContentEntity) _then;

/// Create a copy of KidsListContentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emptyStateTitle = null,Object? emptyStateSubtitle = null,Object? emptyStateIcon = freezed,Object? messageBar = freezed,Object? addChildTitle = null,Object? addChildSubtitle = null,Object? addChildLeadingIcon = freezed,Object? addChildTrailingIcon = freezed,}) {
  return _then(_KidsListContentEntity(
emptyStateTitle: null == emptyStateTitle ? _self.emptyStateTitle : emptyStateTitle // ignore: cast_nullable_to_non_nullable
as String,emptyStateSubtitle: null == emptyStateSubtitle ? _self.emptyStateSubtitle : emptyStateSubtitle // ignore: cast_nullable_to_non_nullable
as String,emptyStateIcon: freezed == emptyStateIcon ? _self.emptyStateIcon : emptyStateIcon // ignore: cast_nullable_to_non_nullable
as String?,messageBar: freezed == messageBar ? _self.messageBar : messageBar // ignore: cast_nullable_to_non_nullable
as MessageBarEntity?,addChildTitle: null == addChildTitle ? _self.addChildTitle : addChildTitle // ignore: cast_nullable_to_non_nullable
as String,addChildSubtitle: null == addChildSubtitle ? _self.addChildSubtitle : addChildSubtitle // ignore: cast_nullable_to_non_nullable
as String,addChildLeadingIcon: freezed == addChildLeadingIcon ? _self.addChildLeadingIcon : addChildLeadingIcon // ignore: cast_nullable_to_non_nullable
as String?,addChildTrailingIcon: freezed == addChildTrailingIcon ? _self.addChildTrailingIcon : addChildTrailingIcon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ChildrenListResult {

 List<ChildEntity> get children; KidsListContentEntity get content;
/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildrenListResultCopyWith<ChildrenListResult> get copyWith => _$ChildrenListResultCopyWithImpl<ChildrenListResult>(this as ChildrenListResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildrenListResult&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(children),content);

@override
String toString() {
  return 'ChildrenListResult(children: $children, content: $content)';
}


}

/// @nodoc
abstract mixin class $ChildrenListResultCopyWith<$Res>  {
  factory $ChildrenListResultCopyWith(ChildrenListResult value, $Res Function(ChildrenListResult) _then) = _$ChildrenListResultCopyWithImpl;
@useResult
$Res call({
 List<ChildEntity> children, KidsListContentEntity content
});


$KidsListContentEntityCopyWith<$Res> get content;

}
/// @nodoc
class _$ChildrenListResultCopyWithImpl<$Res>
    implements $ChildrenListResultCopyWith<$Res> {
  _$ChildrenListResultCopyWithImpl(this._self, this._then);

  final ChildrenListResult _self;
  final $Res Function(ChildrenListResult) _then;

/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? children = null,Object? content = null,}) {
  return _then(_self.copyWith(
children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildEntity>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as KidsListContentEntity,
  ));
}
/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KidsListContentEntityCopyWith<$Res> get content {
  
  return $KidsListContentEntityCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChildrenListResult].
extension ChildrenListResultPatterns on ChildrenListResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildrenListResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildrenListResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildrenListResult value)  $default,){
final _that = this;
switch (_that) {
case _ChildrenListResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildrenListResult value)?  $default,){
final _that = this;
switch (_that) {
case _ChildrenListResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChildEntity> children,  KidsListContentEntity content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildrenListResult() when $default != null:
return $default(_that.children,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChildEntity> children,  KidsListContentEntity content)  $default,) {final _that = this;
switch (_that) {
case _ChildrenListResult():
return $default(_that.children,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChildEntity> children,  KidsListContentEntity content)?  $default,) {final _that = this;
switch (_that) {
case _ChildrenListResult() when $default != null:
return $default(_that.children,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _ChildrenListResult implements ChildrenListResult {
  const _ChildrenListResult({required final  List<ChildEntity> children, required this.content}): _children = children;
  

 final  List<ChildEntity> _children;
@override List<ChildEntity> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override final  KidsListContentEntity content;

/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildrenListResultCopyWith<_ChildrenListResult> get copyWith => __$ChildrenListResultCopyWithImpl<_ChildrenListResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildrenListResult&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_children),content);

@override
String toString() {
  return 'ChildrenListResult(children: $children, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ChildrenListResultCopyWith<$Res> implements $ChildrenListResultCopyWith<$Res> {
  factory _$ChildrenListResultCopyWith(_ChildrenListResult value, $Res Function(_ChildrenListResult) _then) = __$ChildrenListResultCopyWithImpl;
@override @useResult
$Res call({
 List<ChildEntity> children, KidsListContentEntity content
});


@override $KidsListContentEntityCopyWith<$Res> get content;

}
/// @nodoc
class __$ChildrenListResultCopyWithImpl<$Res>
    implements _$ChildrenListResultCopyWith<$Res> {
  __$ChildrenListResultCopyWithImpl(this._self, this._then);

  final _ChildrenListResult _self;
  final $Res Function(_ChildrenListResult) _then;

/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? children = null,Object? content = null,}) {
  return _then(_ChildrenListResult(
children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildEntity>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as KidsListContentEntity,
  ));
}

/// Create a copy of ChildrenListResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KidsListContentEntityCopyWith<$Res> get content {
  
  return $KidsListContentEntityCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
