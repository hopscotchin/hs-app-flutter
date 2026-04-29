part of 'moments_bloc.dart';

abstract class MomentsEvent extends Equatable {
  const MomentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoments extends MomentsEvent {}

class LoadMoreMoments extends MomentsEvent {}

class LikeMoment extends MomentsEvent {
  final String momentId;

  const LikeMoment({required this.momentId});

  @override
  List<Object?> get props => [momentId];
}
