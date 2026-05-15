import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/account_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, AccountEntity>> getAccount({CancelToken? cancelToken});
  Future<Either<Failure, void>> forgetGuestUser({CancelToken? cancelToken});
}
