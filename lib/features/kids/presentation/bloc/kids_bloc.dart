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

    final result = await _deleteChild(DeleteChildParams(childId: event.childId));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(deletingId: null, deleteError: failure.message));
      },
      (message) {
        emit(
          state.copyWith(
            deletingId: null,
            deleteSuccessMessage: message.isNotEmpty ? message : KidsStrings.deleteSuccessMessage,
          ),
        );
        add(const LoadChildren());
      },
    );
  }

  Future<void> _onClearDeleteFeedback(ClearDeleteFeedback event, Emitter<KidsState> emit) async {
    emit(state.copyWith(deleteSuccessMessage: null, deleteError: null));
  }
}
