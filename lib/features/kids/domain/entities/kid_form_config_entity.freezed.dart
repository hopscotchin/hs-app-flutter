// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kid_form_config_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KidFormConfigEntity {

 String get heading; String get subheading; String get bannerTitle; String get bannerSubtitle; Color get bannerBackgroundColor; String get consentText; String get viewPrivacyPolicyLabel; String get viewPrivacyPolicyUrl;// Shown on the screen's own photo-picker circle (the tappable trigger
// that opens the bottom sheet) before the user has chosen a photo or
// avatar — the empty-state image. Root-level, not per-avatar: this is
// one generic image for the trigger itself, distinct from each avatar
// option's own [KidAvatarOptionEntity.imageUrl] inside the sheet.
 String? get placeholderImage; List<KidAvatarOptionEntity> get avatars;
/// Create a copy of KidFormConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KidFormConfigEntityCopyWith<KidFormConfigEntity> get copyWith => _$KidFormConfigEntityCopyWithImpl<KidFormConfigEntity>(this as KidFormConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidFormConfigEntity&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.subheading, subheading) || other.subheading == subheading)&&(identical(other.bannerTitle, bannerTitle) || other.bannerTitle == bannerTitle)&&(identical(other.bannerSubtitle, bannerSubtitle) || other.bannerSubtitle == bannerSubtitle)&&(identical(other.bannerBackgroundColor, bannerBackgroundColor) || other.bannerBackgroundColor == bannerBackgroundColor)&&(identical(other.consentText, consentText) || other.consentText == consentText)&&(identical(other.viewPrivacyPolicyLabel, viewPrivacyPolicyLabel) || other.viewPrivacyPolicyLabel == viewPrivacyPolicyLabel)&&(identical(other.viewPrivacyPolicyUrl, viewPrivacyPolicyUrl) || other.viewPrivacyPolicyUrl == viewPrivacyPolicyUrl)&&(identical(other.placeholderImage, placeholderImage) || other.placeholderImage == placeholderImage)&&const DeepCollectionEquality().equals(other.avatars, avatars));
}


@override
int get hashCode => Object.hash(runtimeType,heading,subheading,bannerTitle,bannerSubtitle,bannerBackgroundColor,consentText,viewPrivacyPolicyLabel,viewPrivacyPolicyUrl,placeholderImage,const DeepCollectionEquality().hash(avatars));

@override
String toString() {
  return 'KidFormConfigEntity(heading: $heading, subheading: $subheading, bannerTitle: $bannerTitle, bannerSubtitle: $bannerSubtitle, bannerBackgroundColor: $bannerBackgroundColor, consentText: $consentText, viewPrivacyPolicyLabel: $viewPrivacyPolicyLabel, viewPrivacyPolicyUrl: $viewPrivacyPolicyUrl, placeholderImage: $placeholderImage, avatars: $avatars)';
}


}

