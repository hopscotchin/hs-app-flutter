// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_nudge_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NudgeRuleEntity {

 int get dismissedFrequency; int get showNudgeFrequency; int get deniedFrequency; int? get oneTimeTargetDate;
/// Create a copy of NudgeRuleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NudgeRuleEntityCopyWith<NudgeRuleEntity> get copyWith => _$NudgeRuleEntityCopyWithImpl<NudgeRuleEntity>(this as NudgeRuleEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NudgeRuleEntity&&(identical(other.dismissedFrequency, dismissedFrequency) || other.dismissedFrequency == dismissedFrequency)&&(identical(other.showNudgeFrequency, showNudgeFrequency) || other.showNudgeFrequency == showNudgeFrequency)&&(identical(other.deniedFrequency, deniedFrequency) || other.deniedFrequency == deniedFrequency)&&(identical(other.oneTimeTargetDate, oneTimeTargetDate) || other.oneTimeTargetDate == oneTimeTargetDate));
}


@override
int get hashCode => Object.hash(runtimeType,dismissedFrequency,showNudgeFrequency,deniedFrequency,oneTimeTargetDate);

@override
String toString() {
  return 'NudgeRuleEntity(dismissedFrequency: $dismissedFrequency, showNudgeFrequency: $showNudgeFrequency, deniedFrequency: $deniedFrequency, oneTimeTargetDate: $oneTimeTargetDate)';
}


}

/// @nodoc
abstract mixin class $NudgeRuleEntityCopyWith<$Res>  {
  factory $NudgeRuleEntityCopyWith(NudgeRuleEntity value, $Res Function(NudgeRuleEntity) _then) = _$NudgeRuleEntityCopyWithImpl;
@useResult
$Res call({
 int dismissedFrequency, int showNudgeFrequency, int deniedFrequency, int? oneTimeTargetDate
});




}
/// @nodoc
class _$NudgeRuleEntityCopyWithImpl<$Res>
    implements $NudgeRuleEntityCopyWith<$Res> {
  _$NudgeRuleEntityCopyWithImpl(this._self, this._then);

  final NudgeRuleEntity _self;
  final $Res Function(NudgeRuleEntity) _then;

/// Create a copy of NudgeRuleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dismissedFrequency = null,Object? showNudgeFrequency = null,Object? deniedFrequency = null,Object? oneTimeTargetDate = freezed,}) {
  return _then(_self.copyWith(
dismissedFrequency: null == dismissedFrequency ? _self.dismissedFrequency : dismissedFrequency // ignore: cast_nullable_to_non_nullable
as int,showNudgeFrequency: null == showNudgeFrequency ? _self.showNudgeFrequency : showNudgeFrequency // ignore: cast_nullable_to_non_nullable
as int,deniedFrequency: null == deniedFrequency ? _self.deniedFrequency : deniedFrequency // ignore: cast_nullable_to_non_nullable
as int,oneTimeTargetDate: freezed == oneTimeTargetDate ? _self.oneTimeTargetDate : oneTimeTargetDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NudgeRuleEntity].
extension NudgeRuleEntityPatterns on NudgeRuleEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NudgeRuleEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NudgeRuleEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NudgeRuleEntity value)  $default,){
final _that = this;
switch (_that) {
case _NudgeRuleEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NudgeRuleEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NudgeRuleEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dismissedFrequency,  int showNudgeFrequency,  int deniedFrequency,  int? oneTimeTargetDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NudgeRuleEntity() when $default != null:
return $default(_that.dismissedFrequency,_that.showNudgeFrequency,_that.deniedFrequency,_that.oneTimeTargetDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dismissedFrequency,  int showNudgeFrequency,  int deniedFrequency,  int? oneTimeTargetDate)  $default,) {final _that = this;
switch (_that) {
case _NudgeRuleEntity():
return $default(_that.dismissedFrequency,_that.showNudgeFrequency,_that.deniedFrequency,_that.oneTimeTargetDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dismissedFrequency,  int showNudgeFrequency,  int deniedFrequency,  int? oneTimeTargetDate)?  $default,) {final _that = this;
switch (_that) {
case _NudgeRuleEntity() when $default != null:
return $default(_that.dismissedFrequency,_that.showNudgeFrequency,_that.deniedFrequency,_that.oneTimeTargetDate);case _:
  return null;

}
}

}

/// @nodoc


class _NudgeRuleEntity implements NudgeRuleEntity {
  const _NudgeRuleEntity({this.dismissedFrequency = 0, this.showNudgeFrequency = 0, this.deniedFrequency = 0, this.oneTimeTargetDate});
  

@override@JsonKey() final  int dismissedFrequency;
@override@JsonKey() final  int showNudgeFrequency;
@override@JsonKey() final  int deniedFrequency;
@override final  int? oneTimeTargetDate;

/// Create a copy of NudgeRuleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NudgeRuleEntityCopyWith<_NudgeRuleEntity> get copyWith => __$NudgeRuleEntityCopyWithImpl<_NudgeRuleEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NudgeRuleEntity&&(identical(other.dismissedFrequency, dismissedFrequency) || other.dismissedFrequency == dismissedFrequency)&&(identical(other.showNudgeFrequency, showNudgeFrequency) || other.showNudgeFrequency == showNudgeFrequency)&&(identical(other.deniedFrequency, deniedFrequency) || other.deniedFrequency == deniedFrequency)&&(identical(other.oneTimeTargetDate, oneTimeTargetDate) || other.oneTimeTargetDate == oneTimeTargetDate));
}


@override
int get hashCode => Object.hash(runtimeType,dismissedFrequency,showNudgeFrequency,deniedFrequency,oneTimeTargetDate);

@override
String toString() {
  return 'NudgeRuleEntity(dismissedFrequency: $dismissedFrequency, showNudgeFrequency: $showNudgeFrequency, deniedFrequency: $deniedFrequency, oneTimeTargetDate: $oneTimeTargetDate)';
}


}

