import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/listing/orders_listing_entity.dart';
import '../../entities/orders_tab.dart';
import '../../repositories/orders_listing_repository.dart';

/// Fetches one page of either listing. Pure delegation — no business logic.
@lazySingleton
class GetOrdersListingUseCase
    implements UseCase<OrdersListingEntity, GetOrdersListingParams> {
  GetOrdersListingUseCase(this._repository);

  final OrdersListingRepository _repository;

  @override
  Future<Either<Failure, OrdersListingEntity>> call(
    GetOrdersListingParams params,
  ) => _repository.getListing(
    tab: params.tab,
    page: params.page,
    pageSize: params.pageSize,
    cancelToken: params.cancelToken,
  );
}

class GetOrdersListingParams extends Equatable {
  const GetOrdersListingParams({
    required this.tab,
    required this.page,
    this.pageSize = 20,
    this.cancelToken,
  });

  final OrdersTab tab;
  final int page;
  final int pageSize;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [tab, page, pageSize];
  // cancelToken is deliberately excluded — it is infrastructure, not a
  // semantic field, and two tokens are never equal.
}
