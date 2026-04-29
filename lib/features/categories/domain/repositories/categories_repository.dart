import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/department_entity.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();
}
