// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_offers_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoOfferSectionEntity {

 String get title; List<PromoOfferEntity> get offers;
/// Create a copy of PromoOfferSectionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoOfferSectionEntityCopyWith<PromoOfferSectionEntity> get copyWith => _$PromoOfferSectionEntityCopyWithImpl<PromoOfferSectionEntity>(this as PromoOfferSectionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoOfferSectionEntity&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.offers, offers));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(offers));

@override
String toString() {
  return 'PromoOfferSectionEntity(title: $title, offers: $offers)';
}


}

/// @nodoc
abstract mixin class $PromoOfferSectionEntityCopyWith<$Res>  {
  factory $PromoOfferSectionEntityCopyWith(PromoOfferSectionEntity value, $Res Function(PromoOfferSectionEntity) _then) = _$PromoOfferSectionEntityCopyWithImpl;
@useResult
$Res call({
 String title, List<PromoOfferEntity> offers
});




}
/// @nodoc
class _$PromoOfferSectionEntityCopyWithImpl<$Res>
    implements $PromoOfferSectionEntityCopyWith<$Res> {
  _$PromoOfferSectionEntityCopyWithImpl(this._self, this._then);

  final PromoOfferSectionEntity _self;
  final $Res Function(PromoOfferSectionEntity) _then;

/// Create a copy of PromoOfferSectionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? offers = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<PromoOfferEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoOfferSectionEntity].
extension PromoOfferSectionEntityPatterns on PromoOfferSectionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoOfferSectionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoOfferSectionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoOfferSectionEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoOfferSectionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoOfferSectionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoOfferSectionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<PromoOfferEntity> offers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoOfferSectionEntity() when $default != null:
return $default(_that.title,_that.offers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<PromoOfferEntity> offers)  $default,) {final _that = this;
switch (_that) {
case _PromoOfferSectionEntity():
return $default(_that.title,_that.offers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<PromoOfferEntity> offers)?  $default,) {final _that = this;
switch (_that) {
case _PromoOfferSectionEntity() when $default != null:
return $default(_that.title,_that.offers);case _:
  return null;

}
}

}

/// @nodoc


class _PromoOfferSectionEntity implements PromoOfferSectionEntity {
  const _PromoOfferSectionEntity({this.title = '', final  List<PromoOfferEntity> offers = const <PromoOfferEntity>[]}): _offers = offers;
  

@override@JsonKey() final  String title;
 final  List<PromoOfferEntity> _offers;
@override@JsonKey() List<PromoOfferEntity> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}


/// Create a copy of PromoOfferSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoOfferSectionEntityCopyWith<_PromoOfferSectionEntity> get copyWith => __$PromoOfferSectionEntityCopyWithImpl<_PromoOfferSectionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoOfferSectionEntity&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._offers, _offers));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_offers));

@override
String toString() {
  return 'PromoOfferSectionEntity(title: $title, offers: $offers)';
}


}

/// @nodoc
abstract mixin class _$PromoOfferSectionEntityCopyWith<$Res> implements $PromoOfferSectionEntityCopyWith<$Res> {
  factory _$PromoOfferSectionEntityCopyWith(_PromoOfferSectionEntity value, $Res Function(_PromoOfferSectionEntity) _then) = __$PromoOfferSectionEntityCopyWithImpl;
@override @useResult
$Res call({
 String title, List<PromoOfferEntity> offers
});




}
/// @nodoc
class __$PromoOfferSectionEntityCopyWithImpl<$Res>
    implements _$PromoOfferSectionEntityCopyWith<$Res> {
  __$PromoOfferSectionEntityCopyWithImpl(this._self, this._then);

  final _PromoOfferSectionEntity _self;
  final $Res Function(_PromoOfferSectionEntity) _then;

/// Create a copy of PromoOfferSectionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? offers = null,}) {
  return _then(_PromoOfferSectionEntity(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<PromoOfferEntity>,
  ));
}


}

/// @nodoc
mixin _$PromoOffersEntity {

 PromoOfferSectionEntity? get applicable; PromoOfferSectionEntity? get nonApplicable;
/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoOffersEntityCopyWith<PromoOffersEntity> get copyWith => _$PromoOffersEntityCopyWithImpl<PromoOffersEntity>(this as PromoOffersEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoOffersEntity&&(identical(other.applicable, applicable) || other.applicable == applicable)&&(identical(other.nonApplicable, nonApplicable) || other.nonApplicable == nonApplicable));
}


@override
int get hashCode => Object.hash(runtimeType,applicable,nonApplicable);

@override
String toString() {
  return 'PromoOffersEntity(applicable: $applicable, nonApplicable: $nonApplicable)';
}


}

