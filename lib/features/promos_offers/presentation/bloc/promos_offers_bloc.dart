import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/constants/strings/promos_offers_strings.dart';
import '../../../../core/entities/backend_action_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/promo_action_result_entity.dart';
import '../../domain/entities/promo_offers_entity.dart';
import '../../domain/usecases/apply_promo_usecase.dart';
import '../../domain/usecases/get_promos_offers_usecase.dart';
import '../../domain/usecases/remove_promo_usecase.dart';

part 'promos_offers_bloc.freezed.dart';
part 'promos_offers_event.dart';
part 'promos_offers_state.dart';

/// BLoC backing the promos & offers bottom sheet. Loads the offer list once
/// when the sheet opens; apply/remove mutate server-side then re-fetch the
/// list so the sheet can stay open with fresh `isApplied` flags.
@injectable
class PromosOffersBloc extends BaseBloc<PromosOffersEvent, PromosOffersState> {
  final GetPromosOffersUseCase _getPromosOffers;
  final ApplyPromoUseCase _applyPromo;
  final RemovePromoUseCase _removePromo;

  PromosOffersBloc(this._getPromosOffers, this._applyPromo, this._removePromo)
    : super(const PromosOffersState()) {
    on<LoadPromosOffers>(_onLoad);
    on<RefreshPromosOffers>(_onRefresh);
    // Sequential, not droppable: a tap the user made must run, but two
    // mutations must never overlap — the second would cancel the first's
    // request after the server may already have applied it.
    on<ApplyPromo>(_onApply, transformer: _sequential());
    on<RemovePromo>(_onRemove, transformer: _sequential());
  }

  /// Mutations use a token of their own rather than [swapCancelToken]. The
  /// bloc-level token is shared, and bloc's default transformer runs handlers
  /// for *different* event types concurrently — a `LoadPromosOffers` arriving
  /// mid-apply would otherwise cancel the apply after the server had already
  /// applied it, leaving the UI and the cart disagreeing.
  CancelToken? _actionCancelToken;

  CancelToken _swapActionCancelToken() {
    _actionCancelToken?.cancel(
      'Cancelled by bloc: a newer promo action superseded it.',
    );
    final token = CancelToken();
    _actionCancelToken = token;
    return token;
  }

  @override
  Future<void> close() {
    _actionCancelToken?.cancel('Bloc closed.');
    _actionCancelToken = null;
    return super.close();
  }

