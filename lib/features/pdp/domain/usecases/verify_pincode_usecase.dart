import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pincode_check_entity.dart';
import '../repositories/product_detail_repository.dart';

@lazySingleton
class VerifyPincodeUseCase
    implements UseCase<PincodeCheckEntity, VerifyPincodeParams> {
  final ProductDetailRepository repository;

  VerifyPincodeUseCase(this.repository);

  @override
  Future<Either<Failure, PincodeCheckEntity>> call(VerifyPincodeParams params) {
    return repository.verifyPincode(params.productId, params.pincode);
  }
}

class VerifyPincodeParams extends Equatable {
  final int productId;
  final String pincode;

  const VerifyPincodeParams({required this.productId, required this.pincode});

  @override
  List<Object?> get props => [productId, pincode];
}
