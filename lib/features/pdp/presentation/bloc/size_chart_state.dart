part of 'size_chart_bloc.dart';

enum SizeChartStatus { initial, loading, success, error }

@freezed
abstract class SizeChartState with _$SizeChartState {
  const factory SizeChartState({
    @Default(SizeChartStatus.initial) SizeChartStatus status,
    SizeChartEntity? chart,
    String? errorMessage,
    // Product the loaded chart belongs to, so reopening the same product's
    // chart does not refetch.
    int? productId,
  }) = _SizeChartState;
}

extension SizeChartStateX on SizeChartState {
  bool get isLoading =>
      status == SizeChartStatus.loading || status == SizeChartStatus.initial;
}
