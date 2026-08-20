// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_offer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoOfferEntity {

/// Server id for this promo. The terms deeplink carries it as `?id=`.
 int get promoId; String get code; String get title; String get description; String? get validityText; String? get savingsText;/// Label + deeplink for the backend-driven CTA on the card (e.g. "View
/// eligible products" → PLP). Routed through `ActionUrlHandler`, exactly
/// like home-page components.
 String? get actionLabel; String? get actionUri; String? get termsText; String? get termsLink; bool get isApplied; bool get isApplicable;/// The details endpoint can suppress the code badge (`showPromotionCode`);
/// the offer list always shows it, hence the default.
 bool get showCode;
/// Create a copy of PromoOfferEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoOfferEntityCopyWith<PromoOfferEntity> get copyWith => _$PromoOfferEntityCopyWithImpl<PromoOfferEntity>(this as PromoOfferEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoOfferEntity&&(identical(other.promoId, promoId) || other.promoId == promoId)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.validityText, validityText) || other.validityText == validityText)&&(identical(other.savingsText, savingsText) || other.savingsText == savingsText)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.termsText, termsText) || other.termsText == termsText)&&(identical(other.termsLink, termsLink) || other.termsLink == termsLink)&&(identical(other.isApplied, isApplied) || other.isApplied == isApplied)&&(identical(other.isApplicable, isApplicable) || other.isApplicable == isApplicable)&&(identical(other.showCode, showCode) || other.showCode == showCode));
}


@override
int get hashCode => Object.hash(runtimeType,promoId,code,title,description,validityText,savingsText,actionLabel,actionUri,termsText,termsLink,isApplied,isApplicable,showCode);

@override
String toString() {
  return 'PromoOfferEntity(promoId: $promoId, code: $code, title: $title, description: $description, validityText: $validityText, savingsText: $savingsText, actionLabel: $actionLabel, actionUri: $actionUri, termsText: $termsText, termsLink: $termsLink, isApplied: $isApplied, isApplicable: $isApplicable, showCode: $showCode)';
}


}

/// @nodoc
abstract mixin class $PromoOfferEntityCopyWith<$Res>  {
  factory $PromoOfferEntityCopyWith(PromoOfferEntity value, $Res Function(PromoOfferEntity) _then) = _$PromoOfferEntityCopyWithImpl;
@useResult
$Res call({
 int promoId, String code, String title, String description, String? validityText, String? savingsText, String? actionLabel, String? actionUri, String? termsText, String? termsLink, bool isApplied, bool isApplicable, bool showCode
});




}
/// @nodoc
class _$PromoOfferEntityCopyWithImpl<$Res>
    implements $PromoOfferEntityCopyWith<$Res> {
  _$PromoOfferEntityCopyWithImpl(this._self, this._then);

  final PromoOfferEntity _self;
  final $Res Function(PromoOfferEntity) _then;

/// Create a copy of PromoOfferEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promoId = null,Object? code = null,Object? title = null,Object? description = null,Object? validityText = freezed,Object? savingsText = freezed,Object? actionLabel = freezed,Object? actionUri = freezed,Object? termsText = freezed,Object? termsLink = freezed,Object? isApplied = null,Object? isApplicable = null,Object? showCode = null,}) {
  return _then(_self.copyWith(
promoId: null == promoId ? _self.promoId : promoId // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,validityText: freezed == validityText ? _self.validityText : validityText // ignore: cast_nullable_to_non_nullable
as String?,savingsText: freezed == savingsText ? _self.savingsText : savingsText // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,termsText: freezed == termsText ? _self.termsText : termsText // ignore: cast_nullable_to_non_nullable
as String?,termsLink: freezed == termsLink ? _self.termsLink : termsLink // ignore: cast_nullable_to_non_nullable
as String?,isApplied: null == isApplied ? _self.isApplied : isApplied // ignore: cast_nullable_to_non_nullable
as bool,isApplicable: null == isApplicable ? _self.isApplicable : isApplicable // ignore: cast_nullable_to_non_nullable
as bool,showCode: null == showCode ? _self.showCode : showCode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoOfferEntity].
extension PromoOfferEntityPatterns on PromoOfferEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoOfferEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoOfferEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoOfferEntity value)  $default,){
final _that = this;
switch (_that) {
case _PromoOfferEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoOfferEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PromoOfferEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int promoId,  String code,  String title,  String description,  String? validityText,  String? savingsText,  String? actionLabel,  String? actionUri,  String? termsText,  String? termsLink,  bool isApplied,  bool isApplicable,  bool showCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoOfferEntity() when $default != null:
return $default(_that.promoId,_that.code,_that.title,_that.description,_that.validityText,_that.savingsText,_that.actionLabel,_that.actionUri,_that.termsText,_that.termsLink,_that.isApplied,_that.isApplicable,_that.showCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int promoId,  String code,  String title,  String description,  String? validityText,  String? savingsText,  String? actionLabel,  String? actionUri,  String? termsText,  String? termsLink,  bool isApplied,  bool isApplicable,  bool showCode)  $default,) {final _that = this;
switch (_that) {
case _PromoOfferEntity():
return $default(_that.promoId,_that.code,_that.title,_that.description,_that.validityText,_that.savingsText,_that.actionLabel,_that.actionUri,_that.termsText,_that.termsLink,_that.isApplied,_that.isApplicable,_that.showCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int promoId,  String code,  String title,  String description,  String? validityText,  String? savingsText,  String? actionLabel,  String? actionUri,  String? termsText,  String? termsLink,  bool isApplied,  bool isApplicable,  bool showCode)?  $default,) {final _that = this;
switch (_that) {
case _PromoOfferEntity() when $default != null:
return $default(_that.promoId,_that.code,_that.title,_that.description,_that.validityText,_that.savingsText,_that.actionLabel,_that.actionUri,_that.termsText,_that.termsLink,_that.isApplied,_that.isApplicable,_that.showCode);case _:
  return null;

}
}

}

/// @nodoc


class _PromoOfferEntity implements PromoOfferEntity {
  const _PromoOfferEntity({this.promoId = 0, this.code = '', this.title = '', this.description = '', this.validityText, this.savingsText, this.actionLabel, this.actionUri, this.termsText, this.termsLink, this.isApplied = false, this.isApplicable = true, this.showCode = true});
  

/// Server id for this promo. The terms deeplink carries it as `?id=`.
@override@JsonKey() final  int promoId;
@override@JsonKey() final  String code;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override final  String? validityText;
@override final  String? savingsText;
/// Label + deeplink for the backend-driven CTA on the card (e.g. "View
/// eligible products" → PLP). Routed through `ActionUrlHandler`, exactly
/// like home-page components.
@override final  String? actionLabel;
@override final  String? actionUri;
@override final  String? termsText;
@override final  String? termsLink;
@override@JsonKey() final  bool isApplied;
@override@JsonKey() final  bool isApplicable;
/// The details endpoint can suppress the code badge (`showPromotionCode`);
/// the offer list always shows it, hence the default.
@override@JsonKey() final  bool showCode;

/// Create a copy of PromoOfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoOfferEntityCopyWith<_PromoOfferEntity> get copyWith => __$PromoOfferEntityCopyWithImpl<_PromoOfferEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoOfferEntity&&(identical(other.promoId, promoId) || other.promoId == promoId)&&(identical(other.code, code) || other.code == code)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.validityText, validityText) || other.validityText == validityText)&&(identical(other.savingsText, savingsText) || other.savingsText == savingsText)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.termsText, termsText) || other.termsText == termsText)&&(identical(other.termsLink, termsLink) || other.termsLink == termsLink)&&(identical(other.isApplied, isApplied) || other.isApplied == isApplied)&&(identical(other.isApplicable, isApplicable) || other.isApplicable == isApplicable)&&(identical(other.showCode, showCode) || other.showCode == showCode));
}


@override
int get hashCode => Object.hash(runtimeType,promoId,code,title,description,validityText,savingsText,actionLabel,actionUri,termsText,termsLink,isApplied,isApplicable,showCode);

@override
String toString() {
  return 'PromoOfferEntity(promoId: $promoId, code: $code, title: $title, description: $description, validityText: $validityText, savingsText: $savingsText, actionLabel: $actionLabel, actionUri: $actionUri, termsText: $termsText, termsLink: $termsLink, isApplied: $isApplied, isApplicable: $isApplicable, showCode: $showCode)';
}


}

