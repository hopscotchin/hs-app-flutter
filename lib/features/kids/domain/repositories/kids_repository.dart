import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/child_entity.dart';
import '../entities/kids_list_content_entity.dart';

abstract class KidsRepository {
  /// Returns the children list together with the list screen's
  /// backend-driven copy/footer images — both arrive in the same
  /// `GET v2/questionnaire/list` response (see ChildrenResponseModel).
  Future<Either<Failure, ChildrenListResult>> getChildren({
    CancelToken? cancelToken,
  });

  /// Creates a new child when [child.isNew], otherwise updates the existing
  /// one.
  Future<Either<Failure, ChildEntity>> saveChild({
    required ChildEntity child,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> deleteChild({
    required int childId,
    CancelToken? cancelToken,
  });
}
