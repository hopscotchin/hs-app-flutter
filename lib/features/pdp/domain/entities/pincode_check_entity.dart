import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/network/models/action_response.dart';
import 'edd_info_entity.dart';
import 'service_guarantee_entity.dart';
import 'sku_entity.dart';

class PincodeCheckEntity extends ActionResponse {
  final List<SkuEntity> skus;
  final bool? isServiceable;
  final EddInfoEntity? eddInfo;
  final List<VisualCueEntity> visualCues;
  final List<ServiceGuaranteeEntity> serviceGuarantee;
  final String? noPinCodeMessage;

  const PincodeCheckEntity({
    super.action,
    super.message,
    this.skus = const [],
    this.isServiceable,
    this.eddInfo,
    this.visualCues = const [],
    this.serviceGuarantee = const [],
    this.noPinCodeMessage,
  });

  PincodeCheckEntity.fromJson(
    super.json, {
    this.skus = const [],
    this.isServiceable,
    this.eddInfo,
    this.visualCues = const [],
    this.serviceGuarantee = const [],
    this.noPinCodeMessage,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    skus,
    isServiceable,
    eddInfo,
    visualCues,
    serviceGuarantee,
    noPinCodeMessage,
  ];
}
