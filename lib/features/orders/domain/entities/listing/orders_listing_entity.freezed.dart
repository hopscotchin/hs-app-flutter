// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_listing_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersListingEntity {

/// Always present, never absent — an absent primary collection reads as a
/// failure rather than an empty result. v5 omitted `items` entirely when
/// empty while `v1/gift-cards` sent `[]`; one shape now.
 List<OrderListingRecordEntity> get records; PageMetaEntity? get pageMeta;/// Sent only when [records] is empty.
 EmptyStateEntity? get emptyState;/// Orders tab only.
 NotificationNudgeEntity? get notificationNudge;/// Orders tab only. App-config in practice — see [SupportSectionEntity].
 SupportSectionEntity? get support;/// The analytics blob, forwarded to Segment whole. **Never read a key out
/// of it.** Keeping it an untyped map is what lets the backend add a
/// dimension without an app release.
 Map<String, dynamic>? get trackingMeta;
/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersListingEntityCopyWith<OrdersListingEntity> get copyWith => _$OrdersListingEntityCopyWithImpl<OrdersListingEntity>(this as OrdersListingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersListingEntity&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&(identical(other.notificationNudge, notificationNudge) || other.notificationNudge == notificationNudge)&&(identical(other.support, support) || other.support == support)&&const DeepCollectionEquality().equals(other.trackingMeta, trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),pageMeta,emptyState,notificationNudge,support,const DeepCollectionEquality().hash(trackingMeta));

