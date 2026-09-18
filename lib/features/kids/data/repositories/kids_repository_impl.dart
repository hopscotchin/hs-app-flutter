import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/kids_list_content_entity.dart';
import '../../domain/repositories/kids_repository.dart';
import '../datasources/remote/kids_remote_datasource.dart';
import '../models/child_model.dart';
import '../models/child_mutation_response_model.dart';
import '../models/children_response_model.dart';
import '../models/kids_list_content_model.dart';

@LazySingleton(as: KidsRepository)
class KidsRepositoryImpl with SafeApiCall implements KidsRepository {
  KidsRepositoryImpl(this._api, this._networkInfo);

  final KidsRemoteDatasource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ChildrenListResult>> getChildren({CancelToken? cancelToken}) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getChildren(cancelToken: cancelToken);
      if (!response.isSuccess) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return ChildrenListResult(
        children: response.children.map((m) => m.toEntity()).toList(),
        content: response.content?.toEntity() ?? KidsListContentEntity.fallback(),
      );
    });
  }

  @override
  Future<Either<Failure, ChildEntity>> saveChild({
    required ChildEntity child,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.saveChild(body: child.toRequestJson(), cancelToken: cancelToken);
      if (!response.isSuccess || response.child == null) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return response.child!.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> deleteChild({required int childId, CancelToken? cancelToken}) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.deleteChild(kidId: childId, cancelToken: cancelToken);
      if (!response.isSuccess) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return response.message ?? '';
    });
  }
}
