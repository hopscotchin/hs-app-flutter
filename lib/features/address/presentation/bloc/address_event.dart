part of 'address_bloc.dart';

@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.load({
    @Default(AddressSource.customer) AddressSource source,
  }) = LoadAddresses;
  const factory AddressEvent.refresh() = RefreshAddresses;
  const factory AddressEvent.delete(int addressId) = DeleteAddress;
  const factory AddressEvent.clearDeleteFeedback() = ClearDeleteFeedback;
  const factory AddressEvent.select(int addressId) = SelectAddress;
  const factory AddressEvent.clearSelectFeedback() = ClearSelectFeedback;
}
