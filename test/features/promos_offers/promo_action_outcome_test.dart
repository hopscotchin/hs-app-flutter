import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/entities/promo_action_result_entity.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/entities/promo_offers_entity.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/usecases/apply_promo_usecase.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/usecases/get_promos_offers_usecase.dart';
import 'package:hs_app_flutter/features/promos_offers/domain/usecases/remove_promo_usecase.dart';
import 'package:hs_app_flutter/features/promos_offers/presentation/bloc/promos_offers_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetOffers extends Mock implements GetPromosOffersUseCase {}

class _MockApplyPromo extends Mock implements ApplyPromoUseCase {}

class _MockRemovePromo extends Mock implements RemovePromoUseCase {}

/// Every completed apply/remove has to leave behind the code it was for.
///
/// `removed_promo_code` and `failed_promo_code` need it, and it is
/// unrecoverable afterwards — `pendingActionCode` is cleared by the same emit
/// the sheet's listener runs on. A completion path that forgot to stamp
/// [PromosOffersState.lastActionCode] would silently ship those two events
/// without their defining property. These pin all four paths.
void main() {
  late _MockGetOffers getOffers;
  late _MockApplyPromo applyPromo;
  late _MockRemovePromo removePromo;
  late PromosOffersBloc bloc;

  setUpAll(() {
    registerFallbackValue(const GetPromosOffersParams());
    registerFallbackValue(const ApplyPromoParams(promoCode: ''));
    registerFallbackValue(const RemovePromoParams(promoCode: ''));
  });

  setUp(() {
    getOffers = _MockGetOffers();
    applyPromo = _MockApplyPromo();
    removePromo = _MockRemovePromo();
    when(
      () => getOffers(any()),
    ).thenAnswer((_) async => const Right<Failure, PromoOffersEntity>(PromoOffersEntity()));
    bloc = PromosOffersBloc(getOffers, applyPromo, removePromo);
  });

  tearDown(() => bloc.close());

  /// The first state with a completed action on it.
  Future<PromosOffersState> completion() => bloc.stream.firstWhere((s) => s.actionNonce > 0);

  test('a successful apply carries the code and reads as succeeded', () async {
    when(() => applyPromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(success: true, message: 'Applied'),
      ),
    );

    bloc.add(const PromosOffersEvent.apply('TESTCART10'));
    final state = await completion();

    expect(state.lastAction, PromoActionKind.apply);
    expect(state.lastActionCode, 'TESTCART10');
    expect(state.actionSucceeded, isTrue);
    // Cleared by this same emit — why lastActionCode exists.
    expect(state.pendingActionCode, '');
  });

  test('a rejected apply carries the code and the server reason', () async {
    // The common rejection: HTTP 200 with `success: false`.
    when(() => applyPromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(message: 'Verify your mobile to avail promotion.'),
      ),
    );

    bloc.add(const PromosOffersEvent.apply('TESTCART10'));
    final state = await completion();

    expect(state.lastAction, PromoActionKind.apply);
    expect(state.lastActionCode, 'TESTCART10');
    expect(state.actionSucceeded, isFalse);
    expect(state.actionError, 'Verify your mobile to avail promotion.');
    // The server said it, so it is safe to ship as `promo_error`.
    expect(state.lastActionServerError, 'Verify your mobile to avail promotion.');
  });

  test('a rejection with no server message ships no promo_error', () async {
    // `actionError` falls back to the app's own copy so the sheet can render;
    // shipping that as `promo_error` would invent a bucket the backend never
    // said. Android: `if (!TextUtils.isEmpty(promoError))`.
    when(() => applyPromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(PromoActionResultEntity()),
    );

    bloc.add(const PromosOffersEvent.apply('TESTCART10'));
    final state = await completion();

    expect(state.actionSucceeded, isFalse);
    expect(state.actionError, isNotEmpty);
    expect(state.lastActionServerError, isNull);
  });

  test('a transport failure on apply carries the code too', () async {
    when(() => applyPromo(any())).thenAnswer(
      (_) async => const Left<Failure, PromoActionResultEntity>(ServerFailure(message: 'offline')),
    );

    bloc.add(const PromosOffersEvent.apply('TESTCART10'));
    final state = await completion();

    expect(state.lastActionCode, 'TESTCART10');
    expect(state.actionSucceeded, isFalse);
    expect(state.actionError, 'offline');
    // A transport failure's message is the genuine reason, so it does ship.
    expect(state.lastActionServerError, 'offline');
  });

  test('a successful remove carries the code through the list re-fetch', () async {
    // A remove's completion emit is built in `_reloadAfterAction`, a separate
    // path that has to stamp the code too.
    when(() => removePromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(success: true, message: 'Removed'),
      ),
    );

    bloc.add(const PromosOffersEvent.remove('TESTCART10'));
    final state = await completion();

    expect(state.lastAction, PromoActionKind.remove);
    expect(state.lastActionCode, 'TESTCART10');
    expect(state.actionSucceeded, isTrue);
  });

  test('a remove whose list re-fetch fails still carries the code', () async {
    // Only the refresh failed — the code came off the cart either way.
    when(() => removePromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(success: true, message: 'Removed'),
      ),
    );
    when(() => getOffers(any())).thenAnswer(
      (_) async => const Left<Failure, PromoOffersEntity>(ServerFailure(message: 'offline')),
    );

    bloc.add(const PromosOffersEvent.remove('TESTCART10'));
    final state = await completion();

    expect(state.lastActionCode, 'TESTCART10');
    expect(state.actionSucceeded, isTrue);
  });

  test('a second action replaces the first code', () async {
    // One session, two actions — the second must not report the first's code.
    when(() => removePromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(success: true, message: 'Removed'),
      ),
    );
    when(() => applyPromo(any())).thenAnswer(
      (_) async => const Right<Failure, PromoActionResultEntity>(
        PromoActionResultEntity(success: true, message: 'Applied'),
      ),
    );

    bloc.add(const PromosOffersEvent.remove('OLDCODE'));
    final removed = await completion();
    expect(removed.lastActionCode, 'OLDCODE');

    bloc.add(const PromosOffersEvent.apply('NEWCODE'));
    final applied = await bloc.stream.firstWhere((s) => s.actionNonce > removed.actionNonce);
    expect(applied.lastAction, PromoActionKind.apply);
    expect(applied.lastActionCode, 'NEWCODE');
  });
}