/// @nodoc
abstract mixin class $KidFormConfigEntityCopyWith<$Res>  {
  factory $KidFormConfigEntityCopyWith(KidFormConfigEntity value, $Res Function(KidFormConfigEntity) _then) = _$KidFormConfigEntityCopyWithImpl;
@useResult
$Res call({
 String heading, String subheading, String bannerTitle, String bannerSubtitle, Color bannerBackgroundColor, String consentText, String viewPrivacyPolicyLabel, String viewPrivacyPolicyUrl, String? placeholderImage, List<KidAvatarOptionEntity> avatars
});




}
/// @nodoc
class _$KidFormConfigEntityCopyWithImpl<$Res>
    implements $KidFormConfigEntityCopyWith<$Res> {
  _$KidFormConfigEntityCopyWithImpl(this._self, this._then);

  final KidFormConfigEntity _self;
  final $Res Function(KidFormConfigEntity) _then;

/// Create a copy of KidFormConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? heading = null,Object? subheading = null,Object? bannerTitle = null,Object? bannerSubtitle = null,Object? bannerBackgroundColor = null,Object? consentText = null,Object? viewPrivacyPolicyLabel = null,Object? viewPrivacyPolicyUrl = null,Object? placeholderImage = freezed,Object? avatars = null,}) {
  return _then(_self.copyWith(
heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as String,subheading: null == subheading ? _self.subheading : subheading // ignore: cast_nullable_to_non_nullable
as String,bannerTitle: null == bannerTitle ? _self.bannerTitle : bannerTitle // ignore: cast_nullable_to_non_nullable
as String,bannerSubtitle: null == bannerSubtitle ? _self.bannerSubtitle : bannerSubtitle // ignore: cast_nullable_to_non_nullable
as String,bannerBackgroundColor: null == bannerBackgroundColor ? _self.bannerBackgroundColor : bannerBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,consentText: null == consentText ? _self.consentText : consentText // ignore: cast_nullable_to_non_nullable
as String,viewPrivacyPolicyLabel: null == viewPrivacyPolicyLabel ? _self.viewPrivacyPolicyLabel : viewPrivacyPolicyLabel // ignore: cast_nullable_to_non_nullable
as String,viewPrivacyPolicyUrl: null == viewPrivacyPolicyUrl ? _self.viewPrivacyPolicyUrl : viewPrivacyPolicyUrl // ignore: cast_nullable_to_non_nullable
as String,placeholderImage: freezed == placeholderImage ? _self.placeholderImage : placeholderImage // ignore: cast_nullable_to_non_nullable
as String?,avatars: null == avatars ? _self.avatars : avatars // ignore: cast_nullable_to_non_nullable
as List<KidAvatarOptionEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [KidFormConfigEntity].
extension KidFormConfigEntityPatterns on KidFormConfigEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KidFormConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KidFormConfigEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KidFormConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _KidFormConfigEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KidFormConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KidFormConfigEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String heading,  String subheading,  String bannerTitle,  String bannerSubtitle,  Color bannerBackgroundColor,  String consentText,  String viewPrivacyPolicyLabel,  String viewPrivacyPolicyUrl,  String? placeholderImage,  List<KidAvatarOptionEntity> avatars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KidFormConfigEntity() when $default != null:
return $default(_that.heading,_that.subheading,_that.bannerTitle,_that.bannerSubtitle,_that.bannerBackgroundColor,_that.consentText,_that.viewPrivacyPolicyLabel,_that.viewPrivacyPolicyUrl,_that.placeholderImage,_that.avatars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String heading,  String subheading,  String bannerTitle,  String bannerSubtitle,  Color bannerBackgroundColor,  String consentText,  String viewPrivacyPolicyLabel,  String viewPrivacyPolicyUrl,  String? placeholderImage,  List<KidAvatarOptionEntity> avatars)  $default,) {final _that = this;
switch (_that) {
case _KidFormConfigEntity():
return $default(_that.heading,_that.subheading,_that.bannerTitle,_that.bannerSubtitle,_that.bannerBackgroundColor,_that.consentText,_that.viewPrivacyPolicyLabel,_that.viewPrivacyPolicyUrl,_that.placeholderImage,_that.avatars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String heading,  String subheading,  String bannerTitle,  String bannerSubtitle,  Color bannerBackgroundColor,  String consentText,  String viewPrivacyPolicyLabel,  String viewPrivacyPolicyUrl,  String? placeholderImage,  List<KidAvatarOptionEntity> avatars)?  $default,) {final _that = this;
switch (_that) {
case _KidFormConfigEntity() when $default != null:
return $default(_that.heading,_that.subheading,_that.bannerTitle,_that.bannerSubtitle,_that.bannerBackgroundColor,_that.consentText,_that.viewPrivacyPolicyLabel,_that.viewPrivacyPolicyUrl,_that.placeholderImage,_that.avatars);case _:
  return null;

}
}

}

/// @nodoc


class _KidFormConfigEntity implements KidFormConfigEntity {
  const _KidFormConfigEntity({required this.heading, required this.subheading, required this.bannerTitle, required this.bannerSubtitle, required this.bannerBackgroundColor, required this.consentText, required this.viewPrivacyPolicyLabel, required this.viewPrivacyPolicyUrl, this.placeholderImage, required final  List<KidAvatarOptionEntity> avatars}): _avatars = avatars;
  

@override final  String heading;
@override final  String subheading;
@override final  String bannerTitle;
@override final  String bannerSubtitle;
@override final  Color bannerBackgroundColor;
@override final  String consentText;
@override final  String viewPrivacyPolicyLabel;
@override final  String viewPrivacyPolicyUrl;
// Shown on the screen's own photo-picker circle (the tappable trigger
// that opens the bottom sheet) before the user has chosen a photo or
// avatar — the empty-state image. Root-level, not per-avatar: this is
// one generic image for the trigger itself, distinct from each avatar
// option's own [KidAvatarOptionEntity.imageUrl] inside the sheet.
@override final  String? placeholderImage;
 final  List<KidAvatarOptionEntity> _avatars;
@override List<KidAvatarOptionEntity> get avatars {
  if (_avatars is EqualUnmodifiableListView) return _avatars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avatars);
}


/// Create a copy of KidFormConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KidFormConfigEntityCopyWith<_KidFormConfigEntity> get copyWith => __$KidFormConfigEntityCopyWithImpl<_KidFormConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KidFormConfigEntity&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.subheading, subheading) || other.subheading == subheading)&&(identical(other.bannerTitle, bannerTitle) || other.bannerTitle == bannerTitle)&&(identical(other.bannerSubtitle, bannerSubtitle) || other.bannerSubtitle == bannerSubtitle)&&(identical(other.bannerBackgroundColor, bannerBackgroundColor) || other.bannerBackgroundColor == bannerBackgroundColor)&&(identical(other.consentText, consentText) || other.consentText == consentText)&&(identical(other.viewPrivacyPolicyLabel, viewPrivacyPolicyLabel) || other.viewPrivacyPolicyLabel == viewPrivacyPolicyLabel)&&(identical(other.viewPrivacyPolicyUrl, viewPrivacyPolicyUrl) || other.viewPrivacyPolicyUrl == viewPrivacyPolicyUrl)&&(identical(other.placeholderImage, placeholderImage) || other.placeholderImage == placeholderImage)&&const DeepCollectionEquality().equals(other._avatars, _avatars));
}


@override
int get hashCode => Object.hash(runtimeType,heading,subheading,bannerTitle,bannerSubtitle,bannerBackgroundColor,consentText,viewPrivacyPolicyLabel,viewPrivacyPolicyUrl,placeholderImage,const DeepCollectionEquality().hash(_avatars));

@override
String toString() {
  return 'KidFormConfigEntity(heading: $heading, subheading: $subheading, bannerTitle: $bannerTitle, bannerSubtitle: $bannerSubtitle, bannerBackgroundColor: $bannerBackgroundColor, consentText: $consentText, viewPrivacyPolicyLabel: $viewPrivacyPolicyLabel, viewPrivacyPolicyUrl: $viewPrivacyPolicyUrl, placeholderImage: $placeholderImage, avatars: $avatars)';
}


}

