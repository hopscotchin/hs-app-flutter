import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/address_mutation_result_entity.dart';
import 'address_model.dart';

class AddressMutationResponseModel {
  const AddressMutationResponseModel({
    this.isSuccessful = false,
    this.allAddressItems = const [],
    this.rawAllAddressItems = const [],
    this.currentAddress,
    this.messageBar,
    this.messageBars = const [],
    this.popUpMessage = '',
  });

  final bool isSuccessful;
  final List<AddressModel> allAddressItems;
  final List<Map<String, dynamic>> rawAllAddressItems;
  final AddressModel? currentAddress;
  final MessageBarModel? messageBar;
  final List<MessageBarModel> messageBars;
  final String popUpMessage;

  factory AddressMutationResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['allAddressItems'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];
    final items = rawItems
        .map(AddressModel.fromJson)
        .toList(growable: false);
    final bars = (json['messageBars'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(MessageBarModel.fromJson)
            .toList(growable: false) ??
        const <MessageBarModel>[];
    final action = json['action'] as String?;
    return AddressMutationResponseModel(
      isSuccessful: action?.toLowerCase() == 'success',
      allAddressItems: items,
      rawAllAddressItems: rawItems,
      currentAddress: json['currentAddress'] is Map<String, dynamic>
          ? AddressModel.fromJson(
              json['currentAddress'] as Map<String, dynamic>,
            )
          : null,
      messageBar: json['messageBar'] is Map<String, dynamic>
          ? MessageBarModel.fromJson(
              json['messageBar'] as Map<String, dynamic>,
            )
          : null,
      messageBars: bars,
      popUpMessage: json['popUpMessage'] as String? ?? '',
    );
  }
}

extension AddressMutationResponseModelX on AddressMutationResponseModel {
  AddressMutationResultEntity toEntity() {
    final bars = <MessageBarEntity>[
      if (messageBar != null) messageBar!,
      ...messageBars,
    ];
    final items = allAddressItems
        .map((m) => m.toEntity())
        .toList(growable: false);
    AddressEntity? current = currentAddress?.toEntity();
    if (current == null && items.isNotEmpty) {
      current = items.first;
    }
    return AddressMutationResultEntity(
      isSuccessful: isSuccessful,
      items: items,
      rawItems: rawAllAddressItems,
      currentAddress: current,
      messageBars: bars,
      popUpMessage: popUpMessage,
    );
  }
}
