import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/department_entity.dart';
import '../repositories/categories_repository.dart';

class GetDepartmentsUseCase
    implements UseCase<List<DepartmentEntity>, NoParams> {
  final CategoriesRepository repository;

  GetDepartmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DepartmentEntity>>> call(NoParams params) {
    return repository.getDepartments();
  }
}
