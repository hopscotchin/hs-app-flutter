// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_listing_record_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderListingRecordEntity {

/// The parent order. Not unique across rows on the Gift Cards tab.
 String get orderId;/// The row's stable identity — list key, automation key, and what
/// `track/v3` takes.
///
/// On gift cards this is a backend ask: the v1 wire sends no item id and
/// `orderId` repeats across rows, so there is nothing unique to key on.
 String get orderItemId;/// Whole-card tap target. Android builds this Intent in the adapter.
 String? get actionUri; String? get actionUriWeb; MediaEntity? get media; String? get title;/// Display-ready, symbol and separators included. Android renders
/// `"₹" + amount.toInt()`, dropping paise and the thousands comma
/// (2493.04 → "₹2493" where the design shows "₹2,493").
///
/// The listing draws `sellingPrice` only — no strikethrough, no discount
/// badge, even on a free gift whose wire record carries both.
 ProductPriceEntity? get priceInfo; int get quantity;/// Absent on every gift card, on a free gift, and whenever the SKU is
/// "One Size". The backend decides; the client just omits the row.
 String? get size;/// A single advisory line under the price — "Non returnable & non
/// exchangeable" and the like — with its own colour and an optional
/// tooltip. Reuses Cart's [CartItemDetailEntity]: the shape is
/// {title, titleColor, action}, and order details already sends the same
/// block as `itemDetails`.
///
/// Was `itemMessageBar` on the v5 wire, where the client picked the colour
/// and the tooltip copy. Both arrive resolved now.
 CartItemDetailEntity? get itemDetails; OrderStatusEntity? get status;
/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderListingRecordEntityCopyWith<OrderListingRecordEntity> get copyWith => _$OrderListingRecordEntityCopyWithImpl<OrderListingRecordEntity>(this as OrderListingRecordEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderListingRecordEntity&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.actionUriWeb, actionUriWeb) || other.actionUriWeb == actionUriWeb)&&(identical(other.media, media) || other.media == media)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.size, size) || other.size == size)&&(identical(other.itemDetails, itemDetails) || other.itemDetails == itemDetails)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderItemId,actionUri,actionUriWeb,media,title,priceInfo,quantity,size,itemDetails,status);

@override
String toString() {
  return 'OrderListingRecordEntity(orderId: $orderId, orderItemId: $orderItemId, actionUri: $actionUri, actionUriWeb: $actionUriWeb, media: $media, title: $title, priceInfo: $priceInfo, quantity: $quantity, size: $size, itemDetails: $itemDetails, status: $status)';
}


}

