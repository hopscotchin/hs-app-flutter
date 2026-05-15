part of 'account_bloc.dart';

enum AccountStatus { initial, loading, success, error }

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    @Default(AccountStatus.success) AccountStatus status,
    @Default(AccountEntity()) AccountEntity account,
    String? errorMessage,
    @Default(false) bool isForgetting,
    String? forgetError,
    @Default(false) bool forgetCompleted,
  }) = _AccountState;
}
