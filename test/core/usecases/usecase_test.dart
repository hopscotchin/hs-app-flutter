import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/core/usecases/usecase.dart';

class _TestUseCase implements UseCase<String, _TestParams> {
  final Either<Failure, String> result;

  _TestUseCase(this.result);

  @override
  Future<Either<Failure, String>> call(_TestParams params) async {
    return result;
  }
}

class _TestParams {
  final String value;
  _TestParams(this.value);
}

void main() {
  group('UseCase', () {
    test('should return Right when successful', () async {
      final useCase = _TestUseCase(const Right('success'));
      final result = await useCase(_TestParams('test'));
      expect(result, const Right('success'));
    });

    test('should return Left with failure when unsuccessful', () async {
      const failure = ServerFailure(message: 'error', statusCode: 500);
      final useCase = _TestUseCase(const Left(failure));
      final result = await useCase(_TestParams('test'));
      expect(result, const Left(failure));
    });
  });

  group('NoParams', () {
    test('should support equality', () {
      expect(NoParams(), NoParams());
    });

    test('should have empty props', () {
      expect(NoParams().props, isEmpty);
    });
  });
}
