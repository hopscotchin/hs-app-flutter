import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/child_entity.dart';
import '../repositories/kids_repository.dart';

@lazySingleton
class SaveChildUseCase implements UseCase<ChildEntity, SaveChildParams> {
  SaveChildUseCase(this._repository);

  final KidsRepository _repository;

  @override
  Future<Either<Failure, ChildEntity>> call(SaveChildParams params) =>
      _repository.saveChild(
        child: params.child,
        photoFile: params.photoFile,
        cancelToken: params.cancelToken,
      );
}

class SaveChildParams extends Equatable {
  const SaveChildParams({required this.child, this.photoFile, this.cancelToken});

  final ChildEntity child;
  final File? photoFile;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [child, photoFile?.path];
}
