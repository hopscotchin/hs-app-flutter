// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kids_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KidsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KidsEvent()';
}


}

/// @nodoc
class $KidsEventCopyWith<$Res>  {
$KidsEventCopyWith(KidsEvent _, $Res Function(KidsEvent) __);
}


/// Adds pattern-matching-related methods to [KidsEvent].
extension KidsEventPatterns on KidsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadChildren value)?  load,TResult Function( RefreshChildren value)?  refresh,TResult Function( DeleteChild value)?  delete,TResult Function( ClearDeleteFeedback value)?  clearDeleteFeedback,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadChildren() when load != null:
return load(_that);case RefreshChildren() when refresh != null:
return refresh(_that);case DeleteChild() when delete != null:
return delete(_that);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadChildren value)  load,required TResult Function( RefreshChildren value)  refresh,required TResult Function( DeleteChild value)  delete,required TResult Function( ClearDeleteFeedback value)  clearDeleteFeedback,}){
final _that = this;
switch (_that) {
case LoadChildren():
return load(_that);case RefreshChildren():
return refresh(_that);case DeleteChild():
return delete(_that);case ClearDeleteFeedback():
return clearDeleteFeedback(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadChildren value)?  load,TResult? Function( RefreshChildren value)?  refresh,TResult? Function( DeleteChild value)?  delete,TResult? Function( ClearDeleteFeedback value)?  clearDeleteFeedback,}){
final _that = this;
switch (_that) {
case LoadChildren() when load != null:
return load(_that);case RefreshChildren() when refresh != null:
return refresh(_that);case DeleteChild() when delete != null:
return delete(_that);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  load,TResult Function()?  refresh,TResult Function( int childId)?  delete,TResult Function()?  clearDeleteFeedback,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadChildren() when load != null:
return load();case RefreshChildren() when refresh != null:
return refresh();case DeleteChild() when delete != null:
return delete(_that.childId);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  load,required TResult Function()  refresh,required TResult Function( int childId)  delete,required TResult Function()  clearDeleteFeedback,}) {final _that = this;
switch (_that) {
case LoadChildren():
return load();case RefreshChildren():
return refresh();case DeleteChild():
return delete(_that.childId);case ClearDeleteFeedback():
return clearDeleteFeedback();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  load,TResult? Function()?  refresh,TResult? Function( int childId)?  delete,TResult? Function()?  clearDeleteFeedback,}) {final _that = this;
switch (_that) {
case LoadChildren() when load != null:
return load();case RefreshChildren() when refresh != null:
return refresh();case DeleteChild() when delete != null:
return delete(_that.childId);case ClearDeleteFeedback() when clearDeleteFeedback != null:
return clearDeleteFeedback();case _:
  return null;

}
}

}

/// @nodoc


class LoadChildren implements KidsEvent {
  const LoadChildren();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadChildren);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KidsEvent.load()';
}


}




/// @nodoc


class RefreshChildren implements KidsEvent {
  const RefreshChildren();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshChildren);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KidsEvent.refresh()';
}


}




/// @nodoc


class DeleteChild implements KidsEvent {
  const DeleteChild(this.childId);
  

 final  int childId;

/// Create a copy of KidsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteChildCopyWith<DeleteChild> get copyWith => _$DeleteChildCopyWithImpl<DeleteChild>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteChild&&(identical(other.childId, childId) || other.childId == childId));
}


@override
int get hashCode => Object.hash(runtimeType,childId);

@override
String toString() {
  return 'KidsEvent.delete(childId: $childId)';
}


}

/// @nodoc
abstract mixin class $DeleteChildCopyWith<$Res> implements $KidsEventCopyWith<$Res> {
  factory $DeleteChildCopyWith(DeleteChild value, $Res Function(DeleteChild) _then) = _$DeleteChildCopyWithImpl;
@useResult
$Res call({
 int childId
});




}
/// @nodoc
class _$DeleteChildCopyWithImpl<$Res>
    implements $DeleteChildCopyWith<$Res> {
  _$DeleteChildCopyWithImpl(this._self, this._then);

  final DeleteChild _self;
  final $Res Function(DeleteChild) _then;

/// Create a copy of KidsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? childId = null,}) {
  return _then(DeleteChild(
null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ClearDeleteFeedback implements KidsEvent {
  const ClearDeleteFeedback();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearDeleteFeedback);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KidsEvent.clearDeleteFeedback()';
}


}




/// @nodoc
mixin _$KidsState {

 KidsStatus get status; List<ChildEntity> get children;// List screen's backend-driven copy + footer avatar images — arrives
// together with `children` in the same list-fetch; null until the first
// successful load, in which case [effectiveContent] falls back locally.
 KidsListContentEntity? get content; String? get errorMessage; int? get deletingId; String? get deleteSuccessMessage; String? get deleteError;
/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KidsStateCopyWith<KidsState> get copyWith => _$KidsStateCopyWithImpl<KidsState>(this as KidsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.deletingId, deletingId) || other.deletingId == deletingId)&&(identical(other.deleteSuccessMessage, deleteSuccessMessage) || other.deleteSuccessMessage == deleteSuccessMessage)&&(identical(other.deleteError, deleteError) || other.deleteError == deleteError));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(children),content,errorMessage,deletingId,deleteSuccessMessage,deleteError);

@override
String toString() {
  return 'KidsState(status: $status, children: $children, content: $content, errorMessage: $errorMessage, deletingId: $deletingId, deleteSuccessMessage: $deleteSuccessMessage, deleteError: $deleteError)';
}


}

