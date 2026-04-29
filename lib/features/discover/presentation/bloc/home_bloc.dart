import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/home_page_entity.dart';
import '../../domain/usecases/get_home_page_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomePageUseCase getHomePageUseCase;
  CancelToken? _cancelToken;

  HomeBloc({required this.getHomePageUseCase}) : super(const HomeInitial()) {
    on<LoadHomePage>(_onLoadHomePage);
    on<RefreshHomePage>(_onRefreshHomePage);
  }

  Future<void> _onLoadHomePage(
      LoadHomePage event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result = await getHomePageUseCase.execute(
      cancelToken: _cancelToken,
    );
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homePage) => emit(HomeLoaded(homePage: homePage)),
    );
  }

  Future<void> _onRefreshHomePage(
      RefreshHomePage event, Emitter<HomeState> emit) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result = await getHomePageUseCase.execute(
      cancelToken: _cancelToken,
    );
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homePage) => emit(HomeLoaded(homePage: homePage)),
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
