part of 'address_bloc.dart';

enum AddressStatus { initial, loading, success, error }

@freezed
abstract class AddressState with _$AddressState {
  const factory AddressState({
    @Default(AddressStatus.initial) AddressStatus status,
    @Default(AddressSource.customer) AddressSource source,
    AddressesListEntity? addresses,
    String? errorMessage,
    int? deletingId,
    String? deleteSuccessMessage,
    String? deleteError,
    int? selectingId,
    @Default(false) bool selectSucceeded,
    String? selectError,
  }) = _AddressState;
}

extension AddressStateX on AddressState {
  List<AddressEntity> get items => addresses?.items ?? const [];
}