/// @nodoc
abstract mixin class $PromoOffersEntityCopyWith<$Res>  {
  factory $PromoOffersEntityCopyWith(PromoOffersEntity value, $Res Function(PromoOffersEntity) _then) = _$PromoOffersEntityCopyWithImpl;
@useResult
$Res call({
 PromoOfferSectionEntity? applicable, PromoOfferSectionEntity? nonApplicable
});


$PromoOfferSectionEntityCopyWith<$Res>? get applicable;$PromoOfferSectionEntityCopyWith<$Res>? get nonApplicable;

}
/// @nodoc
class _$PromoOffersEntityCopyWithImpl<$Res>
    implements $PromoOffersEntityCopyWith<$Res> {
  _$PromoOffersEntityCopyWithImpl(this._self, this._then);

  final PromoOffersEntity _self;
  final $Res Function(PromoOffersEntity) _then;

/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicable = freezed,Object? nonApplicable = freezed,}) {
  return _then(_self.copyWith(
applicable: freezed == applicable ? _self.applicable : applicable // ignore: cast_nullable_to_non_nullable
as PromoOfferSectionEntity?,nonApplicable: freezed == nonApplicable ? _self.nonApplicable : nonApplicable // ignore: cast_nullable_to_non_nullable
as PromoOfferSectionEntity?,
  ));
}
/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferSectionEntityCopyWith<$Res>? get applicable {
    if (_self.applicable == null) {
    return null;
  }

  return $PromoOfferSectionEntityCopyWith<$Res>(_self.applicable!, (value) {
    return _then(_self.copyWith(applicable: value));
  });
}/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferSectionEntityCopyWith<$Res>? get nonApplicable {
    if (_self.nonApplicable == null) {
    return null;
  }

  return $PromoOfferSectionEntityCopyWith<$Res>(_self.nonApplicable!, (value) {
    return _then(_self.copyWith(nonApplicable: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromoOffersEntity].
extension PromoOffersEntityPatterns on PromoOffersEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoOffersEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoOffersEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoOffersEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoOffersEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoOffersEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoOffersEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromoOfferSectionEntity? applicable,  PromoOfferSectionEntity? nonApplicable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoOffersEntity() when $default != null:
return $default(_that.applicable,_that.nonApplicable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromoOfferSectionEntity? applicable,  PromoOfferSectionEntity? nonApplicable)  $default,) {final _that = this;
switch (_that) {
case _PromoOffersEntity():
return $default(_that.applicable,_that.nonApplicable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromoOfferSectionEntity? applicable,  PromoOfferSectionEntity? nonApplicable)?  $default,) {final _that = this;
switch (_that) {
case _PromoOffersEntity() when $default != null:
return $default(_that.applicable,_that.nonApplicable);case _:
  return null;

}
}

}

/// @nodoc


class _PromoOffersEntity extends PromoOffersEntity {
  const _PromoOffersEntity({this.applicable, this.nonApplicable}): super._();
  

@override final  PromoOfferSectionEntity? applicable;
@override final  PromoOfferSectionEntity? nonApplicable;

/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoOffersEntityCopyWith<_PromoOffersEntity> get copyWith => __$PromoOffersEntityCopyWithImpl<_PromoOffersEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoOffersEntity&&(identical(other.applicable, applicable) || other.applicable == applicable)&&(identical(other.nonApplicable, nonApplicable) || other.nonApplicable == nonApplicable));
}


@override
int get hashCode => Object.hash(runtimeType,applicable,nonApplicable);

@override
String toString() {
  return 'PromoOffersEntity(applicable: $applicable, nonApplicable: $nonApplicable)';
}


}

/// @nodoc
abstract mixin class _$PromoOffersEntityCopyWith<$Res> implements $PromoOffersEntityCopyWith<$Res> {
  factory _$PromoOffersEntityCopyWith(_PromoOffersEntity value, $Res Function(_PromoOffersEntity) _then) = __$PromoOffersEntityCopyWithImpl;
@override @useResult
$Res call({
 PromoOfferSectionEntity? applicable, PromoOfferSectionEntity? nonApplicable
});


@override $PromoOfferSectionEntityCopyWith<$Res>? get applicable;@override $PromoOfferSectionEntityCopyWith<$Res>? get nonApplicable;

}
/// @nodoc
class __$PromoOffersEntityCopyWithImpl<$Res>
    implements _$PromoOffersEntityCopyWith<$Res> {
  __$PromoOffersEntityCopyWithImpl(this._self, this._then);

  final _PromoOffersEntity _self;
  final $Res Function(_PromoOffersEntity) _then;

/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicable = freezed,Object? nonApplicable = freezed,}) {
  return _then(_PromoOffersEntity(
applicable: freezed == applicable ? _self.applicable : applicable // ignore: cast_nullable_to_non_nullable
as PromoOfferSectionEntity?,nonApplicable: freezed == nonApplicable ? _self.nonApplicable : nonApplicable // ignore: cast_nullable_to_non_nullable
as PromoOfferSectionEntity?,
  ));
}

/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferSectionEntityCopyWith<$Res>? get applicable {
    if (_self.applicable == null) {
    return null;
  }

  return $PromoOfferSectionEntityCopyWith<$Res>(_self.applicable!, (value) {
    return _then(_self.copyWith(applicable: value));
  });
}/// Create a copy of PromoOffersEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferSectionEntityCopyWith<$Res>? get nonApplicable {
    if (_self.nonApplicable == null) {
    return null;
  }

  return $PromoOfferSectionEntityCopyWith<$Res>(_self.nonApplicable!, (value) {
    return _then(_self.copyWith(nonApplicable: value));
  });
}
}

// dart format on
