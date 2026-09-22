import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Shell-level override that force-hides the bottom nav bar regardless of
/// scroll state. Used by Categories' inline search, which needs the full
/// viewport once the accordion list is swapped out for search content.
@singleton
class BottomNavVisibilityCubit extends Cubit<bool> {
  BottomNavVisibilityCubit() : super(true);

  void hide() => emit(false);
  void show() => emit(true);
}
