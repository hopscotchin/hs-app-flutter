import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/init_juspay_entity.dart';
import '../repositories/checkout_repository.dart';

@lazySingleton
class InitPaymentUseCase
    implements UseCase<InitJusPayEntity, InitPaymentParams> {
  final CheckoutRepository repository;

  InitPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, InitJusPayEntity>> call(InitPaymentParams params) {
    return repository.initPayment(
      params.recordId,
      params.creditsApplied,
      params.quickPayEnabled,
    );
  }
}

class InitPaymentParams extends Equatable {
  final int recordId;
  final bool creditsApplied;
  final bool quickPayEnabled;

  const InitPaymentParams({
    required this.recordId,
    required this.creditsApplied,
    required this.quickPayEnabled,
  });

  @override
  List<Object?> get props => [recordId, creditsApplied, quickPayEnabled];
}
