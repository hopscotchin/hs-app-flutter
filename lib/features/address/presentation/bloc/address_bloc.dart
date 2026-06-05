import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hs_app_flutter/core/constants/strings/address_pincode_strings.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../data/managers/address_cache_manager.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/addresses_list_entity.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/select_address_usecase.dart';

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

@injectable
class AddressBloc extends BaseBloc<AddressEvent, AddressState> {
  AddressBloc(
    this._getAddresses,
    this._deleteAddress,
    this._selectAddress,
    this._cache,
  ) : super(const AddressState()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<RefreshAddresses>(_onRefreshAddresses);
    on<DeleteAddress>(_onDeleteAddress);
    on<ClearDeleteFeedback>(_onClearDeleteFeedback);
    on<SelectAddress>(_onSelectAddress);
    on<ClearSelectFeedback>(_onClearSelectFeedback);
  }

  final GetAddressesUseCase _getAddresses;
  final DeleteAddressUseCase _deleteAddress;
  final SelectAddressUseCase _selectAddress;
  final AddressCacheManager _cache;

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressState(status: AddressStatus.loading));
    final token = swapCancelToken();

    final result = await _getAddresses(GetAddressesParams(cancelToken: token));

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          AddressState(
            status: AddressStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (list) {
        _cache.setAll(list.rawItems);
        emit(AddressState(status: AddressStatus.success, addresses: list));
      },
    );
  }

  Future<void> _onRefreshAddresses(
    RefreshAddresses event,
    Emitter<AddressState> emit,
  ) async {
    add(const LoadAddresses());
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    final current = state;
    if (current.status != AddressStatus.success) return;

    emit(current.copyWith(deletingId: event.addressId));

    final result = await _deleteAddress(
      DeleteAddressParams(addressId: event.addressId),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          current.copyWith(deletingId: null, deleteError: failure.message),
        );
      },
      (popUpMessage) {
        emit(
          current.copyWith(
            deletingId: null,
            deleteSuccessMessage: popUpMessage,
          ),
        );
        add(const LoadAddresses());
      },
    );
  }

  Future<void> _onClearDeleteFeedback(
    ClearDeleteFeedback event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(deleteSuccessMessage: null, deleteError: null));
  }

  Future<void> _onSelectAddress(
    SelectAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        selectingId: event.addressId,
        selectError: null,
        selectSucceeded: false,
      ),
    );

    final token = swapCancelToken();
    final result = await _selectAddress(
      SelectAddressParams(addressId: event.addressId, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.copyWith(selectingId: null, selectError: failure.message),
        );
      },
      (mutation) {
        if (!mutation.isSuccessful) {
          final msg = mutation.popUpMessage.isNotEmpty
              ? mutation.popUpMessage
              : mutation.messageBars.isNotEmpty
                  ? mutation.messageBars.first.message
                  : AddressStrings.errorSelectingAddress;
          emit(state.copyWith(selectingId: null, selectError: msg));
          return;
        }
        if (mutation.rawItems.isNotEmpty) {
          _cache.setAll(mutation.rawItems);
        }
        emit(
          state.copyWith(
            selectingId: null,
            selectSucceeded: true,
          ),
        );
      },
    );
  }

  Future<void> _onClearSelectFeedback(
    ClearSelectFeedback event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(selectSucceeded: false, selectError: null));
  }
}
