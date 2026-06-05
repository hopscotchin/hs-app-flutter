import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../address/data/managers/address_cache_manager.dart';
import '../../../address/domain/usecases/get_addresses_usecase.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/forget_guest_user_usecase.dart';
import '../../domain/usecases/get_account_usecase.dart';

part 'account_bloc.freezed.dart';
part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends BaseBloc<AccountEvent, AccountState> {
  final GetAccountUseCase _getAccount;
  final ForgetGuestUserUseCase _forgetGuestUser;
  final PrefManager _prefs;
  final GetAddressesUseCase _getAddresses;
  final AddressCacheManager _addressCache;

  AccountBloc(
    this._getAccount,
    this._forgetGuestUser,
    this._prefs,
    this._getAddresses,
    this._addressCache,
  ) : super(AccountState(status: AccountStatus.success, account: _localAccount(_prefs))) {
    on<LoadAccount>(_onLoad);
    on<RefreshFromLocal>(_onRefreshLocal);
    on<ForgetGuestUser>(_onForgetGuestUser);
    on<ClearForgetSignal>(_onClearForgetSignal);
    on<PrefetchAddresses>(_onPrefetchAddresses);
  }

  static AccountEntity _localAccount(PrefManager p) => AccountEntity(
    isLoggedIn: p.isLoggedIn,
    hasGuestData: p.hasGuestData,
    name: p.firstName,
    email: p.email,
    phone: p.phoneNumber,
    avatarUrl: p.profileImage,
  );

  Future<void> _onLoad(LoadAccount event, Emitter<AccountState> emit) async {
    if (!_prefs.isLoggedIn) return;
    final current = state;
    final token = swapCancelToken();
    final result = await _getAccount(GetAccountParams(cancelToken: token));
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
      },
      (api) => emit(
        current.copyWith(
          status: AccountStatus.success,
          account: current.account.copyWith(
            email: api.email ?? current.account.email,
            credit: api.credit,
          ),
        ),
      ),
    );
  }

  void _onRefreshLocal(RefreshFromLocal event, Emitter<AccountState> emit) {
    emit(state.copyWith(account: _localAccount(_prefs)));
  }

  Future<void> _onForgetGuestUser(ForgetGuestUser event, Emitter<AccountState> emit) async {
    final current = state;
    emit(current.copyWith(isForgetting: true, forgetError: null));
    final token = swapCancelToken();
    final result = await _forgetGuestUser(ForgetGuestUserParams(cancelToken: token));
    result.fold(
      (error) {
        if (error is RequestCancelledFailure) return;
        emit(current.copyWith(isForgetting: false, forgetError: error.message));
      },
      (success) {
        _clearGuestUserData();
        emit(
          current.copyWith(
            isForgetting: false,
            forgetCompleted: true,
            account: current.account.copyWith(hasGuestData: false),
          ),
        );
      },
    );
  }

  Future<void> _clearGuestUserData() async {
    await _prefs.setHasGuestData(false);
  }

  void _onClearForgetSignal(ClearForgetSignal event, Emitter<AccountState> emit) {
    emit(state.copyWith(forgetError: null, forgetCompleted: false));
  }

  Future<void> _onPrefetchAddresses(PrefetchAddresses event, Emitter<AccountState> emit) async {
    final result = await _getAddresses(const GetAddressesParams());
    await result.fold(
      (_) async {},
      (list) => _addressCache.setAll(list.rawItems),
    );
  }
}
