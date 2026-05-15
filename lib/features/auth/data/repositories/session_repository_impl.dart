import 'package:injectable/injectable.dart';

import '../../../../core/network/network_client.dart';
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
      _prefManager.setIsLoggedIn(true),
      _prefManager.setUserId(entity.user.userId),
      _prefManager.setFirstName(entity.user.firstName),
      _prefManager.setLastName(entity.user.lastName),
      _prefManager.setUserName(entity.user.userName),
      _prefManager.setPhoneNumber(entity.user.mobile),
      _prefManager.setEmail(entity.user.email),
      _prefManager.setProfileImage(null),
      _prefManager.setMobileStatus(entity.user.mobileStatus),
      _prefManager.setCartItemQty(entity.user.cartItemCount),
      _prefManager.setHasGuestData(false),
      if (hasTicket) _prefManager.setPersistentTicket(ticket),
    ]);

    if (hasTicket) _networkClient.setPersistentTicket(ticket);
  }

  @override
  Future<void> clearSession() async {
    await Future.wait([
      _prefManager.setIsLoggedIn(false),
      _prefManager.setUserId(null),
      _prefManager.setFirstName(null),
      _prefManager.setLastName(null),
      _prefManager.setUserName(null),
      _prefManager.setPhoneNumber(null),
      _prefManager.setEmail(null),
      _prefManager.setProfileImage(null),
      _prefManager.setMobileStatus(null),
      _prefManager.setCartItemQty(0),
      _prefManager.setPersistentTicket(null),
    ]);
    _networkClient.setPersistentTicket(null);
  }
}
