import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/orders_page_entity.dart';
import '../repositories/orders_repository.dart';

@lazySingleton
class GetOrdersPageUseCase
    implements UseCase<OrdersPageEntity, GetOrdersPageParams> {
  GetOrdersPageUseCase(this._repository);
  final OrdersRepository _repository;

  @override
  Future<Either<Failure, OrdersPageEntity>> call(GetOrdersPageParams params) =>
      _repository.getOrders(
        pageNo: params.pageNo,
        pageSize: params.pageSize,
        cancelToken: params.cancelToken,
      );
}

class GetOrdersPageParams extends Equatable {
  const GetOrdersPageParams({
    required this.pageNo,
    this.pageSize = 20,
    this.cancelToken,
  });

  final int pageNo;
  final int pageSize;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pageNo, pageSize];
  // cancelToken intentionally excluded — it is not a semantic field
}