/// @nodoc
abstract mixin class _$NudgeRuleEntityCopyWith<$Res> implements $NudgeRuleEntityCopyWith<$Res> {
  factory _$NudgeRuleEntityCopyWith(_NudgeRuleEntity value, $Res Function(_NudgeRuleEntity) _then) = __$NudgeRuleEntityCopyWithImpl;
@override @useResult
$Res call({
 int dismissedFrequency, int showNudgeFrequency, int deniedFrequency, int? oneTimeTargetDate
});




}
/// @nodoc
class __$NudgeRuleEntityCopyWithImpl<$Res>
    implements _$NudgeRuleEntityCopyWith<$Res> {
  __$NudgeRuleEntityCopyWithImpl(this._self, this._then);

  final _NudgeRuleEntity _self;
  final $Res Function(_NudgeRuleEntity) _then;

/// Create a copy of NudgeRuleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dismissedFrequency = null,Object? showNudgeFrequency = null,Object? deniedFrequency = null,Object? oneTimeTargetDate = freezed,}) {
  return _then(_NudgeRuleEntity(
dismissedFrequency: null == dismissedFrequency ? _self.dismissedFrequency : dismissedFrequency // ignore: cast_nullable_to_non_nullable
as int,showNudgeFrequency: null == showNudgeFrequency ? _self.showNudgeFrequency : showNudgeFrequency // ignore: cast_nullable_to_non_nullable
as int,deniedFrequency: null == deniedFrequency ? _self.deniedFrequency : deniedFrequency // ignore: cast_nullable_to_non_nullable
as int,oneTimeTargetDate: freezed == oneTimeTargetDate ? _self.oneTimeTargetDate : oneTimeTargetDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$NotificationNudgeEntity {

 String? get title; String? get titleImage; String? get description; String? get negativeButtonText; String? get positiveButtonText; int? get position; NudgeRuleEntity? get rule;
/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationNudgeEntityCopyWith<NotificationNudgeEntity> get copyWith => _$NotificationNudgeEntityCopyWithImpl<NotificationNudgeEntity>(this as NotificationNudgeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationNudgeEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.titleImage, titleImage) || other.titleImage == titleImage)&&(identical(other.description, description) || other.description == description)&&(identical(other.negativeButtonText, negativeButtonText) || other.negativeButtonText == negativeButtonText)&&(identical(other.positiveButtonText, positiveButtonText) || other.positiveButtonText == positiveButtonText)&&(identical(other.position, position) || other.position == position)&&(identical(other.rule, rule) || other.rule == rule));
}


@override
int get hashCode => Object.hash(runtimeType,title,titleImage,description,negativeButtonText,positiveButtonText,position,rule);

@override
String toString() {
  return 'NotificationNudgeEntity(title: $title, titleImage: $titleImage, description: $description, negativeButtonText: $negativeButtonText, positiveButtonText: $positiveButtonText, position: $position, rule: $rule)';
}


}

