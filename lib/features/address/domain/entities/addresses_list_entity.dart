import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_entity.dart';

part 'addresses_list_entity.freezed.dart';

@freezed
abstract class AddressesListEntity with _$AddressesListEntity {
  const AddressesListEntity._();

  const factory AddressesListEntity({
    @Default(<AddressEntity>[]) List<AddressEntity> items,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> rawItems,
  }) = _AddressesListEntity;

  AddressEntity? get primary =>
      items.where((a) => a.isDefault).cast<AddressEntity?>().firstOrNull;
}
