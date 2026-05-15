import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/department_entity.dart';
import '../../domain/usecases/get_departments_usecase.dart';
import 'package:injectable/injectable.dart';

part 'categories_event.dart';
part 'categories_state.dart';

@injectable
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetDepartmentsUseCase getDepartmentsUseCase;
  CancelToken? _cancelToken;

  CategoriesBloc({required this.getDepartmentsUseCase})
    : super(const CategoriesInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result = await getDepartmentsUseCase(NoParams());
    result.fold(
      (failure) => emit(CategoriesError(message: failure.message)),
      (departments) => emit(CategoriesLoaded(departments: departments)),
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
