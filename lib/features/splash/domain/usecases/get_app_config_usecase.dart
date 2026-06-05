import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/splash_repository.dart';

@lazySingleton
class GetAppConfigUseCase implements UseCase<Unit, NoParams> {
  GetAppConfigUseCase(this._repository);

  final SplashRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.getAppConfig();
}