  Future<void> _onLoad(
    LoadPromosOffers event,
    Emitter<PromosOffersState> emit,
  ) async {
    emit(const PromosOffersState(status: PromosOffersStatus.loading));
    final token = swapCancelToken();

    final result = await _getPromosOffers(
      GetPromosOffersParams(cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          PromosOffersState(
            status: PromosOffersStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (offers) => emit(
        PromosOffersState(status: PromosOffersStatus.success, offers: offers),
      ),
    );
  }

  Future<void> _onRefresh(
    RefreshPromosOffers event,
    Emitter<PromosOffersState> emit,
  ) async {
    add(const LoadPromosOffers());
  }

  Future<void> _onApply(ApplyPromo event, Emitter<PromosOffersState> emit) =>
      _runAction(
        emit,
        kind: PromoActionKind.apply,
        promoCode: event.promoCode,
        run: (token) => _applyPromo(
          ApplyPromoParams(promoCode: event.promoCode, cancelToken: token),
        ),
        fallbackSuccess: PromosOffersStrings.offerApplied,
        fallbackError: PromosOffersStrings.couldNotApplyOffer,
      );

  Future<void> _onRemove(RemovePromo event, Emitter<PromosOffersState> emit) =>
      _runAction(
        emit,
        kind: PromoActionKind.remove,
        promoCode: event.promoCode,
        run: (token) => _removePromo(
          RemovePromoParams(promoCode: event.promoCode, cancelToken: token),
        ),
        fallbackSuccess: PromosOffersStrings.offerRemoved,
        fallbackError: PromosOffersStrings.couldNotRemoveOffer,
      );

  /// Shared apply/remove flow: lock the buttons, hit the endpoint, then — for a
  /// remove, which leaves the sheet open — re-fetch the list so `isApplied`
  /// reflects the server. An apply closes the sheet, so it skips the re-fetch.
  Future<void> _runAction(
    Emitter<PromosOffersState> emit, {
    required PromoActionKind kind,
    required String promoCode,
    required Future<Either<Failure, PromoActionResultEntity>> Function(
      CancelToken token,
    )
    run,
    required String fallbackSuccess,
    required String fallbackError,
  }) async {
    final current = state;
    if (current.isActionInProgress || promoCode.isEmpty) return;

    emit(
      current.copyWith(
        pendingActionCode: promoCode,
        actionMessage: null,
        actionError: null,
      ),
    );

    final result = await run(_swapActionCancelToken());

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        emit(
          current.copyWith(
            pendingActionCode: '',
            actionError: failure.message,
            actionNonce: current.actionNonce + 1,
            lastAction: kind,
          ),
        );
      },
      (action) async {
        final sheet = action.hasBottomSheet ? action.bottomSheet : null;
        if (!action.success) {
          emit(
            current.copyWith(
              pendingActionCode: '',
              // A backend sheet carries its own copy, so don't also raise an
              // error toast behind it.
              actionError: sheet != null
                  ? null
                  : (action.hasMessage ? action.message : fallbackError),
              actionBottomSheet: sheet,
              actionNonce: current.actionNonce + 1,
              lastAction: kind,
            ),
          );
          return;
        }
        final message = action.hasMessage ? action.message : fallbackSuccess;
        if (kind == PromoActionKind.apply) {
          // The sheet closes on a successful apply and the cart re-reads, so a
          // list re-fetch here would be thrown away.
          emit(
            current.copyWith(
              pendingActionCode: '',
              actionMessage: sheet != null ? null : message,
              actionBottomSheet: sheet,
              actionNonce: current.actionNonce + 1,
              lastAction: kind,
              cartChanged: true,
            ),
          );
          return;
        }
        await _reloadAfterAction(
          emit,
          base: current,
          kind: kind,
          actionMessage: message,
          bottomSheet: sheet,
        );
      },
    );
  }

  /// Re-fetch the list and surface the action outcome in a single emit, so the
  /// success toast fires once and never flickers against an intermediate state.
  Future<void> _reloadAfterAction(
    Emitter<PromosOffersState> emit, {
    required PromosOffersState base,
    required PromoActionKind kind,
    required String actionMessage,
    BackendActionContentEntity? bottomSheet,
  }) async {
    final result = await _getPromosOffers(
      GetPromosOffersParams(cancelToken: swapCancelToken()),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        // The mutation succeeded — only the refresh failed. Keep the stale
        // list visible rather than blanking the sheet.
        emit(
          base.copyWith(
            pendingActionCode: '',
            actionError: failure.message,
            actionBottomSheet: bottomSheet,
            actionNonce: base.actionNonce + 1,
            lastAction: kind,
            cartChanged: true,
          ),
        );
      },
      (offers) => emit(
        base.copyWith(
          status: PromosOffersStatus.success,
          offers: offers,
          pendingActionCode: '',
          actionMessage: bottomSheet != null ? null : actionMessage,
          actionBottomSheet: bottomSheet,
          actionNonce: base.actionNonce + 1,
          lastAction: kind,
          cartChanged: true,
        ),
      ),
    );
  }
}

/// bloc_concurrency is not a dependency of this project, so the one transformer
/// we need is spelled out here — identical to `bloc_concurrency`'s `sequential`.
EventTransformer<E> _sequential<E>() =>
    (events, mapper) => events.asyncExpand(mapper);
