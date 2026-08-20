import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/promo_details_entity.dart';
import '../../domain/entities/promo_offer_entity.dart';
import '../../domain/usecases/get_promo_details_usecase.dart';

part 'promo_details_bloc.freezed.dart';
part 'promo_details_event.dart';
part 'promo_details_state.dart';

/// BLoC backing `PromoDetailsPage`.
///
/// Deliberately separate from `PromosOffersBloc`: [BaseBloc] keeps one
/// [CancelToken] per bloc, so sharing would let a details fetch cancel an
/// in-flight apply/remove (and vice versa).
@injectable
class PromoDetailsBloc extends BaseBloc<PromoDetailsEvent, PromoDetailsState> {
  final GetPromoDetailsUseCase _getPromoDetails;

  PromoDetailsBloc(this._getPromoDetails) : super(const PromoDetailsState()) {
    on<LoadPromoDetails>(_onLoad);
  }

  Future<void> _onLoad(
    LoadPromoDetails event,
    Emitter<PromoDetailsState> emit,
  ) async {
    emit(const PromoDetailsState(status: PromoDetailsStatus.loading));
    final token = swapCancelToken();

    final result = await _getPromoDetails(
      GetPromoDetailsParams(promoId: event.promoId, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          PromoDetailsState(
            status: PromoDetailsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (details) => emit(
        PromoDetailsState(
          status: PromoDetailsStatus.success,
          details: details,
        ),
      ),
    );
  }
}