/// @nodoc
abstract mixin class $OrderListingRecordEntityCopyWith<$Res>  {
  factory $OrderListingRecordEntityCopyWith(OrderListingRecordEntity value, $Res Function(OrderListingRecordEntity) _then) = _$OrderListingRecordEntityCopyWithImpl;
@useResult
$Res call({
 String orderId, String orderItemId, String? actionUri, String? actionUriWeb, MediaEntity? media, String? title, ProductPriceEntity? priceInfo, int quantity, String? size, CartItemDetailEntity? itemDetails, OrderStatusEntity? status
});


$MediaEntityCopyWith<$Res>? get media;$ProductPriceEntityCopyWith<$Res>? get priceInfo;$OrderStatusEntityCopyWith<$Res>? get status;

}
/// @nodoc
class _$OrderListingRecordEntityCopyWithImpl<$Res>
    implements $OrderListingRecordEntityCopyWith<$Res> {
  _$OrderListingRecordEntityCopyWithImpl(this._self, this._then);

  final OrderListingRecordEntity _self;
  final $Res Function(OrderListingRecordEntity) _then;

/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderItemId = null,Object? actionUri = freezed,Object? actionUriWeb = freezed,Object? media = freezed,Object? title = freezed,Object? priceInfo = freezed,Object? quantity = null,Object? size = freezed,Object? itemDetails = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,actionUriWeb: freezed == actionUriWeb ? _self.actionUriWeb : actionUriWeb // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaEntity?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,itemDetails: freezed == itemDetails ? _self.itemDetails : itemDetails // ignore: cast_nullable_to_non_nullable
as CartItemDetailEntity?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatusEntity?,
  ));
}
/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEntityCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaEntityCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get priceInfo {
    if (_self.priceInfo == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.priceInfo!, (value) {
    return _then(_self.copyWith(priceInfo: value));
  });
}/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderStatusEntityCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $OrderStatusEntityCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderListingRecordEntity].
extension OrderListingRecordEntityPatterns on OrderListingRecordEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderListingRecordEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderListingRecordEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderListingRecordEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderListingRecordEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderListingRecordEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderListingRecordEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String orderItemId,  String? actionUri,  String? actionUriWeb,  MediaEntity? media,  String? title,  ProductPriceEntity? priceInfo,  int quantity,  String? size,  CartItemDetailEntity? itemDetails,  OrderStatusEntity? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderListingRecordEntity() when $default != null:
return $default(_that.orderId,_that.orderItemId,_that.actionUri,_that.actionUriWeb,_that.media,_that.title,_that.priceInfo,_that.quantity,_that.size,_that.itemDetails,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String orderItemId,  String? actionUri,  String? actionUriWeb,  MediaEntity? media,  String? title,  ProductPriceEntity? priceInfo,  int quantity,  String? size,  CartItemDetailEntity? itemDetails,  OrderStatusEntity? status)  $default,) {final _that = this;
switch (_that) {
case _OrderListingRecordEntity():
return $default(_that.orderId,_that.orderItemId,_that.actionUri,_that.actionUriWeb,_that.media,_that.title,_that.priceInfo,_that.quantity,_that.size,_that.itemDetails,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String orderItemId,  String? actionUri,  String? actionUriWeb,  MediaEntity? media,  String? title,  ProductPriceEntity? priceInfo,  int quantity,  String? size,  CartItemDetailEntity? itemDetails,  OrderStatusEntity? status)?  $default,) {final _that = this;
switch (_that) {
case _OrderListingRecordEntity() when $default != null:
return $default(_that.orderId,_that.orderItemId,_that.actionUri,_that.actionUriWeb,_that.media,_that.title,_that.priceInfo,_that.quantity,_that.size,_that.itemDetails,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _OrderListingRecordEntity implements OrderListingRecordEntity {
  const _OrderListingRecordEntity({this.orderId = '', this.orderItemId = '', this.actionUri, this.actionUriWeb, this.media, this.title, this.priceInfo, this.quantity = 0, this.size, this.itemDetails, this.status});
  

/// The parent order. Not unique across rows on the Gift Cards tab.
@override@JsonKey() final  String orderId;
/// The row's stable identity — list key, automation key, and what
/// `track/v3` takes.
///
/// On gift cards this is a backend ask: the v1 wire sends no item id and
/// `orderId` repeats across rows, so there is nothing unique to key on.
@override@JsonKey() final  String orderItemId;
/// Whole-card tap target. Android builds this Intent in the adapter.
@override final  String? actionUri;
@override final  String? actionUriWeb;
@override final  MediaEntity? media;
@override final  String? title;
/// Display-ready, symbol and separators included. Android renders
/// `"₹" + amount.toInt()`, dropping paise and the thousands comma
/// (2493.04 → "₹2493" where the design shows "₹2,493").
///
/// The listing draws `sellingPrice` only — no strikethrough, no discount
/// badge, even on a free gift whose wire record carries both.
@override final  ProductPriceEntity? priceInfo;
@override@JsonKey() final  int quantity;
/// Absent on every gift card, on a free gift, and whenever the SKU is
/// "One Size". The backend decides; the client just omits the row.
@override final  String? size;
/// A single advisory line under the price — "Non returnable & non
/// exchangeable" and the like — with its own colour and an optional
/// tooltip. Reuses Cart's [CartItemDetailEntity]: the shape is
/// {title, titleColor, action}, and order details already sends the same
/// block as `itemDetails`.
///
/// Was `itemMessageBar` on the v5 wire, where the client picked the colour
/// and the tooltip copy. Both arrive resolved now.
@override final  CartItemDetailEntity? itemDetails;
@override final  OrderStatusEntity? status;

/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderListingRecordEntityCopyWith<_OrderListingRecordEntity> get copyWith => __$OrderListingRecordEntityCopyWithImpl<_OrderListingRecordEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderListingRecordEntity&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.actionUri, actionUri) || other.actionUri == actionUri)&&(identical(other.actionUriWeb, actionUriWeb) || other.actionUriWeb == actionUriWeb)&&(identical(other.media, media) || other.media == media)&&(identical(other.title, title) || other.title == title)&&(identical(other.priceInfo, priceInfo) || other.priceInfo == priceInfo)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.size, size) || other.size == size)&&(identical(other.itemDetails, itemDetails) || other.itemDetails == itemDetails)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderItemId,actionUri,actionUriWeb,media,title,priceInfo,quantity,size,itemDetails,status);

