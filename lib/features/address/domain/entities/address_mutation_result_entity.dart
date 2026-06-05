import 'package:equatable/equatable.dart';

import '../../../../core/entities/message_bar_entity.dart';
import 'address_entity.dart';

class AddressMutationResultEntity extends Equatable {
  const AddressMutationResultEntity({
    required this.isSuccessful,
    required this.items,
    required this.currentAddress,
    required this.messageBars,
    required this.popUpMessage,
    this.rawItems = const [],
  });

  final bool isSuccessful;
  final List<AddressEntity> items;
  final List<Map<String, dynamic>> rawItems;
  final AddressEntity? currentAddress;
  final List<MessageBarEntity> messageBars;
  final String popUpMessage;

  @override
  List<Object?> get props => [
    isSuccessful,
    items,
    rawItems,
    currentAddress,
    messageBars,
    popUpMessage,
  ];
}
