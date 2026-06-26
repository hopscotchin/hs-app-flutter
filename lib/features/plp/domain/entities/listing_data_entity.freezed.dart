// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_data_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingDataEntity {

 PageMetaEntity? get pageMeta; TrackingMetaEntity? get trackingMeta; NotificationNudgeEntity? get notificationNudge; List<BannerEntity> get banners; FloatingFilterEntity? get floatingFilter; PlpFilterEntity? get filters; List<ListingProductEntity> get records; QueryCorrectionEntity? get queryCorrection; List<MessageBarEntity> get messageBars; int get orderRule;
/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingDataEntityCopyWith<ListingDataEntity> get copyWith => _$ListingDataEntityCopyWithImpl<ListingDataEntity>(this as ListingDataEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDataEntity&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.trackingMeta, trackingMeta) || other.trackingMeta == trackingMeta)&&(identical(other.notificationNudge, notificationNudge) || other.notificationNudge == notificationNudge)&&const DeepCollectionEquality().equals(other.banners, banners)&&(identical(other.floatingFilter, floatingFilter) || other.floatingFilter == floatingFilter)&&(identical(other.filters, filters) || other.filters == filters)&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.queryCorrection, queryCorrection) || other.queryCorrection == queryCorrection)&&const DeepCollectionEquality().equals(other.messageBars, messageBars)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule));
}


@override
int get hashCode => Object.hash(runtimeType,pageMeta,trackingMeta,notificationNudge,const DeepCollectionEquality().hash(banners),floatingFilter,filters,const DeepCollectionEquality().hash(records),queryCorrection,const DeepCollectionEquality().hash(messageBars),orderRule);

@override
String toString() {
  return 'ListingDataEntity(pageMeta: $pageMeta, trackingMeta: $trackingMeta, notificationNudge: $notificationNudge, banners: $banners, floatingFilter: $floatingFilter, filters: $filters, records: $records, queryCorrection: $queryCorrection, messageBars: $messageBars, orderRule: $orderRule)';
}


}

