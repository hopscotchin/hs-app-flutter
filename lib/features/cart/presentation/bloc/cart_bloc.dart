import 'dart:convert';
import 'package:injectable/injectable.dart';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/get_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final PrefManager prefManager;
  final CartCountCubit cartCountCubit;
  CancelToken? _cancelToken;

  CartBloc({
    required this.getCartUseCase,
    required this.prefManager,
    required this.cartCountCubit,
  }) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result = await getCartUseCase(NoParams());
    result.fold((failure) => emit(CartError(message: failure.message)), (cart) {
      cartCountCubit.set(cart.items.length);
      emit(CartLoaded(cart: cart, staticMessageBars: List.empty()));
    });
  }


  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
