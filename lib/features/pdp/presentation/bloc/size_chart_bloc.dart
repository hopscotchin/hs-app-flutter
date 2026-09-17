import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/size_chart_entity.dart';
import '../../domain/usecases/get_size_chart_usecase.dart';

part 'size_chart_bloc.freezed.dart';
part 'size_chart_event.dart';
part 'size_chart_state.dart';

/// Standalone size-chart loader for screens that have no [PdpBloc] — the PDP
/// keeps the chart on its own bloc, while the wishlist (and any future listing
/// that opens the chart) provides this one and reuses the same use case and
/// sheet UI.
@injectable
class SizeChartBloc extends BaseBloc<SizeChartEvent, SizeChartState> {
  final GetSizeChartUseCase _getSizeChart;

  SizeChartBloc(this._getSizeChart) : super(const SizeChartState()) {
    on<LoadSizeChart>(_onLoad);
  }

  Future<void> _onLoad(
    LoadSizeChart event,
    Emitter<SizeChartState> emit,
  ) async {
    // Already have this product's chart — reopening the sheet must not refetch.
    if (state.status == SizeChartStatus.success &&
        state.productId == event.productId) {
      return;
    }

    emit(
      SizeChartState(
        status: SizeChartStatus.loading,
        productId: event.productId,
      ),
    );
    final token = swapCancelToken();

    final result = await _getSizeChart(
      GetSizeChartParams(productId: event.productId, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          SizeChartState(
            status: SizeChartStatus.error,
            errorMessage: failure.message,
            productId: event.productId,
          ),
        );
      },
      (chart) => emit(
        SizeChartState(
          status: SizeChartStatus.success,
          chart: chart,
          productId: event.productId,
        ),
      ),
    );
  }
}
