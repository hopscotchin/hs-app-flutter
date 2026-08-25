import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/kids_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/kids_list_content_entity.dart';
import '../../domain/usecases/delete_child_usecase.dart';
import '../../domain/usecases/get_children_usecase.dart';

part 'kids_bloc.freezed.dart';
part 'kids_event.dart';
part 'kids_state.dart';

// TEMPORARY — UI review only. Flip to `false` once the live
// questionnaire/list & save endpoints are confirmed reachable end-to-end
// (see PROFILE_KIDS_API_CONTRACT.md / kids_repository_impl.dart), then
// delete this flag and _sampleChildren entirely.
const bool _kUseHardcodedDataForUiReview = true;

List<ChildEntity> _sampleChildren() {
  const names = [
    ('Ananya', ChildGender.girl, 2019, 5, 15),
    ('Aarav', ChildGender.boy, 2021, 7, 20),
    ('Ishaan', ChildGender.boy, 2018, 11, 2),
    ('Diya', ChildGender.girl, 2022, 1, 30),
    ('Vivaan', ChildGender.boy, 2016, 3, 12),
    ('Myra', ChildGender.girl, 2020, 9, 8),
    ('Reyansh', ChildGender.boy, 2023, 6, 25),
    ('Anika', ChildGender.girl, 2017, 4, 19),
    ('Kabir', ChildGender.boy, 2019, 12, 5),
    ('Saanvi', ChildGender.girl, 2015, 8, 14),
  ];
  return [
    for (var i = 0; i < names.length; i++)
      ChildEntity(id: i + 1, name: names[i].$1, gender: names[i].$2)
          .copyWith(dob: DateTime(names[i].$3, names[i].$4, names[i].$5)),
  ];
}

@injectable
class KidsBloc extends BaseBloc<KidsEvent, KidsState> {
  KidsBloc(this._getChildren, this._deleteChild) : super(const KidsState()) {
    on<LoadChildren>(_onLoad);
    on<RefreshChildren>(_onRefresh);
    on<DeleteChild>(_onDelete);
    on<ClearDeleteFeedback>(_onClearDeleteFeedback);
  }

  final GetChildrenUseCase _getChildren;
  final DeleteChildUseCase _deleteChild;

  Future<void> _onLoad(LoadChildren event, Emitter<KidsState> emit) async {
    emit(state.copyWith(status: KidsStatus.loading));

    if (_kUseHardcodedDataForUiReview) {
      emit(state.copyWith(status: KidsStatus.success, children: _sampleChildren()));
      return;
    }

    final token = swapCancelToken();

    final result = await _getChildren(GetChildrenParams(cancelToken: token));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(status: KidsStatus.error, errorMessage: failure.message));
      },
      (result) => emit(
        state.copyWith(status: KidsStatus.success, children: result.children, content: result.content),
      ),
    );
  }

  Future<void> _onRefresh(RefreshChildren event, Emitter<KidsState> emit) async {
    add(const LoadChildren());
  }

  Future<void> _onDelete(DeleteChild event, Emitter<KidsState> emit) async {
    if (state.status != KidsStatus.success) return;
    emit(state.copyWith(deletingId: event.childId));

    if (_kUseHardcodedDataForUiReview) {
      final updated = state.children.where((c) => c.id != event.childId).toList();
      emit(
        state.copyWith(
          deletingId: null,
          children: updated,
          deleteSuccessMessage: KidsStrings.deleteSuccessMessage,
        ),
      );
      return;
    }

    final result = await _deleteChild(DeleteChildParams(childId: event.childId));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(deletingId: null, deleteError: failure.message));
      },
      (message) {
        emit(state.copyWith(deletingId: null, deleteSuccessMessage: message));
        add(const LoadChildren());
      },
    );
  }

  Future<void> _onClearDeleteFeedback(ClearDeleteFeedback event, Emitter<KidsState> emit) async {
    emit(state.copyWith(deleteSuccessMessage: null, deleteError: null));
  }
}