@override
String toString() {
  return 'OrdersListingEntity(records: $records, pageMeta: $pageMeta, emptyState: $emptyState, notificationNudge: $notificationNudge, support: $support, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class $OrdersListingEntityCopyWith<$Res>  {
  factory $OrdersListingEntityCopyWith(OrdersListingEntity value, $Res Function(OrdersListingEntity) _then) = _$OrdersListingEntityCopyWithImpl;
@useResult
$Res call({
 List<OrderListingRecordEntity> records, PageMetaEntity? pageMeta, EmptyStateEntity? emptyState, NotificationNudgeEntity? notificationNudge, SupportSectionEntity? support, Map<String, dynamic>? trackingMeta
});


$PageMetaEntityCopyWith<$Res>? get pageMeta;$EmptyStateEntityCopyWith<$Res>? get emptyState;$NotificationNudgeEntityCopyWith<$Res>? get notificationNudge;$SupportSectionEntityCopyWith<$Res>? get support;

}
/// @nodoc
class _$OrdersListingEntityCopyWithImpl<$Res>
    implements $OrdersListingEntityCopyWith<$Res> {
  _$OrdersListingEntityCopyWithImpl(this._self, this._then);

  final OrdersListingEntity _self;
  final $Res Function(OrdersListingEntity) _then;

/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? pageMeta = freezed,Object? emptyState = freezed,Object? notificationNudge = freezed,Object? support = freezed,Object? trackingMeta = freezed,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<OrderListingRecordEntity>,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,emptyState: freezed == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyStateEntity?,notificationNudge: freezed == notificationNudge ? _self.notificationNudge : notificationNudge // ignore: cast_nullable_to_non_nullable
as NotificationNudgeEntity?,support: freezed == support ? _self.support : support // ignore: cast_nullable_to_non_nullable
as SupportSectionEntity?,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaEntityCopyWith<$Res>? get pageMeta {
    if (_self.pageMeta == null) {
    return null;
  }

  return $PageMetaEntityCopyWith<$Res>(_self.pageMeta!, (value) {
    return _then(_self.copyWith(pageMeta: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateEntityCopyWith<$Res>? get emptyState {
    if (_self.emptyState == null) {
    return null;
  }

  return $EmptyStateEntityCopyWith<$Res>(_self.emptyState!, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationNudgeEntityCopyWith<$Res>? get notificationNudge {
    if (_self.notificationNudge == null) {
    return null;
  }

  return $NotificationNudgeEntityCopyWith<$Res>(_self.notificationNudge!, (value) {
    return _then(_self.copyWith(notificationNudge: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupportSectionEntityCopyWith<$Res>? get support {
    if (_self.support == null) {
    return null;
  }

  return $SupportSectionEntityCopyWith<$Res>(_self.support!, (value) {
    return _then(_self.copyWith(support: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrdersListingEntity].
extension OrdersListingEntityPatterns on OrdersListingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdersListingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdersListingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdersListingEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrdersListingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdersListingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrdersListingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OrderListingRecordEntity> records,  PageMetaEntity? pageMeta,  EmptyStateEntity? emptyState,  NotificationNudgeEntity? notificationNudge,  SupportSectionEntity? support,  Map<String, dynamic>? trackingMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdersListingEntity() when $default != null:
return $default(_that.records,_that.pageMeta,_that.emptyState,_that.notificationNudge,_that.support,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OrderListingRecordEntity> records,  PageMetaEntity? pageMeta,  EmptyStateEntity? emptyState,  NotificationNudgeEntity? notificationNudge,  SupportSectionEntity? support,  Map<String, dynamic>? trackingMeta)  $default,) {final _that = this;
switch (_that) {
case _OrdersListingEntity():
return $default(_that.records,_that.pageMeta,_that.emptyState,_that.notificationNudge,_that.support,_that.trackingMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OrderListingRecordEntity> records,  PageMetaEntity? pageMeta,  EmptyStateEntity? emptyState,  NotificationNudgeEntity? notificationNudge,  SupportSectionEntity? support,  Map<String, dynamic>? trackingMeta)?  $default,) {final _that = this;
switch (_that) {
case _OrdersListingEntity() when $default != null:
return $default(_that.records,_that.pageMeta,_that.emptyState,_that.notificationNudge,_that.support,_that.trackingMeta);case _:
  return null;

}
}

}

/// @nodoc


class _OrdersListingEntity implements OrdersListingEntity {
  const _OrdersListingEntity({final  List<OrderListingRecordEntity> records = const <OrderListingRecordEntity>[], this.pageMeta, this.emptyState, this.notificationNudge, this.support, final  Map<String, dynamic>? trackingMeta}): _records = records,_trackingMeta = trackingMeta;
  

/// Always present, never absent — an absent primary collection reads as a
/// failure rather than an empty result. v5 omitted `items` entirely when
/// empty while `v1/gift-cards` sent `[]`; one shape now.
 final  List<OrderListingRecordEntity> _records;
/// Always present, never absent — an absent primary collection reads as a
/// failure rather than an empty result. v5 omitted `items` entirely when
/// empty while `v1/gift-cards` sent `[]`; one shape now.
@override@JsonKey() List<OrderListingRecordEntity> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override final  PageMetaEntity? pageMeta;
/// Sent only when [records] is empty.
@override final  EmptyStateEntity? emptyState;
/// Orders tab only.
@override final  NotificationNudgeEntity? notificationNudge;
/// Orders tab only. App-config in practice — see [SupportSectionEntity].
@override final  SupportSectionEntity? support;
/// The analytics blob, forwarded to Segment whole. **Never read a key out
/// of it.** Keeping it an untyped map is what lets the backend add a
/// dimension without an app release.
 final  Map<String, dynamic>? _trackingMeta;
/// The analytics blob, forwarded to Segment whole. **Never read a key out
/// of it.** Keeping it an untyped map is what lets the backend add a
/// dimension without an app release.
@override Map<String, dynamic>? get trackingMeta {
  final value = _trackingMeta;
  if (value == null) return null;
  if (_trackingMeta is EqualUnmodifiableMapView) return _trackingMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdersListingEntityCopyWith<_OrdersListingEntity> get copyWith => __$OrdersListingEntityCopyWithImpl<_OrdersListingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdersListingEntity&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.emptyState, emptyState) || other.emptyState == emptyState)&&(identical(other.notificationNudge, notificationNudge) || other.notificationNudge == notificationNudge)&&(identical(other.support, support) || other.support == support)&&const DeepCollectionEquality().equals(other._trackingMeta, _trackingMeta));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),pageMeta,emptyState,notificationNudge,support,const DeepCollectionEquality().hash(_trackingMeta));

@override
String toString() {
  return 'OrdersListingEntity(records: $records, pageMeta: $pageMeta, emptyState: $emptyState, notificationNudge: $notificationNudge, support: $support, trackingMeta: $trackingMeta)';
}


}

/// @nodoc
abstract mixin class _$OrdersListingEntityCopyWith<$Res> implements $OrdersListingEntityCopyWith<$Res> {
  factory _$OrdersListingEntityCopyWith(_OrdersListingEntity value, $Res Function(_OrdersListingEntity) _then) = __$OrdersListingEntityCopyWithImpl;
@override @useResult
$Res call({
 List<OrderListingRecordEntity> records, PageMetaEntity? pageMeta, EmptyStateEntity? emptyState, NotificationNudgeEntity? notificationNudge, SupportSectionEntity? support, Map<String, dynamic>? trackingMeta
});


@override $PageMetaEntityCopyWith<$Res>? get pageMeta;@override $EmptyStateEntityCopyWith<$Res>? get emptyState;@override $NotificationNudgeEntityCopyWith<$Res>? get notificationNudge;@override $SupportSectionEntityCopyWith<$Res>? get support;

}
/// @nodoc
class __$OrdersListingEntityCopyWithImpl<$Res>
    implements _$OrdersListingEntityCopyWith<$Res> {
  __$OrdersListingEntityCopyWithImpl(this._self, this._then);

  final _OrdersListingEntity _self;
  final $Res Function(_OrdersListingEntity) _then;

/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? pageMeta = freezed,Object? emptyState = freezed,Object? notificationNudge = freezed,Object? support = freezed,Object? trackingMeta = freezed,}) {
  return _then(_OrdersListingEntity(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<OrderListingRecordEntity>,pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,emptyState: freezed == emptyState ? _self.emptyState : emptyState // ignore: cast_nullable_to_non_nullable
as EmptyStateEntity?,notificationNudge: freezed == notificationNudge ? _self.notificationNudge : notificationNudge // ignore: cast_nullable_to_non_nullable
as NotificationNudgeEntity?,support: freezed == support ? _self.support : support // ignore: cast_nullable_to_non_nullable
as SupportSectionEntity?,trackingMeta: freezed == trackingMeta ? _self._trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageMetaEntityCopyWith<$Res>? get pageMeta {
    if (_self.pageMeta == null) {
    return null;
  }

  return $PageMetaEntityCopyWith<$Res>(_self.pageMeta!, (value) {
    return _then(_self.copyWith(pageMeta: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmptyStateEntityCopyWith<$Res>? get emptyState {
    if (_self.emptyState == null) {
    return null;
  }

  return $EmptyStateEntityCopyWith<$Res>(_self.emptyState!, (value) {
    return _then(_self.copyWith(emptyState: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationNudgeEntityCopyWith<$Res>? get notificationNudge {
    if (_self.notificationNudge == null) {
    return null;
  }

  return $NotificationNudgeEntityCopyWith<$Res>(_self.notificationNudge!, (value) {
    return _then(_self.copyWith(notificationNudge: value));
  });
}/// Create a copy of OrdersListingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupportSectionEntityCopyWith<$Res>? get support {
    if (_self.support == null) {
    return null;
  }

  return $SupportSectionEntityCopyWith<$Res>(_self.support!, (value) {
    return _then(_self.copyWith(support: value));
  });
}
}

// dart format on
