import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/outlined_text_field.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/components/form/app_checkbox.dart';
import 'package:hs_app_flutter/components/form/app_radio.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/utils/snackbar_utils.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/filter_thumbpainter.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/filter_visualcue_tag.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../bloc/filter_bloc.dart';
import 'filter_tree_content.dart';

class FilterPage extends StatelessWidget {
  final PlpFilterEntity? plpFilter;
  final Map<String, String> appliedFilters;
  final Map<String, dynamic> baseQueryParams;

  const FilterPage({
    super.key,
    this.plpFilter,
    this.appliedFilters = const {},
    this.baseQueryParams = const {},
  });

  static Future<Map<String, String>?> open(
    BuildContext context, {
    PlpFilterEntity? plpFilter,
    Map<String, String> appliedFilters = const {},
    Map<String, dynamic> baseQueryParams = const {},
  }) {
    final screenH = MediaQuery.of(context).size.height;

    return showGeneralDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: PlpStrings.filters,
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
              child: BlocProvider(
                create: (_) => sl<FilterBloc>()
                  ..add(
                    InitializeFilter(
                      plpFilter: plpFilter ?? const PlpFilterEntity(),
                      appliedFilters: appliedFilters,
                      baseQueryParams: baseQueryParams,
                    ),
                  ),
                child: FilterPage(
                  plpFilter: plpFilter,
                  appliedFilters: appliedFilters,
                  baseQueryParams: baseQueryParams,
                ),
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
        final slide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved);
        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _FilterPageView();
  }
}

class _FilterPageView extends StatefulWidget {
  const _FilterPageView();

  @override
  State<_FilterPageView> createState() => _FilterPageViewState();
}

class _FilterPageViewState extends State<_FilterPageView> {
  String _searchQuery = '';

  final ScrollController _sidebarController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  FocusNode pincodeFocusNode = FocusNode();

