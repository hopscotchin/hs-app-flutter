import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/usecases/usecase.dart';

@lazySingleton
class HandleDeeplinkUseCase implements UseCase<NavDestination, DeeplinkParams> {
  @override
  Future<Either<Failure, NavDestination>> call(DeeplinkParams params) async {
    final destination = ActionUrlHandler.parse(params.deeplink);
    if (destination != null) {
      return Right(destination);
    }
    return const Right(HomeDestination());
  }
}

class DeeplinkParams {
  final String deeplink;

  DeeplinkParams({required this.deeplink});
}
