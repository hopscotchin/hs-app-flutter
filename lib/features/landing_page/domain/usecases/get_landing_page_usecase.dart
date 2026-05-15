import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../repositories/landing_page_repository.dart';

@lazySingleton
class GetLandingPageUseCase
    implements UseCase<HomePageEntity, GetLandingPageParams> {
  GetLandingPageUseCase(this.repository);

  final LandingPageRepository repository;

  @override
  Future<Either<Failure, HomePageEntity>> call(GetLandingPageParams params) =>
      repository.getLandingPage(
        pageName: params.pageName,
        cancelToken: params.cancelToken,
      );
}

class GetLandingPageParams extends Equatable {
  const GetLandingPageParams({required this.pageName, this.cancelToken});

  final String pageName;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pageName];
}
