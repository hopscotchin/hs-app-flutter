import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../../../core/logger/my_logger.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/kid_form_config_entity.dart';
import '../../domain/entities/kids_list_content_entity.dart';
import '../../domain/repositories/kids_repository.dart';
import '../datasources/remote/kids_remote_datasource.dart';
import '../models/child_model.dart';

@LazySingleton(as: KidsRepository)
class KidsRepositoryImpl with SafeApiCall implements KidsRepository {
  KidsRepositoryImpl(this._api, this._networkInfo);

  final KidsRemoteDatasource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ChildrenListResult>> getChildren({CancelToken? cancelToken}) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getChildren(cancelToken: cancelToken);
      if (!response.isSuccessful) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return ChildrenListResult(
        children: response.children.map((m) => m.toEntity()).toList(),
        content: response.content,
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
      if (!response.isSuccessful || response.child == null) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return response.child!.toEntity();
    });
  }

  @override
  Future<Either<Failure, KidFormConfigEntity>> getFormConfig({CancelToken? cancelToken}) async {
    // Deliberately never returns Left — see KidsRepository.getFormConfig
    // doc. Network failure, 404 (endpoint not shipped yet), and decode
    // errors all fall back to local defaults instead of surfacing an error
    // for what's purely presentational screen copy.
    try {
      final response = await _api.getFormConfig(cancelToken: cancelToken);
      if (!response.isSuccessful) return Right(KidFormConfigEntity.fallback());
      return Right(response.toEntity());
    } catch (e, s) {
      logger.w('Kid form config fetch failed, using local fallback', error: e, stackTrace: s);
      return Right(KidFormConfigEntity.fallback());
    }
  }

  @override
  Future<Either<Failure, String>> deleteChild({required int childId, CancelToken? cancelToken}) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.deleteChild(kidId: childId, cancelToken: cancelToken);
      if (!response.isSuccessful) {
        throw ApiFailureException(message: response.message ?? 'Something went wrong');
      }
      return response.message ?? '';
    });
  }
}
