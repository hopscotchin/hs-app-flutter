import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/categories_page_entity.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, CategoriesPageEntity>> getCategoriesPage();
}
