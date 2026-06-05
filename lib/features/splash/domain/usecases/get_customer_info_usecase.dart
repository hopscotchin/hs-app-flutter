import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer_info_entity.dart';
import '../repositories/splash_repository.dart';

@lazySingleton
class GetCustomerInfoUseCase implements UseCase<CustomerInfoEntity, NoParams> {
  GetCustomerInfoUseCase(this._repository);

  final SplashRepository _repository;

  @override
  Future<Either<Failure, CustomerInfoEntity>> call(NoParams params) =>
      _repository.getCustomerInfo();
}
