part of 'account_bloc.dart';

@freezed
sealed class AccountEvent with _$AccountEvent {
  const factory AccountEvent.load() = LoadAccount;
  const factory AccountEvent.refreshFromLocal() = RefreshFromLocal;
  const factory AccountEvent.forgetGuestUser() = ForgetGuestUser;
  const factory AccountEvent.clearForgetSignal() = ClearForgetSignal;
  const factory AccountEvent.prefetchAddresses() = PrefetchAddresses;
}