/// @nodoc
abstract mixin class $KidsStateCopyWith<$Res>  {
  factory $KidsStateCopyWith(KidsState value, $Res Function(KidsState) _then) = _$KidsStateCopyWithImpl;
@useResult
$Res call({
 KidsStatus status, List<ChildEntity> children, KidsListContentEntity? content, String? errorMessage, int? deletingId, String? deleteSuccessMessage, String? deleteError
});


$KidsListContentEntityCopyWith<$Res>? get content;

}
/// @nodoc
class _$KidsStateCopyWithImpl<$Res>
    implements $KidsStateCopyWith<$Res> {
  _$KidsStateCopyWithImpl(this._self, this._then);

  final KidsState _self;
  final $Res Function(KidsState) _then;

/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? children = null,Object? content = freezed,Object? errorMessage = freezed,Object? deletingId = freezed,Object? deleteSuccessMessage = freezed,Object? deleteError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KidsStatus,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildEntity>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as KidsListContentEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,deletingId: freezed == deletingId ? _self.deletingId : deletingId // ignore: cast_nullable_to_non_nullable
as int?,deleteSuccessMessage: freezed == deleteSuccessMessage ? _self.deleteSuccessMessage : deleteSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KidsListContentEntityCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $KidsListContentEntityCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [KidsState].
extension KidsStatePatterns on KidsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KidsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KidsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KidsState value)  $default,){
final _that = this;
switch (_that) {
case _KidsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KidsState value)?  $default,){
final _that = this;
switch (_that) {
case _KidsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KidsStatus status,  List<ChildEntity> children,  KidsListContentEntity? content,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KidsState() when $default != null:
return $default(_that.status,_that.children,_that.content,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KidsStatus status,  List<ChildEntity> children,  KidsListContentEntity? content,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError)  $default,) {final _that = this;
switch (_that) {
case _KidsState():
return $default(_that.status,_that.children,_that.content,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KidsStatus status,  List<ChildEntity> children,  KidsListContentEntity? content,  String? errorMessage,  int? deletingId,  String? deleteSuccessMessage,  String? deleteError)?  $default,) {final _that = this;
switch (_that) {
case _KidsState() when $default != null:
return $default(_that.status,_that.children,_that.content,_that.errorMessage,_that.deletingId,_that.deleteSuccessMessage,_that.deleteError);case _:
  return null;

}
}

}

/// @nodoc


class _KidsState implements KidsState {
  const _KidsState({this.status = KidsStatus.initial, final  List<ChildEntity> children = const <ChildEntity>[], this.content, this.errorMessage, this.deletingId, this.deleteSuccessMessage, this.deleteError}): _children = children;
  

@override@JsonKey() final  KidsStatus status;
 final  List<ChildEntity> _children;
@override@JsonKey() List<ChildEntity> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

// List screen's backend-driven copy + footer avatar images — arrives
// together with `children` in the same list-fetch; null until the first
// successful load, in which case [effectiveContent] falls back locally.
@override final  KidsListContentEntity? content;
@override final  String? errorMessage;
@override final  int? deletingId;
@override final  String? deleteSuccessMessage;
@override final  String? deleteError;

/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KidsStateCopyWith<_KidsState> get copyWith => __$KidsStateCopyWithImpl<_KidsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KidsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.deletingId, deletingId) || other.deletingId == deletingId)&&(identical(other.deleteSuccessMessage, deleteSuccessMessage) || other.deleteSuccessMessage == deleteSuccessMessage)&&(identical(other.deleteError, deleteError) || other.deleteError == deleteError));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_children),content,errorMessage,deletingId,deleteSuccessMessage,deleteError);

@override
String toString() {
  return 'KidsState(status: $status, children: $children, content: $content, errorMessage: $errorMessage, deletingId: $deletingId, deleteSuccessMessage: $deleteSuccessMessage, deleteError: $deleteError)';
}


}

/// @nodoc
abstract mixin class _$KidsStateCopyWith<$Res> implements $KidsStateCopyWith<$Res> {
  factory _$KidsStateCopyWith(_KidsState value, $Res Function(_KidsState) _then) = __$KidsStateCopyWithImpl;
@override @useResult
$Res call({
 KidsStatus status, List<ChildEntity> children, KidsListContentEntity? content, String? errorMessage, int? deletingId, String? deleteSuccessMessage, String? deleteError
});


@override $KidsListContentEntityCopyWith<$Res>? get content;

}
/// @nodoc
class __$KidsStateCopyWithImpl<$Res>
    implements _$KidsStateCopyWith<$Res> {
  __$KidsStateCopyWithImpl(this._self, this._then);

  final _KidsState _self;
  final $Res Function(_KidsState) _then;

/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? children = null,Object? content = freezed,Object? errorMessage = freezed,Object? deletingId = freezed,Object? deleteSuccessMessage = freezed,Object? deleteError = freezed,}) {
  return _then(_KidsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KidsStatus,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildEntity>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as KidsListContentEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,deletingId: freezed == deletingId ? _self.deletingId : deletingId // ignore: cast_nullable_to_non_nullable
as int?,deleteSuccessMessage: freezed == deleteSuccessMessage ? _self.deleteSuccessMessage : deleteSuccessMessage // ignore: cast_nullable_to_non_nullable
as String?,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of KidsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KidsListContentEntityCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $KidsListContentEntityCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