/// @nodoc
abstract mixin class _$KidFormConfigEntityCopyWith<$Res> implements $KidFormConfigEntityCopyWith<$Res> {
  factory _$KidFormConfigEntityCopyWith(_KidFormConfigEntity value, $Res Function(_KidFormConfigEntity) _then) = __$KidFormConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 String heading, String subheading, String bannerTitle, String bannerSubtitle, Color bannerBackgroundColor, String consentText, String viewPrivacyPolicyLabel, String viewPrivacyPolicyUrl, String? placeholderImage, List<KidAvatarOptionEntity> avatars
});




}
/// @nodoc
class __$KidFormConfigEntityCopyWithImpl<$Res>
    implements _$KidFormConfigEntityCopyWith<$Res> {
  __$KidFormConfigEntityCopyWithImpl(this._self, this._then);

  final _KidFormConfigEntity _self;
  final $Res Function(_KidFormConfigEntity) _then;

/// Create a copy of KidFormConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? heading = null,Object? subheading = null,Object? bannerTitle = null,Object? bannerSubtitle = null,Object? bannerBackgroundColor = null,Object? consentText = null,Object? viewPrivacyPolicyLabel = null,Object? viewPrivacyPolicyUrl = null,Object? placeholderImage = freezed,Object? avatars = null,}) {
  return _then(_KidFormConfigEntity(
heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as String,subheading: null == subheading ? _self.subheading : subheading // ignore: cast_nullable_to_non_nullable
as String,bannerTitle: null == bannerTitle ? _self.bannerTitle : bannerTitle // ignore: cast_nullable_to_non_nullable
as String,bannerSubtitle: null == bannerSubtitle ? _self.bannerSubtitle : bannerSubtitle // ignore: cast_nullable_to_non_nullable
as String,bannerBackgroundColor: null == bannerBackgroundColor ? _self.bannerBackgroundColor : bannerBackgroundColor // ignore: cast_nullable_to_non_nullable
as Color,consentText: null == consentText ? _self.consentText : consentText // ignore: cast_nullable_to_non_nullable
as String,viewPrivacyPolicyLabel: null == viewPrivacyPolicyLabel ? _self.viewPrivacyPolicyLabel : viewPrivacyPolicyLabel // ignore: cast_nullable_to_non_nullable
as String,viewPrivacyPolicyUrl: null == viewPrivacyPolicyUrl ? _self.viewPrivacyPolicyUrl : viewPrivacyPolicyUrl // ignore: cast_nullable_to_non_nullable
as String,placeholderImage: freezed == placeholderImage ? _self.placeholderImage : placeholderImage // ignore: cast_nullable_to_non_nullable
as String?,avatars: null == avatars ? _self._avatars : avatars // ignore: cast_nullable_to_non_nullable
as List<KidAvatarOptionEntity>,
  ));
}


}

