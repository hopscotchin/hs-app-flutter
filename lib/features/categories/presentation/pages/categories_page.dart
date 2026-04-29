import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/loading_shimmer.dart';
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

          if (state is CategoriesLoaded) {
            if (state.departments.isEmpty) {
              return const Center(child: Text('No categories available'));
            }

            return ListView.separated(
              itemCount: state.departments.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final dept = state.departments[index];
                return DepartmentItemWidget(
                  department: dept,
                  onTap: () => {},
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
