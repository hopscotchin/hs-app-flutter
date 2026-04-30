import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/error_retry_widget.dart';
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
      appBar: AppBar(title: const Text('Categories'), centerTitle: false),
      body: ErrorRetryWidget(
        message: "No Categories Available..!!",
        onRetry: VoidCallbackAction.new,
      ),
    );
  }
}