/// @nodoc
mixin _$KidAvatarOptionEntity {

 int get id; String? get imageUrl;
/// Create a copy of KidAvatarOptionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KidAvatarOptionEntityCopyWith<KidAvatarOptionEntity> get copyWith => _$KidAvatarOptionEntityCopyWithImpl<KidAvatarOptionEntity>(this as KidAvatarOptionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KidAvatarOptionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl);

@override
String toString() {
  return 'KidAvatarOptionEntity(id: $id, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $KidAvatarOptionEntityCopyWith<$Res>  {
  factory $KidAvatarOptionEntityCopyWith(KidAvatarOptionEntity value, $Res Function(KidAvatarOptionEntity) _then) = _$KidAvatarOptionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String? imageUrl
});




}
/// @nodoc
class _$KidAvatarOptionEntityCopyWithImpl<$Res>
    implements $KidAvatarOptionEntityCopyWith<$Res> {
  _$KidAvatarOptionEntityCopyWithImpl(this._self, this._then);

  final KidAvatarOptionEntity _self;
  final $Res Function(KidAvatarOptionEntity) _then;

/// Create a copy of KidAvatarOptionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KidAvatarOptionEntity].
extension KidAvatarOptionEntityPatterns on KidAvatarOptionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KidAvatarOptionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KidAvatarOptionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KidAvatarOptionEntity value)  $default,){
final _that = this;
switch (_that) {
case _KidAvatarOptionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KidAvatarOptionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _KidAvatarOptionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KidAvatarOptionEntity() when $default != null:
return $default(_that.id,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _KidAvatarOptionEntity():
return $default(_that.id,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _KidAvatarOptionEntity() when $default != null:
return $default(_that.id,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _KidAvatarOptionEntity implements KidAvatarOptionEntity {
  const _KidAvatarOptionEntity({required this.id, this.imageUrl});
  

@override final  int id;
@override final  String? imageUrl;

/// Create a copy of KidAvatarOptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KidAvatarOptionEntityCopyWith<_KidAvatarOptionEntity> get copyWith => __$KidAvatarOptionEntityCopyWithImpl<_KidAvatarOptionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KidAvatarOptionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageUrl);

@override
String toString() {
  return 'KidAvatarOptionEntity(id: $id, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$KidAvatarOptionEntityCopyWith<$Res> implements $KidAvatarOptionEntityCopyWith<$Res> {
  factory _$KidAvatarOptionEntityCopyWith(_KidAvatarOptionEntity value, $Res Function(_KidAvatarOptionEntity) _then) = __$KidAvatarOptionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String? imageUrl
});




}
/// @nodoc
class __$KidAvatarOptionEntityCopyWithImpl<$Res>
    implements _$KidAvatarOptionEntityCopyWith<$Res> {
  __$KidAvatarOptionEntityCopyWithImpl(this._self, this._then);

  final _KidAvatarOptionEntity _self;
  final $Res Function(_KidAvatarOptionEntity) _then;

/// Create a copy of KidAvatarOptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageUrl = freezed,}) {
  return _then(_KidAvatarOptionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
