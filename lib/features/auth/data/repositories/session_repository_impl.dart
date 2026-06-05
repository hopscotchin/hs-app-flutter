import 'package:injectable/injectable.dart';

import '../../../../core/network/network_client.dart';
import '../models/user_info/user_info_model.dart';
import '../../../../core/services/pref_manager.dart';
import '../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../../domain/repositories/session_repository.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._prefManager, this._networkClient);

  final PrefManager _prefManager;
  final NetworkClient _networkClient;

  @override
  Future<void> saveSession(VerifyOtpResponseEntity entity) async {
    final ticket = entity.auth.persistentTicket;
    final hasTicket = ticket?.isNotEmpty == true;

    await Future.wait([
      _prefManager.setCustomerInfo(
        UserInfoModel.fromJson({
          ...UserInfoModel.fromEntity(entity.user).toJson(),
          'isLoggedIn': true,
        }),
      ),
      _prefManager.setCartItemQty(entity.user.cartItemCount),
      _prefManager.setHasGuestData(false),
      if (hasTicket) _prefManager.setPersistentTicket(ticket),
    ]);

    if (hasTicket) _networkClient.setPersistentTicket(ticket);
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([
      _prefManager.clearCustomerInfo(),
      _prefManager.setCartItemQty(0),
      _prefManager.setPersistentTicket(null),
    ]);
    _networkClient.setPersistentTicket(null);
  }
}