/// @nodoc
abstract mixin class $NotificationNudgeEntityCopyWith<$Res>  {
  factory $NotificationNudgeEntityCopyWith(NotificationNudgeEntity value, $Res Function(NotificationNudgeEntity) _then) = _$NotificationNudgeEntityCopyWithImpl;
@useResult
$Res call({
 String? title, String? titleImage, String? description, String? negativeButtonText, String? positiveButtonText, int? position, NudgeRuleEntity? rule
});


$NudgeRuleEntityCopyWith<$Res>? get rule;

}
/// @nodoc
class _$NotificationNudgeEntityCopyWithImpl<$Res>
    implements $NotificationNudgeEntityCopyWith<$Res> {
  _$NotificationNudgeEntityCopyWithImpl(this._self, this._then);

  final NotificationNudgeEntity _self;
  final $Res Function(NotificationNudgeEntity) _then;

/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? titleImage = freezed,Object? description = freezed,Object? negativeButtonText = freezed,Object? positiveButtonText = freezed,Object? position = freezed,Object? rule = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleImage: freezed == titleImage ? _self.titleImage : titleImage // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,negativeButtonText: freezed == negativeButtonText ? _self.negativeButtonText : negativeButtonText // ignore: cast_nullable_to_non_nullable
as String?,positiveButtonText: freezed == positiveButtonText ? _self.positiveButtonText : positiveButtonText // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,rule: freezed == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as NudgeRuleEntity?,
  ));
}
/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NudgeRuleEntityCopyWith<$Res>? get rule {
    if (_self.rule == null) {
    return null;
  }

  return $NudgeRuleEntityCopyWith<$Res>(_self.rule!, (value) {
    return _then(_self.copyWith(rule: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationNudgeEntity].
extension NotificationNudgeEntityPatterns on NotificationNudgeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationNudgeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationNudgeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationNudgeEntity value)  $default,){
final _that = this;
switch (_that) {
case _NotificationNudgeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationNudgeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationNudgeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? titleImage,  String? description,  String? negativeButtonText,  String? positiveButtonText,  int? position,  NudgeRuleEntity? rule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationNudgeEntity() when $default != null:
return $default(_that.title,_that.titleImage,_that.description,_that.negativeButtonText,_that.positiveButtonText,_that.position,_that.rule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? titleImage,  String? description,  String? negativeButtonText,  String? positiveButtonText,  int? position,  NudgeRuleEntity? rule)  $default,) {final _that = this;
switch (_that) {
case _NotificationNudgeEntity():
return $default(_that.title,_that.titleImage,_that.description,_that.negativeButtonText,_that.positiveButtonText,_that.position,_that.rule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? titleImage,  String? description,  String? negativeButtonText,  String? positiveButtonText,  int? position,  NudgeRuleEntity? rule)?  $default,) {final _that = this;
switch (_that) {
case _NotificationNudgeEntity() when $default != null:
return $default(_that.title,_that.titleImage,_that.description,_that.negativeButtonText,_that.positiveButtonText,_that.position,_that.rule);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationNudgeEntity implements NotificationNudgeEntity {
  const _NotificationNudgeEntity({this.title, this.titleImage, this.description, this.negativeButtonText, this.positiveButtonText, this.position, this.rule});
  

@override final  String? title;
@override final  String? titleImage;
@override final  String? description;
@override final  String? negativeButtonText;
@override final  String? positiveButtonText;
@override final  int? position;
@override final  NudgeRuleEntity? rule;

/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationNudgeEntityCopyWith<_NotificationNudgeEntity> get copyWith => __$NotificationNudgeEntityCopyWithImpl<_NotificationNudgeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationNudgeEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.titleImage, titleImage) || other.titleImage == titleImage)&&(identical(other.description, description) || other.description == description)&&(identical(other.negativeButtonText, negativeButtonText) || other.negativeButtonText == negativeButtonText)&&(identical(other.positiveButtonText, positiveButtonText) || other.positiveButtonText == positiveButtonText)&&(identical(other.position, position) || other.position == position)&&(identical(other.rule, rule) || other.rule == rule));
}


@override
int get hashCode => Object.hash(runtimeType,title,titleImage,description,negativeButtonText,positiveButtonText,position,rule);

@override
String toString() {
  return 'NotificationNudgeEntity(title: $title, titleImage: $titleImage, description: $description, negativeButtonText: $negativeButtonText, positiveButtonText: $positiveButtonText, position: $position, rule: $rule)';
}


}

/// @nodoc
abstract mixin class _$NotificationNudgeEntityCopyWith<$Res> implements $NotificationNudgeEntityCopyWith<$Res> {
  factory _$NotificationNudgeEntityCopyWith(_NotificationNudgeEntity value, $Res Function(_NotificationNudgeEntity) _then) = __$NotificationNudgeEntityCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? titleImage, String? description, String? negativeButtonText, String? positiveButtonText, int? position, NudgeRuleEntity? rule
});


@override $NudgeRuleEntityCopyWith<$Res>? get rule;

}
/// @nodoc
class __$NotificationNudgeEntityCopyWithImpl<$Res>
    implements _$NotificationNudgeEntityCopyWith<$Res> {
  __$NotificationNudgeEntityCopyWithImpl(this._self, this._then);

  final _NotificationNudgeEntity _self;
  final $Res Function(_NotificationNudgeEntity) _then;

/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? titleImage = freezed,Object? description = freezed,Object? negativeButtonText = freezed,Object? positiveButtonText = freezed,Object? position = freezed,Object? rule = freezed,}) {
  return _then(_NotificationNudgeEntity(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleImage: freezed == titleImage ? _self.titleImage : titleImage // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,negativeButtonText: freezed == negativeButtonText ? _self.negativeButtonText : negativeButtonText // ignore: cast_nullable_to_non_nullable
as String?,positiveButtonText: freezed == positiveButtonText ? _self.positiveButtonText : positiveButtonText // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,rule: freezed == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as NudgeRuleEntity?,
  ));
}

/// Create a copy of NotificationNudgeEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NudgeRuleEntityCopyWith<$Res>? get rule {
    if (_self.rule == null) {
    return null;
  }

  return $NudgeRuleEntityCopyWith<$Res>(_self.rule!, (value) {
    return _then(_self.copyWith(rule: value));
  });
}
}

// dart format on
