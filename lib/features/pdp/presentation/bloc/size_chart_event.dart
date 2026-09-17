part of 'size_chart_bloc.dart';

@freezed
sealed class SizeChartEvent with _$SizeChartEvent {
  /// Fetch the size chart for a product; replaces whatever was loaded before.
  const factory SizeChartEvent.load(int productId) = LoadSizeChart;
}
