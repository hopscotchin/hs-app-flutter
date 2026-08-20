import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_bar_entity.dart';
import '../repositories/cart_repository.dart';

/// Reads the cart message bars cached from the app config at splash. Local
/// read, so it never fails on the network — a malformed cache surfaces as a
/// [CacheFailure] and the cart just renders without static bars.
@lazySingleton
class GetStaticMessageBarsUseCase
    implements UseCase<List<MessageBarEntity>, NoParams> {
  final CartRepository repository;

  GetStaticMessageBarsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageBarEntity>>> call(NoParams params) {
    return repository.getStaticMessageBars();
  }
}