/// @nodoc
abstract mixin class $ListingDataEntityCopyWith<$Res>  {
  factory $ListingDataEntityCopyWith(ListingDataEntity value, $Res Function(ListingDataEntity) _then) = _$ListingDataEntityCopyWithImpl;
@useResult
$Res call({
 PageMetaEntity? pageMeta, TrackingMetaEntity? trackingMeta, NotificationNudgeEntity? notificationNudge, List<BannerEntity> banners, FloatingFilterEntity? floatingFilter, PlpFilterEntity? filters, List<ListingProductEntity> records, QueryCorrectionEntity? queryCorrection, List<MessageBarEntity> messageBars, int orderRule
});


$PageMetaEntityCopyWith<$Res>? get pageMeta;$TrackingMetaEntityCopyWith<$Res>? get trackingMeta;$NotificationNudgeEntityCopyWith<$Res>? get notificationNudge;$FloatingFilterEntityCopyWith<$Res>? get floatingFilter;$PlpFilterEntityCopyWith<$Res>? get filters;$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection;

}
/// @nodoc
class _$ListingDataEntityCopyWithImpl<$Res>
    implements $ListingDataEntityCopyWith<$Res> {
  _$ListingDataEntityCopyWithImpl(this._self, this._then);

  final ListingDataEntity _self;
  final $Res Function(ListingDataEntity) _then;

/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageMeta = freezed,Object? trackingMeta = freezed,Object? notificationNudge = freezed,Object? banners = null,Object? floatingFilter = freezed,Object? filters = freezed,Object? records = null,Object? queryCorrection = freezed,Object? messageBars = null,Object? orderRule = null,}) {
  return _then(_self.copyWith(
pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as TrackingMetaEntity?,notificationNudge: freezed == notificationNudge ? _self.notificationNudge : notificationNudge // ignore: cast_nullable_to_non_nullable
as NotificationNudgeEntity?,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,floatingFilter: freezed == floatingFilter ? _self.floatingFilter : floatingFilter // ignore: cast_nullable_to_non_nullable
as FloatingFilterEntity?,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,queryCorrection: freezed == queryCorrection ? _self.queryCorrection : queryCorrection // ignore: cast_nullable_to_non_nullable
as QueryCorrectionEntity?,messageBars: null == messageBars ? _self.messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ListingDataEntity
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
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingMetaEntityCopyWith<$Res>? get trackingMeta {
    if (_self.trackingMeta == null) {
    return null;
  }

  return $TrackingMetaEntityCopyWith<$Res>(_self.trackingMeta!, (value) {
    return _then(_self.copyWith(trackingMeta: value));
  });
}/// Create a copy of ListingDataEntity
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
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloatingFilterEntityCopyWith<$Res>? get floatingFilter {
    if (_self.floatingFilter == null) {
    return null;
  }

  return $FloatingFilterEntityCopyWith<$Res>(_self.floatingFilter!, (value) {
    return _then(_self.copyWith(floatingFilter: value));
  });
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res>? get filters {
    if (_self.filters == null) {
    return null;
  }

  return $PlpFilterEntityCopyWith<$Res>(_self.filters!, (value) {
    return _then(_self.copyWith(filters: value));
  });
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection {
    if (_self.queryCorrection == null) {
    return null;
  }

  return $QueryCorrectionEntityCopyWith<$Res>(_self.queryCorrection!, (value) {
    return _then(_self.copyWith(queryCorrection: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListingDataEntity].
extension ListingDataEntityPatterns on ListingDataEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingDataEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingDataEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingDataEntity value)  $default,){
final _that = this;
switch (_that) {
case _ListingDataEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingDataEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ListingDataEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PageMetaEntity? pageMeta,  TrackingMetaEntity? trackingMeta,  NotificationNudgeEntity? notificationNudge,  List<BannerEntity> banners,  FloatingFilterEntity? floatingFilter,  PlpFilterEntity? filters,  List<ListingProductEntity> records,  QueryCorrectionEntity? queryCorrection,  List<MessageBarEntity> messageBars,  int orderRule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingDataEntity() when $default != null:
return $default(_that.pageMeta,_that.trackingMeta,_that.notificationNudge,_that.banners,_that.floatingFilter,_that.filters,_that.records,_that.queryCorrection,_that.messageBars,_that.orderRule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PageMetaEntity? pageMeta,  TrackingMetaEntity? trackingMeta,  NotificationNudgeEntity? notificationNudge,  List<BannerEntity> banners,  FloatingFilterEntity? floatingFilter,  PlpFilterEntity? filters,  List<ListingProductEntity> records,  QueryCorrectionEntity? queryCorrection,  List<MessageBarEntity> messageBars,  int orderRule)  $default,) {final _that = this;
switch (_that) {
case _ListingDataEntity():
return $default(_that.pageMeta,_that.trackingMeta,_that.notificationNudge,_that.banners,_that.floatingFilter,_that.filters,_that.records,_that.queryCorrection,_that.messageBars,_that.orderRule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PageMetaEntity? pageMeta,  TrackingMetaEntity? trackingMeta,  NotificationNudgeEntity? notificationNudge,  List<BannerEntity> banners,  FloatingFilterEntity? floatingFilter,  PlpFilterEntity? filters,  List<ListingProductEntity> records,  QueryCorrectionEntity? queryCorrection,  List<MessageBarEntity> messageBars,  int orderRule)?  $default,) {final _that = this;
switch (_that) {
case _ListingDataEntity() when $default != null:
return $default(_that.pageMeta,_that.trackingMeta,_that.notificationNudge,_that.banners,_that.floatingFilter,_that.filters,_that.records,_that.queryCorrection,_that.messageBars,_that.orderRule);case _:
  return null;

}
}

}

/// @nodoc


class _ListingDataEntity implements ListingDataEntity {
  const _ListingDataEntity({this.pageMeta, this.trackingMeta, this.notificationNudge, final  List<BannerEntity> banners = const [], this.floatingFilter, this.filters, final  List<ListingProductEntity> records = const [], this.queryCorrection, final  List<MessageBarEntity> messageBars = const <MessageBarEntity>[], this.orderRule = -1}): _banners = banners,_records = records,_messageBars = messageBars;
  

@override final  PageMetaEntity? pageMeta;
@override final  TrackingMetaEntity? trackingMeta;
@override final  NotificationNudgeEntity? notificationNudge;
 final  List<BannerEntity> _banners;
@override@JsonKey() List<BannerEntity> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

@override final  FloatingFilterEntity? floatingFilter;
@override final  PlpFilterEntity? filters;
 final  List<ListingProductEntity> _records;
@override@JsonKey() List<ListingProductEntity> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override final  QueryCorrectionEntity? queryCorrection;
 final  List<MessageBarEntity> _messageBars;
@override@JsonKey() List<MessageBarEntity> get messageBars {
  if (_messageBars is EqualUnmodifiableListView) return _messageBars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageBars);
}

@override@JsonKey() final  int orderRule;

/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingDataEntityCopyWith<_ListingDataEntity> get copyWith => __$ListingDataEntityCopyWithImpl<_ListingDataEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingDataEntity&&(identical(other.pageMeta, pageMeta) || other.pageMeta == pageMeta)&&(identical(other.trackingMeta, trackingMeta) || other.trackingMeta == trackingMeta)&&(identical(other.notificationNudge, notificationNudge) || other.notificationNudge == notificationNudge)&&const DeepCollectionEquality().equals(other._banners, _banners)&&(identical(other.floatingFilter, floatingFilter) || other.floatingFilter == floatingFilter)&&(identical(other.filters, filters) || other.filters == filters)&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.queryCorrection, queryCorrection) || other.queryCorrection == queryCorrection)&&const DeepCollectionEquality().equals(other._messageBars, _messageBars)&&(identical(other.orderRule, orderRule) || other.orderRule == orderRule));
}


@override
int get hashCode => Object.hash(runtimeType,pageMeta,trackingMeta,notificationNudge,const DeepCollectionEquality().hash(_banners),floatingFilter,filters,const DeepCollectionEquality().hash(_records),queryCorrection,const DeepCollectionEquality().hash(_messageBars),orderRule);

@override
String toString() {
  return 'ListingDataEntity(pageMeta: $pageMeta, trackingMeta: $trackingMeta, notificationNudge: $notificationNudge, banners: $banners, floatingFilter: $floatingFilter, filters: $filters, records: $records, queryCorrection: $queryCorrection, messageBars: $messageBars, orderRule: $orderRule)';
}


}

/// @nodoc
abstract mixin class _$ListingDataEntityCopyWith<$Res> implements $ListingDataEntityCopyWith<$Res> {
  factory _$ListingDataEntityCopyWith(_ListingDataEntity value, $Res Function(_ListingDataEntity) _then) = __$ListingDataEntityCopyWithImpl;
@override @useResult
$Res call({
 PageMetaEntity? pageMeta, TrackingMetaEntity? trackingMeta, NotificationNudgeEntity? notificationNudge, List<BannerEntity> banners, FloatingFilterEntity? floatingFilter, PlpFilterEntity? filters, List<ListingProductEntity> records, QueryCorrectionEntity? queryCorrection, List<MessageBarEntity> messageBars, int orderRule
});


@override $PageMetaEntityCopyWith<$Res>? get pageMeta;@override $TrackingMetaEntityCopyWith<$Res>? get trackingMeta;@override $NotificationNudgeEntityCopyWith<$Res>? get notificationNudge;@override $FloatingFilterEntityCopyWith<$Res>? get floatingFilter;@override $PlpFilterEntityCopyWith<$Res>? get filters;@override $QueryCorrectionEntityCopyWith<$Res>? get queryCorrection;

}
/// @nodoc
class __$ListingDataEntityCopyWithImpl<$Res>
    implements _$ListingDataEntityCopyWith<$Res> {
  __$ListingDataEntityCopyWithImpl(this._self, this._then);

  final _ListingDataEntity _self;
  final $Res Function(_ListingDataEntity) _then;

/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageMeta = freezed,Object? trackingMeta = freezed,Object? notificationNudge = freezed,Object? banners = null,Object? floatingFilter = freezed,Object? filters = freezed,Object? records = null,Object? queryCorrection = freezed,Object? messageBars = null,Object? orderRule = null,}) {
  return _then(_ListingDataEntity(
pageMeta: freezed == pageMeta ? _self.pageMeta : pageMeta // ignore: cast_nullable_to_non_nullable
as PageMetaEntity?,trackingMeta: freezed == trackingMeta ? _self.trackingMeta : trackingMeta // ignore: cast_nullable_to_non_nullable
as TrackingMetaEntity?,notificationNudge: freezed == notificationNudge ? _self.notificationNudge : notificationNudge // ignore: cast_nullable_to_non_nullable
as NotificationNudgeEntity?,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,floatingFilter: freezed == floatingFilter ? _self.floatingFilter : floatingFilter // ignore: cast_nullable_to_non_nullable
as FloatingFilterEntity?,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as PlpFilterEntity?,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<ListingProductEntity>,queryCorrection: freezed == queryCorrection ? _self.queryCorrection : queryCorrection // ignore: cast_nullable_to_non_nullable
as QueryCorrectionEntity?,messageBars: null == messageBars ? _self._messageBars : messageBars // ignore: cast_nullable_to_non_nullable
as List<MessageBarEntity>,orderRule: null == orderRule ? _self.orderRule : orderRule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ListingDataEntity
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
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingMetaEntityCopyWith<$Res>? get trackingMeta {
    if (_self.trackingMeta == null) {
    return null;
  }

  return $TrackingMetaEntityCopyWith<$Res>(_self.trackingMeta!, (value) {
    return _then(_self.copyWith(trackingMeta: value));
  });
}/// Create a copy of ListingDataEntity
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
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloatingFilterEntityCopyWith<$Res>? get floatingFilter {
    if (_self.floatingFilter == null) {
    return null;
  }

  return $FloatingFilterEntityCopyWith<$Res>(_self.floatingFilter!, (value) {
    return _then(_self.copyWith(floatingFilter: value));
  });
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlpFilterEntityCopyWith<$Res>? get filters {
    if (_self.filters == null) {
    return null;
  }

  return $PlpFilterEntityCopyWith<$Res>(_self.filters!, (value) {
    return _then(_self.copyWith(filters: value));
  });
}/// Create a copy of ListingDataEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueryCorrectionEntityCopyWith<$Res>? get queryCorrection {
    if (_self.queryCorrection == null) {
    return null;
  }

  return $QueryCorrectionEntityCopyWith<$Res>(_self.queryCorrection!, (value) {
    return _then(_self.copyWith(queryCorrection: value));
  });
}
}

// dart format on
