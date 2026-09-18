import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/address/data/managers/address_cache_manager.dart';
import 'package:hs_app_flutter/features/address/domain/usecases/select_address_usecase.dart';
import 'package:hs_app_flutter/features/pincode/domain/entities/pincode_check_result_entity.dart';
import 'package:hs_app_flutter/features/pincode/domain/usecases/check_delivery_pincode_usecase.dart';
import 'package:hs_app_flutter/features/pincode/presentation/bloc/pincode_sheet_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../analytics/support/analytics_test_harness.dart';

class _MockCheckPincode extends Mock implements CheckDeliveryPincodeUseCase {}

class _MockSelectAddress extends Mock implements SelectAddressUseCase {}

class _MockAddressCache extends Mock implements AddressCacheManager {}

/// `pincode_checked` names both ends of the change.
///
/// `pincode` is the value the user just entered; `from_pincode` is the one it
/// replaces, captured when the sheet opened. The distinction is the event's
/// whole point — without it there is no way to tell a first-time entry from a
/// correction, or to see which pincodes users abandon.
void main() {
  late AnalyticsTestHarness h;
  late _MockCheckPincode checkPincode;
  late _MockAddressCache cache;
  late PincodeSheetBloc bloc;

  setUpAll(() {
    registerFallbackValue(const CheckDeliveryPincodeParams(pincode: ''));
  });

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    checkPincode = _MockCheckPincode();
    cache = _MockAddressCache();

    when(() => cache.cachedEntities).thenReturn(const []);
    when(() => cache.lastSelectedPincodeAddressId).thenReturn(null);
    when(() => cache.setLastSelectedPincodeAddressId(any())).thenAnswer((_) async {});
    when(() => checkPincode(any())).thenAnswer(
      (_) async => const Right<Failure, PincodeCheckResultEntity>(
        PincodeCheckResultEntity(isSuccessful: true),
      ),
    );

    bloc = PincodeSheetBloc(checkPincode, _MockSelectAddress(), cache, h.analytics);
  });

  tearDown(() => h.tearDown());

  /// Opens the sheet against [currentPincode], enters [entered], applies, and
  /// returns the `pincode_checked` that fired.
  Future<Map<String, Object?>> check({String? currentPincode, required String entered}) async {
    bloc.add(PincodeSheetEvent.open(currentPincode: currentPincode));
    bloc.add(PincodeSheetEvent.pincodeChanged(entered));
    bloc.add(const PincodeSheetEvent.apply());
    for (var tick = 0; tick < 40; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final events = h.eventsNamed(AnalyticsEvents.pincodeChecked);
      if (events.isNotEmpty) return events.last;
    }
    fail('no pincode_checked fired. Saw: ${h.captured.map((e) => e.name).toList()}');
  }

  test('pincode is the new value, from_pincode the one it replaces', () async {
    final e = await check(currentPincode: '560004', entered: '516215');
    expect(e[AnalyticsProperties.pincode], '516215');
    expect(e[AnalyticsProperties.fromPincode], '560004');
  });

  test('no prior pincode reports the standard sentinel', () async {
    // Android's own branch on `deliveryPincode.pincode.isNullOrEmpty()`.
    final e = await check(entered: '516215');
    expect(e[AnalyticsProperties.pincode], '516215');
    expect(e[AnalyticsProperties.fromPincode], AnalyticsDefaults.standard);
  });

  test('a second check in one session still reports the original', () async {
    // The bug this replaced: `from_pincode` followed the last *checked* value,
    // so a correction reported the user's first attempt as the "from" rather
    // than the pincode they actually arrived with.
    await check(currentPincode: '560004', entered: '516215');
    h.clear();

    bloc.add(const PincodeSheetEvent.pincodeChanged('110001'));
    bloc.add(const PincodeSheetEvent.apply());
    Map<String, Object?>? second;
    for (var tick = 0; tick < 40; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      final events = h.eventsNamed(AnalyticsEvents.pincodeChecked);
      if (events.isNotEmpty) {
        second = events.last;
        break;
      }
    }
    expect(second, isNotNull, reason: 'the second check fired no event');
    expect(second![AnalyticsProperties.pincode], '110001');
    expect(second[AnalyticsProperties.fromPincode], '560004');
  });

  test('the two ends are never the same value', () async {
    // A payload where both read alike means the wiring collapsed back to one
    // source — the failure mode that makes the event useless.
    final e = await check(currentPincode: '560004', entered: '516215');
    expect(e[AnalyticsProperties.pincode], isNot(e[AnalyticsProperties.fromPincode]));
  });

  test('an unserviceable pincode is still counted', () async {
    // Fired on the API answering, not on it succeeding — dropping failures
    // would make the serviceability rate unmeasurable.
    when(() => checkPincode(any())).thenAnswer(
      (_) async =>
          const Left<Failure, PincodeCheckResultEntity>(ServerFailure(message: 'not served')),
    );
    final e = await check(currentPincode: '560004', entered: '999999');
    expect(e[AnalyticsProperties.pincode], '999999');
    expect(e[AnalyticsProperties.fromPincode], '560004');
  });
}
