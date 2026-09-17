import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/error/failures.dart';
import 'package:hs_app_flutter/features/wishlist/domain/entities/wishlist_response_entity.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:hs_app_flutter/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:mocktail/mocktail.dart';

/// `WishlistCubit` owns **when** wishlist analytics fires. Every surface — PDP,
/// its two rails, PLP, home, cart — passes `onAdded` / `onRemoved` and the cubit
/// invokes them from its server-confirmed branches only.
///
/// That placement is the whole point: the three gates are identical everywhere
/// and none of them is a surface's business to get right.
///
///   1. the request **succeeded** — `toggle` emits optimistically and each of
///      `_add` / `_remove` reverts on failure, so the tap proves nothing;
///   2. the **right outcome** — an add must not report a removal, and neither
///      must report the other's failure;
///   3. the user was **logged in** — a logged-out tap defers to login, so nothing
///      has happened yet and nothing should be reported. It must still report if
///      the user completes login, which is why the callbacks travel with the
///      deferred toggle.
class _MockAdd extends Mock implements AddToWishlistUseCase {}

class _MockRemove extends Mock implements RemoveFromWishlistUseCase {}

void main() {
  const id = '945499';
  const itemId = 'w-1';

  late _MockAdd add;
  late _MockRemove remove;
  late WishlistCubit cubit;
  late List<String> fired;

  setUpAll(() {
    registerFallbackValue(
      const AddToWishlistParams(productId: id, price: 349),
    );
    registerFallbackValue(const RemoveFromWishlistParams(wishlistId: itemId));
  });

  setUp(() {
    add = _MockAdd();
    remove = _MockRemove();
    cubit = WishlistCubit(add, remove);
    fired = [];
  });

  tearDown(() => cubit.close());

  void whenAddSucceeds() => when(() => add(any())).thenAnswer(
    (_) async => const Right(WishlistResponseEntity(wishlistItemId: itemId)),
  );
  void whenAddFails() => when(() => add(any())).thenAnswer(
    (_) async =>
        const Left<Failure, WishlistResponseEntity>(ServerFailure(message: 'nope')),
  );
  void whenRemoveSucceeds() => when(
    () => remove(any()),
  ).thenAnswer((_) async => const Right<Failure, String?>(null));
  void whenRemoveFails() => when(
    () => remove(any()),
  ).thenAnswer((_) async => const Left<Failure, String?>(ServerFailure(message: 'nope')));

  Future<void> toggle() => cubit.toggle(
    productId: id,
    price: 349,
    onAdded: () => fired.add('added'),
    onRemoved: () => fired.add('removed'),
  );

  /// Puts the product in the wishlist without going through `toggle`, so the next
  /// toggle is a removal.
  void seedWishlisted() =>
      cubit.seed([const WishlistSeed(productId: id, wished: true, wishlistItemId: itemId)]);

  group('add', () {
    test('reports once the server confirms', () async {
      whenAddSucceeds();
      await toggle();
      expect(fired, ['added']);
    });

    test('reports NOTHING when the server rejects it', () async {
      // `_add`'s failure branch reverts membership. The user tapped, the heart
      // flashed on and back off, and nothing was wishlisted.
      whenAddFails();
      await toggle();
      expect(fired, isEmpty);
      expect(cubit.state.isWishlisted(id), isFalse);
    });

    test('does not report a removal', () async {
      whenAddSucceeds();
      await toggle();
      expect(fired, isNot(contains('removed')));
    });
  });

  group('remove', () {
    test('reports once the server confirms', () async {
      seedWishlisted();
      whenRemoveSucceeds();
      await toggle();
      expect(fired, ['removed']);
    });

    test('reports NOTHING when the server rejects it', () async {
      // The trap this file exists for. `_remove`'s failure branch puts the
      // product BACK, so the end state is "wishlisted" — which is exactly what a
      // successful add looks like from the outside. Reporting an `added` here was
      // a live bug.
      seedWishlisted();
      whenRemoveFails();
      await toggle();
      expect(
        fired,
        isEmpty,
        reason: 'a failed removal must not report an add',
      );
      expect(cubit.state.isWishlisted(id), isTrue, reason: 'reverted');
    });

    test('does not report an add', () async {
      seedWishlisted();
      whenRemoveSucceeds();
      await toggle();
      expect(fired, isNot(contains('added')));
    });
  });

  group('the login detour', () {
    test('a deferred toggle reports when it is replayed', () async {
      // `WishlistActions.toggle` calls `setPending` instead of `toggle` when the
      // user is logged out, so nothing fires at tap time — correctly, nothing has
      // happened. The callbacks travel with the deferred action so the add that
      // eventually happens is the one that reports. Without this, a logged-out
      // tap reported at the wrong moment and never at the right one.
      whenAddSucceeds();
      cubit.setPending(
        productId: id,
        price: 349,
        onAdded: () => fired.add('added'),
        onRemoved: () => fired.add('removed'),
      );
      expect(fired, isEmpty, reason: 'nothing has happened yet');

      cubit.resumePending();
      await Future<void>.delayed(Duration.zero);
      expect(fired, ['added']);
    });

    test('resuming with nothing pending fires nothing', () async {
      cubit.resumePending();
      await Future<void>.delayed(Duration.zero);
      expect(fired, isEmpty);
      verifyNever(() => add(any()));
    });
  });

  group('a surface that passes no callback', () {
    test('emits nothing — the correct default for an unported screen', () async {
      whenAddSucceeds();
      await cubit.toggle(productId: id, price: 349);
      expect(fired, isEmpty);
      expect(cubit.state.isWishlisted(id), isTrue, reason: 'the add still ran');
    });
  });

  group('a second tap while the first is in flight', () {
    test('is ignored, so it cannot double-report', () async {
      whenAddSucceeds();
      final first = toggle();
      final second = toggle(); // in-flight guard drops this one
      await Future.wait([first, second]);
      expect(fired, ['added']);
      verify(() => add(any())).called(1);
    });
  });
}
