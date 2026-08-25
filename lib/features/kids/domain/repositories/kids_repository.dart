import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/child_entity.dart';
import '../entities/kid_form_config_entity.dart';
import '../entities/kids_list_content_entity.dart';

abstract class KidsRepository {
  /// Returns the children list together with the list screen's
  /// backend-driven copy/footer images — both arrive in the same
  /// `GET v2/questionnaire/list` response (see ChildrenResponseModel).
  Future<Either<Failure, ChildrenListResult>> getChildren({
    CancelToken? cancelToken,
  });

  /// Add/Edit-screen copy + avatar catalog. Unlike every other method here,
  /// this NEVER returns `Left` — a network failure, a 404 (the endpoint
  /// doesn't exist yet), or a decode error all resolve to
  /// `Right(KidFormConfigEntity.fallback())` instead of propagating, so the
  /// screen always has something to render. See KidsRepositoryImpl for
  /// where that fallback actually happens.
  Future<Either<Failure, KidFormConfigEntity>> getFormConfig({CancelToken? cancelToken});

  /// Creates a new child when [child.isNew], otherwise updates the existing
  /// one. [photoFile] is optional — when present it's sent as part of the
  /// same multipart request (see PROFILE_KIDS_MIGRATION.md §7 note on the
  /// live app's two-step upload-then-save flow; simplified here to one call
  /// since Flutter has no existing generic S3-upload endpoint to reuse — flag
  /// this with backend before relying on it in production).
  Future<Either<Failure, ChildEntity>> saveChild({
    required ChildEntity child,
    File? photoFile,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> deleteChild({
    required int childId,
    CancelToken? cancelToken,
  });
}
