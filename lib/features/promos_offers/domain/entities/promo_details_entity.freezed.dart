// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_details_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoDetailsEntity {

 PromoOfferEntity get item; String get about; List<String> get terms; List<PromoFaqEntity> get faqs;
/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoDetailsEntityCopyWith<PromoDetailsEntity> get copyWith => _$PromoDetailsEntityCopyWithImpl<PromoDetailsEntity>(this as PromoDetailsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoDetailsEntity&&(identical(other.item, item) || other.item == item)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other.terms, terms)&&const DeepCollectionEquality().equals(other.faqs, faqs));
}


@override
int get hashCode => Object.hash(runtimeType,item,about,const DeepCollectionEquality().hash(terms),const DeepCollectionEquality().hash(faqs));

@override
String toString() {
  return 'PromoDetailsEntity(item: $item, about: $about, terms: $terms, faqs: $faqs)';
}


}

/// @nodoc
abstract mixin class $PromoDetailsEntityCopyWith<$Res>  {
  factory $PromoDetailsEntityCopyWith(PromoDetailsEntity value, $Res Function(PromoDetailsEntity) _then) = _$PromoDetailsEntityCopyWithImpl;
@useResult
$Res call({
 PromoOfferEntity item, String about, List<String> terms, List<PromoFaqEntity> faqs
});


$PromoOfferEntityCopyWith<$Res> get item;

}
/// @nodoc
class _$PromoDetailsEntityCopyWithImpl<$Res>
    implements $PromoDetailsEntityCopyWith<$Res> {
  _$PromoDetailsEntityCopyWithImpl(this._self, this._then);

  final PromoDetailsEntity _self;
  final $Res Function(PromoDetailsEntity) _then;

/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? about = null,Object? terms = null,Object? faqs = null,}) {
  return _then(_self.copyWith(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PromoOfferEntity,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,terms: null == terms ? _self.terms : terms // ignore: cast_nullable_to_non_nullable
as List<String>,faqs: null == faqs ? _self.faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<PromoFaqEntity>,
  ));
}
/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferEntityCopyWith<$Res> get item {
  
  return $PromoOfferEntityCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromoDetailsEntity].
extension PromoDetailsEntityPatterns on PromoDetailsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoDetailsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoDetailsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoDetailsEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoDetailsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoDetailsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoDetailsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromoOfferEntity item,  String about,  List<String> terms,  List<PromoFaqEntity> faqs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoDetailsEntity() when $default != null:
return $default(_that.item,_that.about,_that.terms,_that.faqs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromoOfferEntity item,  String about,  List<String> terms,  List<PromoFaqEntity> faqs)  $default,) {final _that = this;
switch (_that) {
case _PromoDetailsEntity():
return $default(_that.item,_that.about,_that.terms,_that.faqs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromoOfferEntity item,  String about,  List<String> terms,  List<PromoFaqEntity> faqs)?  $default,) {final _that = this;
switch (_that) {
case _PromoDetailsEntity() when $default != null:
return $default(_that.item,_that.about,_that.terms,_that.faqs);case _:
  return null;

}
}

}

/// @nodoc


class _PromoDetailsEntity implements PromoDetailsEntity {
  const _PromoDetailsEntity({this.item = const PromoOfferEntity(), this.about = '', final  List<String> terms = const <String>[], final  List<PromoFaqEntity> faqs = const <PromoFaqEntity>[]}): _terms = terms,_faqs = faqs;
  

@override@JsonKey() final  PromoOfferEntity item;
@override@JsonKey() final  String about;
 final  List<String> _terms;
@override@JsonKey() List<String> get terms {
  if (_terms is EqualUnmodifiableListView) return _terms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_terms);
}

 final  List<PromoFaqEntity> _faqs;
@override@JsonKey() List<PromoFaqEntity> get faqs {
  if (_faqs is EqualUnmodifiableListView) return _faqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faqs);
}


/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoDetailsEntityCopyWith<_PromoDetailsEntity> get copyWith => __$PromoDetailsEntityCopyWithImpl<_PromoDetailsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoDetailsEntity&&(identical(other.item, item) || other.item == item)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other._terms, _terms)&&const DeepCollectionEquality().equals(other._faqs, _faqs));
}


@override
int get hashCode => Object.hash(runtimeType,item,about,const DeepCollectionEquality().hash(_terms),const DeepCollectionEquality().hash(_faqs));

