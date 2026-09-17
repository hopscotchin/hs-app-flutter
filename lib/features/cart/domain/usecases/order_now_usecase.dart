import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../checkout/domain/entities/buy_now_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderNowUseCase implements UseCase<BuyNowEntity, OrderNowParams> {
  final CartRepository repository;

  OrderNowUseCase(this.repository);

  @override
  Future<Either<Failure, BuyNowEntity>> call(OrderNowParams params) {
    return repository.orderNow(cancelToken: params.cancelToken);
  }
}

class OrderNowParams extends Equatable {
  final CancelToken? cancelToken;

  const OrderNowParams({this.cancelToken});

  @override
  List<Object?> get props => [];
  // cancelToken intentionally excluded — not a semantic field
}
