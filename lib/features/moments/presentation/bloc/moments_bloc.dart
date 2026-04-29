import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/moment_entity.dart';
import '../../domain/usecases/get_moments_usecase.dart';
import '../../domain/usecases/like_moment_usecase.dart';

part 'moments_event.dart';
part 'moments_state.dart';

class MomentsBloc extends Bloc<MomentsEvent, MomentsState> {
  final GetMomentsUseCase getMomentsUseCase;
  final LikeMomentUseCase likeMomentUseCase;
  CancelToken? _cancelToken;

  MomentsBloc({
    required this.getMomentsUseCase,
    required this.likeMomentUseCase,
  }) : super(const MomentsInitial()) {
    on<LoadMoments>(_onLoadMoments);
    on<LoadMoreMoments>(_onLoadMoreMoments);
    on<LikeMoment>(_onLikeMoment);
  }

  Future<void> _onLoadMoments(
      LoadMoments event, Emitter<MomentsState> emit) async {
    emit(const MomentsLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result =
        await getMomentsUseCase(const GetMomentsParams(page: 0));
    result.fold(
      (failure) => emit(MomentsError(message: failure.message)),
      (moments) => emit(MomentsLoaded(moments: moments, page: 0)),
    );
  }

  Future<void> _onLoadMoreMoments(
      LoadMoreMoments event, Emitter<MomentsState> emit) async {
    final currentState = state;
    if (currentState is MomentsLoaded) {
      final nextPage = currentState.page + 1;
      final result =
          await getMomentsUseCase(GetMomentsParams(page: nextPage));
      result.fold(
        (failure) => emit(MomentsError(message: failure.message)),
        (newMoments) => emit(MomentsLoaded(
          moments: [...currentState.moments, ...newMoments],
          page: nextPage,
          hasReachedMax: newMoments.isEmpty,
        )),
      );
    }
  }

  Future<void> _onLikeMoment(
      LikeMoment event, Emitter<MomentsState> emit) async {
    final currentState = state;
    if (currentState is MomentsLoaded) {
      // Optimistic update
      final updatedMoments = currentState.moments.map((m) {
        if (m.id == event.momentId) {
          return m.copyWith(
            isLiked: !m.isLiked,
            likes: m.isLiked ? m.likes - 1 : m.likes + 1,
          );
        }
        return m;
      }).toList();
      emit(MomentsLoaded(
        moments: updatedMoments,
        page: currentState.page,
        hasReachedMax: currentState.hasReachedMax,
      ));

      // Fire API call
      await likeMomentUseCase(
          LikeMomentParams(momentId: event.momentId));
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