/// @nodoc
abstract mixin class _$PromoOfferEntityCopyWith<$Res> implements $PromoOfferEntityCopyWith<$Res> {
  factory _$PromoOfferEntityCopyWith(_PromoOfferEntity value, $Res Function(_PromoOfferEntity) _then) = __$PromoOfferEntityCopyWithImpl;
@override @useResult
$Res call({
 int promoId, String code, String title, String description, String? validityText, String? savingsText, String? actionLabel, String? actionUri, String? termsText, String? termsLink, bool isApplied, bool isApplicable, bool showCode
});




}
/// @nodoc
class __$PromoOfferEntityCopyWithImpl<$Res>
    implements _$PromoOfferEntityCopyWith<$Res> {
  __$PromoOfferEntityCopyWithImpl(this._self, this._then);

  final _PromoOfferEntity _self;
  final $Res Function(_PromoOfferEntity) _then;

/// Create a copy of PromoOfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promoId = null,Object? code = null,Object? title = null,Object? description = null,Object? validityText = freezed,Object? savingsText = freezed,Object? actionLabel = freezed,Object? actionUri = freezed,Object? termsText = freezed,Object? termsLink = freezed,Object? isApplied = null,Object? isApplicable = null,Object? showCode = null,}) {
  return _then(_PromoOfferEntity(
promoId: null == promoId ? _self.promoId : promoId // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,validityText: freezed == validityText ? _self.validityText : validityText // ignore: cast_nullable_to_non_nullable
as String?,savingsText: freezed == savingsText ? _self.savingsText : savingsText // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,termsText: freezed == termsText ? _self.termsText : termsText // ignore: cast_nullable_to_non_nullable
as String?,termsLink: freezed == termsLink ? _self.termsLink : termsLink // ignore: cast_nullable_to_non_nullable
as String?,isApplied: null == isApplied ? _self.isApplied : isApplied // ignore: cast_nullable_to_non_nullable
as bool,isApplicable: null == isApplicable ? _self.isApplicable : isApplicable // ignore: cast_nullable_to_non_nullable
as bool,showCode: null == showCode ? _self.showCode : showCode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
