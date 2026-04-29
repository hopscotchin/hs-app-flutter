import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/models/message_bar_model.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/usecases/usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final PrefManager prefManager;
  CancelToken? _cancelToken;

  CartBloc({
    required this.prefManager,
  }) : super(const CartInitial()) {
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
