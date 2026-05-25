import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_page_entity.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetHomePageUseCase implements UseCase<HomePageEntity, GetHomePageParams> {
  GetHomePageUseCase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, HomePageEntity>> call(GetHomePageParams params) =>
      repository.getHomePage(
        pageName: params.pageName,
        pageNo: params.pageNo,
        cancelToken: params.cancelToken,
      );
}

class GetHomePageParams extends Equatable {
  const GetHomePageParams({
    required this.pageName,
    this.pageNo = 1,
    this.cancelToken,
  });

  final String pageName;
  final int pageNo;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pageName, pageNo];
}
