import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/listing_data_entity.dart';
import '../entities/page_type.dart';
import '../repositories/plp_repository.dart';

@lazySingleton
class GetListingDataUseCase
    implements UseCase<ListingDataEntity, GetListingDataParams> {
  final PlpRepository repository;

  GetListingDataUseCase(this.repository);

  @override
  Future<Either<Failure, ListingDataEntity>> call(GetListingDataParams params) {
    return repository.getListingData(
      pageType: params.pageType,
      queryParams: params.queryParams,
      cancelToken: params.cancelToken,
    );
  }
}

class GetListingDataParams extends Equatable {
  final PageType pageType;
  final Map<String, dynamic> queryParams;
  final CancelToken? cancelToken;

  const GetListingDataParams({
    required this.pageType,
    required this.queryParams,
    this.cancelToken,
  });

  @override
  List<Object?> get props => [pageType, queryParams, cancelToken];
}