  String? _lastPincodeHit;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyDeliveryPincode(context.read<FilterBloc>().state);
    });
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilterBloc, FilterState>(
          listenWhen: (prev, curr) => prev.selectedSectionIndex != curr.selectedSectionIndex,
          listener: (context, state) {
            _resetSearchInput();
            // _applyDeliveryPincode(state);
          },
        ),
        // Surface a filter-refresh failure without blanking the sheet — the
        // current sections stay visible (see FilterBloc) and we just toast.
        BlocListener<FilterBloc, FilterState>(
          listenWhen: (prev, curr) =>
              prev.status != FilterStatus.error && curr.status == FilterStatus.error,
          listener: (context, state) {
            final msg = state.errorMessage;
            if (msg == null || msg.isEmpty) return;
            context.showSnack(msg, status: SnackStatus.error);
          },
        ),
      ],
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildHeader(context, state),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionSidebar(context, state),
                          const SizedBox(width: 20),
                          _buildFilterContent(context, state),
                        ],
                      ),
                    ),

                    _buildApplyButton(context, state),
                  ],
                ),
                if (state.isRefreshing) _buildRefreshingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REFRESHING OVERLAY
  // ---------------------------------------------------------------------------
  Widget _buildRefreshingOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.white.withValues(alpha: 0.5),
        child: const Center(
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER — title + close + clear all
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, FilterState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xxs,
        AppSpacing.xxs,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(PlpStrings.filters, style: AppTypographyV1.titleMedium.bold.textPrimary()),
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LEFT SIDEBAR — filter section names (35% width)
  // ---------------------------------------------------------------------------
  Widget _buildSectionSidebar(BuildContext context, FilterState state) {
    final sections = state.sections;

    final selectedIndex = state.safeSectionIndex;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.345,

      child: ColoredBox(
        color: Colors.white,
        child: CustomPaint(
          foregroundPainter: ScrollThumbPainter(
            controller: _sidebarController,
            thumbHeight: 80,
            thickness: 2,
            color: AppColors.brandPrimary,
            trackColor: Colors.transparent,
            rightInset: 0,
          ),
          child: ListView.builder(
            controller: _sidebarController,
            clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final isSelected = index == selectedIndex;
              // final hasActive = state.isSectionActive(section);

              const r = Radius.circular(8);
              final roundTopRight = !isSelected && (index - 1) == selectedIndex;
              final roundBottomRight = !isSelected && (index + 1) == selectedIndex;
              final cardRadius = BorderRadius.only(
                topRight: roundTopRight ? r : Radius.zero,
                bottomRight: roundBottomRight ? r : Radius.zero,
              );

              return GestureDetector(
                onTap: () => context.read<FilterBloc>().add(SwitchSection(sectionIndex: index)),
                child: Stack(
                  clipBehavior: Clip.none,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.transparent : AppColors.neutralGrey1,
                        borderRadius: cardRadius,
                      ),
                      child: CustomPaint(
                        painter: isSelected
                            ? const SelectedAccentPainter(
                                color: AppColors.brandPrimary,
                                width: 3,
                                verticalInset: 0,
                                cornerRadius: 0,
                              )
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.md,
                            right: AppSpacing.xs,
                            top: AppSpacing.lmd,
                            bottom: AppSpacing.lmd,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  section.label ?? '',
                                  style: isSelected
                                      ? AppTypographyV1.bodyLarge.bold.brandPrimary()
                                      : AppTypographyV1.bodyMedium.medium.textPrimary(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if ((section.appliedCount ?? 0) > 0)
                                Text(
                                  section.appliedCount.toString(),
                                  style: isSelected
                                      ? AppTypographyV1.labelLarge.medium.brandPrimary()
                                      : AppTypographyV1.labelLarge.medium.copyWith(
                                          color: Colors.black.withAlpha(50),
                                        ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // use this for testing the visual cue manually
                    // index == 4
                    //     ? const VisualCueEntity(
                    //         // IMAGE path — backend SVG.
                    //         uiType: 'IMAGE',
                    //         imageUrl: 'https://static.hopscotch.in/new-filter-tag.svg',
                    //       )
                    //     : const VisualCueEntity(
                    //         // TEXT path — custom-painted ribbon.
                    //         text: 'NEW',
                    //         bgColor: '#BD1550',
                    //       ),
                    if (section.visualCue != null)
                      Positioned(
                        top: 2,
                        right: -8,

                        child: FilterSectionBadge(
                          cue: section.visualCue!,
                          height: 20,
                          foldSize: 7,
                          notchDepth: 5,
                          fallbackBgColor: const Color(0xFFBD1550),
                          fallbackTextColor: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          foldShadowAlpha: 0.6,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContent(BuildContext context, FilterState state) {
    final sections = state.sections;
    if (sections.isEmpty) return const Expanded(child: SizedBox.shrink());

    final section = sections[state.safeSectionIndex];
    final uiType = section.uiType?.toLowerCase();

    // Route by uiType
    if (uiType == 'tree') {
      return Expanded(
        child: FilterTreeContent(
          section: section,
          treeSelections: state.treeSelections,
          pendingFilters: state.pendingFilters,
          onDrillIn: (param, value, level) => context.read<FilterBloc>().add(
            SelectTreeItem(param: param, value: value, level: level),
          ),
          onLeafToggle: (param, value) => context.read<FilterBloc>().add(
            ToggleFilterItem(param: param, value: value, isMultiSelect: true),
          ),
          onPopToLevel: (level) => context.read<FilterBloc>().add(PopTreeToLevel(level: level)),
        ),
      );
    }

    final isColourMode = uiType == 'colour';
    //TODO check this later because from the API we always get showSearch as false, and in the android code i see it's showing same always
    final isDelivery = uiType == 'delivery' || section.showSearch;
    final allFilters = _flattenFilterList(section.filterList);

    final filtered = (isDelivery || _searchQuery.isEmpty)
        ? allFilters
        : allFilters
              .where((f) => (f.label ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

    return Expanded(
      child: Column(
        children: [
          if (isDelivery) _buildSearchBar(section.searchBarLabel),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final filter = filtered[index];
                if (filter.isSection) {
                  return _buildSectionHeader(filter);
                }
                return isColourMode
                    ? _buildColourFilterItem(context, state, filter, section)
                    : _buildFilterItem(context, state, filter, section);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FilterEntity> _flattenFilterList(List<FilterEntity> filters) {
    final result = <FilterEntity>[];
    for (final filter in filters) {
      if (filter.filters.isNotEmpty) {
        result.addAll(filter.filters);
      } else {
        result.add(filter);
      }
    }
    return result;
  }

  Widget _buildSearchBar(String? hint) {
    return BlocBuilder<FilterBloc, FilterState>(
      buildWhen: (prev, curr) =>
          (prev.pincodeError != curr.pincodeError && curr.pincodeError != null) ||
          prev.isPincodeLoading != curr.isPincodeLoading,
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, AppSpacing.xs, AppSpacing.sm, AppSpacing.xxs),
          child: OutlinedTextField(
            required: false,
            controller: _searchController,
            labelText: hint ?? PlpStrings.pincode,
            errorText: state.pincodeError.isNotNullOrEmpty ? state.pincodeError : null,
            onChanged: _onSearchTextChanged,
            keyboardType: TextInputType.number,
            maxLength: 6,
            focusNode: pincodeFocusNode,
            onTapOutside: (p0) => FocusScope.of(context).unfocus(),
            suffix: state.isPincodeLoading
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _onSearchTextChanged(String value) {
    setState(() => _searchQuery = value);

    if (value.length == 6 && value != _lastPincodeHit) {
      _lastPincodeHit = value;
      context.read<FilterBloc>().add(VerifyPincode(pincode: value));
    } else if (value.length < 6 && _lastPincodeHit != null) {
      _lastPincodeHit = null;
      context.read<FilterBloc>().add(const ClearPincodeError());
    }
  }

  void _resetSearchInput() {
    if (_searchController.text.isEmpty && _searchQuery.isEmpty && _lastPincodeHit == null) {
      return;
    }
    _searchController.clear();
    _lastPincodeHit = null;
    context.read<FilterBloc>().add(const ClearPincodeError());
    setState(() => _searchQuery = '');
  }

  void _applyDeliveryPincode(FilterState state) {
    final pincode = state.currentDeliveryPincode;
    if (pincode == null || pincode.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text = pincode;
      _lastPincodeHit = pincode;
      setState(() => _searchQuery = pincode);
    });
  }

  Widget _buildSectionHeader(FilterEntity filter) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md + AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      child: Text(
        filter.label ?? '',
        style: AppTypography.caption.copyWith(fontWeight: AppTypography.semiBold),
      ),
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    FilterState state,
    FilterEntity filter,
    FilterSectionEntity section,
  ) {
    final param = filter.filterKey ?? '';
    final value = filter.filterValue ?? filter.label ?? '';
    final isChecked = _isFilterSelected(state, param, value);
    final label = filter.label ?? '';
    final count = filter.count != null && filter.count! > 0 ? '(${filter.count})' : null;

    void onToggle() {
      context.read<FilterBloc>().add(
        ToggleFilterItem(param: param, value: value, isMultiSelect: section.isMultiSelect),
      );
    }

    return SizedBox(
      height: 40,
      child: section.isMultiSelect
          ? AppCheckbox.labeled(
              onChanged: (_) => onToggle(),
              isSelected: isChecked,
              checkColor:
                  ['White', 'Yellow', 'Khaki', 'Cream', 'Off-White', 'Ivory'].contains(filter.label)
                  ? Colors.black
                  : null,
              label: label,
              count: count,
            )
          : AppRadio.labeled(onTap: onToggle, isSelected: isChecked, label: label, count: count),
    );
  }

  Widget _buildColourFilterItem(
    BuildContext context,
    FilterState state,
    FilterEntity filter,
    FilterSectionEntity section,
  ) {
    final param = filter.filterKey ?? '';
    final value = filter.filterValue ?? filter.label ?? '';
    final isChecked = _isFilterSelected(state, param, value);
    final colourHex = filter.colorHex;
    final showBlackCheckColor = [
      'White',
      'Yellow',
      'Khaki',
      'Cream',
      'Off-White',
      'Ivory',
    ].contains(filter.label);

    return SizedBox(
      height: 46,
      child: AppCheckbox.labeled(
        checkBoxSelectedColor: colourHex.toColor,
        checkBoxUnSelectedColor: colourHex.toColor,
        onChanged: (_) {
          context.read<FilterBloc>().add(
            ToggleFilterItem(param: param, value: value, isMultiSelect: section.isMultiSelect),
          );
        },
        isSelected: isChecked,
        checkColor: showBlackCheckColor ? Colors.black : null,
        label: filter.label ?? '',
        count: filter.count != null && filter.count! > 0 ? '(${filter.count})' : null,
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, FilterState state) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
        child: Row(
          children: [
            Expanded(
              child: TertiaryButton.defaultType(
                text: CommonStrings.clearAll,
                onTap: state.hasSelections
                    ? () => context.read<FilterBloc>().add(const ClearAllPendingFilters())
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: PrimaryButton.defaultType(
                text: CommonStrings.apply,
                // Always enabled — applying commits the current selection (incl.
                // removals / cleared state) and fires the filter API.
                state: ButtonState.enabled,
                onTap: () => Navigator.of(context).pop(state.flattenFilters()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFilterSelected(FilterState state, String param, String value) {
    return state.pendingFilters[param]?.contains(value) == true;
  }
}
