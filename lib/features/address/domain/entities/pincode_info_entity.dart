import 'package:equatable/equatable.dart';

import '../../../../core/entities/message_bar_entity.dart';
import 'address_entity.dart';

class PincodeInfoEntity extends Equatable {
  const PincodeInfoEntity({
    required this.isSuccessful,
    required this.city,
    required this.state,
    required this.canCod,
    required this.canPol,
    required this.isOpa,
    required this.location,
    required this.messageBars,
    required this.popUpMessage,
  });

  final bool isSuccessful;
  final String city;
  final String state;
  final bool canCod;
  final bool canPol;
  final bool isOpa;
  final AddressLocationEntity location;
  final List<MessageBarEntity> messageBars;
  final String popUpMessage;

  String? get firstErrorMessage {
    for (final bar in messageBars) {
      final t = bar.displayText;
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    isSuccessful,
    city,
    state,
    canCod,
    canPol,
    isOpa,
    location,
    messageBars,
    popUpMessage,
  ];
}
