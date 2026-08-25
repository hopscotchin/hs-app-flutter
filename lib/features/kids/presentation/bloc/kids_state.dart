part of 'kids_bloc.dart';

enum KidsStatus { initial, loading, success, error }

@freezed
abstract class KidsState with _$KidsState {
  const factory KidsState({
    @Default(KidsStatus.initial) KidsStatus status,
    @Default(<ChildEntity>[]) List<ChildEntity> children,
    // List screen's backend-driven copy + footer avatar images — arrives
    // together with `children` in the same list-fetch; null until the first
    // successful load, in which case [effectiveContent] falls back locally.
    KidsListContentEntity? content,
    String? errorMessage,
    int? deletingId,
    String? deleteSuccessMessage,
    String? deleteError,
  }) = _KidsState;
}

extension KidsStateX on KidsState {
  KidsListContentEntity get effectiveContent => content ?? KidsListContentEntity.fallback();
}