@override
String toString() {
  return 'PromoDetailsEntity(item: $item, about: $about, terms: $terms, faqs: $faqs)';
}


}

/// @nodoc
abstract mixin class _$PromoDetailsEntityCopyWith<$Res> implements $PromoDetailsEntityCopyWith<$Res> {
  factory _$PromoDetailsEntityCopyWith(_PromoDetailsEntity value, $Res Function(_PromoDetailsEntity) _then) = __$PromoDetailsEntityCopyWithImpl;
@override @useResult
$Res call({
 PromoOfferEntity item, String about, List<String> terms, List<PromoFaqEntity> faqs
});


@override $PromoOfferEntityCopyWith<$Res> get item;

}
/// @nodoc
class __$PromoDetailsEntityCopyWithImpl<$Res>
    implements _$PromoDetailsEntityCopyWith<$Res> {
  __$PromoDetailsEntityCopyWithImpl(this._self, this._then);

  final _PromoDetailsEntity _self;
  final $Res Function(_PromoDetailsEntity) _then;

/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? about = null,Object? terms = null,Object? faqs = null,}) {
  return _then(_PromoDetailsEntity(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PromoOfferEntity,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String,terms: null == terms ? _self._terms : terms // ignore: cast_nullable_to_non_nullable
as List<String>,faqs: null == faqs ? _self._faqs : faqs // ignore: cast_nullable_to_non_nullable
as List<PromoFaqEntity>,
  ));
}

/// Create a copy of PromoDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoOfferEntityCopyWith<$Res> get item {
  
  return $PromoOfferEntityCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc
mixin _$PromoFaqEntity {

 String get question; String get answer;
/// Create a copy of PromoFaqEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoFaqEntityCopyWith<PromoFaqEntity> get copyWith => _$PromoFaqEntityCopyWithImpl<PromoFaqEntity>(this as PromoFaqEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoFaqEntity&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}


@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'PromoFaqEntity(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $PromoFaqEntityCopyWith<$Res>  {
  factory $PromoFaqEntityCopyWith(PromoFaqEntity value, $Res Function(PromoFaqEntity) _then) = _$PromoFaqEntityCopyWithImpl;
@useResult
$Res call({
 String question, String answer
});




}
/// @nodoc
class _$PromoFaqEntityCopyWithImpl<$Res>
    implements $PromoFaqEntityCopyWith<$Res> {
  _$PromoFaqEntityCopyWithImpl(this._self, this._then);

  final PromoFaqEntity _self;
  final $Res Function(PromoFaqEntity) _then;

/// Create a copy of PromoFaqEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoFaqEntity].
extension PromoFaqEntityPatterns on PromoFaqEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoFaqEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoFaqEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoFaqEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoFaqEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoFaqEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoFaqEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoFaqEntity() when $default != null:
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String answer)  $default,) {final _that = this;
switch (_that) {
case _PromoFaqEntity():
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String answer)?  $default,) {final _that = this;
switch (_that) {
case _PromoFaqEntity() when $default != null:
return $default(_that.question,_that.answer);case _:
  return null;

}
}

}

/// @nodoc


class _PromoFaqEntity implements PromoFaqEntity {
  const _PromoFaqEntity({this.question = '', this.answer = ''});
  

@override@JsonKey() final  String question;
@override@JsonKey() final  String answer;

/// Create a copy of PromoFaqEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoFaqEntityCopyWith<_PromoFaqEntity> get copyWith => __$PromoFaqEntityCopyWithImpl<_PromoFaqEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoFaqEntity&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}


@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'PromoFaqEntity(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$PromoFaqEntityCopyWith<$Res> implements $PromoFaqEntityCopyWith<$Res> {
  factory _$PromoFaqEntityCopyWith(_PromoFaqEntity value, $Res Function(_PromoFaqEntity) _then) = __$PromoFaqEntityCopyWithImpl;
@override @useResult
$Res call({
 String question, String answer
});




}
/// @nodoc
class __$PromoFaqEntityCopyWithImpl<$Res>
    implements _$PromoFaqEntityCopyWith<$Res> {
  __$PromoFaqEntityCopyWithImpl(this._self, this._then);

  final _PromoFaqEntity _self;
  final $Res Function(_PromoFaqEntity) _then;

/// Create a copy of PromoFaqEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_PromoFaqEntity(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
