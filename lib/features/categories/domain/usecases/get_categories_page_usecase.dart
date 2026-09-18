import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/categories_page_entity.dart';
import '../repositories/categories_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCategoriesPageUseCase
    implements UseCase<CategoriesPageEntity, NoParams> {
  final CategoriesRepository repository;

  GetCategoriesPageUseCase(this.repository);

  @override
  Future<Either<Failure, CategoriesPageEntity>> call(NoParams params) {
    return repository.getCategoriesPage();
  }
}
