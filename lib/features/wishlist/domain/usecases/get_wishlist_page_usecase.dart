import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_page_entity.dart';
import '../repositories/wishlist_repository.dart';

@lazySingleton
class GetWishlistPageUseCase
    implements UseCase<WishlistPageEntity, GetWishlistPageParams> {
  GetWishlistPageUseCase(this._repository);
  final WishlistRepository _repository;

  @override
  Future<Either<Failure, WishlistPageEntity>> call(
    GetWishlistPageParams params,
  ) => _repository.getWishlist(
    pageNo: params.pageNo,
    pageSize: params.pageSize,
    cancelToken: params.cancelToken,
  );
}

class GetWishlistPageParams extends Equatable {
  const GetWishlistPageParams({
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
