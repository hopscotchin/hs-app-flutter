import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../services/pref_manager.dart';

@singleton
class CartCountCubit extends Cubit<int> {
  final PrefManager _prefManager;

  CartCountCubit(this._prefManager) : super(_prefManager.cartItemQty);

  void set(int count) {
    _prefManager.setCartItemQty(count);
    emit(count);
  }
}
