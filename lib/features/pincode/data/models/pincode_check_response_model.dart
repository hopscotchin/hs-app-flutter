import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../domain/entities/pincode_check_result_entity.dart';

class PincodeCheckResponseModel {
  const PincodeCheckResponseModel({
    this.isSuccessful = false,
    this.popUpMessage = '',
    this.messageBar,
    this.messageBars = const [],
  });

  final bool isSuccessful;
  final String popUpMessage;
  final MessageBarModel? messageBar;
  final List<MessageBarModel> messageBars;

  factory PincodeCheckResponseModel.fromJson(Map<String, dynamic> json) {
    final action = json['action'] as String?;
    final bar = json['messageBar'];
    final bars = (json['messageBars'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(MessageBarModel.fromJson)
            .toList(growable: false) ??
        const <MessageBarModel>[];
    return PincodeCheckResponseModel(
      isSuccessful: action?.toLowerCase() == 'success',
      popUpMessage: json['popUpMessage'] as String? ?? '',
      messageBar: bar is Map<String, dynamic>
          ? MessageBarModel.fromJson(bar)
          : null,
      messageBars: bars,
    );
  }
}

extension PincodeCheckResponseModelX on PincodeCheckResponseModel {
  PincodeCheckResultEntity toEntity() {
    final bars = <MessageBarEntity>[
      if (messageBar != null) messageBar!,
      ...messageBars,
    ];
    return PincodeCheckResultEntity(
      isSuccessful: isSuccessful,
      popUpMessage: popUpMessage,
      messageBars: bars,
    );
  }
}