# Package-Wise Coding Rules for AI Agents

Binding rules per package. Read alongside `coding_rule.md`. When in doubt, the orders module is the reference implementation.

---

## flutter_bloc

**Rules**

- Use `Bloc` for event-driven, network-backed features. Use `Cubit` only for simple local UI state with no network calls.
- Every Bloc extends `BaseBloc<Event, State>` — never plain `Bloc`.
- Annotate `@injectable` — never `@lazySingleton` or `@singleton`.
- **Soft limit: max 7 events per Bloc.** More than 7 events signals multiple responsibilities — split into focused Blocs. Can be exceeded when justified.
- **Soft limit: max 700 lines per file** (bloc, widget, repository, API client). Approaching the limit is a signal to extract sub-widgets or split by sub-domain. Can be exceeded when justified.
- Single `@freezed abstract class` state with a status enum — never multiple state subclasses.
- `BlocProvider` lives in the route file only — never in `build()` methods or `initState`.
- Use `BlocSelector` when only one field drives a rebuild; use `BlocBuilder` for whole-state rebuilds.
- Side effects (navigation, snackbars, dialogs) go in `BlocListener` — never in `builder`.
- Do not dispatch events from `build()`. Use `initState` or `didChangeDependencies` with `context.read<B>().add(...)`.
- Pass already-created Blocs via `BlocProvider.value` — never re-wrap with `BlocProvider(create:)`.

**State snapshot rule — `final current = state`**

bloc's default transformer is `concurrent()`: handlers for **different event types** run simultaneously. Snapshot before any intermediate emit so your success/failure emits always branch from the state you started with, not from whatever a concurrent handler may have emitted during your `await`.

Required in these patterns:

| Pattern                         | Why snapshot is needed                                |
| ------------------------------- | ----------------------------------------------------- |
| Pagination                      | Concurrent refresh can wipe `page` to null mid-flight |
| Optimistic update               | Need original state to revert on API failure          |
| Per-row action (delete, toggle) | Need original list to restore on failure              |
| Form submit with loading state  | Preserve form data if API errors                      |

Skip only for bare-constructor full resets (`emit(const MyState(status: loading))`) or single synchronous emits with no `await`.

```dart
// Required — two emits, await in between, success needs pre-emit fields
final current = state;
emit(current.copyWith(isLoadingMore: true));
final result = await _fetch(...);
result.fold(
  (f) => emit(current.copyWith(isLoadingMore: false, paginationError: f.message)),
  (p) => emit(current.copyWith(isLoadingMore: false, page: current.page!.merge(p))),
);

// Not required — full reset, bare constructor, no fields carried forward
emit(const OrdersState(status: OrdersStatus.loading));
```

**Never**

- `safeEmit` — use plain `emit(...)`.
- `BuildContext` inside a Bloc.
- `sl<T>()` inside a Bloc.

---

## freezed

**Rules**

- Domain entities: `@freezed abstract class` — no `fromJson`, no `toJson`.
- Data models: **do NOT use Freezed** — use `@JsonSerializable(createToJson: false)` only. DTOs are short-lived and never need `copyWith` or value equality.
- Bloc events: `@freezed sealed class` — `sealed` enables exhaustive switch checking.
- Bloc state: `@freezed abstract class` — single class, status enum, `@Default` on every optional field.
- Use `@Default(value)` — never nullable fields that default to null when a sensible default exists.
- Derived values go in extension methods on the generated class — never in the class body.
- Never manually edit `.freezed.dart` files.
- Run `dart run build_runner build --delete-conflicting-outputs` after every change to an annotated file.

```dart
// Events — sealed
@freezed
sealed class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.load() = LoadOrders;
  const factory OrdersEvent.loadNextPage() = LoadNextOrdersPage;
}

// State — single class + enum
enum OrdersStatus { initial, loading, success, error }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(OrdersStatus.initial) OrdersStatus status,
    OrdersPageEntity? page,
    @Default(false) bool isLoadingMore,
  }) = _OrdersState;
}

extension OrdersStateX on OrdersState {
  bool get hasData => page != null;
}
```

---

## dartz

**Rules**

- Every repository method returns `Future<Either<Failure, T>>` — no exceptions propagate past the repository.
- Use cases propagate `Either` unchanged — no fold, no try/catch in use cases.
- Blocs consume `Either` via `result.fold(onLeft, onRight)` — always handle both branches.
- `Either` is created only in the repository (via `SafeApiCall`) — never in use cases or Blocs.
- Always handle `RequestCancelledFailure` silently (early return) before any other failure branch.

```dart
result.fold(
  (f) {
    if (f is RequestCancelledFailure) return;
    emit(OrdersState(status: OrdersStatus.error, errorMessage: f.message));
  },
  (page) => emit(OrdersState(status: OrdersStatus.success, page: page)),
);
```

---

## equatable

**Rules**

- Use `Equatable` for simple params/value objects that don't need `copyWith`.
- Use `Freezed` for entities, events, and states — it generates equality automatically. Data models use `@JsonSerializable` instead.
- Always make `Equatable` classes `const`-constructable.
- Always exclude infrastructure objects (`CancelToken`, controllers, streams) from `props`.
- Never include mutable objects in `props`.

