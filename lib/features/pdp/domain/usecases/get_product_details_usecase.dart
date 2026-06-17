import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_detail_entity.dart';
import '../repositories/product_detail_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProductDetailsUseCase
    implements UseCase<ProductDetailEntity, GetProductDetailsParams> {
  final ProductDetailRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductDetailEntity>> call(
    GetProductDetailsParams params,
  ) {
    return repository.getProductDetails(params.productId);
  }
}

class GetProductDetailsParams extends Equatable {
  final int productId;

  const GetProductDetailsParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
