part of 'moments_bloc.dart';

abstract class MomentsState extends Equatable {
  const MomentsState();

  @override
  List<Object?> get props => [];
}

class MomentsInitial extends MomentsState {
  const MomentsInitial();
}

class MomentsLoading extends MomentsState {
  const MomentsLoading();
}

class MomentsLoaded extends MomentsState {
  final List<MomentEntity> moments;
  final int page;
  final bool hasReachedMax;

  const MomentsLoaded({
    required this.moments,
    required this.page,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [moments, page, hasReachedMax];
}

class MomentsError extends MomentsState {
  final String message;

  const MomentsError({required this.message});

  @override
  List<Object?> get props => [message];
}
