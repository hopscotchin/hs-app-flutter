import '../../domain/entities/addresses_list_entity.dart';
import 'address_model.dart';

class AddressesResponseModel {
  const AddressesResponseModel({
    this.allAddressItems = const [],
    this.rawAllAddressItems = const [],
  });

  final List<AddressModel> allAddressItems;
  final List<Map<String, dynamic>> rawAllAddressItems;

  factory AddressesResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['allAddressItems'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];
    return AddressesResponseModel(
      allAddressItems:
          raw.map(AddressModel.fromJson).toList(growable: false),
      rawAllAddressItems: raw,
    );
  }
}

extension AddressesResponseModelX on AddressesResponseModel {
  AddressesListEntity toEntity() => AddressesListEntity(
    items: allAddressItems.map((m) => m.toEntity()).toList(growable: false),
    rawItems: rawAllAddressItems,
  );
}
