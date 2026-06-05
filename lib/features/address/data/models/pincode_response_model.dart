import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import 'address_model.dart';

class PincodeResponseModel {
  const PincodeResponseModel({
    this.isSuccessful = false,
    this.city = '',
    this.state = '',
    this.canCod = false,
    this.canPol = false,
    this.isOpa = false,
    this.location,
    this.messageBar,
    this.messageBars = const [],
    this.popUpMessage = '',
  });

  final bool isSuccessful;
  final String city;
  final String state;
  final bool canCod;
  final bool canPol;
  final bool isOpa;
  final AddressLocationModel? location;
  final MessageBarModel? messageBar;
  final List<MessageBarModel> messageBars;
  final String popUpMessage;

  factory PincodeResponseModel.fromJson(Map<String, dynamic> json) {
    final bars = (json['messageBars'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(MessageBarModel.fromJson)
            .toList(growable: false) ??
        const <MessageBarModel>[];
    final bar = json['messageBar'];
    final action = json['action'] as String?;
    return PincodeResponseModel(
      isSuccessful: action?.toLowerCase() == 'success',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      canCod: json['canCod'] as bool? ?? false,
      canPol: json['canPol'] as bool? ?? false,
      isOpa: json['isOpa'] as bool? ?? false,
      location: json['location'] is Map<String, dynamic>
          ? AddressLocationModel.fromJson(
              json['location'] as Map<String, dynamic>,
            )
          : null,
      messageBar: bar is Map<String, dynamic>
          ? MessageBarModel.fromJson(bar)
          : null,
      messageBars: bars,
      popUpMessage: json['popUpMessage'] as String? ?? '',
    );
  }
}

extension PincodeResponseModelX on PincodeResponseModel {
  PincodeInfoEntity toEntity() {
    final bars = <MessageBarEntity>[
      if (messageBar != null) messageBar!,
      ...messageBars,
    ];
    return PincodeInfoEntity(
      isSuccessful: isSuccessful,
      city: city,
      state: state,
      canCod: canCod,
      canPol: canPol,
      isOpa: isOpa,
      location: location?.toEntity() ?? const AddressLocationEntity(),
      messageBars: bars,
      popUpMessage: popUpMessage,
    );
  }
}
