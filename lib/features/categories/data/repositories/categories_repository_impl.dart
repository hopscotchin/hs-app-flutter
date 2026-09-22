import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/categories_page_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/remote/categories_remote_datasource.dart';
import '../models/categories_page_response_model.dart';

@LazySingleton(as: CategoriesRepository)
class CategoriesRepositoryImpl
    with SafeApiCall
    implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CategoriesPageEntity>> getCategoriesPage() {
    return safeApiCall(networkInfo, () async {
      final result = await remoteDataSource.getCategoriesPage();
      return result.toEntity();
    });
  }
}
