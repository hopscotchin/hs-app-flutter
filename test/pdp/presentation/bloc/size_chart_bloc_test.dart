import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/size_chart_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/usecases/get_size_chart_usecase.dart';
import 'package:hs_app_flutter/features/pdp/presentation/bloc/size_chart_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSizeChartUseCase extends Mock implements GetSizeChartUseCase {}

const _kChart = SizeChartEntity(
  charts: [
    SizeChartDtoEntity(
      parameterNames: ['Size', 'Chest'],
      parameterMeasureTypes: ['', 'L'],
      lengthUnit: 'cm',
      rows: [
        SizeChartRowEntity(values: ['2-3 years', '54']),
      ],
    ),
  ],
);

void main() {
  late MockGetSizeChartUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const GetSizeChartParams(productId: 0));
  });

  setUp(() {
    useCase = MockGetSizeChartUseCase();
  });

  group('SizeChartBloc', () {
    blocTest<SizeChartBloc, SizeChartState>(
      'emits loading then success',
      build: () => SizeChartBloc(useCase),
      setUp: () => when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Right(_kChart)),
      act: (bloc) => bloc.add(const SizeChartEvent.load(944042)),
      expect: () => const [
        SizeChartState(status: SizeChartStatus.loading, productId: 944042),
        SizeChartState(
          status: SizeChartStatus.success,
          chart: _kChart,
          productId: 944042,
        ),
      ],
    );

    blocTest<SizeChartBloc, SizeChartState>(
      'emits loading then error with the failure message',
      build: () => SizeChartBloc(useCase),
      setUp: () => when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'boom'))),
      act: (bloc) => bloc.add(const SizeChartEvent.load(944042)),
      expect: () => const [
        SizeChartState(status: SizeChartStatus.loading, productId: 944042),
        SizeChartState(
          status: SizeChartStatus.error,
          errorMessage: 'boom',
          productId: 944042,
        ),
      ],
    );

    blocTest<SizeChartBloc, SizeChartState>(
      'ignores RequestCancelledFailure',
      build: () => SizeChartBloc(useCase),
      setUp: () => when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Left(RequestCancelledFailure())),
      act: (bloc) => bloc.add(const SizeChartEvent.load(944042)),
      expect: () => const [
        SizeChartState(status: SizeChartStatus.loading, productId: 944042),
      ],
    );

    blocTest<SizeChartBloc, SizeChartState>(
      'does not refetch when the same product is reopened',
      build: () => SizeChartBloc(useCase),
      setUp: () => when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Right(_kChart)),
      act: (bloc) async {
        bloc.add(const SizeChartEvent.load(944042));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SizeChartEvent.load(944042));
      },
      verify: (_) => verify(() => useCase(any())).called(1),
    );

    blocTest<SizeChartBloc, SizeChartState>(
      'refetches for a different product',
      build: () => SizeChartBloc(useCase),
      setUp: () => when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Right(_kChart)),
      act: (bloc) async {
        bloc.add(const SizeChartEvent.load(944042));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SizeChartEvent.load(943717));
      },
      verify: (_) => verify(() => useCase(any())).called(2),
    );
  });
}
