import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_page_entity.dart';
import '../repositories/home_repository.dart';

class GetHomePageUseCase implements UseCase<HomePageEntity, NoParams> {
  final HomeRepository repository;

  GetHomePageUseCase(this.repository);

  @override
  Future<Either<Failure, HomePageEntity>> call(NoParams params) {
    return repository.getHomePage();
  }

  Future<Either<Failure, HomePageEntity>> execute({
    CancelToken? cancelToken,
  }) {
    return repository.getHomePage(cancelToken: cancelToken);
  }
}