@override
String toString() {
  return 'OrderListingRecordEntity(orderId: $orderId, orderItemId: $orderItemId, actionUri: $actionUri, actionUriWeb: $actionUriWeb, media: $media, title: $title, priceInfo: $priceInfo, quantity: $quantity, size: $size, itemDetails: $itemDetails, status: $status)';
}


}

/// @nodoc
abstract mixin class _$OrderListingRecordEntityCopyWith<$Res> implements $OrderListingRecordEntityCopyWith<$Res> {
  factory _$OrderListingRecordEntityCopyWith(_OrderListingRecordEntity value, $Res Function(_OrderListingRecordEntity) _then) = __$OrderListingRecordEntityCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String orderItemId, String? actionUri, String? actionUriWeb, MediaEntity? media, String? title, ProductPriceEntity? priceInfo, int quantity, String? size, CartItemDetailEntity? itemDetails, OrderStatusEntity? status
});


@override $MediaEntityCopyWith<$Res>? get media;@override $ProductPriceEntityCopyWith<$Res>? get priceInfo;@override $OrderStatusEntityCopyWith<$Res>? get status;

}
/// @nodoc
class __$OrderListingRecordEntityCopyWithImpl<$Res>
    implements _$OrderListingRecordEntityCopyWith<$Res> {
  __$OrderListingRecordEntityCopyWithImpl(this._self, this._then);

  final _OrderListingRecordEntity _self;
  final $Res Function(_OrderListingRecordEntity) _then;

/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderItemId = null,Object? actionUri = freezed,Object? actionUriWeb = freezed,Object? media = freezed,Object? title = freezed,Object? priceInfo = freezed,Object? quantity = null,Object? size = freezed,Object? itemDetails = freezed,Object? status = freezed,}) {
  return _then(_OrderListingRecordEntity(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,actionUri: freezed == actionUri ? _self.actionUri : actionUri // ignore: cast_nullable_to_non_nullable
as String?,actionUriWeb: freezed == actionUriWeb ? _self.actionUriWeb : actionUriWeb // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaEntity?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priceInfo: freezed == priceInfo ? _self.priceInfo : priceInfo // ignore: cast_nullable_to_non_nullable
as ProductPriceEntity?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,itemDetails: freezed == itemDetails ? _self.itemDetails : itemDetails // ignore: cast_nullable_to_non_nullable
as CartItemDetailEntity?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatusEntity?,
  ));
}

/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaEntityCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaEntityCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductPriceEntityCopyWith<$Res>? get priceInfo {
    if (_self.priceInfo == null) {
    return null;
  }

  return $ProductPriceEntityCopyWith<$Res>(_self.priceInfo!, (value) {
    return _then(_self.copyWith(priceInfo: value));
  });
}/// Create a copy of OrderListingRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderStatusEntityCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $OrderStatusEntityCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

// dart format on