```dart
class GetOrdersPageParams extends Equatable {
  const GetOrdersPageParams({required this.pageNo, this.pageSize = 20, this.cancelToken});
  final int pageNo;
  final int pageSize;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pageNo, pageSize]; // cancelToken excluded
}
```

---

## json_serializable

**Rules**

- `fromJson` / `toJson` belong only in data-layer models — never in domain entities.
- Use `@JsonSerializable(createToJson: false)` — API response models are never serialized back to JSON.
- Every field that can be missing or null in the API response **must** have `@JsonKey(defaultValue: ...)`.
- Use `@JsonKey(name: 'snake_case')` when the JSON key differs from the Dart field name.
- Use `@JsonKey(fromJson: parseToInt)` (from `lib/core/utils/json_parsers.dart`) when the API sends a number as a string.
- For nullable nested models where the JSON value may not be a Map, use a top-level `_xFromJson(Object? json)` helper with `@JsonKey(fromJson: _xFromJson)` rather than relying on automatic deserialization.
- Never manually edit `.g.dart` files.

```dart
@JsonSerializable(createToJson: false)
class OrderInfoModel {
  const OrderInfoModel({required this.orderId, required this.status});

  @JsonKey(name: 'order_id', defaultValue: 0) final int orderId;
  @JsonKey(name: 'status',   defaultValue: '') final String status;

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoModelFromJson(json);
}
```

---

## dio

**Rules**

- One `Dio` singleton per app — never instantiate `Dio` inline.
- Interceptor order must be: Auth → Retry → Logging (`TalkerDioLogger`).
- Token refresh must use a `QueuedInterceptor` + `Completer` pattern — never a simple `on401` retry that can trigger concurrent refreshes.
- Only retry on safe conditions: connection timeout, receive timeout, 5xx server errors. Never retry 4xx.
- Use `CancelToken` on every request; cancel in `dispose()` or `swapCancelToken()`.
- Map `DioException` to domain `Failure` types at one boundary (`SafeApiCall`) — never in repositories or Blocs.
- Timeouts: connect ≤ 10 s, receive ≤ 30 s.

**Never**

- `Dio()` inside a widget, repository, or use case.
- `print(e)` for Dio errors — use `talker.handle(e, st, 'context')`.
- Retry 401 without a queued interceptor.

---

## retrofit

**Rules**

- Always apply all three annotations together: `@RestApi()` + `@lazySingleton` + `@factoryMethod`.
- Path strings come from `ApiConstants` constants — never hardcode paths.
- Return type is always a typed model class — never `dynamic`, `Map`, or `Response`.
- Every method has `@CancelRequest() CancelToken? cancelToken`.
- One Retrofit client per feature domain.
- Never call the generated `_FeatureApi` implementation directly — inject via `FeatureApi` interface.

```dart
@RestApi()
@lazySingleton
abstract class OrdersApi {
  @factoryMethod
  factory OrdersApi(Dio dio) = _OrdersApi;

  @GET(ApiConstants.ordersListing)
  Future<OrdersPageResponseModel> getOrders({
    @Query('pageNo')   required int pageNo,
    @Query('pageSize') required int pageSize,
    @CancelRequest()   CancelToken? cancelToken,
  });
}
```

---

## get_it + injectable

**Rules**

| Layer                  | Annotation                                         |
| ---------------------- | -------------------------------------------------- |
| Retrofit API client    | `@lazySingleton` + `@factoryMethod`                |
| Repository impl        | `@LazySingleton(as: FeatureRepository)`            |
| Use case               | `@lazySingleton`                                   |
| Bloc                   | `@injectable` (factory — a new instance per route) |
| Global Cubit / service | `@singleton`                                       |

- Always inject the **interface** (`OrdersRepository`), never the implementation.
- `sl<T>()` is allowed only in: route builders, `injection_container.dart`, `@module` methods.
- After adding or changing any injectable annotation: `dart run build_runner build --delete-conflicting-outputs`.
- Until `injection.config.dart` is generated, add manual registrations to `injection_container.dart`.

**Never**

- `@lazySingleton` or `@singleton` on a Bloc.
- `sl<T>()` inside widgets, Blocs, use cases, or repositories.
- Inject the implementation class — always inject its interface.

---

## go_router

**Rules**

- One `<feature>_route.dart` file per feature; class named `<Feature>Route` with a static `getRoute()`.
- `BlocProvider` lives only in the route builder — nowhere else.
- Fire the initial Bloc event inside `create:`.
- Set `name:` on every `GoRoute` — required for `pushNamed`.
- Set `parentNavigatorKey: rootKey` for routes that push over the bottom nav shell.
- All navigation calls go through `AppNavigator.goToX(context)` — never raw `context.go()` or `context.pushNamed()` at call sites.
- Auth guards live in `GoRouter.redirect` — never in `initState` or Bloc handlers.
- Use `StatefulShellRoute.indexedStack` for bottom nav — keeps tab state alive.
- Pass an already-created Bloc across routes via `extra: {'bloc': bloc}` + `BlocProvider.value` — never `BlocProvider(create:)`.

