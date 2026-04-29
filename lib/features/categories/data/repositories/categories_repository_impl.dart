import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/department_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/remote/categories_remote_datasource.dart';

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
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() {
    return safeApiCall(
      networkInfo,
      () async {
        final result = await remoteDataSource.getDepartments();
        return result.departments;
      },
    );
  }
}
