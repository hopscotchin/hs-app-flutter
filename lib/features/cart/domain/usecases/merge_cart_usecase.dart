import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MergeCartUseCase implements UseCase<CartEntity, MergeCartParams> {
  final CartRepository repository;

  MergeCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(MergeCartParams params) {
    return repository.mergeCart(cancelToken: params.cancelToken);
  }
}

class MergeCartParams extends Equatable {
  final CancelToken? cancelToken;

  const MergeCartParams({this.cancelToken});

  @override
  List<Object?> get props => [];
  // cancelToken intentionally excluded — not a semantic field
}