```dart
class OrdersRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.orders,
    name: 'orders',
    parentNavigatorKey: rootKey,
    builder: (_, __) => BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(const LoadOrders()),
      child: const OrdersPage(),
    ),
  );
}
```

---

## talker

**Rules**

- Register `Talker` as `@singleton` via a `@module` provider — never instantiate inline.
- Inject `Talker` via constructor — `sl<Talker>()` only in route builders or DI modules.
- Use `talker.handle(e, st, 'description')` in all catch blocks — preserves the stack trace.
- Log levels: `info` for lifecycle events, `warning` for recoverable anomalies, `error`/`critical` for failures.
- Wire `TalkerDioLogger` to `Dio` interceptors and `TalkerBlocObserver` to `Bloc.observer`.
- Route Crashlytics via `CrashlyticsTalkerObserver` — never call `FirebaseCrashlytics.instance.recordError(...)` in feature code.
- Never log PII (email, phone, address) — log IDs only.

**Never**

- `print()` or `debugPrint()` anywhere in feature code.
- `talker.error(e.toString())` — loses the stack trace; use `talker.handle(e, st, ...)`.
- `FirebaseCrashlytics.instance.recordError(...)` in feature code.

---

## cached_network_image

**Rules**

- Always use `CachedNetworkImage` for remote images — never `Image.network`.
- Always provide both `placeholder` and `errorWidget`.
- Set `memCacheWidth` / `memCacheHeight` for images in list views and grids (prevents OOM on low-end devices; values in device pixels, not logical pixels).
- Use `cacheKey` when the URL contains dynamic query params (tracking tokens, timestamps).
- Use `CachedNetworkImageProvider` inside `CircleAvatar.backgroundImage` and `DecorationImage`.

```dart
CachedNetworkImage(
  imageUrl: product.thumbnailUrl,
  placeholder: (_, __) => const ShimmerBox(width: 120, height: 120),
  errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
  memCacheWidth: 300,
  memCacheHeight: 300,
  fit: BoxFit.cover,
)
```

---

## bloc_test + mocktail

**Rules**

- One `blocTest` per event-to-state transition — test loading, success, and error paths separately.
- Always call `bloc.close()` in `tearDown`.
- Configure mocks in `setUp` inside each `group` — never rely on state from a previous test.
- Use `any()` for `CancelToken` in `when` stubs — token instances are never equal.
- Mock only the **direct dependency** of the Bloc (use case) — never the repository or API client.
- Store reusable fake entities in `test/fixtures/<feature>_fixtures.dart`.
- Never write `expect: () => []` — always assert the exact expected state sequence.

```dart
class MockGetOrdersPageUseCase extends Mock implements GetOrdersPageUseCase {}

blocTest<OrdersBloc, OrdersState>(
  'LoadOrders: emits loading → success on success',
  build: () => OrdersBloc(mockUseCase),
  setUp: () => when(() => mockUseCase(any()))
      .thenAnswer((_) async => Right(fakeOrdersPage)),
  act: (b) => b.add(const LoadOrders()),
  expect: () => [
    const OrdersState(status: OrdersStatus.loading),
    OrdersState(status: OrdersStatus.success, page: fakeOrdersPage),
  ],
);
```

---

## connectivity_plus

**Rules**

- Never use `connectivity_plus` directly in Blocs or UI — always go through the `NetworkInfo` abstraction (`lib/core/network/network_info.dart`).
- Use `NetworkInfo.isConnected` as a pre-flight check only; always handle `DioException.connectionError` as the authoritative fallback.
- Cache the last known connectivity status — do not call `checkConnectivity()` on every request.
- Reactive no-connection UI: drive it from the stream via `StreamBuilder` or a global Cubit.

---

## shared_preferences

**Rules**

- Never call `SharedPreferences` directly — always go through `PrefManager` (the typed wrapper).
- Initialise once in `initDependencies()` and inject `PrefManager` as a dependency.
- All keys are constants defined in one place — never write raw key strings at call sites.
- Never store sensitive data (tokens, passwords) in `SharedPreferences` — use `flutter_secure_storage`.
- Only store primitives: `String`, `int`, `double`, `bool`, `List<String>`.

---

## firebase_crashlytics

**Rules**

- Wire both error hooks at startup:
  ```dart
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (e, st) {
    FirebaseCrashlytics.instance.recordError(e, st, fatal: true);
    return true;
  };
  ```
- All manual recording goes through `CrashlyticsTalkerObserver` — never call `FirebaseCrashlytics.instance.recordError(...)` in feature code.
- Set user identifier (`userId`) after login; clear on logout. Use ID only — never PII.
- Disable in debug builds: `await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode)`.
- Add breadcrumbs (`FirebaseCrashlytics.instance.log(...)`) for critical user flows (checkout, auth).

**Never**

- `FirebaseCrashlytics.instance.recordError(...)` directly in feature code — always via the observer.
- Log email, phone number, or name as the user identifier.
