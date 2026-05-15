import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/categories_bloc.dart';
import '../widgets/department_item_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return LoadingShimmer.listShimmer();
          }

          if (state is CategoriesError) {
            return ErrorRetryWidget(
              message: state.message,
              onRetry: () =>
                  context.read<CategoriesBloc>().add(LoadCategories()),
            );
          }

          if (state is CategoriesLoaded) {
            if (state.departments.isEmpty) {
              return const Center(child: Text('No categories available'));
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: state.departments.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final dept = state.departments[index];
                return DepartmentItemWidget(
                  department: dept,
                  onTap: () => AppNavigator.goToPlp(
                    context,
                    plpId: int.tryParse(dept.id) ?? 0,
                    categoryName: dept.label,
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
