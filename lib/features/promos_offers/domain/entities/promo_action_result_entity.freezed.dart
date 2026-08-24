// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_action_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoActionResultEntity {

 bool get success; String get message; String get promoCode;/// Backend-authored bottom sheet to show instead of the toast — sent on
/// either outcome (e.g. "Invalid promotion" with a "Got It" button).
 BackendActionContentEntity? get bottomSheet;/// Bars the response carried, from `messageBar` and/or `messageBars`.
/// Take priority over [message] when rendering a failure — the backend
/// authored them, so they carry their own copy, colour and icon.
 List<MessageBarEntity> get messageBars;
/// Create a copy of PromoActionResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoActionResultEntityCopyWith<PromoActionResultEntity> get copyWith => _$PromoActionResultEntityCopyWithImpl<PromoActionResultEntity>(this as PromoActionResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoActionResultEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.bottomSheet, bottomSheet) || other.bottomSheet == bottomSheet)&&const DeepCollectionEquality().equals(other.messageBars, messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,success,message,promoCode,bottomSheet,const DeepCollectionEquality().hash(messageBars));

@override
String toString() {
  return 'PromoActionResultEntity(success: $success, message: $message, promoCode: $promoCode, bottomSheet: $bottomSheet, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class $PromoActionResultEntityCopyWith<$Res>  {
  factory $PromoActionResultEntityCopyWith(PromoActionResultEntity value, $Res Function(PromoActionResultEntity) _then) = _$PromoActionResultEntityCopyWithImpl;
@useResult
$Res call({
 bool success, String message, String promoCode, BackendActionContentEntity? bottomSheet, List<MessageBarEntity> messageBars
});




}
/// @nodoc
class _$PromoActionResultEntityCopyWithImpl<$Res>
    implements $PromoActionResultEntityCopyWith<$Res> {
  _$PromoActionResultEntityCopyWithImpl(this._self, this._then);

  final PromoActionResultEntity _self;
  final $Res Function(PromoActionResultEntity) _then;

/// Create a copy of PromoActionResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? promoCode = null,Object? bottomSheet = freezed,Object? messageBars = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,promoCode: null == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String,bottomSheet: freezed == bottomSheet ? _self.bottomSheet : bottomSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoActionResultEntity].
extension PromoActionResultEntityPatterns on PromoActionResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoActionResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoActionResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoActionResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoActionResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoActionResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoActionResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  String promoCode,  BackendActionContentEntity? bottomSheet,  List<MessageBarEntity> messageBars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoActionResultEntity() when $default != null:
return $default(_that.success,_that.message,_that.promoCode,_that.bottomSheet,_that.messageBars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  String promoCode,  BackendActionContentEntity? bottomSheet,  List<MessageBarEntity> messageBars)  $default,) {final _that = this;
switch (_that) {
case _PromoActionResultEntity():
return $default(_that.success,_that.message,_that.promoCode,_that.bottomSheet,_that.messageBars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  String promoCode,  BackendActionContentEntity? bottomSheet,  List<MessageBarEntity> messageBars)?  $default,) {final _that = this;
switch (_that) {
case _PromoActionResultEntity() when $default != null:
return $default(_that.success,_that.message,_that.promoCode,_that.bottomSheet,_that.messageBars);case _:
  return null;

}
}

}

/// @nodoc


class _PromoActionResultEntity implements PromoActionResultEntity {
  const _PromoActionResultEntity({this.success = false, this.message = '', this.promoCode = '', this.bottomSheet, final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[]}): _messageBars = messageBars;
  

@override@JsonKey() final  bool success;
@override@JsonKey() final  String message;
@override@JsonKey() final  String promoCode;
/// Backend-authored bottom sheet to show instead of the toast — sent on
/// either outcome (e.g. "Invalid promotion" with a "Got It" button).
@override final  BackendActionContentEntity? bottomSheet;
/// Bars the response carried, from `messageBar` and/or `messageBars`.
/// Take priority over [message] when rendering a failure — the backend
/// authored them, so they carry their own copy, colour and icon.
 final  List<MessageBarEntity> _messageBars;
/// Bars the response carried, from `messageBar` and/or `messageBars`.
/// Take priority over [message] when rendering a failure — the backend
/// authored them, so they carry their own copy, colour and icon.
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}


/// Create a copy of PromoActionResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoActionResultEntityCopyWith<_PromoActionResultEntity> get copyWith => __$PromoActionResultEntityCopyWithImpl<_PromoActionResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoActionResultEntity&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.promoCode, promoCode) || other.promoCode == promoCode)&&(identical(other.bottomSheet, bottomSheet) || other.bottomSheet == bottomSheet)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars));
}


@override
int get hashCode => Object.hash(runtimeType,success,message,promoCode,bottomSheet,const DeepCollectionEquality().hash(_messageBars));

@override
String toString() {
  return 'PromoActionResultEntity(success: $success, message: $message, promoCode: $promoCode, bottomSheet: $bottomSheet, messageBars: $messageBars)';
}


}

/// @nodoc
abstract mixin class _$PromoActionResultEntityCopyWith<$Res> implements $PromoActionResultEntityCopyWith<$Res> {
  factory _$PromoActionResultEntityCopyWith(_PromoActionResultEntity value, $Res Function(_PromoActionResultEntity) _then) = __$PromoActionResultEntityCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, String promoCode, BackendActionContentEntity? bottomSheet, List<MessageBarEntity> messageBars
});




}
/// @nodoc
class __$PromoActionResultEntityCopyWithImpl<$Res>
    implements _$PromoActionResultEntityCopyWith<$Res> {
  __$PromoActionResultEntityCopyWithImpl(this._self, this._then);

  final _PromoActionResultEntity _self;
  final $Res Function(_PromoActionResultEntity) _then;

/// Create a copy of PromoActionResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? promoCode = null,Object? bottomSheet = freezed,Object? messageBars = null,}) {
  return _then(_PromoActionResultEntity(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,promoCode: null == promoCode ? _self.promoCode : promoCode // ignore: cast_nullable_to_non_nullable
as String,bottomSheet: freezed == bottomSheet ? _self.bottomSheet : bottomSheet // ignore: cast_nullable_to_non_nullable
as BackendActionContentEntity?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,
  ));
}


}

// dart format on
