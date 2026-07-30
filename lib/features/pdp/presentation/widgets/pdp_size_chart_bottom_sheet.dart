import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/size_chart_entity.dart';
import '../bloc/pdp_bloc.dart';

// Continuous horizontal-scroll indicator state (no snapping — the thumb tracks
// the raw scroll fraction so the table scrolls smoothly).
typedef _LineState = ({double progress, double fraction});

// Design tokens
const _kColWidth = 90.0;
const _kHeaderHeight = 34.0;
const _kRowHeight = 33.0;
const _kRowAltBg = Color(0x1A836EF1); // rgba(131, 110, 241, 0.1)
const _kHeaderBorderColor = Color(0x33000000); // rgba(0,0,0,0.2)
const _kBrandPurple = Color(0xFF67218C);
const _kInToCm = 2.54;
const _kKgToLb = 2.20462;

void showPdpSizeChartBottomSheet(BuildContext context, {String? productName}) {
  final bloc = context.read<PdpBloc>()..add(const PdpEvent.loadSizeChart());
  final screenH = MediaQuery.of(context).size.height;

  // Slides in from the right edge (mirrors PLP's FilterPage.open) rather than
  // up from the bottom.
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Size Chart',
    barrierColor: Colors.black.withValues(alpha: 0.22),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SizedBox(
            height: screenH * 0.9,
            width: double.infinity,
            child: BlocProvider.value(
              value: bloc,
              child: _SizeChartSheet(productName: productName),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curved);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

class _SizeChartSheet extends StatelessWidget {
  const _SizeChartSheet({this.productName});

  final String? productName;

  @override
  Widget build(BuildContext context) {
    // Keep the last rows clear of the system nav/gesture inset.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: product name + X close
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  productName != null
                      ? 'Size Chart For $productName'
                      : 'Size Chart',
                  key: const ValueKey(PdpTestStrings.sizeChartSheetTitle),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                key: const ValueKey(PdpTestStrings.sizeChartSheetCloseButton),
                onTap: () => AppNavigator.goBack(context),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(Icons.close, size: 24, color: Colors.black),
                ),
              ),
            ],
          ),
        ),

        // Scrollable body
        Expanded(
          child: BlocBuilder<PdpBloc, PdpState>(
            builder: (context, state) {
              if (state.isLoadingSizeChart) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.sizeChartError != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.sizeChartError!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (state.sizeChart != null) {
                if (state.sizeChart!.charts.isEmpty) {
                  return const Center(child: Text('No size chart available.'));
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 24 + bottomInset),
                  itemCount: state.sizeChart!.charts.length,
                  itemBuilder: (_, i) => _SizeChartDtoView(
                    dto: state.sizeChart!.charts[i],
                    chartIndex: i,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Per-DTO view
// ---------------------------------------------------------------------------

class _SizeChartDtoView extends StatefulWidget {
  const _SizeChartDtoView({required this.dto, required this.chartIndex});

  final SizeChartDtoEntity dto;
  final int chartIndex;

  @override
  State<_SizeChartDtoView> createState() => _SizeChartDtoViewState();
}

class _SizeChartDtoViewState extends State<_SizeChartDtoView> {
  late String _selectedLengthUnit;
  late String _selectedWeightUnit;

  // Drives the smooth horizontal-scroll indicator under the table.
  final _tableController = ScrollController();
  final _lineState = ValueNotifier<_LineState>((progress: 0.0, fraction: 1.0));

  SizeChartDtoEntity get dto => widget.dto;

  bool get _hasLength =>
      dto.parameterMeasureTypes.contains('L') && dto.lengthUnit != null;

  bool get _hasWeight =>
      dto.parameterMeasureTypes.contains('W') && dto.weightUnit != null;

  @override
  void initState() {
    super.initState();
    _selectedLengthUnit = dto.lengthUnit ?? 'cm';
    _selectedWeightUnit = dto.weightUnit ?? 'kg';
    _tableController.addListener(_onTableScroll);
    // Compute the thumb fraction once after first layout so the indicator
    // reflects overflow before the user scrolls.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onTableScroll();
    });
  }

  @override
  void dispose() {
    _tableController
      ..removeListener(_onTableScroll)
      ..dispose();
    _lineState.dispose();
    super.dispose();
  }

  void _onTableScroll() {
    if (!_tableController.hasClients) return;
    final pos = _tableController.position;
    final max = pos.maxScrollExtent;
    if (max <= 0) {
      _lineState.value = (progress: 0.0, fraction: 1.0);
      return;
    }
    final progress = (pos.pixels / max).clamp(0.0, 1.0);
    final total = pos.viewportDimension + max;
    final fraction = total > 0
        ? (pos.viewportDimension / total).clamp(0.15, 1.0)
        : 1.0;
    _lineState.value = (progress: progress, fraction: fraction);
  }

  String _convertValue(String raw, int colIndex) {
    if (raw == 'NA' || raw.isEmpty) return raw;
    final measureType = colIndex < dto.parameterMeasureTypes.length
        ? dto.parameterMeasureTypes[colIndex]
        : '';
    final value = double.tryParse(raw);
    if (value == null) return raw;

    if (measureType == 'L' && dto.lengthUnit != null) {
      final inCm = dto.lengthUnit == 'cm' ? value : value * _kInToCm;
      final result = _selectedLengthUnit == 'cm' ? inCm : inCm / _kInToCm;
      return result.toStringAsFixed(1);
    }
    if (measureType == 'W' && dto.weightUnit != null) {
      final inKg = dto.weightUnit == 'kg' ? value : value / _kKgToLb;
      final result = _selectedWeightUnit == 'kg' ? inKg : inKg * _kKgToLb;
      return result.toStringAsFixed(1);
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Illustration image
        if (dto.illustrationImageUrl != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: CachedNetworkImage(
              imageUrl: dto.illustrationImageUrl!,
              width: double.infinity,
              fit: BoxFit.contain,
              placeholder: (_, url) => const SizedBox(
                height: 160,
                child: ColoredBox(color: Color(0xFFF6F6F6)),
              ),
              errorWidget: (_, url, error) => const SizedBox.shrink(),
            ),
          ),
        ],

        // Unit toggles
        if (_hasLength || _hasWeight) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasLength)
                  _UnitToggleRow(
                    chartIndex: widget.chartIndex,
                    label: 'Length:',
                    options: const ['cm', 'in'],
                    selected: _selectedLengthUnit,
                    onChanged: (u) => setState(() => _selectedLengthUnit = u),
                  ),
                if (_hasLength && _hasWeight) const SizedBox(height: 8),
                if (_hasWeight)
                  _UnitToggleRow(
                    chartIndex: widget.chartIndex,
                    label: 'Weight:',
                    options: const ['kg', 'lb'],
                    selected: _selectedWeightUnit,
                    onChanged: (u) => setState(() => _selectedWeightUnit = u),
                  ),
              ],
            ),
          ),
        ],

        // Table — stretches to fill the width when columns fit, otherwise
        // falls back to a fixed column width and scrolls horizontally.
        if (dto.parameterNames.isNotEmpty) ...[
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final colWidth =
                  (constraints.maxWidth / dto.parameterNames.length).clamp(
                    _kColWidth,
                    double.infinity,
                  );
              return SingleChildScrollView(
                controller: _tableController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: _SizeTable(
                    chartIndex: widget.chartIndex,
                    headers: dto.parameterNames,
                    rows: dto.rows,
                    convertValue: _convertValue,
                    colWidth: colWidth,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Smooth horizontal scroll indicator — collapses when the table fits.
          _TableScrollIndicator(
            key: ValueKey(
              '${PdpTestStrings.sizeChartTableIndicator}_${widget.chartIndex}',
            ),
            state: _lineState,
          ),
        ],

        // Notes
        if (dto.notesList.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Size notes and fitting tips:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...dto.notesList.map(
                  (note) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Expanded(
                          child: Text(
                            note,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Smooth horizontal-scroll indicator for the table (continuous, no snapping)
// ---------------------------------------------------------------------------

class _TableScrollIndicator extends StatelessWidget {
  const _TableScrollIndicator({required this.state, super.key});

  final ValueListenable<_LineState> state;

  static const _kIndicatorColor = AppColors.neutralGrey6;
  static const double _activeHeight = 3.0;
  static const double _trackHeight = 1.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_LineState>(
      valueListenable: state,
      builder: (context, s, _) {
        // Fraction 1.0 means the table fits — no scrolling, so hide the bar.
        if (s.fraction >= 1.0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final thumbWidth = (trackWidth * s.fraction).clamp(
                24.0,
                trackWidth,
              );
              final left =
                  s.progress.clamp(0.0, 1.0) * (trackWidth - thumbWidth);
              return SizedBox(
                height: _activeHeight,
                width: trackWidth,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: _trackHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _kIndicatorColor.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_trackHeight / 2),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: left,
                      top: 0,
                      width: thumbWidth,
                      height: _activeHeight,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: _kIndicatorColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(_activeHeight / 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Unit toggle row: "Length:" label + separate cm / in buttons
// ---------------------------------------------------------------------------

class _UnitToggleRow extends StatelessWidget {
  const _UnitToggleRow({
    required this.chartIndex,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final int chartIndex;
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        for (int i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          _UnitButton(
            key: ValueKey(
              '${PdpTestStrings.sizeChartUnitButton}_${chartIndex}_${options[i]}',
            ),
            label: options[i],
            isSelected: options[i] == selected,
            onTap: () => onChanged(options[i]),
          ),
        ],
      ],
    );
  }
}

class _UnitButton extends StatelessWidget {
  const _UnitButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _kBrandPurple : Colors.white,
          border: Border.all(color: _kBrandPurple),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _kBrandPurple,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Table: header row with bottom-border only, alternating data rows
// ---------------------------------------------------------------------------

class _SizeTable extends StatelessWidget {
  const _SizeTable({
    required this.chartIndex,
    required this.headers,
    required this.rows,
    required this.convertValue,
    this.colWidth = _kColWidth,
  });

  final int chartIndex;
  final List<String> headers;
  final List<SizeChartRowEntity> rows;
  final String Function(String value, int colIndex) convertValue;
  final double colWidth;

  @override
  Widget build(BuildContext context) {
    final colCount = headers.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row — border-bottom only
        Row(
          children: List.generate(
            colCount,
            (i) => _HeaderCell(
              key: ValueKey(
                '${PdpTestStrings.sizeChartHeader}_${chartIndex}_$i',
              ),
              text: headers[i],
              width: colWidth,
            ),
          ),
        ),
        // Data rows — alternating background
        ...List.generate(rows.length, (rowIdx) {
          final row = rows[rowIdx];
          return ColoredBox(
            color: rowIdx.isOdd ? _kRowAltBg : Colors.white,
            child: Row(
              children: List.generate(colCount, (colIdx) {
                final raw = colIdx < row.values.length
                    ? row.values[colIdx]
                    : '';
                return _DataCell(
                  key: ValueKey(
                    '${PdpTestStrings.sizeChartCell}_${chartIndex}_${rowIdx}_$colIdx',
                  ),
                  text: convertValue(raw, colIdx),
                  width: colWidth,
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, this.width = _kColWidth, super.key});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _kHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kHeaderBorderColor)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.text, this.width = _kColWidth, super.key});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: _kRowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
